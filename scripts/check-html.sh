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

# Mermaid draws on a transparent canvas: a generic dark `pre` background would
# swallow the diagram. Flatten the file (CSS rules span multiple lines) and look
# for a dark pre style without a pre.mermaid override in the same file.
flat="$(tr '\n' ' ' < "$FILE")"
if grep -qE 'class="mermaid"' "$FILE" \
   && printf '%s' "$flat" | grep -qE 'pre[^{}]*\{[^}]*background:[[:space:]]*(var\(--color-ink\)|var\(--color-simulator\)|#[0-3][0-9a-fA-F]{2,5})' \
   && ! printf '%s' "$flat" | grep -qE 'pre\.mermaid[^{}]*\{'; then
  echo 'MISSING: ธีมมี pre พื้นเข้ม (code-block) แต่ไม่มี pre.mermaid override — mermaid ต้อง render บนพื้นสว่าง (ดู กฎการสร้าง HTML ข้อ 3)'
  fail=1
fi

if grep -qE 'tailwindcss|@apply' "$FILE" || \
   grep -oE 'class="[^"]+"' "$FILE" | \
   grep -qE '(^|[[:space:]])(flex|grid|grid-cols-[0-9]+|px-[0-9]+|py-[0-9]+|text-(xs|sm|lg|xl))([[:space:]]|")'; then
  if ! grep -qE 'tailwindcss/browser|assets/vendor/@tailwindcss' "$FILE"; then
    echo 'MISSING: ใช้ Tailwind class แต่ไม่ได้ include @tailwindcss/browser'
    fail=1
  fi
fi

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
