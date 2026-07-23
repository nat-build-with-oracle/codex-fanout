# บทที่ 8: Dispatch, Probe, และที่อยู่ที่ผิด

charter เขียนเสร็จ preflight เขียวหมด coder บูตขึ้นมาเรียบร้อยแล้ว — เหลือแค่ทดสอบว่า loop ทั้งเส้นทำงานจริงไหม จาก dispatch → coder ทำงาน → coder รายงานกลับ ครบวงจร

แต่ความเงียบ ๆ อันตรายที่สุดในระบบ multi-agent ไม่ใช่ตอนที่ agent ทำงานผิด เป็นตอนที่มันทำงาน**ถูก**ทุกขั้นตอน ยกเว้นขั้นตอนสุดท้ายที่ไม่มีใครเห็นจนกว่า error message จะโผล่ขึ้นมา บทนี้คือเรื่องของ probe task แรกของ codex-1 — งานง่าย ๆ สี่ขั้นตอน เขียนไฟล์ commit push เปิด PR — ที่ทำสำเร็จหมดทุกอย่าง ก่อนจะสะดุดที่บรรทัดสุดท้าย: การรายงานกลับไปยัง "lead"

ปัญหาคือ `lead` ที่ charter เขียนไว้เป็นแค่ label ใน YAML ไม่ใช่ที่อยู่จริงในระบบ tmux เลย coder จึงยิงข้อความไปที่ `codex-fanout:lead` — ซึ่งไม่มีอยู่จริง แล้วได้ error กลับมา

จุดที่น่าสนใจไม่ใช่ error เอง เป็นสิ่งที่ coder ทำ**หลังจาก**เจอ error ต่างหาก มันเริ่ม self-diagnose ด้วยการ scan tmux ทั้งฟลีตทันที — วิธีแก้ที่แพงมากสำหรับปัญหาที่คำตอบมีบรรทัดเดียว นี่คือบทเรียนที่บทนี้จะพาไล่ดูทีละจุด ตั้งแต่ probe task แรก ไปจนถึง PR #1 ที่ merge สำเร็จ ปิด loop ของทั้งการทดลองนี้

## 8.1 Probe task แรก — เขียนไฟล์ commit push PR

ก่อนจะให้ coder ทำงานจริง ต้องรู้ก่อนว่า loop ทั้งเส้นใช้งานได้ไหม dispatch จึงเป็น task เล็กที่สุดเท่าที่จะทดสอบ end-to-end ได้ครบทุก step:

```bash
maw hey codex-fanout:codex-1 'Probe task — verify the full loop works. In your worktree:
1. Create NOTES.md with "codex-1 online — probe ok". 2. commit. 3. push. 4. gh pr create
--base alpha --head agents/codex-1 --title "probe: codex-1 online".
Report back: maw hey codex-fanout:lead "done — PR #<N>"'
```

สี่ขั้นตอนแรกไม่มีอะไรซับซ้อน สร้างไฟล์ commit push เปิด PR ไปที่ `alpha` — codex-1 ทำครบทุกอย่างถูกต้องหมด ไฟล์ถูกสร้าง commit ถูก push PR #1 เปิดสำเร็จ ถ้าดูแค่สี่ขั้นตอนนี้ก็ต้องบอกว่า loop ทำงานสมบูรณ์แบบ

แต่ dispatch message มีคำสั่งขั้นที่ห้าซ่อนอยู่ท้ายสุด — "Report back" ไปที่ `codex-fanout:lead` ตรงนี้แหละที่ทุกอย่างเริ่มพัง

## 8.2 codex-1 รายงานผิดที่ (`codex-fanout:lead` ไม่มีจริงในระบบ tmux)

charter เขียน role ของ lead ไว้แบบนี้:

```yaml
members:
  - role: lead
    name: codex-fanout
```

`role: lead` เป็นแค่ label ความหมายทาง YAML — ไว้บอกว่า member ตัวนี้ทำหน้าที่อะไรในทีม ไม่ใช่ address จริงที่ tmux รู้จัก เมื่อ codex-1 ลองส่งข้อความไปที่ `codex-fanout:lead` ตามที่ prompt บอก ผลที่ได้คือ:

```
Ran maw hey codex-fanout:lead 'done — PR #1'
  └ error: no window 'lead' in session 'codex-fanout'
    hint: windows: codex-fanout:1 (codex-fanout), codex-fanout:2 (codex-1)
```

tmux ไม่รู้จัก role name เลย มันรู้จักแค่ index กับ window name เท่านั้น — session `codex-fanout` มีสอง window จริง ๆ คือ `1` (ชื่อ `codex-fanout`) กับ `2` (ชื่อ `codex-1`) ส่วน `lead` เป็นคำที่มีอยู่เฉพาะใน charter ไม่เคยแปลงเป็นชื่อ window เลยสักครั้ง

ระบบตั้งชื่อสองระบบ — charter role กับ tmux window — ดูเหมือนกันแต่ไม่ใช่สิ่งเดียวกัน แล้วก็ไม่มีอะไร sync ทั้งสองให้ตรงกันอัตโนมัติด้วย

## 8.3 การแก้ที่ตรงจุด แทนปล่อยให้ coder scan ทั้งฟลีต (context ของ coder มีค่า)

