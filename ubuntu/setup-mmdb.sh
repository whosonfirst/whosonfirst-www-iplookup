#!/bin/sh

PYTHON=`which python`

WHOAMI=`${PYTHON} -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

PARENT=`dirname ${WHOAMI}`
PROJECT=`dirname ${PARENT}`

MMDB="${PROJECT}/mmdb"

cd ${MMDB}

LATEST_GEOLITE2="http://whosonfirst.mapzen.com.s3.amazonaws.com/mmdb/whosonfirst-maxmind-city-latest.mmdb.gz"
LATEST_WOF="http://whosonfirst.mapzen.com.s3.amazonaws.com/mmdb/whosonfirst-city-latest.mmdb.gz"

for REMOTE in ${LATEST_GEOLITE2} ${LATEST_WOF}
do
    FNAME=`basename ${REMOTE}`
    LOCAL="${MMDB}/${FNAME}"

    # TODO: check for changes

    if [ ! -f ${LOCAL} ]
    then
	echo "fetch ${REMOTE}"
	curl -s -O ${REMOTE}
	gunzip ${LOCAL}
    fi

done

cd -
exit 0
