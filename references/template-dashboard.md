# Template: Dashboard / Control Center

สไตล์เหมาะกับ: assessment, migration readiness, blockers/risks tracking, roadmap, executive summary

ใช้ [Shared UI Theme](./ui-theme.md) และ
`assets/templates/business-docs-ui.css` เป็น visual foundation ของ HTML นี้
(ไม่ใช่ slide) โดยคงโครง dashboard ด้านล่างไว้

## โครงหน้า

- App shell: sidebar เข้ม (brand + nav จัดกลุ่ม Overview/Execution/Source) / main
- Topbar sticky: breadcrumb + ปุ่มลิงก์ Markdown ฉบับเต็ม + print
- Hero: gradient เข้ม + eyebrow + ชื่อ + pills (สถานะ, วันที่, scope)
- Decision banner: เหลือง amber + icon "!" + gate counter
- Metric grid: การ์ดตัวเลขสำคัญ ทำเป็น `<button>` เปิด dialog รายการได้
- Sections: blockers (`<details class="endpoint">`), risk cards, roadmap phases, backlog, unknowns
- Dialog ด้วย `<dialog>` + `::backdrop` สำหรับ inventory รายการ

## Head, fonts และ CDN ที่ต้องใช้

```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4.3.3"></script>
<script src="https://cdn.jsdelivr.net/npm/marked@15.0.12/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/gsap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.4/dist/confetti.browser.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Thai:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="./assets/business-docs-ui.css">
```

## Visual direction และ design tokens

```css
/* ใช้ tokens ใน Shared UI Theme เป็นหลัก */
--color-paper; --color-surface; --color-ink; --color-ink-2;
--color-line; --color-accent; --color-amber; --color-green; --color-red;
--color-simulator; --color-simulator-2; --radius-lg; --radius-xl;
```

- Hero ใช้ `grid-lines` + `docs-title` + kicker mono + metadata pills
- Border-top ของ metric ใช้ accent ตามความหมาย (accent/amber/green/red)
- Tag/pill สี: blocker/critical แดง, high เหลือง, p2 น้ำเงิน, done เขียว
- ใช้ `.simulator-panel` สำหรับ execution console หรือ simulation ที่มี interaction
- Compare block: code เทียบ Oracle↔PostgreSQL หรือ before↔after ใน grid 2 col
- `@media print`: ซ่อน sidebar/topbar/dialog, แสดง details ทั้งหมด

## กฎเนื้อหา

- ตัวเลขใน metric ต้องมาจาก evidence จริง (นับจาก repo) ไม่เดา
- Blocker ทุกอันต้องมี "Why blocked" + "Exit condition"
- เชื่อมกลับไฟล์ Markdown ฉบับเต็มเสมอ
