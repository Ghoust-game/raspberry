#!/bin/sh

[ $(git rev-parse HEAD) = $(git ls-remote $(git rev-parse --abbrev-ref @{u} | \
sed 's/\// /g') | cut -f1) ] && update_repo=0 || update_repo=1


if [ $update_repo  = 1 ]; then
 echo "Updating the repo!"

 echo "Remounting writeable"
 rw

 echo "Updating via github"
 git pull

 echo "Remounting Readonly"
 ro

 echo "Done"

else
 echo "Up to date. Quitting"

fi;
