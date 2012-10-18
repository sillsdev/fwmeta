#!/bin/bash
# Rebase current branch either on latest of remote branch (if we're tracking a remote branch),
# or on latest of parent branch.
# If --no-rebase is passed as parameter we only fetch the latest changes but don't rebase.

. $(dirname $0)/functions.sh

curbranch=$(currentBranch)

if [ -z $curbranch ]; then
	echo "fatal: Can't detect current branch. Rebasing not possible." >&2
	echo "       Are you in a 'detached HEAD' state?" >&2
	exit 1
fi

parent=$(getParentBranch "$curbranch")
if [ -z "$parent" ]; then
	# non-standard branch naming
	echo "fatal: Non-standard branch naming. Can't detect parent branch." >&2
	echo "       Rebasing is not possible." >&2
	exit 2
fi

git fetch origin +refs/notes/*:refs/notes/*
git fetch origin +refs/heads/$parent:refs/remotes/origin/$parent

if [ "$1" != "--no-rebase" ]; then
	git rebase origin/$parent
fi
