#!/bin/bash
#
# Execute the update of all git repos
#
# 'git pull --tags' has to be executed before separately.
#

set -e

DIRECTORIES="/server/webserver/frontend /server/ghoust /server/raspberry"

for DIR in $DIRECTORIES; do
    echo "changing into $DIR"
    cd "$DIR"

    TAG_LATEST=$( git tag -l | tail -n 1 )
    echo "Updating $DIR to $TAG_LATEST"

    echo "running 'git reset --hard' in $DIR"
    git reset --hard


    echo "running 'git merge tags/$TAG_LATEST' in $DIR"
    git merge "tags/$TAG_LATEST"
done;

mosquitto_pub -h localhost -p 1883 -t "GHOUST/server/updated-performed" -m 1
