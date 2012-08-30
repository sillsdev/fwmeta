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
