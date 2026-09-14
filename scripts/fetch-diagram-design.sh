#!/usr/bin/env bash
# fetch-diagram-design.sh — manage the vendored diagram-design copy
#
# The skill ships with a vendored MIT-licensed copy of
# https://github.com/cathrynlavery/diagram-design at assets/diagram-design/
# so it works offline and is safe to publish.
#
# usage:
#   ./scripts/fetch-diagram-design.sh            print vendored path + quick help
#   ./scripts/fetch-diagram-design.sh --list     list available diagram files
#   ./scripts/fetch-diagram-design.sh --update   re-sync from upstream (network)
#   ./scripts/fetch-diagram-design.sh --copy <file> <dest-dir>
#                                                copy a diagram (keeps attribution)
set -euo pipefail

SKILL_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENDORED="$SKILL_ROOT/assets/diagram-design"
UPSTREAM="https://github.com/cathrynlavery/diagram-design"
PIN="8d8b2993ee2256ee7dfc0eeb3b5713aba3b60792" # 2026-09-10 — update with --update

usage() {
  echo "vendored copy: $VENDORED"
  echo "upstream pin : $PIN"
  echo
  echo "examples (use --list to find files):"
  echo "  assets/diagram-design/assets/example-architecture-full.html"
  echo "  assets/diagram-design/references/type-flowchart.md"
}

case "${1:-}" in
  "")
    usage
    ;;
  --list)
    find "$VENDORED/assets" "$VENDORED/references" -type f \
      | sed "s|$VENDORED/||" | sort
    ;;
  --update)
    TMP="$(mktemp -d)"
    git clone --depth 1 "$UPSTREAM" "$TMP/dd"
    NEWPIN="$(git -C "$TMP/dd" rev-parse HEAD)"
    echo "upstream pin: $PIN"
    echo "new pin     : $NEWPIN"
    rm -rf "$VENDORED"
    cp -R "$TMP/dd/skills/diagram-design" "$VENDORED"
    cp "$TMP/dd/LICENSE" "$VENDORED/LICENSE.upstream"
    cp "$TMP/dd/THIRD_PARTY_LICENSES.md" "$VENDORED/THIRD_PARTY_LICENSES.md"
    rm -rf "$TMP"
    echo
    echo "IMPORTANT: update PIN in scripts/fetch-diagram-design.sh and ATTRIBUTION.md to $NEWPIN"
    ;;
  --copy)
    FILE="$VENDORED/${2:?file path relative to vendored root required}"
    DEST="${3:?dest dir required}"
    mkdir -p "$DEST"
    BASE="$(basename "$FILE")"
    { printf '<!-- Source: cathrynlavery/diagram-design (MIT) — %s/%s -->\n' "$UPSTREAM" "$PIN"; cat "$FILE"; } \
      > "$DEST/$BASE"
    echo "copied with attribution header: $DEST/$BASE"
    ;;
  *)
    echo "unknown option: $1" >&2
    exit 1
    ;;
esac