พอ error โผล่ขึ้นมา สิ่งที่ codex-1 ทำต่อคือ self-diagnose — เริ่ม `tmux list-windows -a` scan ทั้งฟลีต ไม่ใช่แค่ session ของตัวเอง

ฟังดูเหมือนความพยายามที่ดี แก้ปัญหาเองไม่รบกวนใคร แต่จริง ๆ แล้วนี่คือทางเลือกที่แพงที่สุดเท่าที่จะเลือกได้ coder แต่ละตัวมี context budget จำกัด การ list-windows ทั้งฟลีตหมายถึงต้อง parse ผลลัพธ์ของทุก session ทุก pane ในระบบ ทั้งที่คำตอบจริง ๆ อยู่ในบรรทัดเดียวของ error message ที่มันได้รับไปแล้ว — `hint: windows: codex-fanout:1 (codex-fanout), codex-fanout:2 (codex-1)`

ปล่อยให้มัน scan ต่อไปเรื่อย ๆ ก็คงหาคำตอบเจอเองในที่สุด แต่จะกินเวลาและ context ไปมากกว่าที่จำเป็นหลายเท่า ในเมื่อคนที่ dispatch งานรู้คำตอบอยู่แล้วตั้งแต่ต้น การปล่อยให้ coder เดาต่อจึงไม่ใช่ความเมตตา เป็นการสิ้นเปลือง resource ของมันเองต่างหาก จึง nudge ตรง ๆ แทนที่จะรอ:

```bash
maw hey codex-fanout:codex-1 'Your target is "codex-fanout:1", not "codex-fanout:lead".
Send: maw hey codex-fanout:1 "done — PR #1"
Rule: use `maw ls -v` or `tmux list-windows -t <session>` to find real targets —
charter role names are not guaranteed to equal tmux window names.'
```

ข้อความสั้น ให้ address ที่ถูกไปตรง ๆ พร้อมกฎทั่วไปติดท้ายไว้ด้วย — เผื่อ coder เจอสถานการณ์แบบนี้อีกในอนาคต จะได้ไม่ต้อง scan ทั้งฟลีตซ้ำอีกรอบ

นี่คือหลักการที่สำคัญที่สุดของบทนี้: เมื่อ lead รู้คำตอบอยู่แล้ว การแก้ที่ตรงจุดถูกกว่าการปล่อยให้ coder ไปหาเองเสมอ ยิ่งทีมมี coder หลายตัว ยิ่งต้องระวังเรื่องนี้ — context ของแต่ละตัวคือทรัพยากรที่ต้องประหยัด ไม่ใช่ปล่อยให้เผาไปกับปัญหาที่มีคำตอบอยู่แล้วในมือของอีกฝ่าย

## 8.4 PR #1 merged — ปิด loop สำเร็จ

codex-1 ตอบกลับภายในไม่กี่วินาทีหลัง nudge: **`[m5:codex-1] done — PR #1`**

loop ที่ทดสอบตั้งแต่ dispatch จนถึง report กลับ ตอนนี้ verified ครบวงจรแล้ว เหลือแค่ merge:

```bash
gh pr merge 1 --squash    # probe PR merged
```

PR #1 ปิดตัวสำเร็จ ปิด loop ทั้งเส้นของการทดลองนี้ — จาก charter ที่เขียนตาม contract v2 ผ่าน symlink workaround ของ blocker #658 มาจนถึง probe task ที่พิสูจน์ว่า dispatch, ทำงาน, และ report กลับ ทำงานจริงในระบบ

## ปิดบท

ปัญหาของบทนี้ไม่ใช่เรื่องใหญ่ — error message บรรทัดเดียว แก้ด้วยข้อความสองประโยค แต่ความเงียบของมันน่ากลัวกว่าความซับซ้อน ถ้า codex-1 ไม่ได้รายงาน error กลับมาให้เห็น หรือถ้าปล่อยให้มัน scan ทั้งฟลีตไปเรื่อย ๆ โดยไม่มีใคร nudge lead อาจไม่มีทางรู้เลยว่า probe สำเร็จจริงหรือค้างอยู่ที่ไหน — ระบบ multi-agent พังแบบเงียบ ๆ บ่อยกว่าที่คิด จนกว่าจะมีคน error กลับมาเตือนเท่านั้น

บทเรียนสรุปสั้น ๆ: role label ใน charter ไม่ใช่ address จริง เสมอต้องแปลงเป็น tmux target ก่อนบอก coder ให้ไปรายงาน และเมื่อ error เกิดขึ้น การแก้ตรงจุดจาก lead ที่รู้คำตอบอยู่แล้ว ประหยัดกว่าปล่อยให้ coder ไล่หาเองเสมอ

ทั้งเส้นทางนี้ — ตั้งแต่ blocker #658 ไปจนถึงที่อยู่ผิดของบทนี้ — ถูกพับเข้า skill `codex-lead` เก็บไว้แล้ว บทถัดไปจะพาไปดูว่า session ที่เต็มไปด้วยบทเรียนเหล่านี้ ถูกกลั่นให้กลายเป็น skill ที่ session ถัดไปหยิบมาใช้ได้ทันทีโดยไม่ต้องค้นพบซ้ำได้อย่างไร
