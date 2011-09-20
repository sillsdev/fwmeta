#!/bin/bash
# Finish a hotfix
# If no hotfix name is given as parameter the name of the current hotfix branch will be used.

flow=$(git config --get gitflow.prefix.hotfix)
if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#$flow}" ]; then
		echo "ERROR: Either specify the hotfix name or switch to a hotfix branch"
		exit 1
	fi
	branch=${branch#refs/heads/$flow}
fi

rel=${1:-$branch}

git checkout develop
git pull --rebase review develop
git checkout master
git pull --rebase review master
git flow hotfix finish $rel
git push review --all
git push review --tags
