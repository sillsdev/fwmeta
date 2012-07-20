#!/bin/bash
# Submit a change for review

if [ -z $1 ]; then
	echo "ERROR: Please specify target branch"
	exit 1
fi

branch=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
branch=${2:-${branch#refs/heads/}}
git push origin HEAD:refs/for/$1/$branch
