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
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$DIR/assets/ui" "$DIR/assets/illustrations" "$DIR/assets/architecture" "$DIR/assets/vendor"

# Shared non-slide HTML references use this theme. Slide output may ignore it.
if [[ ! -f "$DIR/assets/business-docs-ui.css" ]]; then
  cp "$REPO_ROOT/assets/templates/business-docs-ui.css" "$DIR/assets/business-docs-ui.css"
fi

if [[ ! -f "$DIR/README.md" ]]; then
  cat > "$DIR/README.md" <<EOF
> **เอกสารนี้** · Feature: $FEATURE · เจ้าของ: TBD
> · ระดับ: lite | full · อัปเดตล่าสุด: $(date +%Y-%m-%d)
> · อ้างอิง code: \`<repo>@<commit-short>\`
> · Ticket/PR: TBD

# $FEATURE

## สรุปสั้น ๆ

<!-- อ่านจบใน 30-60 วินาที: ใครกดอะไร ระบบทำอะไร ผลลัพธ์คืออะไร -->

## 1. ภาพรวม

## 2. จุดประสงค์ทาง Business

## 3. ผู้ที่เกี่ยวข้อง

## 4. Business Flow

\`\`\`mermaid
flowchart TD
    A["ผู้ใช้เริ่มต้น"] --> B["ระบบทำงาน"]
\`\`\`

## 5. ผลลัพธ์ที่ผู้ใช้ได้รับ

## 6. Technical Reference

> ส่วนนี้สำหรับ Developer

| ประเภท | Reference |
| ------ | --------- |
| TBD    | TBD       |

## ประวัติการแก้ไข

| วันที่ | เปลี่ยนอะไร | อ้างอิง |
| --- | --- | --- |
| $(date +%Y-%m-%d) | สร้างเอกสารครั้งแรก | TBD |

<!--
หัวข้อ conditional: ใส่เฉพาะที่ trigger ตรงกับงานนี้ (ดู Document Outline Planning ใน SKILL.md)
ห้ามคงหัวข้อที่ trigger ไม่ตรง และห้ามใส่ TBD ล้วนเพื่อให้ครบ list
หลังเลือกหัวข้อแล้วให้เรียงเลขใหม่ต่อเนื่อง

- หน้าจอที่เกี่ยวข้อง          → พบ UI page/route/menu จริง
- ขั้นตอนการทำงานของผู้ใช้      → มี user action ต่อเนื่องจาก entry point
- กฎของระบบ (ตาราง BR-xx)      → พบ validation / condition / limit / role gate
- ภาพรวมระบบ (architecture)    → มี >= 2 system/service boundary หรือ external integration
- การทำงานเบื้องหลัง            → พบ background job / scheduler / cron / batch / worker
- จังหวะส่งงานเข้า Queue        → พบ publish/enqueue/emit จริง
- Queue / Consumer Flow        → พบ consumer/subscriber/listener จริง
- สถานะของงาน                  → พบ status enum / state machine
- กรณีผิดปกติ                  → พบ retry/DLQ/compensation/failure path จริง
- Integration / External API   → พบการเรียกหรือรับจากระบบภายนอก
- ข้อมูลที่จัดเก็บ / ส่งต่อ      → งานเน้น data mapping, schema, report, export
- หัวข้อเฉพาะ domain           → logic นั้นเป็นหัวใจของงาน (ตั้งชื่อตามธุรกิจของงาน)

ก่อนส่งงาน:
- คำใหม่ทุกคำเพิ่มใน docs/glossary.md
- ค่า enum จริงแสดงคู่คำไทย เช่น \`PENDING_APPROVAL\` (รออนุมัติ)
- ไม่มี secret/PII/prod URL/path เฉพาะเครื่อง ใช้ placeholder เช่น <employee-id>
- เทียบระดับความลึกกับ examples/<level>/README.md
-->
EOF
fi

# Glossary กลางของระบบ — สร้างครั้งแรกที่ใช้
if [[ ! -f docs/glossary.md && "$DIR" == docs/* ]]; then
  mkdir -p docs
  cat > docs/glossary.md <<'EOF'
# Glossary — คำศัพท์กลางของระบบ

คำที่คน business ใช้เรียกพฤติกรรมระบบ ต้องตรงกันทุกเอกสาร
เพิ่มคำใหม่ที่นี่ทุกครั้งที่เอกสารอ้างคำที่ยังไม่มีในตาราง

| คำที่ใช้ในเอกสาร | ความหมายสั้น ๆ | ค่าในระบบ (enum/table/field) | เอกสารที่เกี่ยวข้อง |
| --- | --- | --- | --- |
| TBD | TBD | TBD | TBD |

กติกา:

- เอกสารที่อ้างคำใหม่ ต้องเพิ่มคำนั้นที่นี่ ไม่เก็บไว้เฉพาะในเอกสารตัวเอง
- แสดงค่า enum จริงคู่คำไทยเสมอในตารางสถานะ/กฎของระบบ
- คำที่ยังไม่นิ่งให้ระบุหมายเหตุ `รอยืนยันคำเรียก`
EOF
fi

# สารบัญกลาง — สร้างเมื่อมีเอกสารเกิน 3 feature
if [[ "$DIR" == docs/* ]]; then
  feature_count=$(find docs -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
  if [[ ! -f docs/README.md && "$feature_count" -gt 3 ]]; then
    cat > docs/README.md <<'EOF'
# สารบัญเอกสาร (docs index)

| Feature | ไฟล์ | เจ้าของ | อัปเดตล่าสุด |
| --- | --- | --- | --- |
| TBD | TBD | TBD | TBD |

อัปเดตตารางนี้ทุกครั้งที่เพิ่มหรือแก้เอกสาร feature
EOF
  fi
fi

echo "created: $DIR"
echo "theme: $DIR/assets/business-docs-ui.css"
find "$DIR" -type d
