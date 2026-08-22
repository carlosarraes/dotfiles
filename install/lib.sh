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

run_root() {
  if [ "$(id -u)" -eq 0 ]; then run "$@"; else run sudo "$@"; fi
}

pkg_install() { # install a space-separated list of distro packages
  case "${PKG:-}" in
    pacman) run_root pacman -Syu --needed --noconfirm "$@" ;;
    apt)    run_root apt-get install -y "$@" ;;
    *)      die "unknown package manager: ${PKG:-unset} (run detect_distro first)" ;;
  esac
}

bootstrap() {
  export DEBIAN_FRONTEND=noninteractive
  [ "$(id -u)" -eq 0 ] || run sudo -v
  if [ "$DISTRO" = "debian" ]; then
    run_root apt-get update
    pkg_install curl ca-certificates git stow
  else
    pkg_install curl git stow
  fi

  local os arch url tmp gum_dir gum_source
  os=Linux
  case "$(uname -m)" in
    x86_64)  arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
  tmp="$(mktemp -d)"
  gum_dir="${TMPDIR:-/tmp}/dotfiles-gum-${UID}"
  url="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_${os}_${arch}.tar.gz"
  log "downloading gum ${GUM_VERSION} (${arch})"
  if ! curl -fsSL "$url" | tar -xz -C "$tmp"; then
    rm -rf "$tmp"
    die "failed to download gum from $url"
  fi
  gum_source="$tmp/gum_${GUM_VERSION}_${os}_${arch}/gum"
  mkdir -p "$gum_dir"
  install -m 0755 "$gum_source" "$gum_dir/gum"
  rm -rf "$tmp"
  export PATH="$gum_dir:$PATH"
  command -v gum >/dev/null || die "gum not available after bootstrap"
}

# --- Interactive pickers -----------------------------------------------------

pick_groups() {
  if [ "${NONINTERACTIVE:-0}" = "1" ]; then SELECTED_GROUPS=$(catalog_groups); return; fi
  SELECTED_GROUPS=$(gum choose --height 10 --no-limit $(catalog_groups) || true)
}

