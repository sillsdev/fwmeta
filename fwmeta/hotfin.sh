#!/bin/bash
# Finish a hotfix
# If no hotfix name is given as parameter the name of the current hotfix branch will be used.

set -e

basedir=$(dirname "$(dirname "$0")")
TOOLSDIR=fwmeta

. "$basedir/$TOOLSDIR/functions.sh"

develop=$(git config --get gitflow.branch.develop || echo develop)
master=$(git config --get gitflow.branch.master || echo master)
hotfix=$(git config --get gitflow.prefix.hotfix || echo hotfix/)
origin=$(git config --get gitflow.origin || echo origin)

if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#refs/heads/$hotfix}" ]; then
		echo "ERROR: Either specify the hotfix name or switch to a hotfix branch"
		exit 1
	fi
	branch=${branch#refs/heads/$hotfix}
fi

if __isDirty; then
	echo "ERROR: You have a dirty working directory. Commit your changes and try again."
	exit 2
fi
if git branch | grep -q -e __develop -e __master; then
	echo "ERROR: temporary branch __develop or __master exists. Please delete manually."
	exit 3
fi

rel=${1:-$branch}

# rename current develop branch to __develop and create new temporary develop branch based on
# origin/develop so that we work with the state the remote repo is in. Similar for master
# branch. The reason we do that is that we don't want to accidentally push local changes.
git fetch $origin $develop
git branch -m $develop __develop
git checkout -b $develop $origin/$develop

git fetch $origin $master
git branch -m $master __master
git checkout -b $master $origin/$master

git flow hotfix finish $rel

# push master and develop branch as well as new tag, delete hotfix branch on remote
echo "Pushing master"
git push $origin $master
echo "Pushing tag $rel"
git push $origin $rel
echo "Pushing develop"
git push $origin $develop
if [ $(git ls-remote $origin $hotfix$rel | wc -l) -gt 0 ]; then
	echo "Deleting hotfix branch $hotfix$rel"
	git push $origin :$hotfix$rel
fi

# restore current branches
echo "Updating $develop branch"
git checkout -q __develop
git branch -D $develop > /dev/null
git branch -m __develop $develop > /dev/null
git rebase $origin/$develop $develop

echo "Updating $master branch"
git branch -D $master > /dev/null
git branch -m __master $master > /dev/null
git rebase $origin/$master $master
