#!/usr/bin/env bash
# new-doc.sh <feature-name> — scaffold docs/<feature>/ structure
set -euo pipefail

FEATURE="${1:-}"
if [[ -z "$FEATURE" ]]; then
  echo "usage: ./scripts/new-doc.sh <feature-name>" >&2
  exit 1
fi

DIR="$FEATURE"
if [[ "$FEATURE" != /* ]]; then
  DIR="docs/$FEATURE"
fi
mkdir -p "$DIR/assets/ui" "$DIR/assets/architecture" "$DIR/assets/vendor"

if [[ ! -f "$DIR/README.md" ]]; then
  cat > "$DIR/README.md" <<EOF
# $FEATURE

## สรุปสั้น ๆ

<!-- อ่านจบใน 30-60 วินาที: ใครกดอะไร ระบบทำอะไร ผลลัพธ์คืออะไร -->

## 1. ภาพรวม

## 2. จุดประสงค์ทาง Business

## 3. ผู้ที่เกี่ยวข้อง

## 4. หน้าจอที่เกี่ยวข้อง

## 5. ขั้นตอนการทำงานของผู้ใช้

## 6. Business Flow

\`\`\`mermaid
flowchart TD
    A["ผู้ใช้เริ่มต้น"] --> B["ระบบทำงาน"]
\`\`\`

## 7. กฎของระบบ

| Rule | รายละเอียด |
| ---- | ---------- |
| BR-01 | TBD |

## 8. ภาพรวมระบบ

## 9. การทำงานเบื้องหลัง

## 10. จังหวะการส่งงานเข้า Queue

## 11. Queue / Consumer Flow

## 12. สถานะของงาน

## 13. กรณีผิดปกติ

## 14. ผลลัพธ์ที่ผู้ใช้ได้รับ

## 15. Technical Reference

> ส่วนนี้สำหรับ Developer

| ประเภท | Reference |
| ------ | --------- |
| TBD    | TBD       |
EOF
fi

echo "created: $DIR"
find "$DIR" -type d
