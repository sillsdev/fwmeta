#!/bin/bash
# Shell functions
# This file gets included in several other scripts

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
	local repo dir repoplatform host
	allrepos=()
	IFS=$'\n'
	for line in $locations
	do
		while IFS='#' read -r repo dir repoplatform host
		do
			if [ "$repo" != "$FWMETAREPO" ]; then
				allrepos+=("$repo")
			fi
		done <<< $line
	done
	echo "${allrepos[@]}"
}

# gets all repos suitable for the current platform
getAllReposForPlatform()
{
	local repo dir repoplatform host
	allrepos=()
	IFS=$'\n'
	for line in $locations
	do
		while IFS='#' read -r repo dir repoplatform host
		do
			if [ "$repo" != "$FWMETAREPO" ]; then
				if [ -z "$repoplatform" ] || [ "$repoplatform" = "$(platform)" ]; then
					allrepos+=("$repo")
				fi
			fi
		done <<< $line
	done
	echo "${allrepos[@]}"
}

# gets the path for repo $1
getDirForRepo()
{
	local repo dir platform host
	IFS=$'\n'
	for line in $locations
	do
		while IFS='#' read -r repo dir platform host
		do
			if [ "$repo" = "$1" ]; then
				echo "$dir"
				return
			fi
		done <<< $line
	done
	echo "Repo $1 not found" >&2
}

# gets the host for repo $1
getHostForRepo()
{
	local repo dir platform host
	IFS=$'\n'
	for line in $locations
	do
		while IFS='#' read -r repo dir platform host
		do
			if [ "$repo" = "$1" ]; then
				echo "$host"
				return
			fi
		done <<< $line
	done
	echo "Repo $1 not found" >&2
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

# define colors (we can't use $(tput bold) because tput isn't installed on Windows by default)
if [ -z $NOCOLORS ] ; then
	_bold="\033[1m"
	_normal="\033[0m"
fi
