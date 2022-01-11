#!/bin/bash

# Create a mirror of all the FW repos
#
# Useful for burning to DVD, or using as a local cache or proxy
#
# To use this script:
#    mkdir mirror && cd mirror
#    path/to/fwmeta/create-mirror.sh
#
# To use the mirror:
#    git clone https://github.com/sillsdev/fwmeta.git fwrepo
#    cd fwrepo
#    git config --global url.file:///path/to/mirror/.insteadOf https://github.com/sillsdev/
#    fwmeta/initrepo # Initial clone
#    git config --global --unset url.file:///path/to/mirror/.insteadOf
#    fwmeta/initrepo # Update to latest
#
# /path/to/mirror could be the location of your mounted DVD, and you would use
# file:///media/gerrit.lsdev.sil.org/

# Assume this script is located in fwmeta
basedir=$(dirname "$(dirname "$0")")
TOOLSDIR=fwmeta

. "$basedir/$TOOLSDIR/functions.sh"

for REPO in $(getAllRepos)
do
	echo "====> $REPO <===="

	if [ ! -d "$REPO.git" ]
	then
		URL=$(getUrlForRepo "$REPO")
		echo git clone --bare "$URL"
		git clone --bare "$URL"
	fi
done
