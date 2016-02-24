#!/bin/sh

PYTHON=`which python`
PERL=`which perl`

WHOAMI=`${PYTHON} -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

PARENT=`dirname ${WHOAMI}`
PROJECT=`dirname ${PARENT}`

INITD="${PROJECT}/init.d"
MMDB="${PROJECT}/mmdb"
SERVICES="${PROJECT}/services"

INITD_WOF="${INITD}/wof-iplookup.sh"
INITD_MAXMIND="${INITD}/wof-iplookup-maxmind.sh"

for INITD_SCRIPT in ${INITD_WOF} ${INITD_MAXMIND}
do

    if [ -f ${INITD_SCRIPT} ]
    then
	mv ${INITD_SCRIPT} ${INITD_SCRIPT}.bak
    fi

    cp ${INITD_SCRIPT}.example ${INITD_SCRIPT}
    chmod 755 ${INITD_SCRIPT}

    # shared configs

    ${PERL} -p -i -e "s!__IPLOOKUP_USER__!www-data!g" ${INITD_SCRIPT}
    ${PERL} -p -i -e "s!__IPLOOKUP_DAEMON__!${SERVICES}/iplookup/wof-iplookup-server!g" ${INITD_SCRIPT}
    ${PERL} -p -i -e "s!__IPLOOKUP_ARGS__!-cors -header x-forwarded-for!g" ${INITD_SCRIPT}
    
done

# wof configs

${PERL} -p -i -e "s!__IPLOOKUP_DB__!${MMDB}/whosonfirst-city-latest.mmdb!g" ${INITD_WOF}
${PERL} -p -i -e "s!__IPLOOKUP_PORT__!4884!g" ${INITD_WOF}

# HOST=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
# ${PERL} -p -i -e "s!__IPLOOKUP_HOST__!localhost!g" ${INITD_WOF}

# maxmind configs

${PERL} -p -i -e "s!__IPLOOKUP_DB__!${MMDB}/whosonfirst-maxmind-city-latest.mmdb!g" ${INITD_MAXMIND}
${PERL} -p -i -e "s!__IPLOOKUP_PORT__!8448!g" ${INITD_MAXMIND}

for INITD_SCRIPT in ${INITD_WOF} ${INITD_MAXMIND}
do

    FNAME=`basename ${INITD_SCRIPT}`

    if [ -L /etc/init.d/${FNAME} ]
    then
	sudo rm /etc/init.d/${FNAME}
    fi

    sudo ln -s ${INITD_SCRIPT} /etc/init.d/${FNAME}
    
    PID_FILE="/var/run/${FNAME}.pid"

    if [ -f ${PID}_FILE ]
    then
	sudo /etc/init.d/${FNAME} stop
    fi

    sudo update-rc.d ${FNAME} defaults
    sudo /etc/init.d/${FNAME} start
done

exit 0
