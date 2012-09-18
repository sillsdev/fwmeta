#!/bin/bash
# Finish a release
# If no release name is given as parameter the name of the current release branch will be used.

set -e

developConfig=$(git config --get gitflow.branch.develop || true)
masterConfig=$(git config --get gitflow.branch.master || true)
releaseConfig=$(git config --get gitflow.prefix.release || true)
originConfig=$(git config --get gitflow.origin || true)
develop=${developConfig:-develop}
master=${masterConfig:-master}
release=${releaseConfig:-release/}
origin=${originConfig:-origin}

if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#refs/heads/$release}" ]; then
		echo "ERROR: Either specify the release or switch to a release branch"
		exit 1
	fi
	branch=${branch#refs/heads/$release}
fi

rel=${1:-$branch}

git checkout $develop
git pull --rebase $origin $develop
git checkout $master
git pull --rebase $origin $master
git flow release finish $rel
git checkout $develop
git pull $origin $develop
git push $origin --all
git push $origin --tags
[ "$(git ls-remote $origin refs/heads/$release$rel)" = "1" ] && git push $origin :refs/heads/$release$rel || true
