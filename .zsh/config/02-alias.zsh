#!/usr/bin/env zsh

# for debugging only, print commands being run by aliases
# (leave this commented when not in use to preserve performance)
#preexec(){ [ $1 != $2 ] && print -r "> $2" }

alias reload='exec zsh'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias cl="clear"
alias cdc="cd; clear"
alias cdphoenix="cd ~/.config/phoenix; clear"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias echopath="echo $PATH | tr : '\n'"
alias rg='rg --smart-case'
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# map `rrm` to the real `rm` as an escape hatch
alias rrm='/bin/rm'

alias timezsh='{ time ( source ~/.zshrc; ) } 2>&1'

alias json='jq .'
alias yaml='yq .'

alias cleanbr='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
alias clearbr='git branch | egrep -v "(^\*|master|main|dev)" | xargs git branch -D'

alias pdev="git co dev && git pull"
alias pmain="git co main && git pull"

alias stash='git stash --include-untracked'

alias logdiff='git log --full-diff -p'

alias cdwiki='cd ~/code/wiki/'
alias syncwiki='cdwiki && git pull && git add -v . && git commit -m "updates" && git push; cd -'
alias synchome='cd ~ && dotfiles pull && dotfiles add -v . && dotfiles commit -m "updates" && dotfiles push; cd -'

#alias viaws="rm -rfv ~/.aws/credentials && touch ~/.aws/credentials && pbpaste > ~/.aws/credentials && perl -i -pe's/\[(.*?)\]/[default]/g' ~/.aws/credentials && cat ~/.aws/credentials"

# pretty `ls` alternatives
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

# create aliases for `vi` and `vim` if the `nvim` command exists
command -v nvim > /dev/null && \
  alias vi='nvim' && \
  alias vim='nvim'

command -v lazygit > /dev/null && alias lg='lazygit'

command -v git-quick-stats > /dev/null && alias gitstats='git-quick-stats'

command -v bat > /dev/null && alias cat='bat --pager never'

# use `btop` if it exists, else use `htop` if it exists
if command -v btop > /dev/null; then
  alias top='btop'
elif command -v htop > /dev/null; then
  alias top='htop'
fi

if command -v fortune > /dev/null && command -v cowsay > /dev/null && command -v lolcat > /dev/null; then
  alias zoltar='fortune | cowsay | lolcat'
fi

# suppress zsh correction...
# aliasing a command to itself also suppresses zsh correction
# but `nocorrect` is more explicit
alias yarn='nocorrect yarn'
alias mas='nocorrect mas'
alias gpg='nocorrect gpg'
alias codex='nocorrect codex'
alias mcp='nocorrect mcp'
