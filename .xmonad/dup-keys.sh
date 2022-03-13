#!/bin/sh

sed -n '/START_KEYS/,/END_KEYS/p' ~/.xmonad/xmonad.hs | sed -r -e 's/^[[:blank:]]+//' | grep -v '^\-\-' | head -n -3 | sed '1,2d' | sed "s/\[ (\"/, \(\"/g"  | grep -v -e '^$' | sed 's/^....//' |  sed 's/\",.*//'  | awk '{print $1}' | uniq -c | while read num dupe; do [[ $num > 1 ]] && grep -n -- "$dupe" ~/.xmonad/xmonad.hs; done | grep -v "\-\- ," |     yad --text-info --back=#282c34 --fore=#D27D2D --geometry=1200x800
