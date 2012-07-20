#!/bin/sh
# Use Wordpad as git editor
file=${1//\//\\}
# replace \c\ (or \d\ ...) with c:\ if filename starts with \
[ "${file:0:1}" == "\\" ] && file=${file:1:1}:${file:2}
echo "Editing $file"
${COMSPEC//\\//} /c "start /wait wordpad $file"

