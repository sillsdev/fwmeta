#!/bin/bash
# Rebase current branch either on latest of remote branch (if we're tracking a remote branch),
# or on latest of parent branch.
# If --no-rebase is passed as parameter we only fetch the latest changes but don't rebase.

findHotfixParent()
{
	# Finds the branch the current hotfix branch was derived from
	local tmpbranch parentbranches
	tmpbranch=$curbranch
	while ! git branch --contains $tmpbranch | grep -v $curbranch &> /dev/null; do
		tmpbranch=$tmpbranch~
	done
	parentbranch=$(git branch --contains $tmpbranch | grep -v $curbranch)
	case "$parentbranch" in
		*$(git config gitflow.prefix.support)*)
			echo "${parentbranch#  }"
			;;
		*)
			echo "master"
			;;
	esac
}

curbranch=$(git symbolic-ref -q HEAD)
curbranch=${curbranch#refs/heads/}

if [ -z $curbranch ]; then
	echo "fatal: Can't detect current branch. Rebasing not possible." >&2
	echo "       Are you in a 'detached HEAD' state?" >&2
	exit 1
fi

if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} &> /dev/null; then
	# We're on a branch that doesn't have a tracking branch. Rebase on parent branch (or what
	# we think is parent branch)
	case "$curbranch" in
		$(git config gitflow.prefix.feature)*)
			parent=develop
			;;
		$(git config gitflow.prefix.release)*)
			parent=develop
			;;
		$(git config gitflow.prefix.hotfix)*)
			# A hotfix branch can derive from master or a support branch. Find out which one.
			parent=$(findHotfixParent)
			;;
		$(git config gitflow.prefix.support)*)
			parent=master
			;;
		*)
			# non-standard branch naming
			echo "fatal: Non-standard branch naming. Can't detect parent branch." >&2
			echo "       Rebasing is not possible." >&2
			exit 2
			;;
	esac
else
	# We're on a branch that has a tracking branch.
	parent=$curbranch
fi

git fetch origin +refs/notes/*:refs/notes/*
git fetch origin +refs/heads/$parent:refs/remotes/origin/$parent

if [ "$1" != "--no-rebase" ]; then
	git rebase origin/$parent
fi
