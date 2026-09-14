# AI System Overview Illustration

ใช้สำหรับภาพประกอบเชิงแนวคิดใน HTML ที่อธิบาย `ภาพรวมระบบ / ใครทำอะไร`
โดยไม่ทำให้ผู้อ่านเข้าใจผิดว่าเป็น screenshot หรือหลักฐานจาก application จริง

## Decision

ถามเฉพาะเมื่อเอกสารมี actor/role/system boundary ที่ชัดและภาพจะช่วยอธิบาย
ownership หรือ handoff ได้:

```text
จากภาพรวมระบบและส่วน "ใครทำอะไร" ต้องการเพิ่มภาพประกอบ AI จำนวน 1 ภาพ
ใน HTML เพื่อช่วยเล่า ownership และ handoff ให้เห็นเร็วขึ้นไหม?
1. ai-illustration — สร้างภาพเดียวสำหรับภาพรวมระบบ (เช่น example.png)
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

## Prompt contract

ก่อนเรียก image generation ให้ทำ evidence list สั้น ๆ:

```text
Actors: <ชื่อ actor/team ที่พบใน source>
Systems: <ชื่อระบบ/service ที่พบใน source>
Responsibilities: <ใครรับผิดชอบอะไร>
Handoffs: <ส่งต่องานระหว่างใครกับใคร>
Unknowns: <สิ่งที่ยังยืนยันไม่ได้ ให้ตัดออกจากภาพ>
```

ใช้ evidence list นี้เป็นขอบเขตของ prompt เท่านั้น และกำหนดให้:

- ภาพเป็น editorial/concept illustration ไม่ใช่ UI screenshot
- ใช้ shapes, lanes, nodes หรือ abstract operational scene ตามความเหมาะสม
- ไม่ให้ AI วางข้อความยาว โลโก้ หรือ label สำคัญในภาพ
- labels และ legend ต้องวางเป็น HTML เพื่อ accessibility และแก้ copy ได้
- ห้ามเพิ่ม actor, service, queue, database, vendor หรือ arrow ที่ไม่มีใน evidence

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
