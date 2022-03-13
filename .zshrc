export HISTORY_IGNORE="(clear)"
HISTSIZE=100000000000000000
SAVEHIST=100000000000000000 # infinite history
HISTFILE=~/documents/cashe/.zsh_history
export HISTTIMEFORMAT='%F %T'

 #Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.
 
### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.cbt) tar xvf $1 ;;
      *.lzma) unlzma $1 ;;
      *.cbr) unrar x $1 ;;
      *.cbz) unzip $1 ;;
      *.arj) 7z x $1 ;;
      *.cab) 7z x $1 ;;
      *.cb7) 7z x $1 ;;
      *.chm) 7z x $1 ;;
      *.deb) 7z x $1 ;;
      *.dmg) 7z x $1 ;;
      *.iso) 7z x $1 ;;
      *.msi) 7z x $1 ;; 
      *.pkg) 7z x $1 ;;
      *.lzh) 7z x $1 ;;
      *.rpm) 7z x $1 ;;
      *.udf) 7z x $1 ;;
      *.wim) 7z x $1 ;;
      *.xar) 7z x $1 ;;
      *.xz) unzx $1 ;;
#      *.cba) ;;
      *.ace) unace x $1 ;;
      *.cpio) cpio -id < $1 ;;  
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *.exe)   7zr -e $1    ;;
      *.jar)   unzip $1    ;;
      *.jpl)   file-roller -h $1    ;;
      *.apk)   file-roller -h $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# vi mode
bindkey -v


# promt starship
function set_win_title(){
            echo -ne "\033]0; $(basename "$PWD") \007"
    }
    starship_precmd_user_func="set_win_title"


export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.local/bin

if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/Applications:$PATH"
fi

if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/.emac.d/bin:$PATH"
fi
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# functions
function today { echo -n "Today's date is: "; date +"%I:%M:%S:%r %d %A, %B %-d, %d/%m/%Y " | cut -c10-; }
function fawk {
    first="awk '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}

# expac -S -H M '%k\t%n'
#copy and go to dir  FIX FIX BROKEN
cpd (){
  if [ -d "$2" ];then
    cp $1 $2 && cd $2 && ls
  else
    cp $1 $2
  fi
}


#move and go to dir
mvd (){
  if [ -d "$2" ];then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}

[ -f "$HOME/.config/bash_aliases" ] && source "$HOME/.config/bash_aliases"

# make directory and cd there
mkcd() {
        if [ $# != 1 ]; then
                echo "Usage: mkcd <dir>"
        else
                mkdir -p $1 && cd $1 && ls
        fi
}
# make file and opens vim
tovi() {
        if [ $# != 1 ]; then
                echo "Usage: tovi <file>"
        else
                touch $1 && vim $1
        fi
}

export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### BASH INSULTER (works in zsh though) ###
if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

#clear
eval "$(starship init zsh)"
#neofetch
