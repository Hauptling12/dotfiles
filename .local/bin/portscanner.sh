#!/bin/bash

[[ "$1" == "" ]] &&
  read -p "Enter IP Adress: " ip ||
  ip="$1"

#scan many ports
for i in {20..10000};
do 
  (echo > /dev/tcp/$ip/$i) &>/dev/null &&
  echo "Port $i is open";
done
