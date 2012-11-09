#!/bin/bash
# Shell functions
# This file gets included in several other scripts

REPOCONFIG=${REPOCONFIG:-${basedir}/${TOOLSDIR}/repodefs.config}

readdefault()
{
	# parameters:
	# $1: prompt
	# $2: default value

	echo -n -e "${_bold}$1${_normal} ($2): " > /dev/tty
	read tmp
	echo "${tmp:-$2}"
}

fullname()
{
	local n f1 f2 f3 f4 f5 f6 f7
	n=$(whoami)
	if [ -r /etc/passwd ]; then
		while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
		do
			[ "$f1" = "$n" ] && echo "${f5%%,*}"
		done </etc/passwd
	else
		echo "$n"
	fi
}

platform()
{
	case "$OSTYPE" in
		msys)
			echo "Windows"
			;;
		cygwin)
			echo "Windows"
			;;
		linux-gnu)
			echo "Linux"
			;;
	esac
}

# Get the directory of the fwmeta repo
getfwmetadir()
{
	local dir olddir curdir
	curdir=$(pwd)
	dir=$curdir

	while true; do
		cd $dir
		dir=$(git rev-parse --show-toplevel 2> /dev/null)
		if [ -z $dir ]; then
			echo "$curdir"
			return
		fi
		cd $dir
		if [ -d fwmeta ] && git config --file .git/config --get fwinit.initialized >/dev/null; then
			echo "$dir"
			return
		else
			olddir="$dir"
			dir=$(dirname "$dir")
			if [ "$olddir" = "$dir" ]; then
				echo "$curdir"
				return
			fi
		fi
	done
}

# gets all repos listed in repodefs.sh
getAllRepos()
{
	local allrepos repo

	allrepos=()
	for repo in $(git config -f "$REPOCONFIG" --get-regexp 'repo\..*\.path' | cut --delimiter=. --fields=2 | grep -v "^${FWMETAREPO}\$")
	do
		allrepos+=("$repo")
	done
	echo "${allrepos[@]}"
}

# gets all repos suitable for the current platform
getAllReposForPlatform()
{
	local allrepos repo
	allrepos=()
	for repo in $(git config -f "$REPOCONFIG" --get-regexp 'repo\..*\.path' | cut --delimiter=. --fields=2 | grep -v "^${FWMETAREPO}\$")
	do
		repoplatform=$(git config -f "$REPOCONFIG" --get "repo.$repo.platform")
		if [ -z "$repoplatform" ] || [ "$repoplatform" = "$(platform)" ]; then
			allrepos+=("$repo")
		fi
	done
	echo "${allrepos[@]}"
}

# gets the path for repo $1
getDirForRepo()
{
	git config -f "$REPOCONFIG" --get "repo.$1.path"
}

# gets the URL for repo $1
getUrlForRepo()
{
	url=$(git config -f "$REPOCONFIG" --get "repo.$1.url")
	if [ -n "$url" ]; then
		echo "$url"
	else
		url=$(git config -f "$REPOCONFIG" --get repo.defaulturl)
		echo "$url/$1.git"
	fi
}

currentBranch()
{
	local curbranch
	curbranch=$(git symbolic-ref -q HEAD)
	curbranch=${curbranch:-"(no branch)"}
	echo ${curbranch#refs/heads/}
}

currentCommit()
{
	local commit
	commit=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	echo ${commit#refs/heads/}
}

# Finds the parent branch of the current hotfix branch ($1)
findHotfixParent()
{
	local tmpbranch parentbranches curbranch
	curbranch=$1
	tmpbranch=$curbranch
	while ! git branch --contains $tmpbranch | grep -q -v $curbranch; do
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

# gets the parent branch for branch $1
getParentBranch()
{
	local parent curBranch

	curBranch="$1"

	if git config branch.${curBranch}.merge > /dev/null; then
		parent=$(git config branch.${curBranch}.merge)
		parent=${parent#refs/heads/}
	else
		case "$curBranch" in
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
				parent=""
				;;
		esac
	fi
	echo "$parent"
}

mktempdir()
{
	# using mktemp didn't work reliably on Windows
	local tmpdir
	tmpdir="${TMP-/tmp}/fwmeta-$$"
	mkdir -p "$tmpdir"
	echo "$tmpdir"
}

# define colors (we can't use $(tput bold) because tput isn't installed on Windows by default)
if [ -z $NOCOLORS ] ; then
	_bold="\033[1m"
	_normal="\033[0m"
fi
