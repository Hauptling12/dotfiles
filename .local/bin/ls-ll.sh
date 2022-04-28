#!/bin/bash
if [ $# -eq 0 ]	# If no arguments
then
[ "$(/usr/bin/ls -Al "$@" | wc -l)" -lt "50" ] && /usr/bin/ls -lAFlh --color=auto --sort=extension --group-directories-first "$@" || /usr/bin/ls -AF --color=auto --group-directories-first --sort=extension "$@"
# ARGUMENTS PASSED run ls
else
[ "$(/usr/bin/ls -Al "$@" | wc -l)" -lt "50" ] && /usr/bin/ls -lAFlh --color=auto --sort=extension --group-directories-first "$@" ||  /usr/bin/ls -AF --color=auto --group-directories-first --sort=extension "$@"
fi
