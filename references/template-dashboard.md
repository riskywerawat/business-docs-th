# Template: Dashboard / Control Center

สไตล์เหมาะกับ: assessment, migration readiness, blockers/risks tracking, roadmap, executive summary

## โครงหน้า

- App shell: sidebar เข้ม (brand + nav จัดกลุ่ม Overview/Execution/Source) / main
- Topbar sticky: breadcrumb + ปุ่มลิงก์ Markdown ฉบับเต็ม + print
- Hero: gradient เข้ม + eyebrow + ชื่อ + pills (สถานะ, วันที่, scope)
- Decision banner: เหลือง amber + icon "!" + gate counter
- Metric grid: การ์ดตัวเลขสำคัญ ทำเป็น `<button>` เปิด dialog รายการได้
- Sections: blockers (`<details class="endpoint">`), risk cards, roadmap phases, backlog, unknowns
- Dialog ด้วย `<dialog>` + `::backdrop` สำหรับ inventory รายการ

## CDN ที่ต้อง pin

```html
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+Thai:wght@400;600;700&display=swap" rel="stylesheet">
<!-- ใช้ pure CSS ก็พอ ถ้าไม่ใช้ Tailwind ไม่ต้อง include -->
```

## Design tokens แนะนำ

```css
--navy:#172b4d; --navy-2:#0e1d34; --blue:#0b75de; --cyan:#00a7b5;
--green:#14804a; --amber:#a35f00; --red:#c62828; --purple:#7145d6;
--canvas:#f4f7fa; --radius:10px;
```

- Border-top สี แยกประเภท metric (blue/cyan/purple/amber/red)
- Tag/pill สี: blocker/critical แดง, high เหลือง, p2 น้ำเงิน, done เขียว
- Compare block: code เทียบ Oracle↔PostgreSQL หรือ before↔after ใน grid 2 col
- `@media print`: ซ่อน sidebar/topbar/dialog, แสดง details ทั้งหมด

## กฎเนื้อหา

- ตัวเลขใน metric ต้องมาจาก evidence จริง (นับจาก repo) ไม่เดา
- Blocker ทุกอันต้องมี "Why blocked" + "Exit condition"
- เชื่อมกลับไฟล์ Markdown ฉบับเต็มเสมอ
