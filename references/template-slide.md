# Template: Slide Deck (นำเสนอ / Sprint Review)

สไตล์เหมาะกับ: sprint review deck, นำเสนอ flow, meeting materials — full-screen scroll-snap slides

## Template file

ใช้ `assets/templates/slide-template.html` เป็น visual shell เมื่อผู้ใช้ต้องการ
ใช้ template นี้โดยตรง คงสี ฟอนต์ spacing, fixed chrome, navigation และ animation
ไว้ แล้วแทนที่ title, copy, labels, metrics และ demo-specific content ให้มาจาก
feature ที่กำลังทำเท่านั้น

ถ้า slide ต้องลิงก์ไปยัง interactive mock ให้ใช้
`assets/templates/order-fulfillment-run-example.html` เป็น reference ของ simulation
แล้วแยก mock ไปไว้ที่ `docs/<feature-name>/simulation/index.html`

## โครงหน้า

- Fixed chrome: progress bar บน, brand + slide counter บนซ้าย/ขวา,
  dot rail ขวา (hover แสดง label), ปุ่ม ↑↓ ขวาล่าง, keyboard hint
- แต่ละ slide เป็น `<section class="slide">` กว้าง 100svh + `scroll-snap-align: start`
- Slide themes สลับกัน: `slide-dark` / `slide-paper` / `slide-white` / `slide-blue` / `slide-acid`
- แต่ละ slide มีเลขใหญ่จาง (`slide-number`) + kicker + h2 + lead + layout grid
- Reveal animation: `.reveal` เริ่ม opacity 0 → active เมื่อ slide เป็น current
- JS: ตาม scroll position เลือก slide ใกล้ center สุด (rAF), ปุ่ม/keyboard
  (↑↓, PageUp/Down, Home/End), progress bar width, aria-current บน rail

## CDN ที่ต้อง pin

```html
<link href="https://fonts.googleapis.com/css2?family=Bai+Jamjuree:wght@400;500;600;700&family=Chakra+Petch:wght@500;600;700&display=swap" rel="stylesheet">
```

## Design tokens แนะนำ

```css
--night:#0b1428; --paper:#f4f0e6; --blue:#2f65ff; --acid:#d9ff43;
--mint:#68e0c2; --orange:#ff6b3d;
--sans:"Bai Jamjuree",sans-serif; --display:"Chakra Petch",sans-serif;
```

- Grid background จางบนทุก slide (linear-gradient 1px lines)
- การ์ด/note เอียงเล็กน้อย (`rotate(±1deg)`) + hard shadow ให้ feel แบบ poster
- `prefers-reduced-motion`: ปิด smooth scroll + reveal
- `@media print`: ปิด snap, แสดงทุก slide เป็นหน้าแยก

## เนื้อหา slide มาตรฐาน (ปรับตาม feature)

1. Cover — ชื่อ + จุดประสงค์การรีวิว + route panel (4 ขั้น)
2. Review frame — จะดูอะไร ดูอย่างไร (3 การ์ด)
3. Flow หลัก 1 — copy + metric strip + ภาพ/screenshot + TRY checkpoints
4. Flow หลัก 2 — สลับ theme, modes 2 การ์ด (เช่น close/reopen)
5. Retro — คำถามคุย
6. Finale — next step + ลิงก์ mock/เอกสาร

## กฎเนื้อหา

- ข้อความสั้น ภาษาไทย ใช้ได้ใน meeting ทันที
- Mock/ขอบเขตต้องระบุชัด (เช่น "MOCK · ไม่เชื่อมต่อระบบจริง")
- ถ้ามี screenshot ใช้รูปจริงจาก `assets/ui/` ห้าม placeholder ปลอม
