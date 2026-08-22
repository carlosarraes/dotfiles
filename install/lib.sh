#!/usr/bin/env bash
# Shared helpers for the dotfiles installer.

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# Usage: apply_zsh_guards <template> <outfile> [tool...]
# Keeps lines between "# @if <t>" / "# @end" iff <t> is listed; drops marker lines.
apply_zsh_guards() {
  local template=$1 out=$2; shift 2
  local selected=" $* "
  AWK_TOOLS="$selected" awk '
    BEGIN { skip = 0 }
    /^# @if / {
      t = $3
      if (index(ENVIRON["AWK_TOOLS"], " " t " ") == 0) skip = 1
      next
    }
    /^# @end$/ { skip = 0; next }
    skip == 0 { print }
  ' "$template" > "$out"
}
