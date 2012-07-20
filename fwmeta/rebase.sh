#!/bin/bash
# deal with rebasing a feature, calling the mergetool if necessary
developConfig=$(git config --get gitflow.branch.develop)
featureConfig=$(git config --get gitflow.prefix.feature)
originConfig=$(git config --get gitflow.origin)
develop=${developConfig:-develop}
feature=${featureConfig:-feature/}
origin=${originConfig:-origin}

git fetch $origin
git rebase $origin/$develop

if [ $? -ne 0 ]; then
	echo bla
	echo n | git mergetool -y
	git rebase --continue
	if [ $? -ne 0 ]; then
		git rebase --abort
		echo ""
		echo "Rebase aborted"
	fi
fi
