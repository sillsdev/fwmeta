#!/bin/sh
# Use Wordpad as git editor
file=${1//\//\\}
file=${file/\\c\\/c:\\}
${COMSPEC//\\//} /c "start /wait wordpad $file"

