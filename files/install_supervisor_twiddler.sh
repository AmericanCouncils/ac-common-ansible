#!/bin/sh

# custom install script for supervisor twiddler


mkdir -p /tmp/supervisor-twiddler

cd /tmp/supervisor-twiddler

wget https://files.pythonhosted.org/packages/b0/0a/3c1d82fc42668df0add33bfb707dd82bc0704004643c91c35808ab761dca/supervisor_twiddler-1.0.0.tar.gz

tar xzvf supervisor_twiddler-1.0.0.tar.gz
cd supervisor_twiddler-1.0.0
python setup.py install --no-deps