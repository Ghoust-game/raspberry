#!/bin/bash

set -e

while true; do
	if mosquitto_sub -C 1 -R -h localhost -p 1884 -t "GHOUST/server/perform-update"; then
	    TAG_LATEST=$( git tag -l | tail -n 1 )
	    echo "Updating to $TAG_LATEST"
            rw

            echo "running 'git reset --hard'"
            git reset --hard


            echo "running 'git merge tags/$TAG_LATEST'"
            git merge "tags/$TAG_LATEST"

            echo "setting drive to read-only"
            ro

            echo "Update successful."
	fi
done;
