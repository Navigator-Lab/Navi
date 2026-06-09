#!/usr/bin/env bash
# Navi version-drift detector (SSOT gate).
# Canonical version = the `version:` frontmatter in .agent/workflows/navi.md.
# Every other Navi-version string in the live operational files must match it.
# Dated snapshots (PROTOCOL_HEALTH.md headers, _backup_*, _archive/, reports) are
# historical and intentionally excluded.
#
# Exit 0 = consistent. Exit 1 = drift found. Usage: bash .agent/scripts/check-version.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BRAIN="$ROOT/.agent/workflows/navi.md"

# 1. Read canonical version (e.g. "28.0") from frontmatter.
CANON="$(grep -m1 '^version:' "$BRAIN" | sed 's/version:[[:space:]]*//; s/[[:space:]]*$//')"
if [ -z "$CANON" ]; then
  echo "FAIL: no canonical 'version:' in $BRAIN" >&2; exit 1
fi
# Major number, e.g. 28 from 28.0 — what "Navi vNN" strings use.
CANON_MAJOR="${CANON%%.*}"
echo "canonical: navi.md version=$CANON (major v$CANON_MAJOR)"

# 2. Files that must agree (live, operational — not dated snapshots).
CMD="$HOME/.claude/commands/navi.md"
FILES=(
  "$BRAIN"
  "$ROOT/.agent/protocols/ADR-P00-Master-Rule.md"
  "$ROOT/.agent/workflows/Navi-cc.md"
)
[ -f "$CMD" ] && FILES+=("$CMD")

drift=0

# 2a. The user-global command must carry NO version number (it is a pointer).
if [ -f "$CMD" ] && grep -qiE 'Navi v[0-9]' "$CMD"; then
  echo "DRIFT: $CMD hardcodes a 'Navi vNN' string — it must be version-less." >&2
  grep -niE 'Navi v[0-9]' "$CMD" >&2 || true
  drift=1
fi

# 2b. Every other "Navi vNN" / "vNN.N" must equal the canonical major.
for f in "${FILES[@]}"; do
  [ "$f" = "$CMD" ] && continue
  while IFS= read -r hit; do
    n="$(echo "$hit" | grep -oiE 'v[0-9]+' | head -1 | tr -d 'vV')"
    if [ -n "$n" ] && [ "$n" != "$CANON_MAJOR" ]; then
      echo "DRIFT: $f references v$n (canonical is v$CANON_MAJOR): $hit" >&2
      drift=1
    fi
  done < <(grep -niE 'Navi v[0-9]+' "$f" || true)
done

if [ "$drift" -ne 0 ]; then
  echo "RESULT: version drift detected." >&2; exit 1
fi
echo "RESULT: no drift — all live Navi files agree on v$CANON_MAJOR."
