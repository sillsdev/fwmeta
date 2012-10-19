#!/bin/bash
# Bypass code review. Push to the parent branch.

. $(dirname $0)/functions.sh

curbranch=$(currentBranch)
if [ -z $curbranch ]; then
	echo "fatal: Can't detect current branch. Pushing is not possible." >&2
	echo "       Are you in a 'detached HEAD' state?" >&2
	exit 1
fi

parent=$(getParentBranch "$curbranch")
if [ -z "$parent" ]; then
	# non-standard branch naming
	echo "fatal: Non-standard branch naming. Can't detect parent branch." >&2
	echo "       Pushing is not possible." >&2
	exit 2
fi

git push origin HEAD:refs/heads/$parent
