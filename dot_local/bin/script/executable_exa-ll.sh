#!/bin/bash
if [ $# -eq 0 ]	# If no arguments
then
[ "$(/bin/exa -ahl "$@" | wc -l)" -lt "50" ] && /bin/exa -aFlh --color=auto --sort=extension --group-directories-first "$@" || /bin/exa -aF --color=auto --group-directories-first --sort=extension "$@"
# ARGUMENTS PASSED run ls
else
[ "$(/bin/exa -ahl "$@" | wc -l)" -lt "50" ] && /bin/exa -alhF --color=auto --sort=extension --group-directories-first "$@" ||  /bin/exa -aF --color=auto --group-directories-first --sort=extension "$@"
fi
