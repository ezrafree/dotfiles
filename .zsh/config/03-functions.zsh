#!/usr/bin/env zsh

# my dotfiles bare repo git command
cfg() {
  /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

# make a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# delete every file except the specified file
# usage: $ keeponly example.txt
# usage: $ keeponly example.txt /some/dir
keeponly() {
  find "${2:-.}" -maxdepth 1 -type f ! -name "$1" -delete
}

# reusable helper to check if a command is installed
has() {
  (( $+commands[$1] ))
}

if has rg && has fzf && has bat && has nvim; then
  _fzfsearch_cmd() {
    case "${FZFSEARCH_EDITOR:-code}" in
      code)  echo "code --goto {1}:{2}" ;;
      nvim)  echo "nvim +{2} {1}" ;;
      *)     echo "$FZFSEARCH_EDITOR {1}" ;;
    esac
  }

  _fzfsearch_open() {
    local file="$1" line="$2"
    local cmd
    cmd="$(_fzfsearch_cmd)"
    cmd="${cmd/\{1\}/\"$file\"}"
    cmd="${cmd/\{2\}/$line}"
    eval "$cmd"
  }

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

    _fzfsearch_open "$file" "$line"
  }

  # recursively perform a live search on the current directory
  # usage: $ livesearch
  livesearch() {
    local rg_prefix='rg --line-number --no-heading --color=always'

    fzf --ansi --disabled \
        --bind "start:reload:$rg_prefix '' || true" \
        --bind "change:reload:$rg_prefix {q} || true" \
        --delimiter : \
        --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
        --bind "enter:execute($(_fzfsearch_cmd))"
  }

  browse() {
    local file
    file=$(fd --type f | fzf --preview "bat --color=always {}" --preview-window=right:60%) || return
    [[ -z "$file" ]] && return
    _fzfsearch_open "$file" 1
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

# custom `brewup` function for update/upgrade
if has brew; then
  brewup() {
    case "$1" in
      update)
        brew update
        local outdated=$(brew outdated)
        [ -z "$outdated" ] && echo "Everything up to date" || echo "$outdated"
        ;;
      upgrade)
      brew update
        local outdated=$(brew outdated)
        if [ -z "$outdated" ]; then
          echo "Everything up to date"
        else
          echo "$outdated"
          echo
          read "?Upgrade all? [y/N] " confirm
          [[ "$confirm" =~ ^[Yy]$ ]] && brew upgrade
        fi
        ;;
      *)
        echo "Usage: brewup [update|upgrade]"
        ;;
    esac
  }
fi

# show local IP address
localip() {
  ipconfig getifaddr "$(route get default | awk '/interface: / {print $2}')"
}

# run `git pull` in each sub-directory if the repo is clean
pullall() {
  local dir="${1:-.}"

  for repo in "$dir"/*(/); do
    [[ -d "$repo/.git" ]] || continue

    echo "==> ${repo:t}"

    if [[ -n "$(git -C "$repo" status --porcelain)" ]]; then
      echo "Skipping: working tree has changes"
      continue
    fi

    git -C "$repo" pull --ff-only
  done
}

# touch a file but make the directory if it doesn't exist
mktouch() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

# commit helper
commit() {
  local type=""
  local scope=""
  local description=""
  local all=false
  local noadd=false
  local nopush=false
  local debug=false
  local positional=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--type)
        type="$2"
        shift 2
        ;;
      --type=*)
        type="${1#*=}"
        shift
        ;;
      -s|--scope)
        scope="$2"
        shift 2
        ;;
      --scope=*)
        scope="${1#*=}"
        shift
        ;;
      -d|--description|-m|--message)
        description="$2"
        shift 2
        ;;
      --description=*|--message=*)
        description="${1#*=}"
        shift
        ;;
      -A|--all)
        all=true
        shift
        ;;
      -a|--noadd)
        noadd=true
        shift
        ;;
      -p|--nopush)
        nopush=true
        shift
        ;;
      --debug)
        debug=true
        shift
        ;;
      *)
        positional+=("$1")
        shift
        ;;
    esac
  done

  [[ -z "$type" ]] && type="${positional[1]}"
  [[ -z "$scope" ]] && scope="${positional[2]}"
  [[ -z "$description" ]] && description="${positional[3,-1]}"

  if [[ -z "$type" ]]; then
    echo "Commit type:"
    select selected_type in feat test fix refactor docs style build ci perf; do
      type="$selected_type"
      break
    done
  fi

  [[ -z "$scope" ]] && read "scope?Commit scope: "
  [[ -z "$description" ]] && read "description?If accepted, this commit will: "

  local commit_message="${type}(${scope}): ${description}"

  if [[ "$debug" == true ]]; then
    echo "$commit_message"
    return 0
  fi

  if [[ ! -d .git ]]; then
    echo "Not in a git repository root."
    return 1
  fi

  if [[ "$noadd" == true ]]; then
    git commit -m "$commit_message"
  elif [[ "$all" == true ]]; then
    git add -A && git commit -m "$commit_message"
  else
    git commit -am "$commit_message"
  fi

  local commit_status=$?
  [[ $commit_status -ne 0 ]] && return $commit_status

  if [[ "$nopush" != true ]]; then
    git push origin HEAD
  fi
}
