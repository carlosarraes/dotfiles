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

rm -rf "$tmp"; exit $fail
