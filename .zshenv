# .zshenv

# configure volta for managing node versions
export VOLTA_HOME="$HOME/.volta"

typeset -U path PATH

path=(
  "$VOLTA_HOME/bin"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "$HOME/.bin"
  "$HOME/bin"
  "/opt/homebrew/opt/coreutils/libexec/gnubin"
  $path
)

# configure a user config for npm
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
