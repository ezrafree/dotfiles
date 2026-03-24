#!/usr/bin/env zsh

# for debugging only, print commands being run by aliases
# (leave this commented when not in use to preserve performance)
#preexec(){ [ $1 != $2 ] && print -r "> $2" }

# reload zsh (better than `source ~/.zshrc`)
alias reload='exec zsh'

# benchmark zsh startup time
alias timezsh='{ time ( source ~/.zshrc; ) } 2>&1 | awk "{print \$(NF-1) \"s\"}"'

# convenience shortcuts
alias cl='clear'
alias cdc='cd; clear'

# git convenience shortcuts
alias pdev='git co dev && git pull'
alias pmain='git co main && git pull'
alias gco='git branch | fzf | xargs git checkout'
alias stash='git stash --include-untracked'
alias logdiff='git log --full-diff -p'

# delete local branches whose remote tracking branch no longer exists
alias brsync='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs -I {} git branch -D {}'

# nuke all local branches except current, master, main, dev
alias brclear='git branch | egrep -v "(^\*|master|main|dev)" | xargs -I {} git branch -D {}'

# map `yarn up` to `yarn upgrade`
alias 'yarn up'='yarn upgrade'

# change directory commands
alias cdwiki='cd ~/code/wiki/'
alias cdphoenix='cd ~/.config/phoenix/'

# tail the phoenix window manager logs
alias logphoenix='cdphoenix && log stream --process Phoenix'

# sync git repos that I don't care about the commit messages
alias syncwiki='syncrepo ~/code/wiki'
alias syncbootstrap='syncrepo ~/code/quietmind-sh'
alias synchome='syncrepo ~'

# add default flags to commands
alias df='df -h'
alias du='du -ch'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias rg='rg --smart-case'

# flush the DNS cache and restart the DNS responder service
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# print out the paths in $PATH each on a new line
alias echopath='echo $PATH | tr : "\n"'

# copy the most recently run command to the clipboard
alias lc='fc -ln -1 | pbcopy'

# map `rrm` to the real `rm` as an escape hatch
alias rrm='/bin/rm'

# more memorable versions of `jq` and `yq`
alias json='jq .'
alias yaml='yq .'

# pretty `ls` alternatives
if [[ "${CUSTOM_LS_COMMAND}" == "eza" ]]; then
  command -v eza > /dev/null && \
    alias ls='eza --group-directories-first --icons' && \
    alias la='eza --group-directories-first --icons --all' && \
    alias ll='eza --group-directories-first --icons --long --group --header --git --all' && \
    alias lt='eza --group-directories-first --icons --tree --level=3 --ignore-glob="node_modules"'
elif [[ "${CUSTOM_LS_COMMAND}" == "lsd" ]]; then
  command -v lsd > /dev/null && \
    alias ls='lsd --group-dirs first --icon always' && \
    alias la='lsd --group-dirs first --icon always -A' && \
    alias ll='lsd --group-dirs first --icon always -Al' && \
    alias lt='lsd --group-dirs first --icon always --tree --depth 3 --ignore-glob "node_modules"'
elif [[ "${CUSTOM_LS_COMMAND}" == "" ]]; then
  unalias ls 2>/dev/null
  unalias la 2>/dev/null
  unalias lt 2>/dev/null
  alias ll='ls -lahp'
fi

# create aliases for `vi` and `vim` if the `nvim` command exists
command -v nvim > /dev/null && \
  alias vi='nvim' && \
  alias vim='nvim'

# ain't nobody got time to be typing out lazygit
command -v lazygit > /dev/null && alias lg='lazygit'

# ain't nobody got time to be typing out dashes
command -v git-quick-stats > /dev/null && alias gitstats='git-quick-stats'

# replace default `cat` command
command -v bat > /dev/null && alias cat='bat --pager never'

# replace default `top` command
# use `btop` if it exists, else use `htop` if it exists
if command -v btop > /dev/null; then
  alias top='btop'
elif command -v htop > /dev/null; then
  alias top='htop'
fi

# just for fun haha
if command -v fortune > /dev/null && command -v cowsay > /dev/null && command -v lolcat > /dev/null; then
  alias zoltar='fortune | cowsay | lolcat'
fi
