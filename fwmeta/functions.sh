#!/bin/bash
# Shell functions
# This file gets included in several other scripts

readdefault()
{
	# parameters:
	# $1: prompt
	# $2: default value
	read -p "$1 ($2): " tmp
	echo "${tmp:-$2}"
}

fullname()
{
	local n f1 f2 f3 f4 f5 f6 f7
	n=$(whoami)
	if [ -r /etc/passwd ]; then
		while IFS=: read -r f1 f2 f3 f4 f5 f6 f7
		do
			[ "$f1" == "$n" ] && echo "${f5%%,*}"
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

# gets all repos listed in repodefs.sh
getAllRepos()
{
	local repo dir repoplatform
	allrepos=()
	IFS=$'\n'
	for line in $locations
	do
		while IFS=: read -r repo dir repoplatform
		do
			allrepos+=("$repo")
		done <<< $line
	done
	echo "${allrepos[@]}"
}

# gets all repos suitable for the current platform
getAllReposForPlatform()
{
	local repo dir repoplatform
	allrepos=()
	IFS=$'\n'
	for line in $locations
	do
		while IFS=: read -r repo dir repoplatform
		do
			if [ -z "$repoplatform" ] || [ "$repoplatform" == "$(platform)" ]; then
				allrepos+=("$repo")
			fi
		done <<< $line
	done
	echo "${allrepos[@]}"
}

# gets the path for repo $1
getDirForRepo()
{
	local repo dir platform
	IFS=$'\n'
	for line in $locations
	do
		while IFS=: read -r repo dir platform
		do
			if [ "$repo" == "$1" ]; then
				echo "$dir"
				return
			fi
		done <<< $line
	done
	echo "Repo $1 not found" >&2
}
