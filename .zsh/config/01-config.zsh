#!/usr/bin/env zsh

##################################################

# MY CUSTOM CONFIG OPTIONS

# set this to either "eza" or "lsd" or an empty string to use normal "ls"
CUSTOM_LS_COMMAND="lsd"

# set to which editor should be used to open files from fzf searches ("code" or "nvim")
export FZFSEARCH_EDITOR="code"

##################################################

# PATH

# add homebrew to PATH
export PATH="/opt/homebrew/bin:$PATH"

# add volta to PATH
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# add pyenv paths to PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
# initialize pyenv (disabled for faster startup; uncomment if you need shims/version switching)
# eval "$(pyenv init -)"

# add gnubin to PATH
export PATH="$BREW_PREFIX/coreutils/libexec/gnubin:$PATH"

# claude code
export PATH="$HOME/.local/bin:$PATH"

##################################################

# CONFIG

# disable command auto-correction
unsetopt CORRECT

# cache all executables in $PATH for faster command lookup
setopt HASH_LIST_ALL

# Zsh variable to determine what to ignore,
# in this case everything starting with _ or .
CORRECT_IGNORE="[_|.]*"

# remove background highlighting when pasting
zle_highlight+=(paste:none)

# initialize zsh completion system
autoload -Uz compinit && compinit

# configure visual editor for git etc.
export GIT_EDITOR="nvim -f"
export VISUAL=nvim
export EDITOR=nvim

# configure fuzzy finder (fzf) shell integration
source <(fzf --zsh)
export FZF_CTRL_T_OPTS="--style full --preview 'fzf-preview.sh {}'"
export FZF_CTRL_R_OPTS="--height 40%"  # keep history search minimal

# initialize zoxide (z) for advanced cd functionality
eval "$(zoxide init zsh)"

# use ↑/↓ to cycle through history matching current input
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# use ctrl-e to backspace through words but stop at $WORDCHARS
bindkey -M viins '^E' vi-backward-kill-word
bindkey '^E' vi-backward-kill-word

# use ctrl-w to jump entire words when backspacing
bindkey -M viins '^W' backward-kill-word
bindkey '^W' backward-kill-word

# clear text between quotes with ctrl-x, ctrl-z
zle -N clear-between-quotes
bindkey -M emacs '^X^Z' clear-between-quotes
bindkey -M viins '^X^Z' clear-between-quotes
