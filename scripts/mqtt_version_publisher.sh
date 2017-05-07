#!/bin/bash
#
# This script checks if an update is available, and can install it.
# Works for both the frontend and the backend
#
# 1. Get latest tags from the Git remote
# 2. If the latest tag is different from the current one, allow to update self
#
# Author: Chris Hager <chris@linuxuser.at>
#
set -euf -o pipefail

function check_for_update() {
    GIT_PATH="$1"
    EXECUTE_UPDATE="$2"

    echo "Changing into '$GIT_PATH'"

    # get latewst tags from online
    echo "Fetching latest version information..."
    git fetch --tags

    # whats the latest tag?
    TAG_LATEST=$( git tag -l | tail -n 1 )

    # whats the current tag?
    TAG_CURRENT=$( git describe --tags )
    

    echo "current=$TAG_CURRENT, latest=$TAG_LATEST"
    mosquitto_pub --will-retain -h 127.0.0.1 -p 1884 -t "/GHOUST/server/version/current" -m "$TAG_CURRENT"
    mosquitto_pub --will-retain -h 127.0.0.1 -p 1884 -t "/GHOUST/server/version/latest" -m "$TAG_LATEST"
    
    if [ "$TAG_CURRENT" == "$TAG_LATEST" ]; then
        echo "Ghoust is already the latest version."
    else
        echo "A newer version is available!"
    fi
}


DIRECTORIES="/server/webserver/frontend /server/ghoust®"
for DIR in $DIRECTORIES; do
  echo "dir: $DIR"
  check_for_update "./" "$1"
done
