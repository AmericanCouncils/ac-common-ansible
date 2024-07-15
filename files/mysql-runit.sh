#!/bin/sh

cd /
umask 077

MYSQLADMIN='/usr/bin/mysqladmin'

trap "$MYSQLADMIN shutdown" 0
trap 'exit 2' 1 2 3 15

exec  /usr/bin/mysqld_safe --defaults-file=/etc/mysql/my.cnf --general_log=1 --general_log_file=/var/log/mysql/queries.log & wait