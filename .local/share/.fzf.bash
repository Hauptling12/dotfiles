# Setup fzf
# ---------
if [[ ! "$PATH" == */home/chief/my-work/DOWNLOADS/git/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/chief/my-work/DOWNLOADS/git/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/chief/my-work/DOWNLOADS/git/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/chief/my-work/DOWNLOADS/git/fzf/shell/key-bindings.bash"
