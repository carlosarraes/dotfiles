#!/usr/bin/env bash
# Interactive dotfiles installer for Arch and Debian families.
# Usage: install.sh [--dry-run] [--non-interactive] [--repo <path>]
set -euo pipefail

usage() {
  echo "usage: install.sh [--dry-run] [--non-interactive] [--repo <path>]"
}

DRY_RUN="${DRY_RUN:-0}"
NONINTERACTIVE="${NONINTERACTIVE:-0}"
REPO=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --non-interactive) NONINTERACTIVE=1 ;;
    --repo)
      [ $# -ge 2 ] && [ -n "$2" ] || { usage >&2; exit 1; }
      REPO=$2
      shift
      ;;
    *) usage >&2; exit 1 ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
TEMP_REPO=""
cleanup() {
  [ -z "$TEMP_REPO" ] || rm -rf "$TEMP_REPO"
}
trap cleanup EXIT

fetch_repo() {
  local clone_url="https://github.com/carlosarraes/dotfiles.git"
  local tar_url="https://github.com/carlosarraes/dotfiles/archive/refs/heads/main.tar.gz"

  if command -v git >/dev/null 2>&1; then
    git clone "$clone_url" "$REPO"
    return
  fi

  mkdir -p "$REPO"
  curl -fsSL "$tar_url" | tar -xz --strip-components=1 -C "$REPO"
}

if [ -f "$SCRIPT_DIR/install/lib.sh" ] && [ -z "$REPO" ]; then
  REPO="$SCRIPT_DIR"
elif [ -z "$REPO" ]; then
  if [ "$DRY_RUN" = "1" ]; then
    TEMP_REPO="$(mktemp -d)"
    REPO="$TEMP_REPO"
  else
    REPO="$HOME/.dotfiles"
  fi
  if [ ! -f "$REPO/install/lib.sh" ]; then
    if [ -d "$REPO" ] && [ -n "$(ls -A "$REPO" 2>/dev/null)" ]; then
      echo "error: $REPO exists but is not a dotfiles checkout" >&2
      exit 1
    fi
    fetch_repo
  fi
fi

# shellcheck source=install/lib.sh
source "$REPO/install/lib.sh"
# shellcheck source=install/catalog.sh
source "$REPO/install/catalog.sh"

detect_distro
bootstrap
log "detected: $DISTRO ($PKG)"

pick_groups
pick_packages
pick_stow_targets "$REPO"
pick_zsh_deps
install_packages
stow_configs "$REPO"
install_zsh_deps
generate_zshrc "$REPO"
summary
