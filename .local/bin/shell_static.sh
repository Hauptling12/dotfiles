#!/bin/bash
#from https://tinyurl.com/y8scqwuo

while true;do 
  printf "$(awk -v c="$(tput cols)" -v s="$RANDOM" 'BEGIN{srand(s);while(--c>=0){printf("\xe2\x96\\%s",sprintf("%o",150+int(10*rand())));}}')"
done
