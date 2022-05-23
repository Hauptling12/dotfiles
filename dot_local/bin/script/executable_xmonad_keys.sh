#!/bin/sh

sed -n '/START_KEYS/,/END_KEYS/p' ~/.config/xmonad/xmonad.hs | sed -r -e 's/^[[:blank:]]+//' -e "s/\-\- KB_G //g" | grep -v '^\-\-' | head -n -3 | sed '1,2d' | sed "s/\[ (\"/\(\"/g"
