#!/usr/bin/env zsh

# disable command auto-correction
unsetopt CORRECT

# cache all executables in $PATH for faster command lookup
setopt HASH_LIST_ALL

# Zsh variable to determine what to ignore,
# in this case everything starting with _ or .
CORRECT_IGNORE="[_|.]*"

# set this to either "eza" or "lsd" or an empty string to use normal "ls"
CUSTOM_LS_COMMAND="lsd"

# remove background highlighting when pasting
zle_highlight+=(paste:none)

# initialize zsh completion system
autoload -Uz compinit && compinit

# configure visual editor for git etc.
export GIT_EDITOR="nvim -f"
export VISUAL=nvim
export EDITOR=nvim

# configure pyenv root
export PYENV_ROOT="$HOME/.pyenv"

# add pyenv root to PATH
export PATH="$PYENV_ROOT/bin:$PATH"

# initialize pyenv (disabled for faster startup; uncomment if you need shims/version switching)
# eval "$(pyenv init -)"

# configure fuzzy finder (fzf) shell integration
source <(fzf --zsh)
export FZF_CTRL_T_OPTS="--style full --preview 'fzf-preview.sh {}'"
export FZF_CTRL_R_OPTS="--height 40%"  # keep history search minimal

# initialize zoxide (z) for advanced cd functionality
eval "$(zoxide init zsh)"

# use ↑/↓ to cycle through history matching current input
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
