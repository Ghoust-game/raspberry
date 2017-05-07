#!/bin/bash
#
# Execute the update of all git repos
#
# 'git pull --tags' has to be executed before separately.
#

set -e

DIRECTORIES="/server/webserver/frontend /server/ghoust /server/raspberry"

echo "setting into read-write"
rw

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

echo "setting into read-only"
ro

echo "restarting ghoust service"
service ghoust restart

echo "publishing current versions"
/server/raspberry/scripts/mqtt_version_publisher.sh
