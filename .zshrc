#!/usr/bin/env zsh
# ~/.zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# initialize powerlevel10k
source ~/powerlevel10k/powerlevel10k.zsh-theme

# source any .zsh files in ~/.zsh/config/
for file in ~/.zsh/config/*.zsh; do
  source "$file"
done

# load the powerlevel10k config. to reconfigure, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# initialize the zsh-autosuggestions plugin
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# initialize the fast-syntax-highlighting plugin (must be last)
source ~/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
