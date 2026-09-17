#!/usr/bin/env bash
# fetch-diagram-design.sh — manage the vendored diagram-design copy
#
# The skill ships with a vendored MIT-licensed copy of
# https://github.com/cathrynlavery/diagram-design at assets/diagram-design/
# so it works offline and is safe to publish.
#
# The vendored copy is bound to one upstream commit (PIN below):
#   - reads (--copy) never leave assets/diagram-design/
#   - --update only materialises PIN, so the vendored content is reproducible
#   - --update-latest deliberately moves to upstream HEAD and tells you to bump PIN
#   - --verify checks the local marker, --verify-upstream diffs against real upstream
#
# usage:
#   ./scripts/fetch-diagram-design.sh              print vendored path + pin + help
#   ./scripts/fetch-diagram-design.sh --list       list available diagram files
#   ./scripts/fetch-diagram-design.sh --verify     check vendored copy matches PIN
#   ./scripts/fetch-diagram-design.sh --verify-upstream
#                                                  prove vendored copy == upstream PIN (network)
#   ./scripts/fetch-diagram-design.sh --copy <file> <dest-dir>
#                                                  copy a diagram (keeps attribution)
#   ./scripts/fetch-diagram-design.sh --update     re-sync from upstream at PIN (network)
#   ./scripts/fetch-diagram-design.sh --update-latest
#                                                  sync upstream HEAD, then print new PIN (network)
set -euo pipefail

SKILL_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENDORED="$SKILL_ROOT/assets/diagram-design"
MARKER="$VENDORED/UPSTREAM_COMMIT"
UPSTREAM="https://github.com/cathrynlavery/diagram-design"
PIN="8d8b2993ee2256ee7dfc0eeb3b5713aba3b60792" # 2026-09-10 — update with --update-latest

TMP=""

die() {
  echo "error: $*" >&2
  exit 1
}

cleanup() {
  if [[ -n "$TMP" ]]; then
    rm -rf "$TMP"
  fi
}
trap cleanup EXIT

usage() {
  echo "vendored copy: $VENDORED"
  echo "upstream pin : $PIN"
  echo
  echo "examples (use --list to find files):"
  echo "  assets/diagram-design/assets/example-architecture-full.html"
  echo "  assets/diagram-design/references/type-flowchart.md"
}

