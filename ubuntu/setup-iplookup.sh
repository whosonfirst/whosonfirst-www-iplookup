#!/bin/sh

PYTHON=`which python`
WHOAMI=`${PYTHON} -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

PARENT=`dirname ${WHOAMI}`
PROJECT=`dirname ${PARENT}`

UBUNTU="${PROJECT}/ubuntu"
SERVICES="${PROJECT}/services"

${UBUNTU}/setup-golang.sh

if [ ! -d /usr/local/mapzen/go-whosonfirst-iplookup ]
then
    git clone git@github.com:whosonfirst/go-whosonfirst-iplookup.git /usr/local/mapzen/go-whosonfirst-iplookup
fi

cd /usr/local/mapzen/go-whosonfirst-iplookup
git pull origin master
make build

cd - 

cp /usr/local/mapzen/go-whosonfirst-iplookup/bin/wof-iplookup-server ${SERVICES}/iplookup/wof-iplookup-server

exit 0
