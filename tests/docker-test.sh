#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
repo=$PWD

run_image() {
  local image=$1
  echo "==> testing $image"
  docker run --rm \
    -v "$repo:/dotfiles" \
    "$image" bash -c '
      set -euo pipefail
      cd /dotfiles
      NONINTERACTIVE=1 ./install.sh --non-interactive --repo /dotfiles

      command -v zsh >/dev/null
      command -v nvim >/dev/null
      command -v tmux >/dev/null

      test -L "$HOME/.tmux.conf"
      case "$(readlink -f "$HOME/.tmux.conf")" in
        /dotfiles/*) ;;
        *) echo "FAIL - ~/.tmux.conf does not link into /dotfiles" >&2; exit 1 ;;
      esac

      test -f "$HOME/.zshrc"
      test ! -L "$HOME/.zshrc"
      ! grep -qE "^# @(if|end)" "$HOME/.zshrc"
      zsh -c "source \"$HOME/.zshrc\""
    '
  echo "ok   - $image"
}

if [ "$#" -gt 0 ]; then
  images=("$@")
else
  images=(archlinux:latest debian:bookworm)
fi

for image in "${images[@]}"; do
  run_image "$image"
done
