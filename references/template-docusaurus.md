# Template: Docusaurus-style Docs Site

สไตล์เหมาะกับ: เอกสาร feature ยาว, หลายหัวข้อ, sidebar นำทาง, อ่านแบบ docs site

ใช้ [Shared UI Theme](./ui-theme.md) และ
`assets/templates/business-docs-ui.css` เป็น visual foundation
เพื่อให้ docs site มีภาษาภาพเดียวกับ Order Fulfillment reference

## โครงหน้า

- Sticky topbar: breadcrumb + ปุ่ม "อ่านฉบับ Markdown" + print
- Sidebar sticky (เหมือน swagger แต่เป็นสารบัญหัวข้อ ไม่ใช่ endpoint):
  ใช้ `<nav>` ลิงก์ anchor ไปทุก `## heading` พร้อม scroll-margin
- Main content: hero/summary card ต้นหน้า → เนื้อหาหัวข้อตามโครง README.md
- ท้ายหน้า: ลิงก์กลับ Markdown + footer version/snapshot date

## Mermaid (บังคับเมื่อมี diagram)

```html
<script src="https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js"></script>
<script>
  mermaid.initialize({ startOnLoad: true, theme: "neutral" });
</script>
<!-- diagram แต่ละอัน -->
<pre class="mermaid">
flowchart TD
    A["ผู้ใช้กด Calculate"] --> B["ระบบตรวจสอบข้อมูล"]
</pre>
```

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

- ใช้ paper/surface/ink/accent จาก Shared UI Theme แทน Docusaurus palette เดิม
- hero ใช้ `docs-card`, `docs-title`, `docs-subtitle`, `pill` และ `grid-lines`
- sidebar ใช้ `.docs-sidebar` และ active link ที่มี border/surface state ชัด
- section รองใช้ `.card-soft`; code block ใช้พื้น `var(--color-ink)` และ mono font
- Callout blocks: `:::note` = เขียวอ่อน, `:::warning` = เหลือง, `:::danger` = แดง
  ทำเป็น `<div class="admonition admonition-note">`
- ตาราง: border-collapse, header `#f5f6f7`, hover row
- animation ใช้เฉพาะ reveal/interaction ที่ช่วยนำทาง และต้องรองรับ reduced motion

## กฎเนื้อหา

- เนื้อหา copy ตรงจาก README.md ของ feature — HTML เป็น render อีกชั้น ไม่แต่งเนื้อหาใหม่
- Screenshot อ้าง path เดียวกับ Markdown (`./assets/ui/01-entry.png`)
- ทุก mermaid block ต้องผ่าน `./scripts/check-html.sh`
