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

DRY_RUN="${DRY_RUN:-0}"
GUM_VERSION="0.14.5"

run() {
  if [ "$DRY_RUN" = "1" ]; then printf '[dry-run] %s\n' "$*"; return 0; fi
  "$@"
}

pkg_install() { # install a space-separated list of distro packages
  case "$PKG" in
    pacman) run sudo pacman -S --needed --noconfirm "$@" ;;
    apt)    run sudo apt-get install -y "$@" ;;
  esac
}

bootstrap() {
  export DEBIAN_FRONTEND=noninteractive
  [ "$(id -u)" -eq 0 ] || run sudo -v
  if [ "$DISTRO" = "debian" ]; then
    run sudo apt-get update
    pkg_install curl ca-certificates git stow
  else
    pkg_install curl git stow
  fi

  local os arch url tmp
  os=Linux
  case "$(uname -m)" in
    x86_64)  arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
  tmp="$(mktemp -d)"
  url="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_${os}_${arch}.tar.gz"
  log "downloading gum ${GUM_VERSION} (${arch})"
  curl -fsSL "$url" | tar -xz -C "$tmp" \
    || die "failed to download gum from $url"
  export PATH="$tmp/gum_${GUM_VERSION}_${os}_${arch}:$PATH"
  command -v gum >/dev/null || die "gum not available after bootstrap"
}
