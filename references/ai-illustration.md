# AI System Overview Illustration

ใช้สำหรับภาพประกอบเชิงแนวคิดใน HTML ที่อธิบาย `ภาพรวมระบบ / ใครทำอะไร`
โดยไม่ทำให้ผู้อ่านเข้าใจผิดว่าเป็น screenshot หรือหลักฐานจาก application จริง

## Decision

ถามเฉพาะเมื่อเอกสารมี actor/role/system boundary ที่ชัดและภาพจะช่วยอธิบาย
ownership หรือ handoff ได้:

```text
จากภาพรวมระบบและส่วน "ใครทำอะไร" ต้องการเพิ่มภาพประกอบ AI จำนวน 1 ภาพ
ใน HTML เพื่อช่วยเล่า ownership และ handoff ให้เห็นเร็วขึ้นไหม?
1. ai-illustration — สร้างภาพเดียวสำหรับภาพรวมระบบ พร้อมข้อความสั้น ๆ บนภาพ
   ตาม reference (เช่น example.png)
2. none — ใช้ Mermaid, HTML/CSS และข้อความเท่านั้น
```

ค่าเริ่มต้นให้ใช้ภาพเดียวและใช้เฉพาะส่วน `ภาพรวมระบบ / System Overview /
ใครทำอะไร` เท่านั้น เช่น `example.png` ห้ามสร้างภาพแยกสำหรับแต่ละ step, UI,
screenshot หรือ diagram

หากต้องการใช้มากกว่า 1 ภาพ ต้องหยุดถามผู้ใช้ก่อนสร้างภาพเพิ่ม โดยระบุจำนวนและ
ขอบเขตของแต่ละภาพให้ชัดเจน ห้ามถือว่าการเลือก `ai-illustration` เป็นการอนุมัติ
ภาพหลายภาพโดยอัตโนมัติ

คำถามเมื่อภาพเดียวอาจไม่พอ:

```text
ภาพรวมระบบนี้อาจต้องใช้ภาพ AI มากกว่า 1 ภาพ ต้องการเพิ่มภาพหรือไม่?
1. 1 ภาพ — ใช้ example.png ภาพเดียว
2. มากกว่า 1 ภาพ — โปรดระบุจำนวนและขอบเขตของแต่ละภาพ
3. none — ไม่สร้างภาพ AI
```

## `example.png` visual blueprint

`example.png` เป็น infographic แนวนอนอัตราส่วน 16:9 ไม่ใช่ภาพ abstract ทั่วไป
รายละเอียดที่ต้องรักษาเมื่อสร้างภาพ overview:

- พื้นหลังสว่าง มี title ใหญ่ด้านบน และ subtitle ที่สรุป business flow
- กล่องขั้นตอนเรียงจากซ้ายไปขวา มีเลขลำดับ, owner/system label, icon และ outcome
  สั้น ๆ ใต้ภาพของแต่ละกล่อง
- มีลูกศรขนาดใหญ่เชื่อมลำดับงานให้เห็น handoff ชัดเจน
- มี callout หนึ่งจุดสำหรับ business takeaway ที่ต้องจำ
- มี result/status legend ด้านล่าง เช่น สำเร็จ, สำเร็จมีคำเตือน, ไม่สำเร็จ,
  ไม่ต้องคำนวณ/ยกเลิก — ใช้เฉพาะสถานะที่ source code รองรับ
- ใช้ navy/teal/orange หรือสี semantic ที่แยกความหมายได้ชัด และใช้ typography
  ที่อ่านภาษาไทยได้จริง

ให้ใช้โครงสร้างนี้เป็น reference เท่านั้น เปลี่ยนจำนวนกล่อง, copy, actor, system,
icon และสถานะให้ตรงกับ evidence ของ feature ปัจจุบัน ห้ามคัดลอกเนื้อหา Payroll
จากตัวอย่างไปใช้กับ feature อื่น

## Prompt contract

ก่อนเรียก image generation ให้ทำ evidence list สั้น ๆ:

```text
Actors: <ชื่อ actor/team ที่พบใน source>
Systems: <ชื่อระบบ/service ที่พบใน source>
Responsibilities: <ใครรับผิดชอบอะไร>
Handoffs: <ส่งต่องานระหว่างใครกับใคร>
Required visible text: <ข้อความ exact ที่ต้องปรากฏบนภาพ: title + subtitle + step labels/outcomes + callout + status legend>
Text placement: <ตำแหน่ง/ลำดับของข้อความให้ใกล้เคียง reference>
Unknowns: <สิ่งที่ยังยืนยันไม่ได้ ให้ตัดออกจากภาพ>
```

ใช้ evidence list นี้เป็นขอบเขตของ prompt เท่านั้น และกำหนดให้:

- ภาพเป็น editorial/concept illustration ไม่ใช่ UI screenshot
- ใช้ shapes, lanes, nodes หรือ abstract operational scene ตามความเหมาะสม
- ต้องมีข้อความสั้น ๆ บนภาพให้เห็นจริงเหมือน reference: title, subtitle,
  actor/system labels, outcome ของแต่ละขั้น, callout และ status legend ที่ระบุใน
  `Required visible text`
- ถ้าเป็น flow หลายขั้น ต้องคงรูปแบบ numbered cards + ลูกศร + outcome + legend
  ตาม blueprint ของ `example.png`; ห้ามลดเหลือเพียง icon หรือภาพตกแต่ง
- ข้อความบนภาพต้องใช้ exact text จาก evidence ห้ามให้ AI แต่งคำหรือสะกดชื่อระบบเอง
- จำกัดข้อความบนภาพให้สั้นและอ่านได้; ข้อความยาว/คำอธิบายเต็มยังวางเป็น HTML
  เพื่อ accessibility และแก้ copy ได้ แต่ห้ามใช้ HTML แทนข้อความบนภาพ
- ห้ามเพิ่ม actor, service, queue, database, vendor หรือ arrow ที่ไม่มีใน evidence

หลัง generate ต้องเปิดตรวจภาพจริงว่ามีข้อความครบ อ่านได้ และสะกดตรงกับ
`Required visible text`; ถ้าข้อความหายหรือเพี้ยน ให้ regenerate หรือทำ text overlay
แล้วตรวจซ้ำก่อน embed ใน HTML

## HTML contract

```html
<figure class="ai-illustration-frame">
  <div class="ai-illustration-badge">AI-GENERATED ILLUSTRATION · CONCEPTUAL</div>
  <img src="./assets/illustrations/example.png"
       alt="ภาพเชิงแนวคิดแสดง <actor> ส่งต่องานให้ <system> ตาม flow ที่ยืนยันจาก source code">
  <figcaption class="ai-illustration-caption">
    ภาพประกอบเชิงแนวคิดเพื่อช่วยอ่าน ownership และ handoff — ไม่ใช่ภาพหน้าจอจริง
    และไม่ใช่หลักฐานเพิ่มเติมจาก application
  </figcaption>
</figure>
```

วาง Mermaid หรือ text evidence ที่เป็น source of truth ใกล้ภาพเสมอ และห้ามใช้ภาพนี้
แทน diagram ที่จำเป็นต่อการตรวจลำดับการทำงาน

## Output and safety

- output: `docs/<feature-name>/assets/illustrations/example.png`
- ตรวจภาพและ prompt ไม่ให้มี secret, token, PII, production data หรือ local path
- ถ้า agent ไม่มี image-generation capability ให้ใช้ `none` หรือรอภาพที่ผู้ใช้แนบ
- ถ้าภาพสื่อความหมายเกิน evidence ให้ regenerate ด้วย prompt ที่แคบลง หรือลบภาพ
