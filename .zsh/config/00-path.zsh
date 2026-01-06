#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# configure n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# configure npm path
export PATH=$HOME/.npm/bin:$PATH

# configure visual editor for git
export VISUAL=/usr/local/bin/nvim
export EDITOR="$VISUAL"
