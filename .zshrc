#!/usr/bin/env zsh
# ~/.zshrc

# homebrew prefix
BREW_PREFIX=/opt/homebrew/opt

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# initialize powerlevel10k
source /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

# source any .zsh files in ~/.zsh/config/
for file in ~/.zsh/config/*.zsh; do
  source "$file"
done

# load the powerlevel10k config. to reconfigure, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# initialize the zsh-autosuggestions plugin
source $BREW_PREFIX/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# enable history substring search (use ↑/↓ to cycle through matching history)
source $BREW_PREFIX/zsh-history-substring-search/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# initialize the fast-syntax-highlighting plugin (must be last)
source $BREW_PREFIX/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
