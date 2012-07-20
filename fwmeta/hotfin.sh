#!/bin/bash
# Finish a hotfix
# If no hotfix name is given as parameter the name of the current hotfix branch will be used.

developConfig=$(git config --get gitflow.branch.develop)
masterConfig=$(git config --get gitflow.branch.master)
hotfixConfig=$(git config --get gitflow.prefix.hotfix)
originConfig=$(git config --get gitflow.origin)
develop=${developConfig:-develop}
master=${masterConfig:-master}
hotfix=${hotfixConfig:-hotfix/}
origin=${originConfig:-origin}

if [ -z $1 ]; then
	branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	if [ "$branch" == "${branch#refs/heads/$hotfix}" ]; then
		echo "ERROR: Either specify the hotfix name or switch to a hotfix branch"
		exit 1
	fi
	branch=${branch#refs/heads/$hotfix}
fi

rel=${1:-$branch}

git checkout $develop
git pull --rebase $origin $develop
git checkout $master
git pull --rebase $origin $master
git flow hotfix finish $rel
git push $origin --all
git push $origin --tags
