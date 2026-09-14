# Template: Swagger-style API Reference

สไตล์เหมาะกับ: API reference, endpoint inventory, migration spec, สิ่งที่มีรายการ operation เยอะและต้องกรอง/ค้นหา

ตัวอย่างเต็มอยู่ในแนบต้นแบบของ skill (Payroll Migration API Reference)
โครงหลักที่ต้องมี:

## โครงหน้า

- Sticky header: brand + stats summary + ปุ่ม print
- Grid 2 คอลัมน์: sidebar nav (จัดกลุ่ม + method badge + status dot) / main content
- Operation แต่ละรายการเป็น `<details class="operation">` — summary แสดง
  method / route / title / badge status; body เปิดแล้วเห็น params, request/response, mapping
- Common sections ท้าย: query ร่วม, กฎร่วม, gates, ขอบเขตการวิเคราะห์

## CDN ที่ต้อง pin

```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4.3.3"></script>
<link rel="preconnect" href="https://esm.sh" crossorigin>
<!-- ถ้าใช้ React workbench -->
<script type="importmap">{"imports":{"react":"https://esm.sh/react@19.2.0"}}</script>
```

## Fonts ไทย

```css
--sans: "IBM Plex Sans Thai","Noto Sans Thai","Leelawadee UI",sans-serif;
--mono: "IBM Plex Mono",SFMono-Regular,Consolas,monospace;
```

## Design tokens แนะนำ

- Surface อ่อน `#eef2f4`, nav เข้ม `#102536`, accent `#e8a317`
- Method colors: GET น้ำเงิน `#1269b0` / POST เขียว `#238636`
- Status badges: ready เขียว / partial เหลือง / missing แดง / proposed ม่วง
- มี `@media print` ซ่อน sidebar/toolbar และเปิด operation ทั้งหมด

## กฎเนื้อหา

- ทุก operation ต้องมี section ภาษาไทยอธิบาย "ทำไม/ใช้ที่ไหน"
- Technical path เก็บใน `evidence` list ท้าย operation
- ใส่ `<noscript>` fallback ชี้ไปไฟล์ Markdown
