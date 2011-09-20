#!/bin/bash
# Finish a feature branch
# If no feature name is given as parameter the name of the current feature branch will be used.

if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#$(git config --get gitflow.prefix.feature)}" ]; then
		echo "ERROR: Either specify the feature to close or switch to a feature branch"
		exit 1
	fi
	branch=${branch#refs/heads/$(git config --get gitflow.prefix.feature)}
fi

feat=${1:-$branch}

git checkout develop
git pull --rebase review develop
git flow feature finish $feat
git push review HEAD:refs/heads/develop
