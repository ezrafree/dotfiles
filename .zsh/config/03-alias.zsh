#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# print commands being run by aliases...
#preexec(){ [ $1 != $2 ] && print -r "> $2" }

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias cl="clear"
alias cdc="cd; clear"
alias cdphoenix="cd ~/.config/phoenix; clear"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
#alias echopath="echo $PATH | tr : '\n'"

alias timezsh='{ time ( source ~/.zshrc; ) } 2>&1'

alias gpg='nocorrect gpg'
alias codex='nocorrect codex'
alias mcp='nocorrect mcp'

alias cleanbr='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
alias clearbr='git branch | egrep -v "(^\*|master|main|dev)" | xargs git branch -D'

alias yarnci='rm -rfv node_modules && rm -fv yarn.lock && yarn'

alias fixyarnlock="rm -rfv yarn.lock && rm -rfv node_modules/.yarn-integrity && yarn && git add -v . && git commit -m 'chore(git): resolve merge conflicts' && git pull && git push"
alias fixyarnlockci="yarn ci && git add -v . && git commit -m 'chore(git): resolve merge conflicts' && git pull && git push"
alias gitfix="git add -v . && git commit -m 'chore(git): resolve merge conflicts' && git push"
alias pdev="git co dev && git pull"
alias pmain="git co main && git pull"

alias stash='git stash --include-untracked'

alias logdiff='git log --full-diff -p'

alias timezsh='{ time ( source ~/.zshrc; ) } 2>&1'

alias cdwiki='cd ~/code/wiki/'
alias syncwiki='cdwiki && git pull && git add -v . && git commit -m "updates" && git push; cd -'
alias synchome='cd ~ && git pull && git add -v . && git commit -m "updates" && git push; cd -'

alias viaws="rm -rfv ~/.aws/credentials && touch ~/.aws/credentials && pbpaste > ~/.aws/credentials && perl -i -pe's/\[(.*?)\]/[default]/g' ~/.aws/credentials && cat ~/.aws/credentials"


# create aliases for `vi` and `vim` if the `nvim` command exists...
command -v nvim > /dev/null && \
  alias vi='nvim' && \
  alias vim='nvim'

#command -v trash > /dev/null && alias rm='trash'

command -v git-stats > /dev/null && alias gitstats='git-stats -g'

if [[ "${CUSTOM_LS_COMMAND}" == "eza" ]]; then
  command -v eza > /dev/null && \
    alias ls='eza --group-directories-first --icons' && \
    alias la='eza --group-directories-first --icons --all' && \
    alias ll='eza --group-directories-first --icons --long --group --header --git --all' && \
    alias lt='eza --group-directories-first --icons --tree --level=3 --ignore-glob="node_modules"'
elif [[ "${CUSTOM_LS_COMMAND}" == "lsd" ]]; then
  command -v lsd > /dev/null && \
    alias ls='lsd --group-dirs first' && \
    alias la='lsd --group-dirs first -A' && \
    alias ll='lsd --group-dirs first -Al' && \
    alias lt='lsd --group-dirs first --tree --depth 3 --ignore-glob "node_modules"'
elif [[ "${CUSTOM_LS_COMMAND}" == "" ]]; then
  unalias ls
  unalias la
  unalias lt
  alias ll='ls -al'
fi

command -v bat > /dev/null && alias cat='bat --pager never'

command -v htop > /dev/null && alias top='htop'

# aliasing a command to itself suppresses zsh correction for it
alias yarn='yarn'
alias mas='mas'
