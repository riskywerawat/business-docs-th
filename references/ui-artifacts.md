# UI Artifacts: Simulation, Snapshot และ None

ใช้ reference นี้หลังจากตรวจ source code และระบุแล้วว่า feature มี UI จริงหรือเป็น
ระบบหลังบ้านที่ต้องการสื่อสารด้วย mock UI

HTML ที่สร้างจากตัวเลือกเหล่านี้ต้องใช้ [Shared UI Theme](./ui-theme.md) และ
`assets/templates/business-docs-ui.css` เช่นเดียวกับ dashboard, docs site และ
API reference โดยไม่ใช้กับ slide

## Decision table

| สถานการณ์ | ตัวเลือกที่ถาม | หลักฐานที่ส่งมอบ |
| --- | --- | --- |
| พบ UI จริงและเข้าถึง app ได้ | `simulation`, `snapshot`, `both`, `none` | mock, ภาพจริง, ทั้งคู่ หรือไม่มี |
| พบ UI จริงแต่เข้าถึง app ไม่ได้ | `simulation`, `snapshot`, `both`, `none` | simulation จาก code, ภาพที่ผู้ใช้แนบ, ทั้งคู่ หรือไม่มี |
| ระบบหลังบ้าน / ไม่มี UI จริง | `simulation`, `none` | mock ที่ติดป้าย หรือ Markdown/Mermaid |

## Simulation

Simulation คือ HTML ที่เลียนแบบโครงหน้าจอและ interaction เพื่อช่วยอธิบาย flow
ไม่ใช่หน้าจอจริงและไม่ใช่หลักฐานว่า application ทำงานแบบนั้นแล้ว

- เริ่มจาก `assets/templates/order-fulfillment-run-example.html` เมื่อรูปแบบ
  interactive walkthrough เหมาะกับเนื้อหา
- ตัวอย่าง Order Fulfillment เป็น dummy และมี relative links สำหรับ demo เท่านั้น
  ซึ่งต้องเปลี่ยนหรือเอาออกเมื่อ reuse กับ feature อื่น
- output ไปที่ `docs/<feature-name>/simulation/index.html`
- ใช้ demo data และปิดการเรียก API / การเขียนข้อมูลจริง
- แสดง `SIMULATION` หรือ `MOCK · ไม่เชื่อมต่อระบบจริง` ในหน้าอย่างเด่นชัด
- คัดเฉพาะ field, action, state และผลลัพธ์ที่ source code ยืนยันได้
- ถ้าเป็นระบบหลังบ้าน ให้แสดงเป็น operator/admin view หรือ process console
  เท่าที่จำเป็นต่อการอธิบาย business flow
- ใช้ dark `.simulator-panel`, status readout, timeline และ progressive disclosure
  แบบ Order Fulfillment เมื่อ interaction เป็น flow หรือ state transition
- ไฟล์ Order Fulfillment เป็น reference จาก demo กลาง จึงต้องตรวจและปรับ
  local/source links, dependency CDN และข้อมูลฝังในไฟล์ก่อน reuse หรือ publish
  โดยห้ามปล่อย path เฉพาะเครื่องหรือข้อมูลลับไปกับ artifact

## Snapshot

Snapshot คือภาพจาก application จริงหรือไฟล์ภาพที่ผู้ใช้ส่งมา

- ใช้ browser/UI automation ของ agent เมื่อมีและเมื่อผู้ใช้อนุญาตให้เข้าถึง app
- ถ้าไม่มี capability ให้ขอผู้ใช้แนบภาพ หรือเขียน `TBD`
- ห้ามวาดภาพขึ้นมาใหม่แล้วเรียกว่า snapshot
- ใช้ test/demo data และตรวจ secret ก่อน embed ทุกครั้ง
- ทุกภาพต้องมี caption ที่บอกว่าผู้อ่านควรสังเกตอะไร

## Naming and disclosure

- ภาพจริง: `assets/ui/01-entry.png`, `assets/ui/02-result.png`
- simulation: `simulation/index.html`
- ใน README และ slide ต้องระบุประเภท artifact ให้ชัด เช่น
  `SNAPSHOT · หน้าจอจริง` หรือ `SIMULATION · ไม่เชื่อมต่อระบบจริง`
