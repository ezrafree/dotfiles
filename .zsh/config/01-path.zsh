#!/usr/bin/env zsh

# configure volta for managing node versions
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# configure vs code's `code` command
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# configure path for my own scripts in `~/.bin/` and `~/bin/`
export PATH="$HOME/.bin:$HOME/bin:$PATH"

# configure a user config for npm
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
