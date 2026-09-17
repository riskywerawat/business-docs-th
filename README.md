# business-docs-th

Skill สำหรับสร้างเอกสาร Business ภาษาไทยจาก source code จริง
self-contained — ใช้รูปแบบ Agent Skills มาตรฐาน จึงติดตั้งได้กับ Codex,
GitHub Copilot และ Claude Code ผ่าน `npx skills`

> อ่านโค้ดจริง แล้วเล่าเป็นเอกสารที่ทั้งทีมเข้าใจ — PO, BA, QA, Support และ dev ใหม่
> อ่านจบแล้วรู้ว่าใครกดอะไร ระบบทำอะไรต่อ งานเข้า Queue ตอนไหน ผิดพลาดแล้วเป็นยังไง

## ทำไมต้องใช้

| สิ่งที่เจอประจำ                    | skill นี้ทำอะไรให้                                                              |
| ---------------------------------- | ------------------------------------------------------------------------------- |
| ต้องรอเจ้าของโค้ดมาไล่ flow ให้ฟัง | explore repo จริงเอง แล้วเขียน Business Flow เป็นภาพภาษาไทย                     |
| เอกสารหาย ไม่รู้ว่าตรงกับ code ไหน | metadata block ต้นเอกสารบอก commit, เจ้าของ, วันที่, ticket ทุกฉบับ             |
| เอกสารเก่าแล้วไม่มีใครกล้าแก้      | `## ประวัติการแก้ไข` ปิดท้าย ทุกครั้งที่แก้ต้องอัปเดตยอดบนให้ตรงกัน             |
| คำเรียกไม่ตรงกันข้ามเอกสาร         | glossary กลาง `docs/glossary.md` + แสดงค่า enum จริงคู่คำไทย                    |
| กลัวหลุดข้อมูลลูกค้า/secret        | กติกาข้อมูลอ่อนไหวบังคับทุกไฟล์ ไม่ใช่แค่ screenshot                            |
| อยากได้เอกสารสวย ๆ ใช้นำเสนอ       | เลือกได้ swagger / docusaurus / dashboard / slide พร้อม design pass + visual QA |

หลักการที่ยึดทุกงาน: **Evidence before assumption** — ห้ามเดาพฤติกรรม ห้ามวาด flow
ที่ไม่มี code รองรับ ที่ยืนยันไม่ได้ให้เขียน `TBD` ตรง ๆ ไม่แต่งให้ดูครบ

## เริ่มใช้

ติดตั้งแล้วพูดธรรมดาได้เลย ไม่ต้องจำคำสั่ง:

```text
"อธิบาย flow ของ feature นี้ให้หน่อย"          → lite
"ทำเอกสาร handover ของ feature นี้"            → full
"ทำเอกสารนี้เป็น slide นำเสนอด้วย"             → โหมดเดิม + HTML/Slide
```

ตัวอย่างผลลัพธ์เทียบสองระดับอยู่ที่ `examples/README.md`
(ระบบสมมติตัวเดียวกัน ทำทั้ง `lite` และ `full` ให้เทียบความลึกตรง ๆ)

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
├── examples/                       # golden examples (fictional demo system)
│   ├── README.md                   #   how to use + disclaimer
│   ├── lite/README.md              #   ตัวอย่างระดับ lite (กลาง ๆ)
│   └── full/README.md              #   ตัวอย่างระดับ full (เนียบที่สุด)
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
    ├── new-doc.sh                  # scaffold docs/<feature>/ + metadata + glossary/index
    ├── fetch-diagram-design.sh     # manage vendored copy (--list/--copy/--verify/--update)
    ├── vendor-cdn.sh               # snapshot CDN assets (https + pinned + #sha256)
    └── check-html.sh               # verify HTML includes mermaid/tailwind deps
```

## เลือกโหมด (Levels)

สองระดับต่างกันที่ **ความลึกและความเนียบของเอกสาร** ไม่ใช่แค่ artifact ที่ได้เพิ่ม:

| โหมด   | เหมาะกับ                             | ได้อะไร                                                                                                                                                                                       |
| ------ | ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lite` | คุยในทีมวันนี้ เข้าใจ flow เร็ว ๆ    | explore codebase + Markdown (Thai) + Mermaid flow diagram กระชับ อ่านจบ 5–10 นาที ครบ flow ที่ต้องรู้ แล้วถามว่าจะทำ HTML template ไหม (swagger / docusaurus / dashboard / slide)             |
| `full` | ส่งมอบ / handover / เอกสารอ้างอิงยาว | ทุกอย่างของ `lite` + traceable ถึง file/line + วิเคราะห์หน้า UI frontend + เลือก UI artifact (simulation/snapshot/both/none ตามหลักฐาน) + HTML template + ต้องผ่าน `Full Polish Pass` ก่อนส่ง |

`Depth Quality Bar` ใน `SKILL.md` เปรียบเทียบทั้ง 15 มิติ และระบุชัดว่า
`full` ห้ามมี "งานหยาบ" แบบใด (หัวข้อตกหล่น, ไม่มีที่มา, diagram ไม่มี caption,
ค่าประมาณแทนค่าจริง, ปล่อย `TBD` ที่ค้นได้)

ใช้ `examples/lite/README.md` และ `examples/full/README.md` เป็นตัวเทียบ —
ทั้งคู่เป็นระบบสมมติเพื่อการสอน ห้ามคัดลอกเนื้อหา/ตัวเลขไปใช้งานจริง

