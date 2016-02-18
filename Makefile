server:
	ubuntu/setup-golang.sh
	if test ! -d /usr/local/mapzen/go-whosonfirst-iplookup; then git clone git@github.com:whosonfirst/go-whosonfirst-iplookup.git /usr/local/mapzen/go-whosonfirst-iplookup; fi
	cd /usr/local/mapzen/go-whosonfirst-iplookup; git pull origin master; make build
	cp /usr/local/mapzen/go-whosonfirst-iplookup/bin/wof-iplookup-server services/iplookup-server/wof-iplookup-server
