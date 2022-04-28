# ~/.bashrc: executed by bash(1) for non-login shells.
PS1="\[\033[31m\][\[\033[0m\]\[\033[36m\]\w\[\033[0m\]\[\033[31m\]]\[\033[0m\]$ "
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTFILE="$HOME/documents/cashe/.zsh_history"
HISTSIZE= HISTFILESIZE= # infinite history
export HISTIGNORE="clear"
export HISTTIMEFORMAT='%F %T'
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s expand_aliases # expand aliases
#shopt -s autocd # change to named directory
shopt -s histappend # append to the history file, don't overwrite it

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


#up(){
#  local d=""
#  limit=$1
#  for ((i=1 ; i <= limit ; i++))
#    do
#      d=$d/..
#    done
#  d=$(echo $d | sed 's/^\///')
#  if [ -z "$d" ]; then
#    d=..
#  fi
#  cd $d
#}

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
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
      *.iso)   7z x $1    ;;
      *.jar)   file-roller -h $1    ;;
      *.jpl)   file-roller -h $1    ;;
      *.apk)   file-roller -h $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'
#rempap keys https://serverfault.com/a/12445

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.config/aliases ]; then
    . ~/.config/aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.local/bin:~/.local/bin/script/

if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

[ -f ~/local/share/.fzf.bash ] && source ~/.local/share/.fzf.bash
