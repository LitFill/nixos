# Bash Utility Functions
# Managed by Home Manager; the nushell counterparts live in
# files/functions.nu. Not a full port — nushell-only data
# transformations (to-kv) and table parsing have no bash equivalent.

# --- Navigation Functions ---

# Create a directory and enter it.
#
# Examples:
#   mkcd new_project
mkcd() {
  mkdir -p -- "$1" && cd -- "$1" || return
}

# Go up the directory tree by one level.
#
# Examples:
#   up
up() {
  cd -- .. || return
}

# Go back to the previous working directory.
#
# Examples:
#   back
back() {
  cd - || return
}

# Fuzzy find a directory and cd into it.
#
# Examples:
#   lcd
#   lcd /tmp
lcd() {
  local dir
  dir="$(fd --type d --max-depth 1 --hidden --follow --exclude .git . "${1:-.}" | fzf --prompt="cd > ")" && cd -- "$dir" || return
}

# List directories with indices and cd into the selected number.
#
# Examples:
#   ncd
ncd() {
  local target="${1:-.}" dirs=() i=0 choice
  mapfile -t dirs < <(fd --type d --max-depth 1 --hidden --follow --exclude .git . "$target" | sort)
  if (( ${#dirs[@]} == 0 )); then
    printf 'No directories found in %s\n' "$target" >&2
    return 1
  fi
  for d in "${dirs[@]}"; do
    printf '%d\t%s\n' "$i" "$d"
    (( i += 1 ))
  done
  read -r -p "Enter the directory index: " choice
  [[ -z "$choice" ]] && return 0
  if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice < ${#dirs[@]} )); then
    cd -- "${dirs[choice]}" || return
  else
    printf "Error: Invalid index '%s'.\n" "$choice" >&2
    return 1
  fi
}

# --- File Management Functions ---

# Smart directory listing with focus on size, mode, and name.
#
# Examples:
#   lss
#   lss /tmp
lss() {
  eza -l --git --icons=auto "$@"
}

# Show content of a file in a fenced block.
#
# Examples:
#   show README.md
show() {
  local f="$1"
  printf '```%s %s\n' "${f##*.}" "$f"
  command cat -- "$f"
  printf '\n```\n'
}

# Show content of all files recursively, with optional filters.
#
# Examples:
#   glimpse
#   glimpse /tmp
#   glimpse --ext md
#   glimpse --max-lines 30
#   glimpse --hidden
glimpse() {
  local path="." ext="" max=0 hidden=0 pretty=0
  while (( $# )); do
    case "$1" in
      --ext) ext="$2"; shift 2 ;;
      --max-lines) max="$2"; shift 2 ;;
      --hidden) hidden=1; shift ;;
      --pretty) pretty=1; shift ;;
      *) path="$1"; shift ;;
    esac
  done

  local fd_args=(--type f)
  (( hidden )) && fd_args+=(--hidden)
  [[ -n "$ext" ]] && fd_args+=(--extension "$ext")

  local file total
  while IFS= read -r file; do
    if (( pretty )); then
      printf '─── %s\n\n' "$file"
    else
      printf '```%s %s\n' "${file##*.}" "$file"
    fi
    if (( max > 0 )); then
      head -n "$max" -- "$file"
      total="$(wc -l < "$file")"
      (( max < total )) && printf '\n... [%s of %s lines]\n' "$max" "$total"
    else
      command cat -- "$file"
    fi
    if (( pretty )); then
      printf '\n'
    else
      printf '\n```\n'
    fi
  done < <(fd "${fd_args[@]}" . "$path" | sort)
}

# Trim whitespace and remove empty lines from input.
#
# Examples:
#   printf '  line 1  \n\n  line 2  \n' | clean-lines
clean-lines() {
  sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d'
}

# --- Git Status Idioms ---

# Get a short git status.
#
# Examples:
#   gst
#   gst --untracked-files=all
gst() {
  git status --short "$@"
}
