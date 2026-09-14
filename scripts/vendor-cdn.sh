#!/usr/bin/env bash
# vendor-cdn.sh <docs-feature-dir> <url>... — snapshot CDN assets to assets/vendor/
# so the HTML renders offline. Always pin versions in URLs (no @latest).
set -euo pipefail

DIR="${1:-}"
shift || true

if [[ -z "$DIR" || "$#" -eq 0 ]]; then
  echo "usage: ./scripts/vendor-cdn.sh <docs-feature-dir> <url>..." >&2
  exit 1
fi

VENDOR="$DIR/assets/vendor"
mkdir -p "$VENDOR"

for url in "$@"; do
  case "$url" in
    *latest*)
      echo "REFUSING @latest (must pin version): $url" >&2
      exit 1
      ;;
  esac
  # filename from URL path, strip query string
  fname="$(basename "${url%%\?*}")"
  fname="${fname//%40/@}"   # restore @ in scoped package names
  curl -fsSL "$url" -o "$VENDOR/$fname"
  echo "snapshots: $VENDOR/$fname"
done

echo "done. reference in HTML as ./assets/vendor/<file>"
