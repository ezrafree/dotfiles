#!/usr/bin/env zsh

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
  rm() {
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
          -v|--verbose)
            verbose=1
            ;;
          -*)
            ;; # ignore other flags like -r -f
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