#!/bin/bash
######################################################################
#Copyright (C) 2020  Kris Occhipinti
#https://filmsbykris.com

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
######################################################################

function main(){
  #$(echo -e "shell\nscreen\nkill\nsearch_packages"|fzf)
  #get list of options
  func=$(cat "$0"|grep function|awk '{print $2}'|grep -v -e 'main()'|grep -v 'grep'|cut -d\( -f1)
  $(echo -e "shell\n$func"|fzf)

  exit 0
}

function search_packages(){
  adb shell "pm list packages -f"|fzf
}

function backup_packages(){
  pkgs="$(adb shell "pm list packages -f"|rev|cut -d\= -f1|rev|fzf -m --prompt "Select Packages to Backup: ")"
  scrcpy -tS &
  echo "$pkgs"|while read pkg;do
    adb backup "$pkg"
    mv backup.ab "$pkg.ab"
  done
}

function upgrade_packages(){
  /usr/local/bin/fdroid
}

function kill(){
  sudo killall adb
}

function screen(){
  scrcpy -tS
}

function shell(){
  #adb shell || sudo killall adb && sudo adb shell
  adb shell
}

function push(){
  files=$(fzf -m --prompt "Select Files to Push: ")
  dir="$(adb shell find /storage -type d 2>/dev/null|fzf --prompt "Select Folder to Push to: ")"
    adb push $files "$dir"
}

function pull(){
  adb shell find /storage 2>/dev/null|\
    fzf -m --prompt "Select File/Folder to Pull from: "|\
  while read f;do
    adb pull "$f" .
  done

}

main *

