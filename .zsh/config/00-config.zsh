#!/usr/bin/env zsh

# read the commands in `~/.zsh_nocorrect` and set them to not be autocorrected
if [ -f ~/.zsh_nocorrect ]; then
    while read -r COMMAND; do
        alias $COMMAND="nocorrect $COMMAND"
    done < ~/.zsh_nocorrect
fi

# enable command auto-correction
ENABLE_CORRECTION="false"

# OPTs to enable
setopt HASH_LIST_ALL
setopt CORRECT
# Zsh variable to determine what to ignore,
# in this case everything starting with _ or .
CORRECT_IGNORE="[_|.]*"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# set this to either "eza" or "lsd" or an empty string to use normal "ls"
CUSTOM_LS_COMMAND="lsd"

# remove background highlighting when pasting
zle_highlight+=(paste:none)

# enable git branch name autocompletion
autoload -Uz compinit && compinit

# configure pyenv for python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
