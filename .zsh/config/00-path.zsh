#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# configure volta for managing node versions
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# configure visual editor for git
export VISUAL=/usr/local/bin/nvim
export EDITOR="$VISUAL"

# configure vs code's `code` command
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# configure path for my own scripts in `~/.bin/` and `~/bin/`
export PATH="$HOME/.bin:$HOME/bin:$PATH"
