#!/bin/sh
# Use Wordpad as git editor
file=${1//\//\\}
# replace \c\ with c:\
file=${file:1:1}:${file:2}
${COMSPEC//\\//} /c "start /wait wordpad $file"

