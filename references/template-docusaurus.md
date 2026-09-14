# Template: Docusaurus-style Docs Site

สไตล์เหมาะกับ: เอกสาร feature ยาว, หลายหัวข้อ, sidebar นำทาง, อ่านแบบ docs site

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

## CDN ที่ต้อง pin

```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4.3.3"></script>
<script src="https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Thai:wght@400;600;700&display=swap" rel="stylesheet">
```

## Design tokens แนะนำ

- Docusaurus palette: primary `#25c2a0` / `#2e8555`, background ขาว, code block `#f6f7f8`
- Callout blocks: `:::note` = เขียวอ่อน, `:::warning` = เหลือง, `:::danger` = แดง
  ทำเป็น `<div class="admonition admonition-note">`
- ตาราง: border-collapse, header `#f5f6f7`, hover row

## กฎเนื้อหา

- เนื้อหา copy ตรงจาก README.md ของ feature — HTML เป็น render อีกชั้น ไม่แต่งเนื้อหาใหม่
- Screenshot อ้าง path เดียวกับ Markdown (`./assets/ui/01-entry.png`)
- ทุก mermaid block ต้องผ่าน `./scripts/check-html.sh`
