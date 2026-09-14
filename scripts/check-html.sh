#!/usr/bin/env bash
# check-html.sh <file.html> — verify diagram/render dependencies are included.
# Fails (exit 1) if the file uses mermaid/tailwind syntax without loading it.
set -uo pipefail

FILE="${1:-}"
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  echo "usage: ./scripts/check-html.sh <file.html>" >&2
  exit 1
fi

fail=0

check() { # <pattern-in-content> <required-pattern> <message>
  if grep -qE "$1" "$FILE" && ! grep -qE "$2" "$FILE"; then
    echo "MISSING: $3"
    fail=1
  fi
}

check 'class="mermaid"' \
      'mermaid(\.min)?\.js|assets/vendor/mermaid' \
      'HTML มี <pre class="mermaid"> แต่ไม่ได้ include mermaid.js (CDN หรือ assets/vendor)'

check 'class="mermaid"' \
      'mermaid\.initialize' \
      'ต้องเรียก mermaid.initialize({ startOnLoad: true }) เมื่อมี mermaid block'

check 'tailwindcss|@apply|class="[^"]*\b(flex|grid|px-|py-|text-(xs|sm|lg|xl))' \
      'tailwindcss/browser|assets/vendor/@tailwindcss' \
      'ใช้ Tailwind class แต่ไม่ได้ include @tailwindcss/browser'

check 'esm\.sh/react|import React' \
      'importmap|esm\.sh/react@' \
      'ใช้ React แต่ไม่มี importmap / pinned esm.sh URL'

if grep -oE 'https?://[^"'"'"' ]+' "$FILE" | grep -q '@latest'; then
  echo "MISSING: CDN ต้อง pin version ห้ามใช้ @latest"
  fail=1
fi

if [[ $fail -eq 0 ]]; then
  echo "OK: dependencies check passed for $FILE"
fi
exit $fail
