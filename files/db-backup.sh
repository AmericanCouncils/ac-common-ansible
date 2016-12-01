#!/bin/sh

set -e -u

MODE=$1
DBNAME=$2

HOSTNAME=$(hostname)
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

BACKUP_DIR=/var/$MODE-backup/$DBNAME
BACKUP_NAME=$DBNAME.$YEAR.$MONTH.$DAY

PATH=$PATH:/usr/local/bin

echo "Backing up $MODE database $DBNAME"

mkdir -p $BACKUP_DIR

case "$MODE" in
  mysql)
    BACKUP_FILE=$BACKUP_DIR/$BACKUP_NAME.sql.gz
    mysqldump -u root --single-transaction $DBNAME | gzip > $BACKUP_FILE
    ;;
  mongo)
    BACKUP_FILE=$BACKUP_DIR/$BACKUP_NAME.tar.gz
    mongodump --db $DBNAME --out /tmp/$BACKUP_NAME
    tar czf $BACKUP_FILE -C /tmp $BACKUP_NAME
    rm -rf /tmp/$BACKUP_NAME
    ;;
  *)
    echo "Unknown mode $MODE"
    exit 1
esac

echo "Transferring $BACKUP_FILE to S3"
s3 -c /etc/s3.yaml -b american-councils-backups put $BACKUP_FILE $HOSTNAME/$MODE/$DBNAME/$YEAR/$MONTH/$BACKUP_NAME.sql.gz

echo "Rotating local $MODE $DBNAME backups"
rotate-backups -d 30 -w 16 $BACKUP_DIR
