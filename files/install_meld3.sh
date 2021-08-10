#!/bin/sh

# custom install script for meld3, which supervisor requires

mkdir -p /tmp/meld3

cd /tmp/meld3

wget https://files.pythonhosted.org/packages/45/a0/317c6422b26c12fe0161e936fc35f36552069ba8e6f7ecbd99bbffe32a5f/meld3-1.0.2.tar.gz

tar xzvf meld3-1.0.2.tar.gz
cd meld3-1.0.2
python setup.py install
