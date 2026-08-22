#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source install/lib.sh

fail=0
assert_eq() { # desc expected actual
  if [ "$2" = "$3" ]; then echo "ok   - $1"; else echo "FAIL - $1"; echo "  expected: [$2]"; echo "  actual:   [$3]"; fail=1; fi
}

tmp=$(mktemp -d)
cat > "$tmp/template" <<'EOF'
line1
# @if asdf
. "$HOME/.asdf/asdf.sh"
# @end
line2
# @if bun
export BUN_INSTALL="$HOME/.bun"
# @end
EOF

apply_zsh_guards "$tmp/template" "$tmp/out" asdf
assert_eq "keeps selected block, drops others+markers" \
'line1
. "$HOME/.asdf/asdf.sh"
line2' "$(cat "$tmp/out")"

apply_zsh_guards "$tmp/template" "$tmp/out2"
assert_eq "no selection strips all guarded blocks" \
'line1
line2' "$(cat "$tmp/out2")"

apply_zsh_guards "$tmp/template" "$tmp/out3" bun asdf
assert_eq "both selected keeps both" \
'line1
. "$HOME/.asdf/asdf.sh"
line2
export BUN_INSTALL="$HOME/.bun"' "$(cat "$tmp/out3")"

# --- Task 2: catalog + distro detection ---
source install/catalog.sh

DISTRO=arch
arch_out=$(catalog_packages terminal)
case "$arch_out" in *fd:fd*) :;; *) echo "FAIL - arch terminal missing fd:fd"; fail=1;; esac
case "$arch_out" in *bat:bat*) :;; *) echo "FAIL - arch terminal missing bat:bat"; fail=1;; esac
assert_eq "arch groups list" "$(printf '%s\n' apps essentials fonts manpages node terminal wayland | sort)" "$(catalog_groups | sort)"

DISTRO=debian
deb_out=$(catalog_packages terminal)
case "$deb_out" in *fd:fd-find*) :;; *) echo "FAIL - debian fd maps to fd-find"; fail=1;; esac
case "$deb_out" in *yazi*) echo "FAIL - yazi should be absent on debian"; fail=1;; esac
assert_eq "debian unavailable entries skipped" "" "$(catalog_packages terminal | grep -E '^(fastfetch|eza|lazygit|starship):' || true)"

# unsupported distro must die: run in a subshell with a fake os-release so
# die()'s exit doesn't kill the harness and the host distro doesn't leak in
tmprel=$(mktemp -d)
echo 'ID=nixos' > "$tmprel/os-release"
if ( source install/catalog.sh; detect_distro "$tmprel/os-release" ) >/dev/null 2>&1; then
  echo "FAIL - unsupported distro should die"; fail=1
else
  echo "ok   - unsupported distro dies"
fi
rm -rf "$tmprel"
echo "catalog tests done"

# --- Task 3: run wrapper dry-run ---
DRY_RUN=1
out=$(run pacman -Syu)
case "$out" in "[dry-run] pacman -Syu") echo "ok   - dry-run prints command";; *) echo "FAIL - run/dry-run got: $out"; fail=1;; esac

# --- Task 4 fix round 1: multi-word distro fields must split into elements ---
DISTRO=arch
NONINTERACTIVE=1
SELECTED_GROUPS=fonts
pick_packages
if [ "${#SELECTED_PKGS[@]}" -eq 4 ] && ! printf '%s\n' "${SELECTED_PKGS[@]}" | grep -q ' '; then
  echo "ok   - nerd-fonts multi-package field splits into individual elements"
else
  echo "FAIL - expected 4 split elements, got ${#SELECTED_PKGS[@]}: ${SELECTED_PKGS[*]:-}"; fail=1
fi

# empty selection must not trip set -u
SELECTED_GROUPS=
pick_packages
echo "ok   - empty group list leaves SELECTED_PKGS empty without error"

# --- Task 6 fix round 1: dry-run generation must not write under HOME ---
test_home=$(mktemp -d)
old_home=$HOME
HOME=$test_home
SELECTED_DEPS=asdf
generate_zshrc "$PWD" >/dev/null
if [ -z "$(find "$test_home" -mindepth 1 -print -quit)" ]; then
  echo "ok   - dry-run zsh generation leaves HOME untouched"
else
  echo "FAIL - dry-run zsh generation wrote under HOME"; fail=1
fi
HOME=$old_home
rm -rf "$test_home"

rm -rf "$tmp"; exit $fail