## เอกสารที่ generate ได้มีอะไรบังคับเสมอ

ไม่ว่าระดับไหน ทุกเอกสารต้องมี:

- **metadata block** ต้นเอกสาร (Feature, เจ้าของ, ระดับ, อัปเดตล่าสุด, อ้างอิง code, Ticket/PR)
- **`## ประวัติการแก้ไข`** ปิดท้ายเอกสาร เรียงใหม่ไปเก่า และห้ามลบแถวเดิม
- **คำศัพท์กลาง** — คำใหม่ทุกคำเพิ่มใน `docs/glossary.md` และแสดงค่า enum จริงคู่คำไทย
- **ไม่มีข้อมูลอ่อนไหว** — secret, token, PII, production data, hostname/IP/URL จริง,
  path เฉพาะเครื่อง ต้องแทนด้วย placeholder ในทุกไฟล์ (Markdown, HTML, caption, diagram)
- **สารบัญกลาง** `docs/README.md` เมื่อมีเอกสารเกิน 3 feature

ถ้าเนื้อหายาวเกินอ่านจบ ~10–15 นาที ต้องแยกเป็น `README.md` + `flow.md` / `rules.md` /
`api.md` / `ui.md` โดย README ต้องยืนได้ด้วยตัวเองและมีสารบัญลิงก์ไฟล์ย่อย

## Document section selection

หัวข้อของเอกสารเลือกจาก evidence ของงานนั้น ไม่ได้ใช้ list ตายตัวชุดเดียวกันทุกงาน:

- workflow การ explore (W0–W8) เป็นขั้นตอนภายในของ agent — ชื่อ step ห้ามกลายเป็นหัวข้อในเอกสาร
- `Document Outline Planning` (ใน `SKILL.md`) กำหนดหัวข้อ core + ตาราง trigger ของหัวข้อ conditional
  เช่น หัวข้อ Queue / Consumer / Failure handling จะปรากฏเฉพาะงานที่พบ producer, consumer, DLQ จริง
- หัวข้อที่ trigger ไม่ตรงให้ตัดออกทั้งหัวข้อ ไม่คงไว้แล้วใส่ `TBD` และเรียงเลขหัวข้อใหม่ต่อเนื่อง
- ทุกงานต้องรายงาน outline `include/skip` + เหตุผลในคำตอบสุดท้าย
- `scripts/new-doc.sh` scaffold เฉพาะหัวข้อ core (+ metadata, ประวัติการแก้ไข, glossary,
  docs index) ส่วนหัวข้อ conditional อยู่ใน comment ให้เลือกเพิ่มเองตามงาน

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
   (รวมถึงไฟล์ใน `examples/` ซึ่งต้องเป็นข้อมูลสมมติเท่านั้น)
4. reference และ asset ที่ skill ต้องใช้ถูก commit อยู่ใน repo แล้ว
5. ไฟล์ที่ vendor จาก `diagram-design` มี attribution และ license ครบ
   และ `./scripts/fetch-diagram-design.sh --verify` ขึ้น `ok`
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
./scripts/fetch-diagram-design.sh --verify        # ตรวจว่า vendored ตรงกับ PIN
./scripts/fetch-diagram-design.sh --verify-upstream # พิสูจน์กับ upstream จริง (network)
./scripts/fetch-diagram-design.sh --update        # vendor ใหม่ที่ commit ที่ pin ไว้ (network)
./scripts/vendor-cdn.sh docs/order-fulfillment \
  https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js
./scripts/check-html.sh docs/order-fulfillment/index.html
```

vendored copy ของ `diagram-design` ผูกกับ upstream commit เดียว (`PIN` ใน
`scripts/fetch-diagram-design.sh` และ `ATTRIBUTION.md`) — `--update` vendor
เฉพาะ commit นั้น, `--verify-upstream` พิสูจน์ว่าเนื้อหาตรงจริง และ `--copy`
อ่านได้เฉพาะในโฟลเดอร์ vendored เท่านั้น ถ้าตั้งใจขยับเวอร์ชันให้ใช้
`--update-latest` แล้วทำตามขั้นตอน bump PIN ที่มันพิมพ์ให้

`vendor-cdn.sh` รับ URL แบบ pinned (`https://` เท่านั้น ไม่รับ `@latest`) และ
ต่อท้ายด้วย `#sha256=<hex>` เพื่อยืนยัน integrity ได้ — script จะปฏิเสธถ้า hash
ไม่ตรง, เขียนไฟล์ลง `assets/vendor/` เท่านั้น และไม่ทิ้งไฟล์ `.part` ค้าง
ถ้าไม่ใส่ hash script จะพิมพ์ค่าที่คำนวณได้ให้คัดลอกไปใช้รอบหน้า:

```bash
curl -fsSL "<url>" | shasum -a 256     # ขอ hash ของไฟล์ที่ pin ไว้
./scripts/vendor-cdn.sh docs/order-fulfillment "<url>#sha256=<hex>"
```

กฎหลัก: Evidence before assumption — ห้ามเดา behavior, ห้ามวาด flow ที่ไม่มี
code รองรับ, unknown = TBD, `## Technical Reference` เป็นหัวข้อเนื้อหาสุดท้าย
และมี `## ประวัติการแก้ไข` ปิดท้ายเอกสารเสมอ
