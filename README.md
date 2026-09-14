# business-docs-th

Skill สำหรับสร้างเอกสาร Business ภาษาไทยจาก source code จริง
self-contained — ใช้รูปแบบ Agent Skills มาตรฐาน จึงติดตั้งได้กับ Codex,
GitHub Copilot และ Claude Code ผ่าน `npx skills`

## Structure

```text
business-docs-th/
├── SKILL.md                        # main skill definition
├── agents/openai.yaml              # optional Codex UI metadata
├── ATTRIBUTION.md                  # license notes for vendored content
├── references/                     # HTML template style guides
│   ├── ui-theme.md                 #   shared UI language (ยกเว้น slide)
│   ├── ai-illustration.md          #   AI system overview image decision/rules
│   ├── template-swagger.md         #   API reference / spec style
│   ├── template-docusaurus.md      #   docs site style
│   ├── template-dashboard.md       #   assessment / control center style
│   └── template-slide.md           #   presentation / sprint deck style
├── assets/templates/               # supplied reusable HTML templates/examples
│   ├── slide-template.html         #   supplied slide template
│   ├── business-docs-ui.css        #   shared UI theme (ยกเว้น slide)
│   └── order-fulfillment-run-example.html # dummy simulation UI example
├── assets/diagram-design/          # vendored MIT copy of
│   │                               # github.com/cathrynlavery/diagram-design
│   ├── assets/example-*.html       #   ready-made diagram HTML
│   ├── references/type-*.md        #   diagram type specs
│   └── LICENSE.upstream            #   upstream MIT license text
└── scripts/
    ├── new-doc.sh                  # scaffold docs/<feature>/ + shared UI theme
    ├── fetch-diagram-design.sh     # manage vendored copy (--list/--copy/--update)
    ├── vendor-cdn.sh               # snapshot CDN assets for offline HTML
    └── check-html.sh               # verify HTML includes mermaid/tailwind deps
```

## Levels

- **lite** — explore codebase + Markdown (Thai) + Mermaid flow diagrams,
  แล้วถามว่าต้องการ HTML template ไหม (swagger / docusaurus / dashboard / slide)
- **full** — lite + วิเคราะห์หน้า UI frontend + เลือก UI artifact
  (เลือก simulation/snapshot/both/none ตามหลักฐานที่มี) + เลือกและสร้าง HTML template

HTML references ทุกแบบยกเว้น slide ใช้ visual system เดียวกับ Order Fulfillment reference:
IBM Plex Sans Thai/IBM Plex Mono, paper-and-ink palette, docs topbar/sidebar,
cards, status pills และ dark simulator panel ดูรายละเอียดที่
`references/ui-theme.md`

## Install

ติดตั้ง skill นี้ให้ครบ 3 agent แบบ global:

```bash
npx skills@latest add riskywerawat/business-docs-th \
  --skill business-docs-th \
  --global \
  --agent codex \
  --agent github-copilot \
  --agent claude-code \
  --yes
```

ชื่อ agent ที่ถูกต้องคือ `codex`, `github-copilot` และ `claude-code`
(`claude` เป็นชื่อ CLI แต่ identifier ของ `npx skills` คือ `claude-code`)

ตรวจสอบผลการติดตั้ง:

```bash
npx skills list --global \
  --agent codex \
  --agent github-copilot \
  --agent claude-code
```

ถ้าต้องการติดตั้งเฉพาะ project ให้ตัด `--global` ออก

### Local smoke test

ก่อน push สามารถทดสอบ discovery จาก local repo ได้:

```bash
npx skills@latest add . --list
npx skills@latest add . --skill business-docs-th --agent codex --yes
```

การติดตั้ง default ใช้ symlink ซึ่งเหมาะกับการพัฒนา skill และการ update
ถ้าสภาพแวดล้อมไม่รองรับ symlink ให้เพิ่ม `--copy`

## Publish checklist

ก่อน publish ให้ตรวจรายการนี้:

1. `SKILL.md` อยู่ที่ root และมี YAML frontmatter `name` กับ `description`
2. `name` ใช้ lowercase พร้อม hyphen และตรงกับ `--skill business-docs-th`
3. ไม่มี path เฉพาะเครื่อง, secret, token หรือ instruction ที่ผูกกับ agent เดียว
4. reference และ asset ที่ skill ต้องใช้ถูก commit อยู่ใน repo แล้ว
5. ไฟล์ที่ vendor จาก `diagram-design` มี attribution และ license ครบ
6. push ไป GitHub แล้วลอง `npx skills@latest add riskywerawat/business-docs-th --list`

Skill แบบพื้นฐานใช้ `SKILL.md` เดียวร่วมกันได้ทั้งสาม agent ไม่ต้องทำไฟล์
`CLAUDE.md` หรือ `copilot-instructions.md` ซ้ำ เว้นแต่ต้องการ behavior เฉพาะ product

เมื่อพบ UI ให้ถามเลือก `simulation`, `snapshot`, `both` หรือ `none`
หลังตรวจ implementation แล้ว ถ้าเป็นระบบหลังบ้านหรือไม่มี UI จริง ให้ถามเพิ่มว่า
ต้องการ `simulation UI` เพื่ออธิบาย flow คล้าย Order Fulfillment Run หรือไม่

เมื่อ HTML มีภาพรวมระบบหรือส่วน "ใครทำอะไร" ให้ถามเพิ่มว่าจะสร้าง
`ai-illustration` หรือใช้ Mermaid/HTML/CSS อย่างเดียว ดูกติกาที่
`references/ai-illustration.md`

## Scripts

```bash
./scripts/new-doc.sh order-fulfillment            # scaffold docs/
./scripts/fetch-diagram-design.sh --list          # ดู diagram สำเร็จรูปทั้งหมด (vendored)
./scripts/fetch-diagram-design.sh --copy \
  assets/example-architecture-full.html \
  docs/order-fulfillment/assets/architecture/     # ลอกพร้อม attribution header
./scripts/fetch-diagram-design.sh --update        # sync จาก upstream (network)
./scripts/vendor-cdn.sh docs/order-fulfillment \
  https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js
./scripts/check-html.sh docs/order-fulfillment/index.html
```

กฎหลัก: Evidence before assumption — ห้ามเดา behavior, ห้ามวาด flow ที่ไม่มี
code รองรับ, unknown = TBD, Technical Reference อยู่ท้ายเอกสารเสมอ
