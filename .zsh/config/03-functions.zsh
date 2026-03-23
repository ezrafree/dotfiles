#!/usr/bin/env zsh

# my dotfiles bare repo git command
cfg() {
  /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

# make a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# reusable helper to check if a command is installed
has() {
  (( $+commands[$1] ))
}

if has rg && has fzf && has bat && has nvim; then
  # recursively search current directory, select a match with fuzzy search, and open it in nvim
  # usage: $ search <search term>
  search() {
    local selection file line

    selection=$(
      rg --line-number --no-heading --color=always "$@" |
      fzf --ansi \
          --delimiter : \
          --preview 'bat --style=numbers --color=always {1} --highlight-line {2}'
    ) || return

    [[ -z "$selection" ]] && return

    file="${selection%%:*}"
    line="${selection#*:}"
    line="${line%%:*}"

    nvim "+${line}" "$file"
  }

  # recursively perform a live search on the current directory
  # usage: $ livesearch
  livesearch() {
    local rg_prefix='rg --line-number --no-heading --color=always'

    fzf --ansi --disabled \
        --bind "change:reload:$rg_prefix {q} || true" \
        --delimiter : \
        --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
        --bind 'enter:execute(nvim +{2} {1})'
  }
fi

# map rm to trash while allowing (but ignoring) additional flags but preserving -v
# usage: $ rm -rfv <file | directory>
if has trash; then
  unalias rm 2>/dev/null

  function rm {
    local verbose=0
    local files=()
    local parsing_flags=1
    local arg

    for arg in "$@"; do
      if (( parsing_flags )); then
        case "$arg" in
          --)
            parsing_flags=0
            ;;
          --verbose)
            verbose=1
            ;;
          -[!-]*)
            [[ "$arg" == *v* ]] && verbose=1
            ;;
          -*)
            ;;
          *)
            files+=("$arg")
            ;;
        esac
      else
        files+=("$arg")
      fi
    done

    (( ${#files[@]} == 0 )) && return 1

    if (( verbose )); then
      command trash -v "${files[@]}"
    else
      command trash "${files[@]}"
    fi
  }
fi

# pull, add, commit, and push a repo (uses dotfiles instead of git when run in ~)
# usage:
# $ syncrepo
# $ syncrepo .
# $ syncrepo ~
# $ syncrepo ~/code/my-repo/
# $ syncrepo "my commit message"
if has git; then
  syncrepo() {
    local dir="."
    local commit_msg="updates"
    local oldpwd="$PWD"
    local -a cmd

    # argument parsing
    if (( $# == 1 )); then
      if [[ -d "$1" ]]; then
        dir="$1"
      else
        commit_msg="$1"
      fi
    elif (( $# >= 2 )); then
      dir="$1"
      commit_msg="$2"
    fi

    cd "$dir" || return

    if [[ "$PWD" == "$HOME" ]]; then
      cmd=(/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME")
    else
      cmd=(git)
    fi

    "${cmd[@]}" pull
    "${cmd[@]}" add -v .

    if "${cmd[@]}" diff --cached --quiet; then
      echo "nothing to commit"
    else
      "${cmd[@]}" commit -m "$commit_msg" && "${cmd[@]}" push
    fi

    cd "$oldpwd" || return
  }
fi

# show local IP address
localip() {
  ipconfig getifaddr "$(route get default | awk '/interface: / {print $2}')"
}
