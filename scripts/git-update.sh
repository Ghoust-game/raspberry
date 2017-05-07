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

    if [ "$TAG_CURRENT" == "$TAG_LATEST" ]; then
        echo "Ghoust is already the latest version."
    else
        echo "A newer version is available!"

        # Update with '--update arg'
        if [ "$EXECUTE_UPDATE" != "--execute" ]; then
            echo "use '$0 --execute' to execute the update"
            exit 1
        else
            echo "setting drive to read-write"
            rw

            echo "running 'git reset --hard'"
            git reset --hard

            echo "running 'git merge tags/$TAG_LATEST'"
            git merge tags/$TAG_LATEST

            echo "setting drive to read-only"
            ro

            echo "Update successful."
        fi
    fi
}


DIRECTORIES="/server/webserver/frontend /server/ghoust®"
for DIR in $DIRECTORIES; do
  echo "dir: $DIR"
  check_for_update "./" "$1"
done
