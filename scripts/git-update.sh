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

function execute_update() {
    GIT_PATH="$1"
    echo "Changing into '$GIT_PATH'"
    cd "$GIT_PATH"

    # whats the latest tag?
    TAG_LATEST=$( git tag -l | tail -n 1 )

    echo "running 'git reset --hard'"
    git reset --hard

    echo "running 'git merge tags/$TAG_LATEST'"
    git merge tags/$TAG_LATEST

    echo "Update successful."
}

function check_for_update() {
    GIT_PATH="$1"

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
        if [ "$1" != "--update" ]; then
            echo "use '$0 --update' to execute the update"
            exit 1
        else
            execute_update $GIT_PATH
        fi
    fi
}

check_for_update "./"
