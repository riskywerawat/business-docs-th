#!/usr/bin/env bash
# vendor-cdn.sh <docs-feature-dir> <url>... — snapshot CDN assets to assets/vendor/
# so the HTML renders offline. Always pin versions in URLs (no @latest).
#
# Integrity: append #sha256=<hex> to a URL and the download is rejected unless the
# bytes match before it replaces the vendored file. Without it the script still
# prints the hash so you can pin it on the next run. Get a hash with:
#   curl -fsSL <url> | shasum -a 256
set -euo pipefail

PART=""
cleanup() {
  if [[ -n "$PART" ]]; then rm -f "$PART"; fi
}
trap cleanup EXIT

die() {
  echo "error: $*" >&2
  exit 1
}

usage() {
  cat >&2 <<'USAGE'
usage: ./scripts/vendor-cdn.sh <docs-feature-dir> <url>...

  <url>   pinned https CDN URL (no @latest). Append #sha256=<hex> to verify.

example:
  ./scripts/vendor-cdn.sh docs/order-fulfillment \
    https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js#sha256=<hex>
USAGE
}

sha256_of() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | cut -d' ' -f1
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d' ' -f1
  fi
}

# The filename comes from the URL, i.e. from outside, so accept only a
# conservative charset. This also blocks ../, %2F-encoded separators, spaces
# and names that would be read as an option.
safe_name() {
  local name
  name="$(basename "$1")"
  name="${name//%40/@}"   # restore @ in scoped package names
  case "$name" in
    '' | . | ..) die "cannot derive a filename from: $1" ;;
    -*) die "refusing filename starting with '-': $name" ;;
  esac
  if [[ ! "$name" =~ ^[A-Za-z0-9._@+-]+$ ]]; then
    die "unsafe filename '${name}' derived from: $1"
  fi
  printf '%s\n' "$name"
}

DIR="${1:-}"
shift || true

if [[ -z "$DIR" || "$#" -eq 0 ]]; then
  usage
  exit 1
fi

case "/$DIR/" in
  */../*) die "refusing '..' in docs dir: $DIR" ;;
esac

VENDOR="$DIR/assets/vendor"
mkdir -p "$VENDOR"

for arg in "$@"; do
  case "$arg" in
    *latest*) die "REFUSING @latest (must pin version): $arg" ;;
  esac

  frag=""
  case "$arg" in
    *"#"*) frag="${arg#*#}" ;;
  esac
  # curl drops the fragment itself; strip it here so the filename parser and the
  # integrity check never see each other's input
  url="${arg%%#*}"

  case "$url" in
    https://*) ;;
    http://*) die "refusing plain http (use https): $url" ;;
    *) die "need an https:// CDN URL, got: $url" ;;
  esac
  case "$url" in
    */) die "URL must point to a file, not a directory: $url" ;;
  esac

  want=""
  case "$frag" in
    '') ;;
    sha256=*)
      want="$(printf '%s' "${frag#sha256=}" | tr 'A-Z' 'a-z')"
      [[ "$want" =~ ^[0-9a-f]{64}$ ]] || die "sha256 must be 64 hex chars, got: ${frag#sha256=}"
      ;;
    *) die "unsupported integrity fragment '#${frag}' (only #sha256=<hex>)" ;;
  esac

  fname="$(safe_name "${url%%\?*}")"
  # download next to the destination so the final mv is a same-dir rename, and
  # a partial file can never be mistaken for a good snapshot
  part="$VENDOR/.$fname.part"
  PART="$part"

  curl -fsSL --proto '=https' --proto-redir '=https' "$url" -o "$part" ||
    die "download failed: $url"

  got="$(sha256_of "$part")"
  if [[ -n "$want" ]]; then
    [[ -n "$got" ]] || die "cannot verify integrity: no shasum or sha256sum found"
    [[ "$got" == "$want" ]] || die "checksum mismatch for $fname
  expected sha256=$want
  got      sha256=$got"
  elif [[ -n "$got" ]]; then
    echo "note: pin this next time — #sha256=$got" >&2
  fi

  mv "$part" "$VENDOR/$fname"
  PART=""
  echo "snapshots: $VENDOR/$fname"
done

echo "done. reference in HTML as ./assets/vendor/<file>"
