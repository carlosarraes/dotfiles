#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

sandbox=$(mktemp -d)
cleanup() { rm -rf "$sandbox"; }
trap cleanup EXIT

fixture="$sandbox/fixture/dotfiles-main"
mkdir -p "$fixture/install"
cat > "$fixture/install/lib.sh" <<'EOF'
log() { :; }
detect_distro() { DISTRO=debian; PKG=apt; }
bootstrap() { :; }
pick_groups() { :; }
pick_packages() { :; }
pick_stow_targets() { :; }
pick_zsh_deps() { :; }
install_packages() { :; }
stow_configs() { :; }
install_zsh_deps() { :; }
generate_zshrc() { :; }
summary() { :; }
EOF
: > "$fixture/install/catalog.sh"
tar -czf "$sandbox/repo.tar.gz" -C "$sandbox/fixture" dotfiles-main
cp install.sh "$sandbox/installer.sh"

fakebin="$sandbox/bin"
mkdir -p "$fakebin"
for command_name in dirname gzip ls mkdir mktemp rm tar; do
  ln -s "$(command -v "$command_name")" "$fakebin/$command_name"
done
cat > "$fakebin/curl" <<EOF
#!/bin/bash
/bin/cat "$sandbox/repo.tar.gz"
EOF
chmod +x "$fakebin/curl"

home="$sandbox/home"
mkdir -p "$home"
PATH="$fakebin" HOME="$home" /bin/bash "$sandbox/installer.sh" --non-interactive

test -f "$home/.dotfiles/install/lib.sh" \
  || { echo "FAIL - tarball fallback did not populate ~/.dotfiles"; exit 1; }
! PATH="$fakebin" command -v git >/dev/null 2>&1 \
  || { echo "FAIL - fallback test unexpectedly exposed git"; exit 1; }

echo "ok   - no-git entrypoint installs repository from tarball"

mkdir -p "$sandbox/tmp" "$sandbox/dry-home"
PATH="$fakebin" HOME="$sandbox/dry-home" TMPDIR="$sandbox/tmp" \
  /bin/bash "$sandbox/installer.sh" --dry-run --non-interactive
[ -z "$(find "$sandbox/dry-home" -mindepth 1 -print -quit)" ] \
  || { echo "FAIL - dry-run tarball fallback wrote under HOME"; exit 1; }
[ -z "$(find "$sandbox/tmp" -mindepth 1 -print -quit)" ] \
  || { echo "FAIL - dry-run temporary repository was not cleaned"; exit 1; }

echo "ok   - no-git dry-run leaves HOME untouched and removes temp repo"
