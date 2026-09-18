# Template: Swagger-style API Reference

สไตล์เหมาะกับ: API reference, endpoint inventory, migration spec, สิ่งที่มีรายการ operation เยอะและต้องกรอง/ค้นหา

ใช้ [Shared UI Theme](./ui-theme.md) และ
`assets/templates/business-docs-ui.css` เป็น visual foundation
ของ API reference นี้ (ยกเว้น slide)

ตัวอย่างเต็มอยู่ใน dummy reference ของ skill (Order Fulfillment API Reference)
โครงหลักที่ต้องมี:

## โครงหน้า

- Sticky header: brand + stats summary + ปุ่ม print
- Grid 2 คอลัมน์: sidebar nav (จัดกลุ่ม + method badge + status dot) / main content
- Operation แต่ละรายการเป็น `<details class="operation">` — summary แสดง
  method / route / title / badge status; body เปิดแล้วเห็น params, request/response, mapping
- Common sections ท้าย: query ร่วม, กฎร่วม, gates, ขอบเขตการวิเคราะห์

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
<style>
/* Inline the full assets/templates/business-docs-ui.css here (keep the
   pre.mermaid light-background override at the end of the file). */
</style>
<link rel="preconnect" href="https://esm.sh" crossorigin>
<!-- ถ้าใช้ React workbench -->
<script type="importmap">{"imports":{"react":"https://esm.sh/react@19.2.0"}}</script>
```

## Visual direction และ design tokens

```css
--font-body: "IBM Plex Sans Thai",system-ui,sans-serif;
--font-display: "IBM Plex Sans Thai",system-ui,sans-serif;
--font-mono: "IBM Plex Mono",ui-monospace,monospace;
--color-paper: oklch(98.2% 0.003 260);
--color-surface: oklch(99.2% 0.003 260);
--color-ink: oklch(22% 0.015 260);
--color-line: oklch(88% 0.01 260);
--color-accent: oklch(54% 0.22 264);
--color-simulator: oklch(24% 0.025 250);
```

- ใช้ docs topbar/sidebar + card/surface แบบ Order Fulfillment; dark surface ใช้กับ
  request/response หรือ execution console ที่ต้องการ focus
- Method colors: GET น้ำเงิน `#1269b0` / POST เขียว `#238636`
- Status badges: ready เขียว / partial เหลือง / missing แดง / proposed ม่วง
- filter/search ใช้ input surface ขาว border บาง และ focus ring accent
- มี `@media print` ซ่อน sidebar/toolbar และเปิด operation ทั้งหมด

## กฎเนื้อหา

- ทุก operation ต้องมี section ภาษาไทยอธิบาย "ทำไม/ใช้ที่ไหน"
- Technical path เก็บใน `evidence` list ท้าย operation
- ใส่ `<noscript>` fallback ชี้ไปไฟล์ Markdown