pick_packages() {
  SELECTED_PKGS=()
  local g p picked
  for g in $SELECTED_GROUPS; do
    local names=()
    # a distro field may list several packages space-separated: split them all
    while IFS=: read -r _ dpkg; do for p in $dpkg; do names+=("$p"); done; done < <(catalog_packages "$g")
    [ ${#names[@]} -gt 0 ] || continue
    if [ "${NONINTERACTIVE:-0}" = "1" ]; then
      SELECTED_PKGS+=("${names[@]}")
    else
      mapfile -t picked < <(printf '%s\n' "${names[@]}" | gum choose --height 15 --no-limit || true)
      if [ "${#picked[@]}" -gt 0 ]; then SELECTED_PKGS+=("${picked[@]}"); fi
    fi
  done
}

pick_stow_targets() {
  local repo=$1 dir
  local all=()
  for dir in "$repo"/*/; do
    dir=$(basename "$dir")
    case "$dir" in cmd|docs|install|tests|.git) continue ;; esac
    [ -n "$(find "$repo/$dir" -maxdepth 0 -type d 2>/dev/null)" ] && all+=("$dir")
  done
  if [ "${NONINTERACTIVE:-0}" = "1" ]; then
    if [ "${#all[@]}" -gt 0 ]; then SELECTED_STOW=("${all[@]}"); else SELECTED_STOW=(); fi
    return
  fi
  mapfile -t SELECTED_STOW < <(printf '%s\n' "${all[@]}" | gum choose --height 15 --no-limit || true)
}

ZSH_DEPS="atuin asdf nvm bun turso"
pick_zsh_deps() {
  if [ "${NONINTERACTIVE:-0}" = "1" ]; then SELECTED_DEPS=$ZSH_DEPS; return; fi
  SELECTED_DEPS=$(printf '%s\n' $ZSH_DEPS | gum choose --height 8 --no-limit || true)
}

# --- Executors (Task 5) ------------------------------------------------------

FAILED=()
INSTALLED_PKGS=()
STOWED=()
SKIPPED=()

# Guard against unset selections when executors run without pickers (set -u).
: "${SELECTED_DEPS:=}"
for _sel in SELECTED_PKGS SELECTED_STOW; do
  declare -p "$_sel" >/dev/null 2>&1 || declare -a "$_sel=()"
done

install_packages() {
  [ ${#SELECTED_PKGS[@]} -gt 0 ] || { log "no packages selected"; return; }
  log "installing ${#SELECTED_PKGS[@]} packages"
  if pkg_install "${SELECTED_PKGS[@]}"; then
    INSTALLED_PKGS=("${SELECTED_PKGS[@]}")
  else
    FAILED+=("packages: some failed")
    SKIPPED+=("packages:${#SELECTED_PKGS[@]}")
  fi
}

stow_configs() {
  local repo=$1 d target
  for d in "${SELECTED_STOW[@]}"; do
    target="$HOME"
    if [ -e "$target/$d" ] && [ ! -L "$target/$d" ]; then
      warn "~/$d already exists (not a symlink); skipping stow of '$d'"
      FAILED+=("stow:$d conflict")
      SKIPPED+=("stow:$d")
      continue
    fi
    if run stow -d "$repo" -t "$target" "$d"; then
      STOWED+=("$d")
    else
      FAILED+=("stow:$d")
      SKIPPED+=("stow:$d")
    fi
  done
}

install_zsh_deps() {
  local dep
  for dep in $SELECTED_DEPS; do
    case "$dep" in
      atuin)
        if ! run bash -o pipefail -c 'curl -sSf https://setup.atuin.sh | sh'; then
          FAILED+=(atuin); SKIPPED+=("dep:atuin")
        fi ;;
      bun)
        if ! run bash -o pipefail -c 'curl -fsSL https://bun.sh/install | bash'; then
          FAILED+=(bun); SKIPPED+=("dep:bun")
        fi ;;
      turso)
        if ! run bash -o pipefail -c 'curl -sSfL https://get.turso.app | sh'; then
          FAILED+=(turso); SKIPPED+=("dep:turso")
        fi ;;
      asdf)
        if [ ! -d "$HOME/.asdf" ] && ! run git clone https://github.com/asdf-vm/asdf.git --depth 1 --branch v0.16.7 "$HOME/.asdf"; then
          FAILED+=(asdf); SKIPPED+=("dep:asdf")
        fi ;;
      nvm)
        if [ ! -d "$HOME/.nvm" ] && ! run git clone https://github.com/nvm-sh/nvm.git --depth 1 "$HOME/.nvm"; then
          FAILED+=(nvm); SKIPPED+=("dep:nvm")
        fi ;;
    esac
  done
}

generate_zshrc() {
  local repo=$1 tmp
  run mkdir -p "$HOME/.zsh"
  if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ] && ! run git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"; then
    FAILED+=("plugin:zsh-autosuggestions")
    SKIPPED+=("plugin:zsh-autosuggestions")
  fi
  if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ] && ! run git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"; then
    FAILED+=("plugin:zsh-syntax-highlighting")
    SKIPPED+=("plugin:zsh-syntax-highlighting")
  fi
  run mkdir -p "$HOME/.tmux/plugins"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ] && ! run git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"; then
    FAILED+=("plugin:tpm")
    SKIPPED+=("plugin:tpm")
  fi

  if [ "$DRY_RUN" = "1" ]; then
    printf '[dry-run] generate %s from %s\n' "$HOME/.zshrc" "$repo/zsh/.zshrc.template"
  else
    tmp="$(mktemp)"
    apply_zsh_guards "$repo/zsh/.zshrc.template" "$tmp" $SELECTED_DEPS
    run install -m 0644 "$tmp" "$HOME/.zshrc"
    run rm -f "$tmp"
  fi
  log "generated ~/.zshrc (deps: ${SELECTED_DEPS:-none})"
}

summary() {
  local packages_label="installed packages" stow_label="stowed"
  if [ "$DRY_RUN" = "1" ]; then
    packages_label="would install packages"
    stow_label="would stow"
  fi
  log "---- summary ----"
  log "distro: ${DISTRO:-unknown} ($(command -v gum >/dev/null && echo 'gum ok' || echo 'gum missing'))"
  log "groups: ${SELECTED_GROUPS:-none}"
  log "$packages_label (${#INSTALLED_PKGS[@]}): ${INSTALLED_PKGS[*]:-none}"
  log "$stow_label: ${STOWED[*]:-none}"
  log "skipped: ${SKIPPED[*]:-none}"
  log "zsh deps selected: ${SELECTED_DEPS:-none}"
  if [ ${#FAILED[@]} -gt 0 ]; then
    warn "${#FAILED[@]} item(s) failed:"
    local f; for f in "${FAILED[@]}"; do warn "  - $f"; done
  else
    log "all steps completed without failures"
  fi
  command -v zsh >/dev/null && log "reminder: chsh -s \"$(command -v zsh)\" to make zsh your default shell"
  return 0
}
