#!/bin/bash

set -e

while true; do
	if mosquitto_sub -C 1 -R -h localhost -p 1883 -t "GHOUST/server/perform-update"; then
	    echo "Beginning update"
	    rw
	    for DIR in ["/server/webserver/frontend" "/server/ghoust"]; do
		    cd "$DIR"

		    TAG_LATEST=$( git tag -l | tail -n 1 )
		    echo "Updating $DIR to $TAG_LATEST"

		    echo "running 'git reset --hard' in $DIR"
		    git reset --hard


		    echo "running 'git merge tags/$TAG_LATEST' in $DIR"
		    git merge "tags/$TAG_LATEST"
	    done;
	    echo "Ending update"
	    ro
	fi
done;
