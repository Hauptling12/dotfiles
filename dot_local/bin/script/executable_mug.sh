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
tmp_jpg="/tmp/wanted.jpg"
tmp_img="/tmp/wanted.img"
tmp_info="/tmp/wanted.info"

function main(){
  list="$(get_list)"
  for link in $list;do
    get_photo $link
    get_info $link
    if [[ $(find $tmp_info -type f -size +5c 2>/dev/null) ]]; then
      clear
      chafa $tmp_jpg > $tmp_img
      print_output

      echo "Press Enter to Continue..."
      read
    fi
  done
  exit 0
}

function print_output(){
  paste $tmp_img $tmp_info|while read l;do
  echo "$l"
  sleep .05
done
}

function get_list(){
  url="https://www.fbi.gov/wanted/topten"
  wget "$url" -qO- |grep "<a href=\"$url/"|cut -d\" -f2|sort -u
}

function get_info(){
  url="$1"
  wget -qO- "$url"|\
    grep -A 55 '<h2>Aliases:</h2>'|\
    tr "\n" " "|\
    sed 's/<tr>/\n/g'|\
    sed -e 's/<[^>]*>//g;s/.\{50\}/&\n/g' > $tmp_info
}

function get_photo(){
  url="$1"
  img="$(wget "$url" -qO-|grep 'images/image/large'|tail -n 1|cut -d\" -f2)"
  wget "$img" -qO $tmp_jpg
}

main