# Resolve <rel> to a regular file inside the vendored copy. Refuses absolute
# paths, '..' traversal and symlinks, so --copy cannot read outside the tree.
vendored_file() {
  local rel="$1"
  local root abs seg
  local -a parts=()

  if [[ "$rel" == /* ]]; then
    die "--copy takes a path relative to the vendored root, got absolute: $rel"
  fi

  IFS='/' read -r -a parts <<<"$rel"
  for seg in "${parts[@]}"; do
    if [[ "$seg" == ".." ]]; then
      die "--copy path must not traverse outside the vendored copy: $rel"
    fi
  done

  abs="$VENDORED/$rel"
  if [[ -L "$abs" ]]; then
    die "--copy refuses symlinks: $rel"
  fi
  if [[ ! -f "$abs" ]]; then
    die "not found in vendored copy: $rel"
  fi

  root="$(cd "$VENDORED" && pwd -P)"
  abs="$(cd "$(dirname "$abs")" && pwd -P)/$(basename "$abs")"
  case "$abs" in
    "$root"/*) ;;
    *) die "--copy would read outside the vendored copy: $rel" ;;
  esac

  printf '%s\n' "$abs"
}

# Clone upstream and check out exactly <commit>, failing if the result differs.
checkout_upstream() {
  local commit="$1" tmp="$2" actual

  git init --quiet "$tmp/dd"
  git -C "$tmp/dd" remote add origin "$UPSTREAM"
  git -C "$tmp/dd" fetch --quiet --depth 1 origin "$commit"
  git -C "$tmp/dd" checkout --quiet FETCH_HEAD

  actual="$(git -C "$tmp/dd" rev-parse HEAD)"
  if [[ "$actual" != "$commit" ]]; then
    die "integrity check failed: wanted $commit but checked out $actual"
  fi
}

# Materialise the vendored tree for <commit> into $2/stage/diagram-design.
# Staging keeps a failed sync from destroying the currently vendored copy.
stage_vendored() {
  # keep these separate: bash 3.2 (macOS) expands all local words before
  # assigning any of them, so `local tmp="$2" stage="$tmp/..."` would be unbound
  local commit="$1"
  local tmp="$2"
  local stage="$tmp/stage/diagram-design"

  checkout_upstream "$commit" "$tmp"

  if [[ ! -d "$tmp/dd/skills/diagram-design" ]]; then
    die "upstream layout changed: skills/diagram-design not found at $commit"
  fi
  if [[ ! -f "$tmp/dd/LICENSE" ]]; then
    die "LICENSE not found at $commit"
  fi
  if [[ ! -f "$tmp/dd/THIRD_PARTY_LICENSES.md" ]]; then
    die "THIRD_PARTY_LICENSES.md not found at $commit"
  fi

  mkdir -p "$stage"
  cp -R "$tmp/dd/skills/diagram-design/." "$stage/"
  cp "$tmp/dd/LICENSE" "$stage/LICENSE.upstream"
  cp "$tmp/dd/THIRD_PARTY_LICENSES.md" "$stage/THIRD_PARTY_LICENSES.md"
  printf '%s\n' "$commit" >"$stage/UPSTREAM_COMMIT"
}

# Replace the vendored copy with the staged tree.
install_staged() {
  rm -rf "$VENDORED"
  mv "$TMP/stage/diagram-design" "$VENDORED"
}

case "${1:-}" in
  "")
    usage
    ;;
  --list)
    find "$VENDORED/assets" "$VENDORED/references" -type f |
      sed "s|$VENDORED/||" | sort
    ;;
  --verify)
    if [[ ! -f "$MARKER" ]]; then
      die "$MARKER not found — run --update to vendor at the pinned commit"
    fi
    have="$(cat "$MARKER")"
    for required in LICENSE.upstream THIRD_PARTY_LICENSES.md SKILL.md; do
      if [[ ! -e "$VENDORED/$required" ]]; then
        die "vendored copy is incomplete: missing $required"
      fi
    done
    if [[ "$have" != "$PIN" ]]; then
      die "vendored copy is at $have but PIN says $PIN — run --update to re-sync at $PIN"
    fi
    echo "ok: vendored copy declares pin $PIN"
    echo "note: this reads the local marker only — use --verify-upstream to prove content"
    ;;
  --verify-upstream)
    TMP="$(mktemp -d)"
    stage_vendored "$PIN" "$TMP"
    if ! diff -rq "$TMP/stage/diagram-design" "$VENDORED"; then
      die "vendored copy differs from upstream $PIN (differing paths listed above)"
    fi
    echo "ok: vendored copy is byte-identical to upstream $PIN"
    ;;
  --update)
    TMP="$(mktemp -d)"
    stage_vendored "$PIN" "$TMP"
    install_staged
    echo "vendored $UPSTREAM at pinned commit $PIN"
    ;;
  --update-latest)
    TMP="$(mktemp -d)"
    NEWPIN="$(git ls-remote "$UPSTREAM" HEAD | awk '{print $1}')"
    if [[ -z "$NEWPIN" ]]; then
      die "could not read upstream HEAD from $UPSTREAM"
    fi
    stage_vendored "$NEWPIN" "$TMP"
    install_staged
    echo "vendored $UPSTREAM at $NEWPIN"
    if [[ "$NEWPIN" == "$PIN" ]]; then
      echo "already at upstream HEAD — nothing to bump"
    else
      echo
      echo "the pin is NOT moved automatically; --verify will fail until you do:"
      echo "  1. review the change : git diff -- assets/diagram-design"
      echo "  2. update PIN        : scripts/fetch-diagram-design.sh -> $NEWPIN"
      echo "  3. update ATTRIBUTION.md -> $NEWPIN"
      echo "  4. confirm           : ./scripts/fetch-diagram-design.sh --verify"
    fi
    ;;
  --copy)
    REL="${2:-}"
    DEST="${3:-}"
    if [[ -z "$REL" || -z "$DEST" ]]; then
      die "usage: ./scripts/fetch-diagram-design.sh --copy <file> <dest-dir>"
    fi
    FILE="$(vendored_file "$REL")"
    mkdir -p "$DEST"
    BASE="$(basename "$FILE")"
    { printf '<!-- Source: cathrynlavery/diagram-design (MIT) — %s/%s -->\n' "$UPSTREAM" "$PIN"; cat "$FILE"; } \
      >"$DEST/$BASE"
    echo "copied with attribution header: $DEST/$BASE"
    ;;
  *)
    echo "unknown option: $1" >&2
    exit 1
    ;;
esac
