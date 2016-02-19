#!/bin/sh

PYTHON=`which python`
WHOAMI=`${PYTHON} -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

PARENT=`dirname ${WHOAMI}`
PROJECT=`dirname ${PARENT}`

NGINX="${PROJECT}/nginx"

CONF="${NGINX}/iplookup.conf"
CONFNAME=`basename ${CONF}`

sudo apt-get install nginx

if [ -L /etc/nginx/sites-enabled/default ]
then
    sudo rm /etc/nginx/sites-enabled/default
fi

if [ -L /etc/nginx/sites-enabled/${CONFNAME} ]
then
    sudo rm /etc/nginx/sites-enabled/${CONFNAME}
fi

sudo ln -s ${CONF} /etc/nginx/sites-enabled/${CONFNAME}

sudo /etc/init.d/nginx restart
exit 0
