#!/bin/bash
# Submit a change for review

. "$(dirname "$0")/functions.sh"

pushQuiet()
{
	# used when running unit tests. Unfortunately passing -q to git push still produces some
	# output on stderr, so we have to redirect that.
	git push -q $@ 2>/dev/null
}

pushNormal()
{
	git push $@
}

pushCmd="pushNormal"
if [ "$1" = "--quiet" ]; then
	pushCmd="pushQuiet"
	shift
fi

feature=$(git config --get gitflow.prefix.feature || echo feature/)

currentBranch=$(currentCommit)

if [ -n "$1" ]; then
	branch=$1
	topic=$2
else
	branch=$(getParentBranch $currentBranch)
	topic=${currentBranch#$feature}
fi
if [ -z "$branch" ]; then
	branch=develop
fi

# prepend topic with %topic= if set
topic=${topic:+%topic=$topic}
# strip things like ~1
topic="${topic%\~*}"

$pushCmd origin HEAD:refs/for/$branch$topic
