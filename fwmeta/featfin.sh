#!/bin/bash
# Finish a feature branch
# If no feature name is given as parameter the name of the current feature branch will be used.

developConfig=$(git config --get gitflow.branch.develop)
featureConfig=$(git config --get gitflow.prefix.feature)
originConfig=$(git config --get gitflow.origin)
develop=${developConfig:-develop}
feature=${featureConfig:-feature/}
origin=${originConfig:-origin}

if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#refs/heads/$feature}" ]; then
		echo "ERROR: Either specify the feature to close or switch to a feature branch"
		exit 1
	fi
	branch=${branch#refs/heads/$feature}
fi

feat=${1:-$branch}

git checkout $develop
git fetch $origin
# TODO: we want to force a merge commit if the feature branch consists of more then one commits.
# This means we have to merge first before we rebase
git pull --rebase $origin $develop
git flow feature finish $feat
git push $origin HEAD:refs/heads/$develop
