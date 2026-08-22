#!/usr/bin/env bash
# Interactive dotfiles installer for Arch and Debian families.
# Usage: install.sh [--dry-run] [--non-interactive] [--repo <path>]
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
NONINTERACTIVE="${NONINTERACTIVE:-0}"
REPO=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --non-interactive) NONINTERACTIVE=1 ;;
    --repo) REPO=$2; shift ;;
    *) echo "usage: install.sh [--dry-run] [--non-interactive] [--repo <path>]"; exit 1 ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
TEMP_REPO=""
cleanup() {
  [ -z "$TEMP_REPO" ] || rm -rf "$TEMP_REPO"
}
trap cleanup EXIT

if [ -f "$SCRIPT_DIR/install/lib.sh" ] && [ -z "$REPO" ]; then
  REPO="$SCRIPT_DIR"
elif [ -z "$REPO" ]; then
  if [ "$DRY_RUN" = "1" ]; then
    TEMP_REPO="$(mktemp -d)"
    REPO="$TEMP_REPO"
  else
    REPO="$HOME/.dotfiles"
  fi
  [ -d "$REPO/.git" ] || git clone https://github.com/carlosarraes/dotfiles.git "$REPO"
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
