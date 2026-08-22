#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source install/lib.sh

command -v stow >/dev/null || { echo "FAIL - stow is required"; exit 1; }

sandbox=$(mktemp -d)
cleanup() { rm -rf "$sandbox"; }
trap cleanup EXIT

source_hash=$(sha256sum zsh/.zshrc | cut -d' ' -f1)
stow -d "$PWD" -t "$sandbox" zsh

test -L "$sandbox/.zshenv" || { echo "FAIL - .zshenv was not stowed"; exit 1; }
test ! -e "$sandbox/.zshrc" || { echo "FAIL - stow linked .zshrc"; exit 1; }
test ! -e "$sandbox/.zshrc.template" || { echo "FAIL - stow linked .zshrc.template"; exit 1; }

# Avoid network clones: these existing directories make generation focus on
# rendering the guarded template after the stow step.
mkdir -p \
  "$sandbox/.zsh/zsh-autosuggestions" \
  "$sandbox/.zsh/zsh-syntax-highlighting" \
  "$sandbox/.tmux/plugins/tpm"
HOME=$sandbox
DRY_RUN=0
SELECTED_DEPS=asdf
generate_zshrc "$PWD" >/dev/null

test -f "$sandbox/.zshrc" || { echo "FAIL - .zshrc was not generated"; exit 1; }
test ! -L "$sandbox/.zshrc" || { echo "FAIL - generated .zshrc is a symlink"; exit 1; }
test "$source_hash" = "$(sha256sum zsh/.zshrc | cut -d' ' -f1)" \
  || { echo "FAIL - repository zsh/.zshrc changed"; exit 1; }
! grep -qE '^# @(if|end)' "$sandbox/.zshrc" \
  || { echo "FAIL - generated .zshrc still has guard markers"; exit 1; }
grep -q '\. "$HOME/.asdf/asdf.sh"' "$sandbox/.zshrc" \
  || { echo "FAIL - selected asdf block missing"; exit 1; }

if command -v zsh >/dev/null; then
  zsh_err="$sandbox/zsh.stderr"
  if ! HOME="$sandbox" zsh -f -c 'set -eu; source "$1"' _ "$sandbox/.zshrc" 2>"$zsh_err"; then
    echo "FAIL - generated .zshrc errors when optional tools are absent"; cat "$zsh_err"; exit 1
  fi
  [ ! -s "$zsh_err" ] \
    || { echo "FAIL - generated .zshrc emitted stderr"; cat "$zsh_err"; exit 1; }
fi

echo "ok   - stow excludes generated zshrc; source remains unchanged"
