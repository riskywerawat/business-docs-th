# Shared UI Theme: Editorial Operations Console

HTML reference ทุกแบบยกเว้น `slide` ต้องใช้ visual system นี้เป็นฐาน เพื่อให้
เอกสารทั้งชุดดูเป็น product เดียวกัน แม้โครงเนื้อหาจะต่างกัน

เมื่อสร้างเอกสารจริง ให้ inline เนื้อ `assets/templates/business-docs-ui.css`
ทั้งไฟล์ไว้ใน `<style>` ของ HTML ที่สร้าง (ทั้ง `index.html` และ
`simulation/index.html`) — ห้าม copy ออกเป็นไฟล์ `assets/business-docs-ui.css`
แล้ว `<link>` กลับเข้ามา และอย่าลบ `pre.mermaid` override ท้ายไฟล์ทิ้ง
เพราะเป็นตัวกันไม่ให้ mermaid จมบนพื้นเข้มของ code-block `pre`

## Direction

- โทน: editorial operations console — จริงจัง อ่านง่าย และมีรายละเอียดเชิงระบบ
- พื้นหลักเป็นกระดาษอ่อน มีเส้น grid บาง ๆ และ surface ขาวสำหรับเนื้อหา
- ใช้ topbar แบบ sticky, sidebar แบบ docs app และ main column ที่มี max-width
- Hero ใช้ตัวอักษรใหญ่ + kicker แบบ mono + metadata pills
- ใช้ dark panel สำหรับ simulator, execution timeline, API request/response
- ใช้สี accent เพื่อสื่อ state เท่านั้น ไม่ใช้ gradient ม่วงหรือสีเพื่อการตกแต่งลอย ๆ

## Fonts — ต้องใช้ชุดนี้

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Thai:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500&display=swap" rel="stylesheet">
```

```css
:root {
  --font-display: "IBM Plex Sans Thai", system-ui, sans-serif;
  --font-body: "IBM Plex Sans Thai", system-ui, sans-serif;
  --font-mono: "IBM Plex Mono", ui-monospace, monospace;
}

*, *::before, *::after { font-family: var(--font-body); }
h1, h2, h3, h4 { font-family: var(--font-display); }
code, pre, kbd, .mono, .kicker, .tag { font-family: var(--font-mono); }
```

ห้ามเปลี่ยนกลับไปใช้ Inter เป็น default ของ reference เหล่านี้ และห้ามใช้
font fallback ที่ทำให้ภาษาไทยกลายเป็นหน้าตาคนละชุดโดยไม่จำเป็น

## CDN baseline — ใช้เท่าที่ feature ต้องใช้

```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4.3.3"></script>
<script src="https://cdn.jsdelivr.net/npm/marked@15.0.12/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/mermaid@12.0.0/dist/mermaid.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.12.5/dist/gsap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.4/dist/confetti.browser.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
```

- ใช้ Tailwind browser build เมื่อมี utility class; ถ้าใช้ pure CSS อย่างเดียว
  ตัด script ที่ไม่จำเป็นออกได้
- `marked` ใช้เมื่อ render Markdown ใน browser
- `mermaid` ใช้เมื่อมี diagram และต้องเรียก
  `mermaid.initialize({ startOnLoad: true, theme: "neutral" })`
- `gsap` และ `canvas-confetti` ใช้เฉพาะ interaction ที่มีประโยชน์ต่อการสาธิต
  ไม่ใส่ animation หรือ effect เพื่อความหวือหวาอย่างเดียว
- ทุก CDN ต้องระบุ version ห้ามใช้ `@latest` หรือ URL ที่ลอยตาม major โดยไม่จำเป็น

## Tokens — ถอดจาก Order Fulfillment reference

```css
:root {
  --color-paper: oklch(98.2% 0.003 260);
  --color-paper-2: oklch(96% 0.005 260);
  --color-surface: oklch(99.2% 0.003 260);
  --color-ink: oklch(22% 0.015 260);
  --color-ink-2: oklch(38% 0.02 260);
  --color-ink-3: oklch(55% 0.015 260);
  --color-line: oklch(88% 0.01 260);
  --color-line-strong: oklch(82% 0.015 260);
  --color-grid: oklch(91% 0.01 260 / .62);
  --color-shadow: oklch(22% 0.015 260 / .08);
  --color-accent: oklch(54% 0.22 264);
  --color-accent-2: oklch(93% 0.04 264);
  --color-accent-ink: oklch(98% 0.01 264);
  --color-coral: oklch(64% 0.17 35);
  --color-coral-bg: oklch(97% 0.03 35);
  --color-amber: oklch(72% 0.14 75);
  --color-amber-bg: oklch(97% 0.03 85);
  --color-green: oklch(58% 0.14 155);
  --color-green-bg: oklch(96% 0.04 155);
  --color-red: oklch(55% 0.18 25);
  --color-red-bg: oklch(97% 0.03 25);
  --color-blue-bg: oklch(97% 0.025 260);
  --color-simulator: oklch(24% 0.025 250);
  --color-simulator-2: oklch(30% 0.035 250);
  --color-simulator-line: oklch(48% 0.035 250);
  --color-simulator-muted: oklch(72% 0.025 250);
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;
  --radius-xl: 22px;
  --shadow-card: 0 14px 40px var(--color-shadow);
}
```

## Component contract

ทุก reference ต้องมี component เหล่านี้ในรูปแบบที่เหมาะกับเนื้อหา:

- `.docs-topbar` — brand, breadcrumb, anchor links, print หรือ action หลัก
- `.docs-sidebar` — navigation ที่ active state ชัด และซ่อน/เปิดบน mobile ได้
- `.docs-main` / `.docs-main-inner` — content column ที่อ่านง่าย ไม่กว้างเต็มจอ
- `.docs-card` หรือ `.card` — surface ขาว ขอบบาง radius ใหญ่ ไม่ใช้ shadow หนัก
- `.card-soft` — callout, metadata หรือ secondary content
- `.kicker` / `.tag` / `.mono` — technical label และ code context
- `.pill` — state, scope, date และ evidence level
- `.grid-lines` — background detail แบบบาง ใช้เฉพาะ hero หรือ section ที่เหมาะสม
- `.simulator-panel` — dark panel สำหรับ simulation หรือ execution console
- `.ai-illustration-frame` — กรอบภาพแนวคิด AI พร้อม badge และ caption
- `<details>` / `<dialog>` — progressive disclosure แทนการยัดข้อมูลทุกอย่างพร้อมกัน

## Interaction and responsive rules

- focus state ต้องเห็นชัดด้วย accent ring และ keyboard navigation ต้องใช้งานได้
- hover ใช้แค่ translate ระยะสั้นหรือเปลี่ยน surface; ห้ามทำให้ layout กระโดด
- animation ใช้ `180ms` โดยประมาณ และเคารพ `prefers-reduced-motion`
- mobile ต้องเปลี่ยน sidebar เป็น drawer หรือ horizontal navigation ที่เข้าถึงได้
- `@media print` ซ่อน topbar/sidebar/action และเปิด details ทั้งหมด
- UI ที่เป็น simulation ต้องติดป้าย `SIMULATION` หรือ `MOCK · ไม่เชื่อมต่อระบบจริง`

## Reuse rule

`assets/templates/order-fulfillment-run-example.html` เป็น visual reference หลักของ
theme นี้ ไม่ใช่ source ของเนื้อหาสำหรับ feature อื่น ให้ reuse shell, spacing,
typography, color และ interaction pattern แล้วแทนที่ copy, fields, state,
metrics และ links ด้วย evidence ของ feature ปัจจุบันเท่านั้น
