#!/usr/bin/env zsh

# my dotfiles bare repo git command
cfg() {
  /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

# pull the latest changes for my ~/.config repos
cfgup() {
  local repo

  for repo in ~/.config/phoenix ~/.config/karabiner; do
    echo "==> ${repo:t}"
    git -C "$repo" pull
  done
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
#
# heavy + regenerable dirs (node_modules, ...) are pulled aside onto their own
# volume and deleted in the background, so they never bloat the Trash and you
# never wait on a slow empty. everything else is trashed (recoverable) as usual.
if has trash; then
  unalias rm 2>/dev/null

  typeset -ga RM_PURGE_DIRS=(node_modules)

  # Writable scratch dir on the SAME volume as $1, so the move is an instant rename.
  # NOTE: must use /usr/bin/stat (BSD) explicitly -- GNU coreutils stat may shadow it
  # on PATH, and there `-f` means --file-system, which breaks the `%d` device lookup.
  _rm_stage_base() {
    local target="${1:A}" dev base root
    dev=$(/usr/bin/stat -f '%d' "$target" 2>/dev/null) || return 1
    if [[ "$dev" == "$(/usr/bin/stat -f '%d' "$HOME" 2>/dev/null)" ]]; then
      base="$HOME/.cache/rm-purge"                 # boot/data volume
    else
      root="$target"                               # walk up to the volume's mount point
      while [[ "${root:h}" != "$root" \
               && "$(/usr/bin/stat -f '%d' "${root:h}" 2>/dev/null)" == "$dev" ]]; do
        root="${root:h}"
      done
      base="$root/.cache/rm-purge"                 # e.g. /Volumes/External/.cache/rm-purge
    fi
    command mkdir -p "$base" 2>/dev/null || return 1
    [[ "$(/usr/bin/stat -f '%d' "$base" 2>/dev/null)" == "$dev" ]] || return 1   # confirm same volume
    print -r -- "$base"
  }

  function rm {
    local verbose=0 files=() parsing_flags=1 arg
    for arg in "$@"; do
      if (( parsing_flags )); then
        case "$arg" in
          --)        parsing_flags=0 ;;
          --verbose) verbose=1 ;;
          -[!-]*)    [[ "$arg" == *v* ]] && verbose=1 ;;
          -*)        ;;
          *)         files+=("$arg") ;;
        esac
      else
        files+=("$arg")
      fi
    done

    (( ${#files[@]} == 0 )) && return 1

    local -a find_expr=( -type d '(' )
    local d first=1
    for d in "${RM_PURGE_DIRS[@]}"; do
      (( first )) || find_expr+=(-o)
      find_expr+=(-name "$d"); first=0
    done
    find_expr+=( ')' -prune -print )

    # Pull regenerable dirs aside on their own volume, then delete in the background.
    # Same-volume move = instant; if we can't stage same-volume, delete in place (sync).
    local -a staged
    local -i n=0
    local f nm base
    for f in "${files[@]}"; do
      [[ -d "$f" ]] || continue
      local -a hits=("${(@f)$(find "$f" "${find_expr[@]}" 2>/dev/null)}")
      for nm in "${hits[@]}"; do
        [[ -n "$nm" && -d "$nm" ]] || continue
        if base=$(_rm_stage_base "$nm") && command mv "$nm" "$base/$$.$n" 2>/dev/null; then
          staged+=("$base/$$.$n"); (( n++ ))
        else
          /bin/rm -rf "$nm" 2>/dev/null
        fi
      done
    done

    if (( ${#staged} )); then
      print "rm: purging ${#staged} ${RM_PURGE_DIRS[*]} dir(s) in background"
      /bin/rm -rf "${staged[@]}" 2>/dev/null &!
    fi

    # trash whatever survives (the source; drops args fully removed above)
    local -a to_trash
    for f in "${files[@]}"; do
      [[ -e "$f" || -L "$f" ]] && to_trash+=("$f")
    done
    (( ${#to_trash} == 0 )) && return 0

    if (( verbose )); then
      command trash -v "${to_trash[@]}"
    else
      command trash "${to_trash[@]}"
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
    local -a add_flags=(-v)

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
      add_flags+=(-u)
    else
      cmd=(git)
    fi

    "${cmd[@]}" pull
    "${cmd[@]}" add "${add_flags[@]}" .

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

# commit helper — flag-driven Conventional Commits fallback.
# Skipped on machines that have the gum-based ~/bin/commit.
[[ -x "$HOME/bin/commit" ]] || commit() {
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

    # Parse conventional commit format: type(scope): description
    if [[ -z "$type" && ${#positional[@]} -eq 1 ]] && [[ "$positional[1]" =~ '^([a-z]+)\(([^)]*)\): *(.+)$' ]]; then
      type="${match[1]}"
      scope="${match[2]}"
      description="${match[3]}"

      # Auto-enable --all if description hints at untracked files
      if [[ "$description" =~ '(untracked|new files|include)' ]]; then
        all=true
      fi
    fi

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
      if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
        git pull && git push
      else
        local current_branch

        current_branch=$(git branch --show-current)

        if [[ -z "$current_branch" ]]; then
          echo "Cannot push without an upstream from a detached HEAD."
          return 1
        fi

        git push -u origin "$current_branch"
      fi
    fi
  }
}

clear-between-quotes() {
  local buf="$BUFFER"
  local i quote_char open=-1 close=-1

  # scan backward from the end to find the last quote character
  for (( i = ${#buf}; i >= 1; i-- )); do
    if [[ "${buf[$i]}" == "'" || "${buf[$i]}" == '"' ]]; then
      close=$i
      quote_char="${buf[$i]}"
      break
    fi
  done
  (( close == -1 )) && { zle -M "No quote found"; return }

  # scan further back for the matching opening quote of the same type
  for (( i = close - 1; i >= 1; i-- )); do
    if [[ "${buf[$i]}" == "$quote_char" ]]; then
      open=$i
      break
    fi
  done
  (( open == -1 )) && { zle -M "No matching opening quote"; return }

  BUFFER="${buf[1,open]}${buf[close,${#buf}]}"
  CURSOR=$open
}

backward-kill-subword() {
  local WORDCHARS=${WORDCHARS//[\/-]}
  zle backward-kill-word
}

# awake — keep the Mac from idle-sleeping for a while
#   awake 4h · awake 90m · awake 1h30 · awake 45 (minutes) · awake 30s
#   awake 4am · awake 4:30pm · awake 16:00   until the next time the clock hits that
#   awake make build                         until that command finishes
#   awake 2h -d   extra flags pass through to caffeinate (-d also keeps the display on)
#   awake         no duration: stay awake until Ctrl-C
awake() {
  zmodload -F zsh/datetime b:strftime p:EPOCHSECONDS

  # Command mode: run it in this shell (so aliases and functions work, with your
  # own shell options) and hold a sleep assertion until it exits, however it exits.
  if [[ -n $1 && $1 != -* ]] && whence -- "$1" >/dev/null; then
    local _awake_took
    integer _awake_start=$EPOCHSECONDS _awake_pid _awake_secs
    print "☕ Awake until $1 finishes"
    caffeinate -i -w $$ &!   # -w $$: also lets go if this terminal is closed
    _awake_pid=$!
    {
      eval "${(q-)@}"
    } always {
      kill $_awake_pid 2>/dev/null
      _awake_secs=$(( EPOCHSECONDS - _awake_start ))
      (( _awake_secs >= 3600 )) && _awake_took+="$(( _awake_secs / 3600 ))h"
      (( _awake_secs >= 60 ))   && _awake_took+="$(( _awake_secs % 3600 / 60 ))m"
      (( _awake_secs < 3600 ))  && _awake_took+="$(( _awake_secs % 60 ))s"
      print "☕ $1 done after $_awake_took — Mac can sleep again"
    }
    return
  fi

  emulate -L zsh -o no_bash_rematch

  if [[ -z $1 || $1 == -* ]]; then
    print "☕ Awake until Ctrl-C"
    caffeinate -i "$@"
    return
  fi

  local arg=${(L)1} usage="usage: awake [4h | 1h30 | 45m | 4am | 4:30pm | 16:00 | <command>] [caffeinate flags]"
  local day today tomorrow end
  integer now=$EPOCHSECONDS total=0 h=-1 m stop
  shift

  if [[ $arg =~ '^([0-9]{1,2})(:([0-9]{2}))?([ap])m?$' ]]; then
    # 12-hour clock: 4am, 4:30pm, 11p
    h=$match[1] m=${match[3]:-0}
    (( h >= 1 && h <= 12 && m < 60 )) || { print -u2 $usage; return 1 }
    (( h %= 12 ))
    [[ $match[4] == p ]] && (( h += 12 ))
  elif [[ $arg =~ '^([0-9]{1,2}):([0-9]{2})$' ]]; then
    # 24-hour clock: 16:00, 0:30
    h=$match[1] m=$match[2]
    (( h < 24 && m < 60 )) || { print -u2 $usage; return 1 }
  else
    # duration: 4h, 90m, 1h30, 30s
    local rest=$arg
    while [[ $rest =~ '^([0-9]+)([hms]?)(.*)$' ]]; do
      case $match[2] in
        h)    (( total += match[1] * 3600 )) ;;
        m|'') (( total += match[1] * 60 )) ;;
        s)    (( total += match[1] )) ;;
      esac
      rest=$match[3]
    done
    if [[ -n $rest ]] || (( total == 0 )); then
      print -u2 $usage
      return 1
    fi
  fi

  strftime -s today    '%Y-%m-%d' $now
  strftime -s tomorrow '%Y-%m-%d' $(( now + 86400 ))

  if (( h >= 0 )); then
    # Next time the clock reads h:m: today if it's still ahead, otherwise tomorrow
    for day in $today $tomorrow; do
      strftime -r -s stop '%Y-%m-%d %H:%M' "$day $h:$m"
      (( stop > now )) && break
    done
    total=$(( stop - now ))
  else
    stop=$(( now + total ))
  fi

  strftime -s day '%Y-%m-%d' $stop
  if [[ $day == $today ]]; then
    strftime -s end '%L:%M %p' $stop
  elif [[ $day == $tomorrow ]]; then
    strftime -s end '%L:%M %p tomorrow' $stop
  else
    strftime -s end '%a %L:%M %p' $stop
  fi

  print "☕ Awake until $end — Ctrl-C to stop early"
  caffeinate -i -t $total "$@"
}

# stage a branch's full diff against a base branch and open it in VS Code for review
# usage: $ branchreview [base] [repo-path]
# usage: $ branchreview --done|-d [repo-path]
branchreview() {
  if [[ "$1" == "--done" || "$1" == "-d" ]]; then
    _branchreview_done "${@:2}"
    return
  fi

  local base="${1:-main}"
  local repo="${2:-.}"
  local top git_dir state_file branch head merge_base

  if [[ -n "$GIT_DIR$GIT_WORK_TREE" ]]; then
    echo "branchreview: GIT_DIR or GIT_WORK_TREE is set and would override the repo path (unset them first)" >&2
    return 1
  fi

  top="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || {
    echo "branchreview: '$repo' is not inside a git work tree" >&2
    return 1
  }
  git_dir="$(git -C "$top" rev-parse --absolute-git-dir)" || return 1
  state_file="$git_dir/branchreview"

  if [[ -e "$state_file" ]]; then
    echo "branchreview: a review is already in progress in $top (run branchreview --done first)" >&2
    return 1
  fi

  branch="$(git -C "$top" symbolic-ref --quiet --short HEAD)" || {
    echo "branchreview: HEAD is detached in $top (check out the branch to review first)" >&2
    return 1
  }

  if [[ -n "$(git -C "$top" status --porcelain --untracked-files=no)" ]]; then
    echo "branchreview: $top has staged or unstaged changes (commit or stash them first)" >&2
    return 1
  fi

  if ! git -C "$top" rev-parse --verify --quiet "${base}^{commit}" >/dev/null; then
    echo "branchreview: base '$base' does not exist" >&2
    return 1
  fi

  if ! has code; then
    echo "branchreview: VS Code 'code' CLI not found in PATH" >&2
    return 1
  fi

  head="$(git -C "$top" rev-parse HEAD)" || return 1
  merge_base="$(git -C "$top" merge-base "$base" "$head")" || {
    echo "branchreview: '$base' and '$branch' have no common ancestor" >&2
    return 1
  }

  if [[ "$merge_base" == "$head" ]]; then
    echo "branchreview: '$branch' has no commits that aren't already in '$base'" >&2
    return 1
  fi

  if [[ -n "$(git -C "$top" ls-files --others --exclude-standard)" ]]; then
    echo "branchreview: warning: untracked files will show up alongside the review diff" >&2
  fi

  print -rl -- "$branch" "$head" > "$state_file" || return 1

  if ! git -C "$top" switch --quiet --detach; then
    command rm -f -- "$state_file"
    return 1
  fi

  if ! git -C "$top" reset --quiet --soft "$merge_base"; then
    git -C "$top" switch --quiet "$branch" && command rm -f -- "$state_file"
    return 1
  fi

  code "$top"

  echo "Reviewing '$branch' against '$base' (merge-base ${merge_base:0:8})"
  git -C "$top" diff --cached --shortstat
  echo "In Source Control, hover \"Staged Changes\" and click the \"Open Staged Changes\" button to see all files in one diff."
  echo "When finished, run: branchreview --done${2:+ ${(q-)top}}"
}

# restore the branch saved by branchreview (called via `branchreview --done`)
_branchreview_done() {
  local repo="${1:-.}"
  local top git_dir state_file branch head current
  local -a state

  if [[ -n "$GIT_DIR$GIT_WORK_TREE" ]]; then
    echo "branchreview --done: GIT_DIR or GIT_WORK_TREE is set and would override the repo path (unset them first)" >&2
    return 1
  fi

  top="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || {
    echo "branchreview --done: '$repo' is not inside a git work tree" >&2
    return 1
  }
  git_dir="$(git -C "$top" rev-parse --absolute-git-dir)" || return 1
  state_file="$git_dir/branchreview"

  if [[ ! -f "$state_file" ]]; then
    echo "branchreview --done: no review in progress in $top" >&2
    return 1
  fi

  state=("${(@f)$(<"$state_file")}")
  branch="${state[1]}"
  head="${state[2]}"

  if [[ -z "$branch" || -z "$head" ]]; then
    echo "branchreview --done: saved state in $state_file is invalid" >&2
    return 1
  fi

  if current="$(git -C "$top" symbolic-ref --quiet --short HEAD)"; then
    if [[ "$current" != "$branch" ]]; then
      echo "branchreview --done: HEAD is on '$current', not the detached review of '$branch' (delete $state_file to discard the review)" >&2
      return 1
    fi

    command rm -f -- "$state_file"
    echo "Already on '$branch'; cleared review state"
    return 0
  fi

  git -C "$top" reset --quiet --soft "$head" || return 1
  git -C "$top" switch --quiet "$branch" || return 1
  command rm -f -- "$state_file"

  echo "Back on '$branch' in $top"

  if [[ -n "$(git -C "$top" status --porcelain --untracked-files=no)" ]]; then
    echo "Note: edits or staging changes made during the review are still present (see git status)"
  fi
}
