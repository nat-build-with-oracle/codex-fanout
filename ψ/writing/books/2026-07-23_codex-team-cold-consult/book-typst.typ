= บท​ที่ 1: ทำไม​ต้อง Codex Team
<บทท-1-ทำไมตอง-codex-team>
งานเขียน​โค้ด​ชิ้น​หนึ่ง ถ้า​ปล่อย​ให้ agent ตัว​เดียว​นั่ง​ทำ​คนเดียว มัน​ไม่​ใช่​แค่​ช้า ---
มัน​มี​เพดาน​ที่​ไป​ต่อ​ไม่​ได้​เลย​ต่างหาก พอ codebase ใหญ่​ขึ้น context window ก็​เริ่ม​ล้น พอ
task แยก​เป็น​หลาย​ส่วน​ที่​ไม่​เกี่ยว​กัน เวลา​ที่ agent ตัว​เดียว​ไล่​ทำ​ทีละ​อย่าง​ก็​บวก​กัน​เป็น​ชั่วโมง
นี่​คือ​จุด​ที่​หนังสือ​เล่ม​นี้​อยาก​พา​ไปดู ไม่​ใช่​ทฤษฎี​ลอยๆ แต่​เป็น​แนวคิด​ที่​มี​ของจริง​รองรับ

หนังสือ​เล่ม​นี้​แบ่ง​เป็น​สอง​ภาค ภาค​แรก (บท​ที่ 1-5) สังเคราะห์​บทเรียน​ที่​พิสูจน์​แล้ว​จาก
crew-master-oracle --- oracle ที่​รัน​การทดลอง multi-agent จริง​หลาย​รอบ วัดผล​จริง
แล้ว​บันทึก​ไว้​เป็น pattern ให้​คนอื่น​เอา​ไป​ใช้​ต่อ ภาค​สอง (บท​ที่ 6-10) เป็น case study
จาก session เดียว​จริงๆ ของ codex-fanout วันที่ 23 กรกฎาคม 2026 ที่ AI (Claude
Sonnet ตัว​เย็น ไม่​มี context มา​ก่อน​เลย) ถาม peer oracle ชื่อ maw-rs สดๆ เพื่อ
spawn codex coder หนึ่ง​ตัว แล้วก็​เจอ blocker จริง​สอง​อัน​ระหว่างทาง

บท​นี้​จะ​ตอบคำถาม​พื้นฐาน​ที่สุด​ก่อน --- ทำไม​ถึง​ต้อง​มี "ทีม" เลย ใน​เมื่อ agent
เดี่ยว​ก็​ทำงาน​ได้ คำตอบ​สั้น​ๆ คือ ปัญหา​บางอย่าง grind คนเดียว​ไม่​มี​วัน​จบ ต้อง multiply
ถึง​จะ​ชนะ

#line(length: 100%)

== 1.1 ปัญหา​ที่ solo agent แก้​ไม่​ได้
<ปญหาท-solo-agent-แกไมได>
Agent ตัว​เดียว​มี​ข้อจำกัด​สามชั้น​ที่​ซ้อน​กัน​อยู่ ชั้นแรก​คือ context --- ยิ่ง codebase ใหญ่
ยิ่ง​ต้อง​แบก state เยอะ​ใน​หัว​เดียว พอ​ถึง​จุด​หนึ่ง context ก็​ล้น​จน​ต้อง truncate
ทิ้ง​บางส่วน​ไป ซึ่ง​แปล​ว่า​คุณภาพ​งาน​ตกลง​โดยไม่รู้ตัว

ชั้น​ที่สอง​คือ​เวลา งาน​ที่​แยก​เป็น subtask อิสระ​กัน​ได้ ถ้า​ให้ agent เดียว​ไล่​ทำ​ทีละ​อย่าง
เวลา​ก็​บวก​กัน​แบบ​เชิงเส้น ทำ 3 ไฟล์​ที่​ไม่​เกี่ยว​กัน​เลย ก็​ต้อง​รอ 3 เท่า​ของ​เวลา​ทำ​ไฟล์​เดียว
ทั้งที่​จริงๆ แล้ว​สาม​ไฟล์​นี้​ทำ​พร้อมกัน​ได้​สบาย​ๆ

ชั้น​ที่สาม​คือ​ขอบเขต --- งาน​บางอย่าง​ต้องการ​มุมมอง​ที่​หลากหลาย ไม่​ใช่​แค่​ทำ​เร็ว​ขึ้น
แต่​ต้องการ​คนละ​มุม​จริงๆ อย่าง​งาน tournament ที่​อยากได้ output คุณภาพ​สูงสุด การ​ให้
agent ตัว​เดียว​ลอง​ครั้ง​เดียว​จบ ไม่​มีทาง​เทียบ​กับ​การ​ให้​หลาย​ตัว​ลอง​แล้ว​เลือก​ตัว​ที่​ดี​ที่สุด

ปัญหา​ทั้ง​สาม​ชั้นนี้​แก้​ด้วย​การ "ทำให้​เร็ว​ขึ้น" อย่าง​เดียว​ไม่​พอ
ต้อง​แก้​ด้วย​การ​แยก​งาน​ออก​ไป​ทำ​ขนาน​กัน​ต่างหาก --- นี่แหละ​คือ​จุด​ที่ solo agent หมด​มุข แล้ว
Codex Team เข้ามา​แทนที่

#line(length: 100%)

== 1.2 Codex Team คือ​อะไร --- lead กับ coder แยก worktree
<codex-team-คออะไร-lead-กบ-coder-แยก-worktree>
โครงสร้างพื้นฐาน​ของ Codex Team ไม่​ซับซ้อน มี agent ตัว​หนึ่ง​เป็น lead ทำหน้าที่​ตัดสินใจ
formation วางแผน dispatch งาน แล้วก็​มี coder หนึ่ง​ตัว​หรือ​หลาย​ตัว​ที่​รับงาน​ไป​ทำ​จริง
แต่ละ coder ทำงาน​ใน worktree ของ​ตัวเอง แยก​ออก​จากกัน​โดย​สมบูรณ์ ไม่​แตะ​ไฟล์​เดียวกัน
ไม่ต้อง lock อะไร​ที่​ซับซ้อน

ประเด็นสำคัญ​คือ worktree แยกกัน​นี่แหละ​ที่​ทำให้​ทีม​ทำงาน​ขนาน​ได้​จริง ถ้า coder
ทุก​ตัวเขียน​ลง​พื้นที่​เดียวกัน conflict จะ​เกิด​ทันที แต่​พอ​แยก worktree แล้ว
งาน​แต่ละ​ส่วน​ก็​เดินหน้า​ไป​พร้อมกัน​ได้​โดย​ไม่​ชน​กัน --- นี่​คือ​เงื่อนไข​ที่​ทำให้ "multiply"
เกิดขึ้น​ได้​จริง ไม่​ใช่​แค่​ทฤษฎี

lead เอง​ก็​ไม่​ได้​แค่​สั่งงาน​แล้ว​รอ​เฉย​ๆ ต้อง​มี pre-dispatch checklist
ก่อน​ปล่อย​งาน​ออก​ไป ต้อง​มี peek loop คอย​เช็ค​ว่า coder แต่ละ​ตัว​ไป​ถึง​ไหน​แล้ว
แล้วก็​ต้อง​รู้จัก pattern ที่​เหมาะกับ​งาน​ตรงหน้า --- Solo, Trio, Swarm, Tournament,
หรือ Scale บทเรียน​พวก​นี้​มาจาก crew-master-oracle จริงๆ ซึ่ง​บท​ถัดไป​ใน​บท​ที่ 6-10
ของ​หนังสือ​เล่ม​นี้ จะ​พา​ไปดู​ว่า​พอ​เอา pattern นี้​มา​ใช้​ใน session จริง​หนึ่ง​ครั้ง
มัน​เจอ​อะไร​บ้าง

#line(length: 100%)

== 1.3 บทเรียน​จาก "Round 3 collision event"
<บทเรยนจาก-round-3-collision-event>
นี่​คือ​บทเรียน​ที่​พิสูจน์​แล้ว​จาก crew-master-oracle --- แหล่งข้อมูล​ภายนอก ไม่​ใช่​จาก
session ของ​หนังสือ​เล่ม​นี้​เอง crew-master-oracle รัน​การทดลอง 4 รอบ​บวก​กับ scale
test หนึ่ง​ครั้ง วัดผล​จริง​ทุก​แกน (output volume, wall time, token spend,
conflict rate) แล้ว​บันทึก​ไว้​อย่าง​ตรงไปตรงมา รวมทั้ง​รอบ​ที่​พัง

รอบ​ที่ 3 คือ Swarm pattern --- coder สาม​ตัว ใช้ task list ร่วมกัน​โดย​ไม่​มี lock
ผล​คือ codex-1 กับ codex-3 ไป​หยิบ​งาน​เดียวกัน (`QUICK-START.md`)
พร้อมกัน​ใน​หน้าต่าง​เวลา​แค่ 1 วินาที ทั้งคู่​ทำงาน​จน​เสร็จ แต่​ต้อง​ทิ้ง​งาน​ของ​ตัว​หนึ่ง​ไป
เพราะ​ซ้ำ​กัน ความเสียหาย​ตรงนี้​คิด​เป็น​ราว 40% ของ token budget ทั้ง​รอบ

```
# Round 3 — collision event (reconstructed from logs)
[codex-1] 09:14:03  CLAIMED: QUICK-START.md
[codex-3] 09:14:04  CLAIMED: QUICK-START.md   ← 1-second race window
[codex-2] 09:14:03  CLAIMED: CONTRIBUTING.md
[codex-1] 09:21:17  DONE: QUICK-START.md (accepted)
[codex-3] 09:21:44  DONE: QUICK-START.md (discarded — duplicate)
```

ทางแก้​ไม่​ได้​ซับซ้อน​อะไร​เลย แค่​สี่​บรรทัด shell ที่​ใช้ atomic `mv` เป็น​กลไก claim งาน:

```bash
# dispatch.sh — atomic claim pattern (post-fix)
claim_task() {
  local task="$1"
  local claimed="$TASK_DIR/claimed"
  mkdir -p "$claimed"
  # mv is atomic on POSIX local filesystems
  mv "$TASK_DIR/available/$task" "$claimed/$task" 2>/dev/null
}
```

สี่​บรรทัด​นี้​แก้ปัญหา​ได้ แต่​สิ่ง​ที่​แพง​กว่า​คือ​ต้นทุน​ของ​การ​ไม่​รู้​ล่วงหน้า​ว่า​ปัญหา​นี้​มี​อยู่ ---
และ​นี่แหละ​คือ​สิ่ง​ที่ Round 3 สอน ไม่​ใช่​แค่ "ใช้ atomic mv" แต่​คือ
ประสานงาน​ที่​ไม่​ดี​มี​ต้นทุน​จริง วัด​ได้​จริง เป็น token 40% ของ​รอบ​นั้น​เลย ทีม​ที่ multiply
ได้​จริง ต้อง​จ่าย​ค่า​ประสานงาน​ให้​ถูก ไม่​ใช่​แค่​จ่าย​ให้​น้อยที่สุด --- เพราะ​ถ้า​ไม่​มี
coordination เลย ต้นทุน​จาก​การชน​กัน​จะ​แพง​กว่า​หลายเท่า

#line(length: 100%)

== 1.4 ผู้​ร่วม​สร้าง​มาตรฐาน --- สี่ oracle ที่ contribute pattern นี้
<ผรวมสรางมาตรฐาน-ส-oracle-ท-contribute-pattern-น>
crew-master-oracle ไม่​ได้​สร้าง pattern พวก​นี้​คนเดียว มัน​ปรึกษา oracle
เฉพาะทาง​สี่​ตัว​ตลอด​การทดลอง แต่ละ​ตัว​มี​ความ​เชี่ยวชาญ​ที่​ต่างกัน​ชัดเจน

#strong[ting] ดูแล​เรื่อง pre-dispatch checklist เคย​คุม​งาน multi-agent มา​แล้ว
7 sessions ผลิต PR ได้ 20 กว่า​อัน หลักการ​ของ ting ตรงไปตรงมา ---
"คุณ​แก้​กลางอากาศ​ไม่​ได้ ถ้า​คุณ​ไม่​เช็ค​ตั้งแต่​อยู่​บน​พื้นดิน" checklist ของ ting ครอบคลุม​ตั้งแต่
isolated CODEX\_HOME ไป​จนถึง atomic claim mechanism

#strong[tee] จับ​เรื่อง false negative --- ช่องว่าง​ระหว่าง "agent บอ​กว่า​เสร็จ" กับ
"งาน​เสร็จ​จริง" คำแนะนำ​หลัก​ของ tee คือ "exit code ที่​ผ่าน ไม่​ใช่ review ที่​ผ่าน ต้อง
peek ก่อน​จะ re-dispatch" ทุกครั้ง

#strong[maw-rs] ดูแล​เรื่อง scale กับ rate-limit เคย​รัน​ทีม 10 coder พร้อมกัน
แล้วก็​บันทึก envelope ของ rate limit ไว้​ชัด --- 5 keys ไม่​ได้​แปล​ว่า throughput
ไม่​มี​เพดาน ต้อง​รู้​เพดาน​ก่อน​จะ​ชน​มัน maw-rs ยัง​เป็น​คน​ที่ session
ใน​ภาค​สอง​ของ​หนังสือ​เล่ม​นี้​ปรึกษา​โดยตรง​ด้วย

#strong[transcriber] ดูแล​เรื่อง sync-before-dispatch ข้อ​ค้นพบ​หลัก​คือ agent ที่
dispatch ออก​ไป​โดย​ไม่ sync กับ oracle context ก่อน จะ​ตัดสินใจ​จาก pattern เก่า
แล้วก็​ไป​เจอ​ปัญหา​ที่​แก้​ไป​แล้ว​ซ้ำ​อี​กรอบ --- Round 3 เอง​ก็​เป็น​ตัวอย่าง เพราะ​สอง agent
ไป​ค้นพบ​ปัญหา collision ที่ oracle memory มี​คำตอบ​อยู่แล้ว เสียเวลา​ไป​ราว 40 นาที​กับ
token 600k โดยไม่จำเป็น

สี่ oracle นี้​ไม่​ได้​แค่​ให้​คำแนะนำ​ลอยๆ --- แต่ละคน​สร้าง mechanism ที่​ฝัง​อยู่​ใน pipeline
จริง ทั้ง preflight, peek, key rotation, sync step ทุกอย่าง​มาจาก consultation
ที่​เกิดขึ้น​จริง​ระหว่าง​การทดลอง

#line(length: 100%)

ทั้ง​สี่ subtopic ใน​บท​นี้​พา​ไป​ถึง​คำตอบ​เดียวกัน --- ทีม​ชนะ solo agent
ตอนที่​งาน​ขนาน​ได้​จริง แต่ "ขนาน​ได้​จริง" ไม่​ได้​แปล​ว่า​ปล่อย​ให้​ต่าง​คน​ต่าง​ทำ ต้อง​มี worktree
แยก ต้อง​มี checklist ก่อน dispatch ต้อง​มี peek หลัง dispatch แล้วก็​ต้อง​รู้​ว่า
pattern ไหน​เหมาะกับ​งาน​แบบ​ไหน Round 3 collision event สอน​ไว้​ชัด​ว่า
ต้นทุน​ของ​การ​ไม่​ประสานงาน แพง​กว่า​ต้นทุน​ของ​การประสานงาน​เสมอ

คำถาม​ที่​ยัง​ไม่​มี​คำตอบ​ใน​บท​นี้​คือ แล้ว​ในทางปฏิบัติ lead ต้อง​เขียน charter
อย่างไร​ถึง​จะ​สั่งงาน​ให้ coder ตัว​หนึ่ง​เข้าใจ​ตรง​กับ​ที่​ตั้งใจ --- charter ที่​เขียน​ดี​กับ​เขียน​แย่
ต่างกัน​ตรงไหน นี่​คือ​สิ่ง​ที่​บท​ที่ 2 จะ​ผ่า​ดู​ละเอียด: กายวิภาค​ของ Charter

= บท​ที่ 2: กายวิภาค​ของ Charter
<บทท-2-กายวภาคของ-charter>
Charter หนึ่ง​ไฟล์ ตัดสิน​ได้​ว่า​ทีม​จะ​เกิด​หรือ​ทีม​จะ​ตาย ไม่​ใช่​คำพูด​เกิน​จริง --- ก่อน
`maw team up` จะ​รัน​แม้แต่​บรรทัด​เดียว charter ต้อง​ถูก parse ผ่าน preflight ก่อน
และ​ถ้า field ไหน​หาย​หรือ​ผิด​ตำแหน่ง ทีม​ทั้ง​ทีม​จะ​ไม่​มี​วัน​ขึ้น​มา

ใน​ภาค 1 บท​ที่ 2 ของ crew-master-oracle วาง​กายวิภาค​ไว้​ชัด​แล้ว ---
หก​คีย์​หลัก​ระดับ​บนสุด (`name`, `project`, `session`, `engines`, `members`, และ
implicit `lifecycle`) แต่ละ​คีย์​มี​หน้าที่​ของ​ตัวเอง ไม่ overlap กัน บท​นั้น​เตือน​ไว้​ว่า
name/path trap ฆ่า​ทีม​ได้​มากกว่า bug ไหน​ๆ ใน​โค้ด

บท​นี้​เอา charter จริง​จาก session codex-fanout วันที่ 2026-07-23 มา​ผ่าตัด​ดู ไฟล์
`ψ/teams/codex-fanout-team.yaml` ที่​ใช้งาน​จริง​ใน​บท​ที่ 1 มี field ครบ​ตาม​ทฤษฎี
แต่​ก็​มี twist ที่​ทฤษฎี​จาก​ภาค 1 ไม่​ได้​ครอบคลุม​ไว้​ทั้งหมด --- โดยเฉพาะ v2 contract ที่​ตัด
`defaults.worktree` block หาย​ไป​เลย แล้วก็ field เดียว​ที่​ทำให้ lead กับ coder
เป็น​คนละ​สายพันธุ์​กัน: `worktree: false`

นี่​คือ charter ทั้ง​ไฟล์ ใช้​เป็น reference ตลอด​บท

```yaml
name: codex-fanout-team
project: nat-build-with-oracle/codex-fanout
session: codex-fanout

goal: |
  Lead (Claude) dispatches tasks to a single codex coder in an isolated worktree.
  Coder owns the loop to done-criteria. PR -> alpha only, never main.

engines:
  omx-5: "bun $HOME/.claude/skills/oracle-team/scripts/codex-setup.ts 5 && CODEX_HOME=$PWD/.codex OMX_AUTO_UPDATE=0 omx --direct --madmax"

members:
  - role: lead
    name: codex-fanout
    engine: claude
    worktree: false
    branch: alpha
    prompt: |
      Lead orchestrator. NEVER write code yourself.
      ...

  - role: codex-1
    name: codex-1
    engine: omx-5
    worktree: agents/codex-1
    branch: agents/codex-1
    prompt: |
      Coder. WAIT for task via maw hey.
      ...

lifecycle:
  worktree: true
  merge_on_shutdown: false
```

สี่ subtopic ต่อไปนี้​ผ่า​ไฟล์​นี้​ทีละ​ชั้น เทียบ​กับ pattern เดิม​จาก​ภาค 1 ตลอดทาง

== 2.1 name / project / session --- สาม​ฟิลด์​ที่​พัง​ทีม​ได้​ถ้า​หาย
<name-project-session-สามฟลดทพงทมไดถาหาย>
`name: codex-fanout-team` คือ identifier ที่ `maw team up` และ
`maw team down` ใช้​ค้นหา​ทีม ส่วน `maw team preflight` รับ path ของ​ไฟล์ ไม่​ใช่
name --- asymmetry นี้​ตรง​กับ​ที่ 02-architecture.md ย้ำ​ไว้​ตั้ง​แต่ต้น: preflight
อ่าน​ไฟล์ ส่วน up/down ทำงาน​กับ​ทีม​ที่​รัน​อยู่แล้ว​โดย​อ้าง​ชื่อ สลับ​สอง​อย่างนี้​คือ trap
อันดับ​หนึ่ง​ที่​คน​ตั้ง​ทีม​ใหม่​ชน​บ่อย​สุด

`project: nat-build-with-oracle/codex-fanout` วาง​เป็น org/repo แบบ
relative ไม่​ใช่ absolute path แบบ​ตัวอย่าง​ใน​ภาค 1
(`/opt/Code/github.com/acme/backend`) --- นี่​คือ​จุด​ที่ charter จริง​ต่าง​จาก
pattern เดิม​ชัด​ที่สุด ทุก worktree ของ​ทีม​นี้ resolve จาก path นี้ ถ้า path
ไม่​มี​อยู่​จริง​ตอน `up` spawn sequence จะ abort ตั้งแต่ preflight ทันที

`session: codex-fanout` ใน​ไฟล์​จริง​เป็น string ธรรมดา ไม่​ใช่ ISO-8601
timestamp แบบ​ที่ 02-architecture.md ใช้​เป็น​ตัวอย่าง (`2026-06-18T09:00:00Z`)
--- session ทำหน้าที่​เป็น routing key สำหรับ `maw hey` และ log namespacing
แต่​ไฟล์​จริง​เลือก​ใช้ session name ที่​คงที่​แทน timestamp ที่​เปลี่ยน​ทุ​กรัน สาม​ฟิลด์​นี้​ดูเหมือน​แค่
metadata แต่​หาย​ฟิลด์​ไหน​ไป ทีม​ไม่​มี​วัน​ขึ้น

== 2.2 engine resolution --- charter engines block ชนะ config เสมอ
<engine-resolution-charter-engines-block-ชนะ-config-เสมอ>
Resolution chain ตาม​ภาค 1 มี​สี่​ชั้น เรียง​จาก member's `engine` field ใน​ไฟล์ ไป​ที่
`engines` block ของ charter ไป​ที่ `maw config commands` แล้ว​ค่อย fallback
แบบ hard-coded --- v26.6.14 เคย​พัง​ตรง lookup ของ engines block เอง alias
สั้น​ๆ อย่าง `fast` ถูก​ส่ง​ตรง​เข้า API เป็น model identifier แทนที่จะ resolve ผ่าน
block ก่อน ทีม​ดูเหมือน​ขึ้น​สำเร็จ (tmux window เปิด process start) แต่ coder error
แล้ว​ออก​ทันที

charter ของ codex-fanout เลี่ยง​ปัญหา​นี้​ทั้งหมด​ด้วย​การ​ไม่​ใช้ alias สั้น​เลย engines
block มี​แค่​ตัว​เดียว​คือ `omx-5` ที่​ผูก​กับ shell command เต็ม​รูปแบบ --- ไม่​ใช่​แค่ model
name แต่​เป็น​ทั้ง bootstrap chain: เรียก `codex-setup.ts` ก่อน ตั้ง `CODEX_HOME`
ตั้ง `OMX_AUTO_UPDATE=0` แล้ว​ค่อย exec `omx --direct --madmax` เข้าไป field
`engine: omx-5` ใน​สมาชิก codex-1 ก็​ชี้​ตรง​มา​ที่ key นี้ ไม่​มี​ชั้น alias คั่น​กลาง​ให้​พัง​ซ้ำ

ส่วน lead ใช้ `engine: claude` ตรงๆ ไม่​ผ่าน engines block เลย เพราะ `claude`
เป็น engine ที่ maw รู้จัก​อยู่แล้ว​ใน​ระดับ config global สอง​แนวทาง​นี้​อยู่​ใน​ไฟล์​เดียวกัน​ได้
--- coder ใช้ engines block เพราะ​ต้อง bootstrap ซับซ้อน ส่วน lead ใช้
fully-qualified name ตรง​ตามคำแนะนำ​ของ​ภาค 1 ที่​ให้​เลี่ยง alias lookup
เมื่อ​ไม่​แน่ใจ​เวอร์ชัน maw

== 2.3 v1 vs v2 contract --- defaults.worktree หาย​ไป​ยังไง
<v1-vs-v2-contract-defaults.worktree-หายไปยงไง>
pattern จาก​ภาค 1 ไม่​มี top-level `lifecycle` block เลย --- charter
ตัวอย่าง​จบ​ที่ `members` list สมาชิก​แต่ละคน​มี `branch` field เดี่ยว​ๆ ไม่​มี field ชื่อ
`worktree` แยก​ออกมา​ต่างหาก นั่น​คือ contract แบบ v1 ที่​สมมติ​ว่า​ทุก member ต้อง​มี
worktree เสมอ ไม่ต้อง​ประกาศ​ชัด

charter ของ codex-fanout เป็น contract คนละ​แบบ มี
`lifecycle: { worktree: true, merge_on_shutdown: false }` อยู่​ท้าย​ไฟล์
และ​ใน​แต่ละ member ก็​มี `worktree` field ของ​ตัวเอง​แยกจาก `branch` --- v2
contract นี้​ไม่​มี `defaults.worktree` เป็น block กลาง​ให้ inherit ทุก member
ต้อง​ประกาศ `worktree` เอง​ตรงๆ ใน​ระดับ member ไม่​ใช่​ปล่อย​ให้ lifecycle block
เป็น​ตัวกำหนด default แทน

ตรง​นี้แหละ​ที่​คอมเมนต์​บนสุด​ของ​ไฟล์​เตือน​ไว้​เป็นพิเศษ --- bug maw-rs \#658 ทำให้
`worktree:`/`branch:` path ของ​สมาชิก​คน​สุดท้าย​ใน​ไฟล์​โดน​ตัด prefix `agents/`
ออก​ตอน preflight กับ team up (canonicalize fail) เพราะ codex-1
เป็น​คน​สุดท้าย​ใน​ไฟล์​นี้ ทีมงาน​เลย​ต้อง​สร้าง symlink `codex-1 -> agents/codex-1` ไว้​ที่
root ของ repo เป็น​ทางแก้​ชั่วคราว จนกว่า \#658 จะ ship ถ้า​ไม่​อยาก​พึ่ง symlink
ก็​แค่​ย้าย lead ให้​เป็นสมาชิก​คน​สุดท้าย​แทน --- proof ตรงๆ ว่า v2 contract ยังมี edge
case ที่ v1 ไม่​เคย​เจอ เพราะ v1 ไม่​มี per-member worktree path ให้ bug
แบบนี้​เกิด​ได้​ตั้ง​แต่ต้น

== 2.4 lead vs coder --- worktree:false คือ​สิ่ง​ที่​แยก​สอง​บทบาท
<lead-vs-coder-worktreefalse-คอสงทแยกสองบทบาท>
field เดียว​ที่​ทำให้ lead กับ coder เป็น​คนละ​บทบาท​กัน​จริงๆ ใน​ไฟล์​นี้​ไม่​ใช่ `role` แต่​เป็น
`worktree` --- lead มี `worktree: false` ส่วน codex-1 มี
`worktree: agents/codex-1` เป็น path จริง

`role: lead` เขียน​ไว้​ก็​จริง แต่ `role` แค่​บอก label สำหรับ prompt กับ log
ไม่​ได้​ผูก​กับ behavior อัตโนมัติ behavior จริง​ที่​แยก lead ออกจาก coder คือ
`worktree: false` --- lead ทำงาน​อยู่​บน checkout หลัก​ของ repo ตรงๆ ไม่​มี
worktree แยก ส่วน branch ของ lead คือ `alpha` ซึ่ง​เป็น​เป้าหมาย​ของ​ทุก PR ตาม
goal ที่​เขียน​ไว้​บนสุด (`PR -> alpha only, never main`)

ทำไม​ต้อง​แยก​แบบนี้ เพราะ lead มี​หน้าที่ merge --- prompt ของ lead เขียน​ชัด​ว่า "Lead
orchestrator. NEVER write code yourself" และ "Merge is the lead's job"
ถ้า lead มี worktree แยก​ของ​ตัวเอง การ merge PR จาก coder เข้า alpha จะ​ต้อง​สลับ
context ไปมา​ระหว่าง worktree สอง​ที่ ในขณะที่ coder ต้อง​แยก worktree เพราะ​ต้อง
"implement MINIMAL precise code" โดย​ไม่​ชน​กับ​ใคร --- ตรง​ตาม worktree
isolation principle จาก​ภาค 1 ที่​บอ​กว่า​หน่วย​แยก parallel work ที่​แท้จริง​คือ git
worktree ไม่​ใช่ process

`worktree: false` จึง​ไม่​ใช่​แค่ optional flag ที่​ปิด​ไว้​เฉย​ๆ แต่​เป็น​ตัวกำหนด role
ทาง​สถาปัตยกรรม​จริงๆ lead คือ​คนเดียว​ที่​แตะ checkout หลัก ส่วน​ใคร​มี worktree เป็น
path จริง คน​นั้น​คือ coder ที่​ต้อง​ทำงาน​แยกตัว ห้าม​แตะ checkout ของ lead หรือ
worktree ของ​คนอื่น​เด็ดขาด ตามที่ prompt ของ codex-1 กำกับ​ไว้​ตรงๆ ว่า "Never
touch lead's checkout or other worktrees"

#line(length: 100%)

Charter หนึ่ง​ไฟล์​ผ่าตัด​ออกมา​แล้ว​เห็นชัด​ว่า​ไม่​มี field ไหน "แค่ metadata" จริงๆ เลย
--- `name` ผิดที่​ก็​หา​ทีม​ไม่​เจอ `project` เขียน relative ผิด​จุด​ก็ resolve worktree
พลาด `engines` alias ผิด​ชั้น​ก็​ตาย​เงียบ​ตั้งแต่ boot และ `worktree` ที่​ดูเหมือน flag
เล็ก​ๆ กลับ​เป็นตัว​ตัดสิน​ว่า​ใคร​ทำหน้าที่​อะไร​ใน​ทีม

v2 contract ที่​ตัด `defaults.worktree` ออก​ไป​แลก​มา​ด้วย​ความ​ชัดเจน​ต่อ member
แต่​ก็​แลก​มา​ด้วย bug อย่าง \#658 ที่​ยัง​ไม่ ship fix เต็ม​รูปแบบ --- นี่​คือ​รา​คาที่​ต้อง​จ่าย​เมื่อ
contract เปลี่ยน​รุ่น​เร็ว​กว่า tooling จะ​ตามทัน

แต่ charter ที่​ถูกต้อง​ทุก field ยัง​ไม่​พอ​จะ​ทำให้​ทีม​ขึ้น​มา​ได้​จริง ---
ไฟล์​บน​ดิสก์​เป็น​แค่​พิมพ์เขียว การ​เดินทาง​จาก `maw team preflight` ไป​จนถึง
`maw team up` ที่​ใช้งาน​ได้​จริง ต้อง​ผ่าน symlink workaround, canonicalize fail,
และ boot pitfall อีก​หลาย​จุด​ที่ 02-architecture.md เขียน​เป็น​ทฤษฎี​ไว้ แต่ session
จริง​ของ codex-fanout เจอ​มา​คนละ​แบบ --- บท​ที่ 3 จะ​ตามรอย​การ​เดินทาง​นั้น​ทีละ​ก้าว

= บท​ที่ 3: การ​เดินทาง​ของ Setup
<บทท-3-การเดนทางของ-setup>
repo ว่างเปล่า​ไม่​ได้​แปล​ว่า​พร้อม --- ประโยค​นี้​ฟัง​ดูเหมือน​เรื่อง​เบสิก​ที่​ไม่​น่า​ต้อง​พูด แต่​พอ
codex-fanout session เจอ​เข้ากับ​ตัวเอง ถึง​รู้​ว่า​มัน​คือ​บล็อกเกอร์​จริง​ที่​รอ​ทุก​ทีม​อยู่ ก่อน​จะ​มี
coder สัก​ตัวเขียน​โค้ด​ได้ ต้อง​มี worktree ก่อน ก่อน​จะ​มี worktree ต้อง​มี branch บน
remote ก่อน ก่อน​จะ​มี branch บน remote ต้อง​มี commit สัก​ตัว​หนึ่ง --- chain
ทั้งหมด​นี้​พัง​ได้​ตั้งแต่​ข้อ​แรก​สุด และ​มัน​มักจะ​พัง​เงียบๆ ด้วย

บท​นี้​เดินตาม 4 หัวข้อ เริ่ม​จาก Trust Prerequisite ที่​ทำให้ coder
ทำงาน​ได้​จริง​ไม่​ใช่​แค่​ดูเหมือน​ทำงาน ต่อ​ด้วย 5-Phase Protocol ที่​กลั่น​จาก 22
ขั้นตอน​ภาคสนาม​ของ Ting เหลือ​แค่ 5 gate ที่​ต้อง​ผ่าน​ตามลำดับ
จากนั้น​ลง​ลึก​ที่​บล็อกเกอร์​ตัวจริง​จาก session 2026-07-23 --- repo ที่​ไม่​มี commit
สัก​บรรทัด​เดียว พร้อม error message ตัว​เป็น​ๆ ที่​ยืนยัน​ปัญหา ปิดท้าย​ด้วย​เรื่อง
pool/account contention ที่เกิด​ตอน​สอง​ทีม​ใช้​บัญชี​เดียวกัน​พร้อมกัน

ภาค 1 สอน​ว่า trust config คือ prerequisite ที่​มองไม่เห็น​จนกว่า​จะ​พัง
บท​นี้​เพิ่ม​อีก​ชั้นหนึ่ง --- repo เอง​ก็​เป็น prerequisite ที่​มองไม่เห็น​เหมือนกัน มัน​ดู​มี​อยู่แล้ว
(`git status` รัน​ได้ ไฟล์​อยู่​ครบ) แต่​ถ้า​ไม่​มี commit สัก​ตัว worktree ก็​ผูก​กิ่ง​ไม่​ได้
ทุกอย่าง​ที่​ดูเหมือน​พร้อม​กลับ​กลายเป็น​ภาพลวงตา

#line(length: 100%)

== 3.1 Trust Prerequisite --- ทำไม codex ค้าง​ที่ prompt ถ้า​ไม่ pre-seed
<trust-prerequisite-ทำไม-codex-คางท-prompt-ถาไม-pre-seed>
`CODEX_HOME` ทุก​ตัว​ต้อง​มี `config.toml` พร้อม `trust_level = "trusted"`
ก่อน​จะ​สั่ง spawn อะไร​ทั้งนั้น ไม่​ใช่ default ไม่​ใช่ optional เพราะ​ถ้า​ไม่​มี codex
จะ​รัน​ใน​โหมด sandbox --- อ่าน​ไฟล์​ได้ วิเคราะห์​ได้ แต่​เขียน​ไม่​ได้​เงียบๆ coder ที่​ขาด
trust จะ​ดูเหมือน active ใช้ token ไป​เรื่อยๆ แต่​ผลลัพธ์​คือ​ศูนย์

crew-master-oracle เจอ​เรื่อง​นี้​ตอน Round 3 Swarm --- สอง coder
เลือก​ไฟล์​เดียวกัน​โดย​ไม่​เขียน​อะไร​ลง disk เลย​สัก​ไบต์ ต้นตอ​ไม่​ใช่​การชน​กัน​ของ task แต่​เป็น
`~/.codex-team/1` ที่​ถูก​รีเซ็ต​ระหว่าง cleanup โดย​ไม่​มี​ใคร​สังเกต #strong[coder
ที่​ไม่​มี trust จะ​เขียน​อะไร​ไม่​ได้​และ​ไม่​บอก​ด้วยว่า​มี​อะไร​ผิด] ต้อง verify ก่อน​เสมอ

```bash
grep trust_level "$CODEX_HOME/config.toml"
# ต้องได้: trust_level = "trusted"
```

ฝั่ง codex-fanout session ไป​ไกล​กว่า​นั้น​อีก​ขั้น --- pre-seed trust เข้าไป​ตรงๆ ก่อน
spawn เลย แทนที่จะ​รอ​เช็ค​ทีหลัง​แล้ว​ค่อย​แก้:

```bash
printf '\n[projects."%s"]\ntrust_level="trusted"\n' "$PWD" >> .codex/config.toml
```

ขั้น​ตอนนี้​มาจาก​คำแนะนำ​ของ maw-rs ตอน​ถูก​ถาม​สดๆ ว่า "gotcha สำหรับ fresh worktree
มี​อะไร​บ้าง" --- คำตอบ​คือ pre-seed ก่อน​เลย อย่า​รอ​ให้ preflight ไป​เจอ​เอง
เพราะ​ถ้า​เจอ​ตอนนั้น​แปล​ว่า worktree ตัว​นั้น​ยัง​ไม่​พร้อม ต้อง full stop

#line(length: 100%)

== 3.2 5-Phase Protocol (repo prep → verify → spawn one → probe → scale)
<phase-protocol-repo-prep-verify-spawn-one-probe-scale>
Ting เคย​มี checklist 22 ขั้นตอน​กระจาย​อยู่ 4 หน้า field notes จาก 7 coder กว่า
20 PR โครงสร้าง​ที่​กลั่น​ออกมา​เหลือ 5 phase --- #strong[Repo Prep → Verify →
Spawn One → Probe → Scale] --- แต่ละ phase มี go/no-go gate ของ​ตัวเอง ถ้า
gate ไหน​ไม่​ผ่าน ห้าม​เดิน​ต่อ

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Phase], [ชื่อ], [เงื่อนไข​ผ่าน],),
    table.hline(),
    [1], [Repo Prep], [มี remote branch, worktree สะอาด],
    [2], [Verify], [`preflight.sh` exit 0, worktree list ตรง​ตามที่​คาด],
    [3], [Spawn One], [coder ตัว​เดียว​รัน​อยู่, `maw peek` เห็น​ว่า active],
    [4], [Probe], [loop เต็ม​พิสูจน์​แล้ว: dispatch → code → push → PR →
    merge],
    [5], [Scale], [coder ที่​เหลือ spawn บน task ที่​ไม่​ทับกัน],
  )]
  , kind: table
  )

#strong[ห้าม​รัน Phase 5 ก่อน Phase 4 เสร็จ] --- นี่​คือ​ความผิดพลาด​ที่​พบ​บ่อย​ที่สุด​ใน
multi-coder deployment ทีม​ที่​รีบ spawn ทั้ง​สาม​ตัว​พร้อมกัน​มักจะ​ไป​ชน​กันที่ role
เดียวกัน​ตอน Phase 4 (อย่าง​กรณี `QUICK-START.md` ถูก​มอบหมาย​ให้​สอง​คน)
แล้ว​ต้อง​เสียเวลา 20 นาที​คลี่ merge ที่​ไม่​มี​วันเกิด​ถ้า loop แรก​ถูก​พิสูจน์​ก่อน

session codex-fanout เดินตาม logic เดียวกัน​นี้ แม้​จะ​ไม่​ได้​เรียกชื่อ phase ตรงๆ ก็ตาม
--- ขั้นตอน​จาก maw-rs ระบุ​ชัด​ว่า "SPAWN ONE FIRST (the golden rule)"
พร้อม​ลำดับ: `git worktree add` → cd → setup script → pre-seed trust →
`maw team load --no-spawn` → `maw team up --only <role>` แล้ว​ค่อย verify
boot ด้วย `maw peek` ว่า​เห็น engine UI จริง ไม่​ใช่​แค่ shell หรือ trust prompt
ค้าง​อยู่ ก่อน​จะ​ขยับ​ไป dispatch task จริง

Phase 4 ใน​เคส​นี้​คือ probe task ง่ายๆ --- สร้าง `NOTES.md`, commit, push, เปิด
PR แล้ว​รายงาน​กลับ codex-1 ทำ​ครบ​ทุก​ขั้นตอน แค่​ตอน​รายงาน​กลับ​ดัน​ส่ง​ผิดที่
(เดี๋ยว​จะ​เล่า​ใน​บท​ที่ 4) แต่ loop หลัก​คือ dispatch → code → push → PR → merge
ผ่าน​ครบ พิสูจน์​ว่า environment พร้อม​ก่อน​จะ​ไป​คิด​เรื่อง scale

#line(length: 100%)

== 3.3 บล็อกเกอร์​จริง --- repo ว่างเปล่า ไม่​มี commit ไม่​มี origin
<บลอกเกอรจรง-repo-วางเปลา-ไมม-commit-ไมม-origin>
นี่​คือ​จุด​ที่​ทฤษฎี​ชน​กับ​ของจริง --- codex-fanout เป็น repo ที่​เพิ่ง​สร้าง​ใหม่ ไม่​มี commit
สัก​ตัว​เดียว พอ​ลอง `git worktree add` ปุ๊บ พัง​ทันที เพราะ `HEAD` ยัง unborn อยู่
ผูก​กิ่ง​อะไร​ไม่​ได้​เลย

```
$ git log --oneline -1
fatal: your current branch 'main' does not have any commits yet
$ git ls-remote origin
(nothing)
```

error message นี้​ตรงตัว --- ไม่​มี commit แปล​ว่า​ไม่​มี​จุด​อ้างอิง​ให้ worktree
แตก​กิ่ง​ออก​ไป และ coder เอง​ก็​ต้อง​มี content บน `origin` ให้ push กลับ​ไป​ทับ เปิด PR
ได้ ถ้า origin ว่างเปล่า​เหมือนกัน push ก็​ไม่​มี​เป้าหมาย

ทางแก้​ตรงไปตรงมา --- สร้าง `README.md` ขั้นต่ำ commit push ขึ้น `origin main`
แล้ว​สร้าง​พร้อม push branch `alpha` (เป้าหมาย​ของ PR ตาม convention "PR →
alpha only, never main"):

```bash
git add . && git commit -m "chore: initial scaffold"
git push -u origin main
git checkout -b alpha
git push -u origin alpha
```

Gate 1 ของ Phase Repo Prep คือ `git branch -r | grep alpha` ต้อง exit 0
ตอนนี้​ผ่าน​แล้ว ประเด็นสำคัญ​คือ empty repo ไม่​ได้ error ให้​เห็น​ตอน​วางแผน
มัน​จะ​โผล่​มา​ตอน `git worktree add` พัง​เท่านั้น --- เป็น prerequisite
ที่​มองไม่เห็น​จนกว่า​จะ​พัง ตรง​กับ dna ของ​บท​นี้​เป๊ะ​ๆ

แล้ว​ทำไม​ไม่​ตรวจ​ตั้งแต่แรก​ล่ะ? เพราะ repo ที่​มี​ไฟล์​อยู่​ครบ `git status` รัน​ผ่าน ดู​เผินๆ
เหมือน​พร้อม​ทุกอย่าง แต่ commit history คือ​สิ่ง​ที่​ต้อง​เช็ค​แยก​ต่างหาก ไม่​ใช่​แค่​ไฟล์​บน disk

#line(length: 100%)

== 3.4 pool/account contention --- บัญชี​เดียวกัน ขีดจำกัด​เดียวกัน
<poolaccount-contention-บญชเดยวกน-ขดจำกดเดยวกน>
ก่อน​จะ​แตะ pool 5 session codex-fanout เช็ค​ก่อน​ว่า​ใช้ได้​จริง​ไหม:

```bash
ls ~/.codex-team/5/auth.json   # exists — pool 5 auth ไว้แล้ว
```

pool 5 auth ไว้​แล้วก็​จริง แต่​ปัญหา​คือ maw-rs เอง​ก็​กำลัง​รัน 4 coder อยู่​บน pool
1/2/5/6 พร้อมกัน --- pool 5 เฉพาะเจาะจง​ถูก​ใช้​อยู่​โดย coder ชื่อ `infra` ของ
maw-rs สถานการณ์​นี้​ต้อง​ส่ง​แผน​กลับ​ไป​ให้ maw-rs ดูก่อน​แตะ​อะไร​ทั้งนั้น
เพราะ​การ​แชร์​บัญชี​เดียวกัน​มีผลกระทบ​ข้าม​ทีม ไม่​ใช่​แค่​ใน​ทีม​ตัวเอง

maw-rs ยืนยัน​ว่า​ใช้​ร่วมกัน​ได้ --- #strong[shared credential, shared rate limit
แต่​แต่ละ coder มี worktree-local `CODEX_HOME` แยกกัน] (SQLite/lock
แยกกัน​คนละ​ชุด) contention ที่จะ​เกิด​คือ rate-limit ทำให้​ช้า​ลง ไม่​ใช่ hard conflict
และ​รับได้​สำหรับ coder เบา​ๆ ตัว​เดียว ส่วน pool 3/4/7 ที่ dedicated ไว้​กลับ​ยัง​ไม่ auth
--- ต้อง manual `codex login` ซึ่ง​อยู่​นอก scope ของ "fast" ไป​เลย เลย​เลือก pool
5 ตามเดิม

จุด​นี้​ต่าง​จาก trap \#2 ใน​ภาค 1 (shared CODEX\_HOME ทำให้ SQLite lock ชน จน​พัง
12% ของ agent) ตรง​ที่​ประเด็น​ใน​ภาค 2 ไม่​ใช่ CODEX\_HOME ที่​แชร์​กัน --- เพราะ​แต่ละ
coder แยก worktree-local CODEX\_HOME กัน​อยู่แล้ว แต่​เป็น#strong[บัญชี] ที่​แชร์​กัน
ผล​คือ rate limit ไม่​ใช่ lock contention คนละชั้น​ของ​ปัญหา แม้​จะ​ฟัง​ดู​คล้าย​กัน​ตอนแรก

#line(length: 100%)

setup ที่​ดูเหมือน​งาน​เตรียมการ​เล็ก​ๆ กลายเป็น​ครึ่งหนึ่ง​ของ​เวลา​ทั้ง session --- จาก
consult เย็นชา​กับ maw-rs ไป​จนถึง commit แรก​บน `alpha` ก่อน​จะ​มี coder
สัก​ตัว​ขยับ​ได้​จริง 4 หัวข้อ​ใน​บท​นี้​ผูก​กัน​เป็น​เส้น​เดียว trust ต้อง pre-seed, phase
ต้อง​เรียงลำดับ, repo ต้อง​มี commit, pool ต้อง​เช็ค​ก่อน​แตะ --- พลาด​จุด​ไหน​จุด​หนึ่ง ทั้ง
chain ก็​สะดุด

บท​ที่ 4 จะ​พา​ไปดู​ว่า​ทีม​ขนาด 1 คน​ขยาย​ไป​เป็น​พัน​ได้​ยังไง จาก probe task เดียว​ของ
codex-1 ที่​ยิง​กลับ​ผิดที่ ("no window 'lead' in session") ไป​จนถึง 1,000 Haiku
agent ที่​วิ่ง​พร้อมกัน​ได้​ใน 103 วินาที --- เส้นทาง​จาก Solo ถึง Thousand ที่​พิสูจน์​ว่า
architecture ที่​ถูกต้อง​ตั้งแต่ setup คือ​สิ่ง​ที่​ทำให้ scale ได้​จริง ไม่​ใช่​แค่ workaround
เฉพาะหน้า

= บท​ที่ 4: จาก Solo ถึง Thousand --- สเกล​ที่​พิสูจน์​แล้ว
<บทท-4-จาก-solo-ถง-thousand-สเกลทพสจนแลว>
ทีม​ของ codex-fanout ที่​เล่า​ใน​ภาค 2 ไม่​ได้​เริ่ม​จาก​ศูนย์ มัน​ยืน​อยู่​บน​บทเรียน​ที่
crew-master-oracle พิสูจน์​มา​ก่อน​แล้ว​ห้า​รอบ แต่ละ​รอบ​ทดสอบ​สเกล​ที่​ต่างกัน --- solo
หนึ่ง​ตัว, trio สาม​ตัว, swarm สาม​ตัว​ไม่​มี​ผู้นำ, tournament สาม​ตัว​แข่ง​กัน, และ
thousand หนึ่ง​พัน​ตัว​พร้อมกัน บท​นี้​ไม่​ได้​เล่า​ซ้ำ​ทุก​ตัวเลข แต่​เลือก​เฉพาะที่​สำคัญ​ที่สุด​จาก​แต่ละ​รอบ
--- proven experiment จาก crew-master-oracle ล้วน ไม่​มี​ตัวเลข​ไหน​มาจาก
session ปัจจุบัน​ของ codex-fanout

ประเด็น​ที่​ผูก​ทุ​กรอบ​เข้าด้วยกัน​คือ​เรื่อง​เดียว ต้นทุน​ต่อ coder ไม่​ได้​ลดลง​แบบ linear
เมื่อ​สเกล​ใหญ่​ขึ้น บางครั้ง​มัน​ดีขึ้น บางครั้ง​มัน​แย่​ลง​แบบ​คาดไม่ถึง solo ตัว​เดียว​ชนะ​ทีม​สอง​คน​ได้
เพราะ overhead การ spawn agent ตัว​ที่สอง​แพง​กว่า​งาน​ที่​ต้อง​ทำ​เสีย​อีก แต่​พอ​ถึง​พัน​ตัว
ต้นทุน​ต่อ agent กลับ​นิ่ง​เป็น​เส้นตรง --- ตราบใดที่​งาน​เบา​พอ พอ​เจอ​งานหนัก
เส้น​ตรงนั้น​หัก​ทันที

dna ของ​บท​นี้​คือ "each scale breaks differently" bug ที่ solo ไม่​มี​วัน​เจอ
จะ​โผล่​ตอน swarm เท่านั้น และ bug ที่ swarm เจอ ก็​ไม่​ใช่ bug เดียว​กับ​ที่ thousand เจอ
นี่​ไม่​ใช่​เรื่อง​บังเอิญ --- มัน​คือ physics ของ coordination ที่​เปลี่ยน​รูปแบบ​ทุกครั้งที่​จำนวน
agent ข้าม threshold หนึ่ง​ไป ใคร​ที่​คิด​ว่า​เข้าใจ multi-agent จาก​การ​รัน trio
ครั้ง​เดียว จะ​พลาด​กับดัก​ที่ swarm วาง​ไว้​เต็มๆ

== 4.1 The Solo --- null hypothesis ที่​ไม่​จริง​อย่าง​ที่​คิด
<the-solo-null-hypothesis-ทไมจรงอยางทคด>
สมมติฐาน​ของ​รอบ​แรก​ฟัง​ดู​โต้แย้ง​ง่าย coder ตัว​เดียว​ไม่​มี lead จะ​เร็ว​กว่า ถูก​กว่า
และ​พลาด​น้อยกว่า​ทีม​ที่​ประสานงาน​กัน --- สำหรับ​งาน​เล็ก (ต่ำกว่า 50 บรรทัด) ทีม
crew-master-oracle ทดสอบ​ด้วย​งาน​จริง สร้าง `.gitignore` กับ `CLAUDE.md` ให้
agent ตัว​เดียว​ชื่อ `omx-1` ไม่​มี lead ไม่​มี orchestration layer

ผลลัพธ์​ชัด​กว่า​ที่​คาด wall-clock ทั้งหมด 2 นาที 52 วินาที ใช้ context แค่ 3% ของ
window ไฟล์​ทั้งสอง​ถูกต้อง​ตั้งแต่​ครั้งแรก ไม่​มี conflict ไม่​มี rewrite
แต่​สิ่ง​ที่​น่าสนใจ​กว่า​ตัวเลข​คือ​พฤติกรรม​ที่​ไม่​มี​ใคร​สั่ง --- สาม​วินาที​หลัง​รับงาน `omx-1` สร้าง
checklist วางแผน​ของ​ตัวเอง​โดย​ไม่​มี​คำสั่ง​ให้​ทำ​แบบ​นั้น นี่​คือ emergent
self-organization ที่​ท้าทาย​สมมติฐาน​พื้นฐาน​ของ lead-coder topology เลย ถ้า coder
วางแผน​เอง​ได้​เมื่อ​งาน​อยู่​ใน​ขอบเขต​ที่​เหมาะสม หน้าที่​วางแผน​ของ lead
ก็​ซ้ำซ้อน​สำหรับ​งาน​ระดับ​นี้

ทีมงาน​ประเมิน​ไว้​ด้วยว่า​ถ้า​ใช้ lead + coder แทน solo งาน​เดียวกัน​นี้​จะ​กินเวลา​ประมาณ 5
นาที​ครึ่ง แพง​กว่า​เกือบ​เท่าตัว ผลลัพธ์​เหมือนกัน​เป๊ะ --- solo จึง​ไม่​ใช่​ทางเลือก​สำรอง มัน​คือ
topology ที่​เหมาะสม​ที่สุด​สำหรับ​งาน​ประเภท​หนึ่ง เงื่อนไข​การ​ทำลาย​กฎ 50
บรรทัด​มี​อยู่​จริง​เหมือนกัน เมื่อ​ไฟล์​ต้อง​เขียน​พร้อมกัน เมื่อ​งาน​ต้องการ​ความ​เชี่ยวชาญ​ต่าง​สาย เมื่อ
deadline บังคับ​ให้​ทำ​ขนาน​กัน หรือ​เมื่อ​ต้อง​มี​คน​ตรวจสอบ​อิสระ​จาก​คน​ทำ ---
สี่​เงื่อนไข​นี้​ไม่​มี​ข้อ​ไหน​อยู่​ใน​รอบ​แรก​เลย​สัก​ข้อ

== 4.2 The Trio --- token economics เริ่ม​มีความหมาย
<the-trio-token-economics-เรมมความหมาย>
รอบ​สอง​ขยับ​ไป​สาม​ตัว lead หนึ่ง coder สาม แต่ละ​ตัว​ได้​ไฟล์​ของ​ตัวเอง ไม่​แตะ​ไฟล์​กัน
สมมติฐาน​คือ​งาน​ที่​แยกกัน​ได้​จริง (file-disjoint) จะ​เร็ว​กว่า​ทำ​ทีละ​ตัว​ตามลำดับ ผล​ออกมา​คือ
1.8 เท่า ไม่​ใช่ 3 เท่า​ตาม​ทฤษฎี และ​ช่องว่าง​ระหว่าง 1.8 กับ 3.0
นั้น​คือ​บทเรียน​ทาง​วิศวกรรม​ล้วน​ๆ

ตัวถ่วง​หลัก​คือ spawn overhead เกือบ​สอง​นาที​ก่อน​เริ่ม​เขียน​โค้ด​สัก​บรรทัด บวก​กับ agent
ที่ทำงาน​เร็ว​สุด​ต้อง​นั่ง​รอ agent ที่​ช้า​สุด --- omx-3 เสร็จ​งาน​แล้ว​นั่ง​เฉย​ไป 1 นาที 43 วินาที
เพราะ lead แจก​งาน​แบบ fixed list ไม่​มี dynamic dispatch มา​รับงาน​ต่อ

ที่​สำคัญ​กว่า​นั้น​คือ​เรื่อง token ต่อ​บรรทัด parallelism ไม่​ได้​ลด token ต่อ​งาน มัน​แค่​ลด​เวลา
รอบ​นี้​ใช้ token รวม​ประมาณ 694,000 สำหรับ​โค้ด 333 บรรทัด แต่ token/line
ไม่​เท่ากัน​ใน​แต่ละ agent --- งาน​ที่​มี conditional logic ซับซ้อน​กิน token
ต่อ​บรรทัด​สูง​กว่า​งาน​ที่​เป็น linear cleanup token-per-line ไม่​ใช่​ตัว​ชี้​วัด​คุณภาพ
มัน​คือ​สัญญาณ​ความลึก​ของ​การให้เหตุผล

```python
# Token cost model (Sonnet 4.x, ~70/30 input/output split)
tokens_total = 694_000
cost_input  = (tokens_total * 0.70 / 1_000_000) * 3.00   # $1.457
cost_output = (tokens_total * 0.30 / 1_000_000) * 15.00  # $3.123
total_cost  = cost_input + cost_output                    # ~$4.58

# Break-even for parallel formation:
# Parallel pays off when  S > P + O
# S = serial total, P = slowest parallel task, O = formation overhead
# ในรอบนี้: 11m36s > 4m53s + 1m52s = 6m45s  ✓
```

trio คือ formation ขนาดเล็ก​ที่สุด​ที่​ยัง​คุ้มค่า​จะ​รัน มัน​เล็ก​พอ​จะ debug ได้​เมื่อ​พัง
และ​ใหญ่​พอ​จะ​เห็น speedup principle ชัดเจน สิ่ง​ที่ trio สอน​ไว้ --- ทั้ง bottleneck
ของ slowest worker, idle capacity ที่​สูญเปล่า, ความเสี่ยง​จาก semantic drift
ระหว่าง​ไฟล์ --- ทุก formation ที่​ใหญ่​กว่า​จะ​สืบทอด failure mode
พวก​นี้​ใน​ความ​เข้มข้น​ที่สูง​ขึ้น

== 4.3 The Swarm --- เมื่อ isolated worktree ยัง​ไม่​พอ
<the-swarm-เมอ-isolated-worktree-ยงไมพอ>
รอบ​สาม​คือ​รอบ​ที่​พัง​ชัด​ที่สุด​ใน​ห้า​รอบ สาม coder ได้รับ​คำสั่ง​เดียวกัน​เป๊ะ
"เลือก​งาน​หนึ่ง​ที่​ยัง​ไม่​มี​ใคร​จับ" ไม่​มี​กลไก​ประสานงาน​ใดๆ ผล​คือ codex-1 กับ codex-3
เลือก​งาน​เดียวกัน (Task 3 ที่​ชื่อ​สื่อ​ความ​ชัด​ที่สุด) ส่วน Task 2 ไม่​มี​ใคร​แตะ​เลย collision
rate 66.7% --- parallelism ที่ effective แค่ 0.67 เท่า แย่​กว่า​ใช้ agent
ตัว​เดียว​ทำ​ตามลำดับ​เสีย​อีก

worktree isolation ที่​ป้องกัน merge conflict ได้ดี
กลับ​เป็นตัว​ปิดกั้น​การรับรู้​ซึ่งกันและกัน​ไป​ด้วย​ใน​ตัว agent แต่ละ​ตัว​ไม่​เห็น working state
ของ​อีก​ตัว ไม่​มี shared state ไม่​มี lock ไม่​มี linearization point --- นี่​คือ
classic thundering herd ผสม​กับ check-then-act race condition ที่​ทฤษฎี
distributed systems อธิบาย​ไว้​ตั้งแต่​ยุค Brooks (1975) และ Lamport (1978) แล้ว

ที่​ทำให้​เรื่อง​ซับซ้อน​ขึ้น​คือ​มี​การ​ทดสอบ​สเกล 1,000 agent คู่ขนาน​กัน​ใน​วันเดียวกัน ได้ผล 100%
สำเร็จ ไม่​มี collision เลย ฟัง​ดู​ขัดแย้ง​กับ​รอบ​สาม แต่​จริงๆ ไม่​ใช่ ---
การ​ทดสอบ​พัน​ตัว​นั้น​ไม่​มี shared resource เลย แต่ละ agent แค่​พูด "hello"
โดย​ไม่​แตะ​ทรัพยากร​ร่วมกับ​ใคร collision probability เป็น​ฟังก์ชัน​ของ resource
scarcity ไม่​ใช่​จำนวน agent ที่ scarcity เป็น​ศูนย์ collision ก็​เป็น​ศูนย์​เสมอ ไม่​ว่า​จะ​มี
agent กี่​ตัว​ก็ตาม

ทางแก้​ไม่​ซับซ้อน​เลย ไฟล์ lock แบบ `O_EXCL`, GitHub issue assignment, หรือ
coordinator process ตัว​เดียว --- อย่างใดอย่างหนึ่ง​พอ​จะ​ทำลาย thundering herd ได้
รอบ​ที่สี่​เอา GitHub issue assignment มา​ใส่​ก่อน dispatch collision rate ตก​จาก
67% เหลือ 0% ทันที ใช้เวลา​เพิ่ม​แค่ 3 วินาที แลก​กับ​การ​ประหยัด compute ที่​เสีย​ไป​ทั้ง​รอบ

== 4.4 The Tournament และ The Thousand --- token efficiency inversion + throughput formula
<the-tournament-และ-the-thousand-token-efficiency-inversion-throughput-formula>
รอบ​สี่​เปลี่ยน​คำถาม​จาก "จะ​ประสานงาน​ยังไง​ไม่​ให้​ชน" เป็น "ถ้า​ให้​สาม coder
ทำงาน​เดียวกัน​พร้อมกัน​แล้ว​เลือก​ที่​ดี​ที่สุด จะ​คุ้ม​ไหม" กลไก​ไม่​ต่าง​จาก swarm เลย​สักนิด
dispatch message เหมือนกัน​ทุก​ตัว ต่างกัน​แค่​ขั้นตอน​สุดท้าย --- swarm synthesize
ผลรวม ส่วน tournament เลือก​ผู้ชนะ

ผล​ที่​พลิก​ความคาดหมาย​ที่สุด​คือ​เรื่อง token codex-1 ใช้ token มากกว่า codex-2 ถึง 2.2
เท่า (1.7 ล้าน เทียบ 766,000) แต่​ได้​บรรทัด​โค้ด​น้อยกว่า​และ​เข้า​เส้นชัย​เป็น​อันดับ​สุดท้าย
token ที่​มากขึ้น​ไม่​ได้​แปล​ว่า​คุณภาพ​ดีขึ้น มัน​มัก​แปล​ว่า agent ใช้เวลา​ไป​กับ​การ deliberate
ใน​ขั้น​วางแผน​มากเกินไป จน​เสียเปรียบ agent ที่ commit เร็ว​กว่า​และ​ลงมือ implement
ตรง​กว่า --- token efficiency inversion นี้​คือ​เหตุผล​ว่า​ทำไม​งาน​ที่​ต้องการ​ความเร็ว​และ
coverage ควร​มอบให้ agent ที่ context เบา ส่วน​งาน​ที่​ต้องการ coherence ลึก​ค่อย​เก็บ
high-context agent ไว้​ใช้

รอบ​ห้า​คือ​รอบ​ที่​ใหญ่​ที่สุด หนึ่ง​พัน agent พร้อมกัน ทั้งหมด​สำเร็จ 100% ใน 103.3 วินาที เฉลี่ย
9.7 agent ต่อ​วินาที ตัวเลข​นี้​ไม่​ได้​มาจาก​การ​ยิง 1,000 คำขอ​พร้อมกัน​ทีเดียว ---
มัน​มาจาก​สูตร​ง่ายๆ ที่​ทีมงาน​เรียก​ว่า​สูตร​เดียว​ที่​ต้อง​จำ

```python
# Throughput formula — engrave this
def agents_per_second(concurrent_cap: int, avg_task_duration_s: float) -> float:
    return concurrent_cap / avg_task_duration_s

agents_per_second(16, 1.65)   # hello-world Haiku   → 9.7 agents/s
agents_per_second(16, 8.0)    # summarize document   → 2.0 agents/s
agents_per_second(16, 45.0)   # codex coder, boot     → 0.36 agents/s
agents_per_second(16, 75.0)   # heavy tmux coder      → 0.21 agents/s
```

concurrent cap ไม่​ใช่​ตัวกำหนด throughput สูงสุด​อย่าง​ที่​คน​มัก​เข้าใจผิด
มัน​แค่​กำหนด​จำนวน slot ที่ทำงาน​พร้อมกัน ณ ขณะ​หนึ่ง ตัว​ที่​กำหนด throughput จริง​คือ task
duration เฉลี่ย งาน​เบา​เท่าไหร่​ก็​ยิ่ง​ดัน​ผ่าน cap เดิม​ได้​มาก​เท่านั้น นี่​คือ​เหตุผล​ที่​การ​ทดสอบ​ใช้
Haiku ล้วน ไม่​ใช่​เพราะ Haiku ฉลาด​พอ แต่​เพราะ​ต้องการ​ทดสอบ scaffolding
ไม่​ใช่​ทดสอบ​โมเดล

แต่​ตัวเลข​นี้​ใช้ไม่ได้​กับ​งานหนัก tmux codex coder ตัวจริง​ที่ boot session,
authenticate, โหลด context จาก​โค้ด​จริง, reasoning หลาย​ขั้นตอน ใช้เวลา​เฉลี่ย 75
วินาที​ต่อ task เทียบ​กับ 1.65 วินาที​ของ hello-world ห่าง​กัน 20-80 เท่า ถ้า​จะ​รัน​พัน
coder หนัก​ขนาด​นี้​ผ่าน cap เดียวกัน จะ​ใช้เวลา​ประมาณ 79 นาที ไม่​ใช่ 103 วินาที
และ​ก่อน​จะ​ถึง cap 16 slot ด้วยซ้ำ RAM ก็​เต็ม​ก่อน​แล้ว --- 15 tmux session กิน​ไป​เกือบ
14GB บน​เครื่อง 16GB การ​ทดสอบ​จริง​จึง​ใช้ 5 ทีม 3 coder ต่อ​ทีม กระจาย API key
แยก​ต่อ​ทีม เพื่อ​ไม่​ให้ rate limit ของ​ทีม​หนึ่ง​ไป​บล็อก​ทีม​อื่น

บทเรียน​ที่​ทั้ง​ห้า​รอบ​ทิ้ง​ไว้​ให้​ร่วมกัน​คือ orchestration layer นั้น scale ได้​เป็น​เส้นตรง​จริง
แต่ hardware ไม่​เคย​เป็น​เส้นตรง เพดาน​ที่​แท้จริง​ไม่​ได้​อยู่​ที่​ทฤษฎี multi-agent มัน​อยู่​ที่ CPU,
RAM, และ rate limit ของ API เสมอ

#line(length: 100%)

ห้า​รอบ​นี้​คือ​รากฐาน​ที่ codex-fanout ยืน​อยู่​ก่อน​จะ​เจอ​สถานการณ์​จริง​ของ​ตัวเอง solo
บอ​กว่า​เมื่อไหร่​ไม่ต้อง​ใช้​ทีม trio บอก​วิธี​คิด break-even ก่อน spawn swarm เตือน​ว่า
isolation ไม่​เท่ากับ coordination tournament เผย​ว่า token มาก​ไม่​ได้​แปล​ว่า​ดีกว่า
และ thousand ให้​สูตร​คำนวณ throughput ที่​ใช้ได้​จริง
แต่​ตัวเลข​ทั้งหมด​นี้​มาจาก​สภาพแวดล้อม​ที่​ควบคุม​ได้ --- งาน​ที่​กำหนด​ไว้​ล่วงหน้า ไม่​มี merge
conflict ที่​ซับซ้อน ไม่​มี agent ที่​ดื้อ​คำสั่ง

บท​ที่ 5 จะ​พา​ไป​สู่​ด้าน​ที่​ไม่​ได้​ถูก​ทดสอบ​ใน​ห้า​รอบ​นี้ --- The Lock และ Twelve Traps เมื่อ
16 agent ต้อง​แย่ง​ทรัพยากร​เดียวกัน​จริงๆ และ​ไม่​มี​ใคร​ยอม​ถอย จะ​เกิด​อะไร​ขึ้น​เมื่อ
coordination protocol ที่​ดูดี​ใน​กระดาษ ต้อง​เจอ​กับ agent ที่​ตีความ​คำสั่ง​คนละ​แบบ
และ​กับดัก​สิบสอง​ข้อ​ที่​รอ​ทีม​ทุก​ทีม​ที่​คิด​ว่า​ตัวเอง​เตรียมพร้อม​แล้ว

= บท​ที่ 5: The Lock และ Twelve Traps
<บทท-5-the-lock-และ-twelve-traps>
บั๊ก​ที่​แพง​ที่สุด​ใน​ระบบ distributed ไม่​ใช่​บั๊ก​ที่ error ดัง ๆ แล้ว​ล่ม​ทั้ง​ระบบ ---
บั๊ก​ที่​แพง​ที่สุด​คือ​บั๊ก​ที่ทำงาน "สำเร็จ" แต่​สำเร็จ​ผิด​อย่าง เงียบสนิท ไม่​มี log ไม่​มี exception
ไม่​มี​ใคร​รู้​จนกว่า​จะ​สาย

เรื่อง​ใน​บท​นี้​มาจาก session จริง​ของ crew-master-oracle ที่ codex-1 ตาย​ซ้ำ ๆ
ไม่​ใช่​ตาย​แบบ crash แต่​ตาย​แบบ boot ขึ้น​มา​เป็น shell เปล่า ไม่​มี task ไม่​มี memory
ไม่​มี goal ระบบ​รายงาน​ว่า fleet เขียว แต่ coder ไม่​ได้ coding อะไร​เลย นี่​คือ
symptom ที่​อันตราย​กว่า error เพราะ​ไม่​มี​สัญญาณ​ให้​จับ

การ​ไล่ root cause ใช้เวลา​สาม​สมมติฐาน สอง​ข้อ​แรก​ผิด ข้อ​ที่สาม​ถูก ---
และ​วิธี​ที่​ทีม​พิสูจน์​แต่ละ​ข้อ​คือ​บทเรียน​ที่​สำคัญ​พอ ๆ กับ​ตัว​บั๊ก​เอง ต่อจากนั้น​บท​นี้​จะ​สรุป Twelve
Traps ที่​ทีม​เดียวกัน​เจอ​ตลอด session และ​ปิดท้าย​ด้วย​การ​เปรียบเทียบ​กับ​บั๊ก \#658
ที่​เจอ​เอง​ใน​ภาค 2 ของ​หนังสือ​เล่ม​นี้ --- pattern เดียวกัน คนละ​บริบท

#line(length: 100%)

== 5.1 อาการ​ที่​ไม่​มี error
<อาการทไมม-error>
codex-1 บูต​ซ้ำแล้วซ้ำเล่า ทุกครั้ง​จบ​ที่ shell เปล่า ไม่​มี context ไม่​มี​อะไร​ให้ agent
ทำงานต่อ จาก​ภายนอก​ดูเหมือน initialization ค้าง​กลางทาง แต่ process ยัง​รัน​อยู่ ---
เทคนิค​แล้ว​คือ "alive" แต่​ใช้งาน​จริง​ไม่​ได้​เลย

fleet monitor รายงาน​สถานะ​ปกติ​ทุกอย่าง เขียว​หมด แต่ coder ไม่​ผลิต​อะไร​ออกมา
ระบบ​ที่​ดู​สุขภาพ​ดี​ในขณะที่​ไม่​ผลิต​ผลลัพธ์ ยาก​กว่า​ระบบ​ที่​ล่ม​ชัดเจน​เยอะ เพราะ​ไม่​มี stack trace
ให้​ตาม ไม่​มี exit code ให้ grep

ทีม​ตั้งสมมติฐาน​สาม​ข้อ​เรียง​กัน แต่ละ​ข้อ​ฟัง​ดู​สมเหตุสมผล แต่ละ​ข้อพิสูจน์​ไม่​ตรง
มี​แค่​ข้อ​ที่สาม​ที่​ยืนยัน​ได้​ด้วย​เครื่องมือ​ระดับ process --- `lsof` กับ `ps eww`

== 5.2 กลไก และ​วิวัฒนาการ​ของ fix
<กลไก-และววฒนาการของ-fix>
สมมติฐาน​แรก​โทษ `reasoning_effort=low` --- คิด​ว่า reasoning ต่ำ​ทำให้ agent
parse task state ไม่​ออก แล้วก็ fallback ไป shell ปิด flag นี้​แล้ว​อาการ​ไม่​หาย
พิสูจน์​แล้ว​ว่า​ไม่​ใช่​จุด​นี้

สมมติฐาน​ที่สอง​โทษ token expiry --- คิด​ว่า credential หมดอายุ​ทำให้ auth
ล้มเหลว​แล้ว process ตกไป shell แทนที่จะ error ตรง ๆ แต่​มี screenshot คัดค้าน​ตรง
ๆ: `omx` ใช้ credential pool เดียวกัน บูต​ปกติ ถ้า token หมด​จริง `omx` บูต​ไม่​ได้​แน่
--- screenshot นี้​คือ falsifier ที่​ปฏิเสธ​ไม่​ได้ บทเรียน​ตรงนี้​ไม่​ใช่
"เก็บ​ข้อมูล​ให้​มาก​ก่อน​ตั้งสมมติฐาน" แต่​คือ​หาทาง​พิสูจน์​ว่า​สมมติฐาน​ตัวเอง​ผิด​ทันทีที่​ตั้งขึ้น​มา

สมมติฐาน​ที่สาม​ต้อง​ใช้​เครื่องมือ​ระดับ process จริง ๆ ทีม​ส่ง 5-agent workflow ไป​รัน
`lsof` ดู open file handle กับ `ps eww` ดู environment variable ทั้ง fleet
ผล​ออกมา​ชัดเจน

```
$ ps eww | grep CODEX_HOME | grep -o 'CODEX_HOME=[^ ]*' | sort | uniq -c | sort -rn
     17 CODEX_HOME=/Users/nat/.codex-team/1
```

สิบ​เจ็ด process ชี้​ไป​ที่ directory เดียวกัน --- SQLite lock contention คือ root
cause ตัวจริง

กลไก​คือ Codex เก็บ state ใน SQLite แล้ว​ล็อก​ไฟล์​ด้วย PID lock ตอน startup พอ​มี
process มากกว่า​หนึ่ง​ชี้​ไป​ที่ `CODEX_HOME` เดียวกัน คน​แรก​ที่​ถึง​ล็อก​ได้​ก็​ยึด​ไว้
ที่​เหลือ​อีก​สิบ​หก​คน​รอ​จน​หมดเวลา​แล้วก็​บูต​ต่อ​โดย​ไม่​มี state --- ไม่ error ไม่ crash
แค่​รัน​ต่อ​แบบ​ว่างเปล่า `waitForNonShell` เช็ค​แค่​ว่า process ยัง​มีชีวิต​อยู่
ไม่​ได้​เช็ค​ว่า​มัน​โหลด state สำเร็จ​หรือเปล่า presence ไม่​เท่ากับ readiness ---
process ที่​เริ่ม​แล้ว​ไม่​ได้​แปล​ว่า process ที่​พร้อม​ใช้งาน

fix ผ่าน​สอง​รอบ รอบ​แรก​ให้​แต่ละ oracle มี `CODEX_HOME` แยกกัน แก้ contention
ระหว่าง oracle คนละ​ประเภท​ได้ แต่​สอง instance ของ oracle เดียวกัน​ยัง​ชน​กัน​อยู่ดี
รอบ​สอง​ถึง​จะ​ตรงจุด --- ผูก `CODEX_HOME` เข้ากับ worktree ผ่าน `codex-setup.ts`
แต่ละ worktree มี `.codex` ของ​ตัวเอง ส่วน auth ยัง symlink มาจาก pool
กลาง​ได้​เพราะ auth เป็น read-only ไม่ต้อง​ล็อก แยก​สิ่ง​ที่​แชร์​ได้​โดยธรรมชาติ
ออกจาก​สิ่ง​ที่​ต้อง​แยก​โดย​สถาปัตยกรรม --- สับสน​สอง​อย่างนี้​คือ​บาป​ต้นทาง

ทดสอบ​ด้วย `maw-rs` รัน​ห้า coder พร้อมกัน --- ห้า SQLite file แยกกัน
ล็อก​ไม่​ชน​กัน​เลย​สักครั้ง บูต​ครบ state ครบ​ทุก​ตัว

== 5.3 Twelve Traps สรุป​ย่อ
<twelve-traps-สรปยอ>
นอกจาก SQLite lock ที่​เป็น​พระเอก​ของ​บท​นี้ session เดียวกัน​ยัง​เจอ​กับดัก​อีก​สิบเอ็ด​จุด
แต่ละ​จุด​เป็น​สิ่ง​ที่​ทีม​ที่​ไม่​เคย​เจอ​มา​ก่อน​จะ​เจ็บ​แน่นอน

#strong[Charter engine block] --- engine ที่ประกาศ​ไว้​ตอน spawn
ไม่​ถูก​จดทะเบียน​ใน config runtime เลย​ข้ามขั้น charter ไป​เงียบ ๆ coder ที่​ออกมา​ไม่​มี
task boundary ไม่​มี scope เลย fix คือ​ลงทะเบียน engine ใน
`~/.maw/config.toml` แล้ว​เช็ค​ด้วย `maw engine list` ก่อน spawn ทุกครั้ง

#strong[`maw team down --only` ฆ่า​ทุกคน] --- flag ตั้งใจ​ให้ terminate
เฉพาะ​บาง​ตัว แต่ parsing บั๊ก​ทำให้ ignore selector ฆ่า​ทั้ง fleด flag
ที่​ไม่​ทำงาน​อันตราย​กว่า flag ที่​ไม่​มี​อยู่ เพราะ​มัน​สร้าง​ความมั่นใจ​ปลอม​ว่า​คำสั่ง​ทำงาน​ตามที่​สั่ง

#strong[SendMessage เงียบ​สำหรับ omx] --- omx ไม่​ได้ poll inbox ที่
`SendMessage` เขียน​ไป ข้อความ​หาย​ไป​เฉย ๆ โดย​ไม่​มี ack ต้อง​ใช้ `maw hey` แทน​เสมอ

#strong[False negative warning] --- monitor เตือน​ว่า "may not have
submitted" ทั้งที่ coder commit สำเร็จ​แล้ว​แค่​ยัง​ไม่ push ทำให้​คน​แทรกแซง coder
ที่​กำลัง​ทำงาน​อยู่ กฎ​คือ peek ก่อน​เชื่อ warning

#strong[Auto-explore ใน `--madmax`] --- coder ที่​ยัง​ไม่​มี task เริ่ม explore
repo เอง​ก่อน​ได้รับ dispatch เผา​โท​เคน​ฟรี ต้อง​ใส่ WAIT directive ใน charter
prompt

#strong[Generic `codex` ชน Claude Code] --- เรียก `codex` แบบ​ไม่​ระบุ path
ชัดเจน ระบบ​ไป​เจอ `.claude/` แล้ว resolve ผิด​ไป​ที่ Claude Code แทน ต้อง​ระบุชื่อ
engine แบบ​เจาะจง เช่น `omx-3` ไม่​ใช่ `codex` เฉย ๆ

#strong[`.codex`/`.claude` บล็อก worktree remove] --- สอง​โฟลเดอร์​นี้​เป็น
untracked โดย​ดีไซน์ `git worktree remove` เลย​ปฏิเสธ​ลบ​ถ้า​ไม่ force ทีม maw-rs
วัด​ได้ fail rate ถึง 45% ตอน shutdown ทางแก้​คือ `mv` ออก​ก่อน​แล้ว​ค่อย remove

#strong[Swarm collision ที่ 67%] --- dispatch โดย​ไม่​มี atomic task-claiming
ทำให้ coder หลาย​ตัว​เห็น task เดียวกัน​แล้ว​เริ่ม​ทำ​พร้อมกัน วัด​ได้ collision rate ราว
67% ทางแก้​คือ `UPDATE ... WHERE claimed_by IS NULL` แบบ test-and-set

#strong[Stale worktree บล็อก spawn] --- worktree เก่า​ที่​ลบ​ไม่​หมด​ชน​กับ path ใหม่
ต้อง treat cleanup เป็น idempotent startup logic ไม่​ใช่​แค่ teardown logic

#strong[`reasoning_effort=low` ผลิต​ขยะ​ใน​งาน planning] --- ใช้​ได้ดี​กับ​งาน
classify/route แต่​ใน​งาน multi-step planning มัน​ตัด reasoning chain สั้น​เกินไป
ได้ output ที่ syntax ผ่าน​แต่ semantic พัง

#strong[Token spend ไม่​แปรผันตรง​กับ​คุณภาพ] --- coder ที่​ใช้​โท​เคน​เยอะ​สุด​ใน​กลุ่ม
(1.7M) กลับ​ส่ง​งาน​ช้า​สุด​และ revise เยอะ​สุด token volume เป็น cost metric ไม่​ใช่
quality metric

#strong[วินิจฉัย "token expired" โดย​ไม่ peek ก่อน] --- ความ​เงียบ​ของ coder
ไม่​เท่ากับ token หมดอายุ​เสมอไป อาจ​แค่​กำลัง​รัน I/O หนัก​อยู่ การ restart โดย​ไม่ peek
ทำให้​เสียงาน checklist ที่​ทำ​ไป​แล้ว​หลาย​สิบ​นาที

สาม​ข้อสรุป​ที่​ลอย​ขึ้น​มาจาก​สิบสอง​กับดัก​นี้​คือ --- ความ​เงียบ​ไม่​ใช่​ความล้มเหลว ต้อง peek
ก่อน​สรุป​ทุกครั้ง shared state ฆ่า parallelism ทุกครั้งที่​มี resource แชร์​กัน​โดย​ไม่
atomic และ default ที่​ออกแบบ​มา​สำหรับ agent เดี่ยว​อันตราย​เมื่อ​ขยาย​เป็น fleet

== 5.4 เงา​สะท้อน​จาก \#658
<เงาสะทอนจาก-658>
เรื่อง​ทั้งหมด​ใน​บท​นี้​เกิด​ที่ crew-master-oracle คนละ session คนละ​ทีม แต่ pattern
เดียวกัน​นี้​โผล่​มา​อีกครั้ง​ใน session codex-fanout วันที่ 23 กรกฎาคม 2026 ---
คราวนี้​ไม่​ใช่ SQLite lock แต่​เป็น​บั๊ก​ใน `maw team preflight` และ `maw team up` ที่
strip prefix `agents/` ออกจาก path ของ member ตัว​สุดท้าย​ใน charter ก่อน
canonicalize

อาการ​หน้าตา​คุ้น ๆ --- path ที่​ควรจะเป็น `agents/codex-1` กลายเป็น `codex-1` เฉย
ๆ ไม่​มี error บอก​ตรง ๆ ว่า "prefix หาย" มี​แค่ error ปลายทาง​ที่​บอ​กว่า worktree
ไม่​พบ กับ trust config อ่าน​ไม่​ได้ --- เหมือนกับ codex-1 ที่​บูต​เป็น shell
เปล่า​ตรง​ที่​ทั้งคู่​คือ silent failure ที่​ต้อง​ไล่​ทีละ​สมมติฐาน​กว่า​จะ​เจอ​ต้นตอ

ทีม​ใน​บท 7 ก็​ทำ​สิ่ง​เดียว​กับ​ที่​บท​นี้​สอน --- ไม่​เชื่อ​สมมติฐาน​แรก (คิด​ว่า​เป็น stale cwd ก่อน)
รัน​ซ้ำ​จาก clean state เพื่อ falsify แล้ว​พอ​ยัง​ไม่​หาย ก็ escalate ไปหา peer
ที่​เขียน​เครื่องมือ​ตัว​นั้น​เอง จน reproduce ได้ live แล้ว​ยืนยัน​เป็น​บั๊ก​จริง ---
วิธี​นี้​ตรง​กับ​สิ่ง​ที่​บท​นี้​ย้ำ​ไว้​ตลอด: อย่า​เชื่อ​สมมติฐาน​แรก และ​เมื่อ instrumentation ใน​มือ​ไม่​พอ
ให้​ไปหา​คน​ที่​มี

ภาค 1 ของ​หนังสือ​เล่ม​นี้​จบ​ตรงนี้ --- ห้า​บท​ที่ผ่านมา​คือ​บทเรียน​ที่​พิสูจน์​แล้ว​จาก
crew-master-oracle การ​กำหนด boundary ของ​ทีม การ​แบ่ง state ที่​ต้อง​แยกจาก state
ที่​แชร์​ได้ และ​วิธี​อ่าน​ความ​เงียบ​ไม่​ให้​เข้าใจผิด ทั้งหมด​นี้​ไม่​ใช่​ทฤษฎี
แต่​เป็น​แผนที่​ที่​เขียน​จาก​รอยแผล​จริง

ภาค 2 ตั้งแต่​บท​ที่ 6 เป็นต้นไป จะ​พา​ไปดู session codex-fanout ตัวจริง ---
ทีม​ที่​ประกอบ​ขึ้น​จาก lead หนึ่ง​ตัว​กับ coder หลาย​ตัว เจอ​บั๊ก​ใหม่​ที่​ไม่​มี​ใน​สิบสอง​กับดัก​นี้ ต้อง
cold-consult กับ peer เจ้าของ​เครื่องมือ และ​ต้อง​ตัดสินใจ​กลางทาง​ว่า​จะ workaround
แบบ​ไหน​ถึง​จะ​ไม่​เสียเวลา​ไป​มากกว่า​ที่​ควร บท​ที่ 6 จะ​เริ่ม​จาก​การ​ก่อ​ร่าง​ทีม​ตั้งแต่​ศูนย์ ก่อนที่​บท​ที่
7 จะ​พา​ไปดู \#658 แบบ​เต็ม ๆ ว่า​ทีม​ไล่​ตามรอย​ยังไง​จน​เจอ fix จริง

= บท​ที่ 6: การ​ถาม​ผู้เชี่ยวชาญ​แบบ​เย็น
<บทท-6-การถามผเชยวชาญแบบเยน>
ภาค 1 ปิดท้าย​ด้วย​การ​สังเคราะห์​บทเรียน​จาก crew-master-oracle ---
ทฤษฎี​ที่​กลั่น​มาจาก​ทีม​จริง​หลาย​ทีม จนถึง​จุด​นี้​ผู้อ่าน​น่าจะ​รู้​แล้ว​ว่า "ควร​ทำ​อะไร"
แต่​บท​นี้​เปลี่ยน​โหมด จาก​ทฤษฎี​ไป​เป็น case study สดๆ ตัว​เดียว บันทึก​แบบ
timestamp-level จาก session จริง​ชื่อ `codex-fanout` วันที่ 23 กรกฎาคม 2026

Session นี้​เริ่ม​ต้นแบบ​เปล่า​เปลือก​ที่สุด​เท่า​ที่จะ​เป็นไปได้ --- Claude Sonnet ตัว​หนึ่ง รัน
reasoning effort ระดับ low ไม่​มี briefing มา​ก่อน ไม่​มี context เกี่ยวกับ codex
team ใน​หัว​เลย​แม้แต่น้อย งาน​ที่​ได้รับ​คือ​ประโยค​สั้น​ๆ จาก Nat: "maw ls to check and
talk to maw-rs how to start make codex team to help us here"
แล้ว​ตาม​ด้วย​การ​เจาะจง​ให้​แคบ​ลง --- "I just want 1 codex and use account 5"

โจทย์​ตรงนี้​คือ​ปัญหา​คลาสสิก​ที่​ทุก orchestrator เจอ --- ต้อง spawn ทีม​โดย​ไม่​รู้ contract
ปัจจุบัน​ของ​ระบบ ทางเลือก​มี​สอง​ทาง หนึ่ง​คือ​เปิด guidebook เก่า​แล้ว​เดา​ไป​ตามนั้น
สอง​คือ​ถาม​คน​ที่​เพิ่ง​ทำงาน​แบบ​เดียวกัน​มา​สดๆ บท​นี้​จะ​เล่า​ว่า​ทาง​ที่สอง​พา​ไป​ถึง​ไหน
และ​ทำไม​ทาง​แรก​ถึง​เกือบ​ทำให้​ทีม​พัง​ตั้งแต่​ยัง​ไม่​ทัน​เริ่ม

== 6.1 บริบท --- session ว่างเปล่า ต้องการ 1 coder บัญชี 5
<บรบท-session-วางเปลา-ตองการ-1-coder-บญช-5>
ก่อน​พิมพ์​คำสั่ง​แรก session `codex-fanout` ไม่​มี​อะไร​เลย repo ว่าง ไม่​มี context
งาน​เก่า ไม่​มี​แม้แต่ commit สัก​ตัว (เรื่อง​นี้​จะ​เป็นปัญหา​จริง​ใน​บท​ที่ 7) สิ่ง​เดียว​ที่​มี​คือ​คำสั่ง​ของ
Nat กับ session name

โจทย์​แคบ​ลง​เรื่อยๆ จาก "make codex team" กว้างๆ กลายเป็น​ตัวเลข​ชัด --- coder
ตัว​เดียว ใช้​บัญชี (pool) หมายเลข 5 นี่​คือ​จุดสำคัญ​ที่​ทำให้​ปัญหา​ไม่​ใหญ่​เกิน​จัดการ
เพราะ​ถ้า​ตั้งเป้าหมาย 5 coder ตั้งแต่แรก ความเสี่ยง​จะ​พุ่ง​ขึ้น​ตาม​จำนวน
แต่​ตัว​เดียว​หมายความว่า ถ้า​อะไร​พัง cause-space ก็​มี​แค่​หนึ่ง​จุด --- หลักการ​เดียว​กับ​ที่
TING-ORACLE เรียนรู้​มา​ด้วย​ราคา 45 นาที (รายละเอียด​ใน 6.4)

คำถาม​ที่​เหลืออยู่​คือ "แล้​วจะ​เริ่ม​ยังไง" --- charter เขียนแบบ​ไหน engine key
ต้อง​ตั้งชื่อ​อะไร มี pitfall อะไร​ซ่อน​อยู่​บ้าง​สำหรับ fresh worktree ตรง​นี้แหละ​ที่ session
ตัดสินใจ​ไม่​เดา แต่​ไป​ถาม​คน​ที่​รู้​จริง

== 6.2 maw hey แบบ cold --- ไม่​มี context ร่วมกัน​มา​ก่อน, maw-rs กำลัง​ยุ่ง​อยู่​กับ​งาน​อื่น
<maw-hey-แบบ-cold-ไมม-context-รวมกนมากอน-maw-rs-กำลงยงอยกบงานอน>
`maw ls` แสดง session ทั้งหมด 40 ตัว​ใน​เฟ​ลี​ต ใน​นั้น​มี `33-maw-rs` --- 9 pane
กำลัง​รัน 4-coder fanout ของ​ตัวเอง​อยู่ นี่​คือ oracle ที่​รู้เรื่อง codex team contract
ล่าสุด​จริงๆ เพราะ​เพิ่ง​สร้าง​ทีม 5-coder ของ​ตัวเอง​มา​ไม่​กี่​วัน​ก่อนหน้า

ไม่​มี​การทักทาย​อุ่นเครื่อง ไม่​มี pre-coordination มา​ก่อน​เลย ข้อความ​แรก​ที่​ส่ง​ไป​คือ

```bash
maw hey 33-maw-rs "Hi maw-rs — I'm working in codex-fanout and want to set up a codex coder
team to help here. What's the recommended flow — maw team up, dry-run first, charter setup?
Any gotchas for a fresh worktree (e.g. omx boot pitfall)? Please advise briefly."
```

จุด​ที่​ต้อง​ขีดเส้นใต้​คือ maw-rs ไม่​ได้​ว่าง​ตอนนั้น กำลัง mid-dispatch อยู่​กับ fanout
ของ​ตัวเอง​ที่​มี issue ผูก​อยู่ (`#648`) --- แต่ `maw hey` ไม่​ใช่​การ​โทร​แบบ
synchronous ที่​ต้อง​รอ​คน​รับสาย​ว่าง ข้อ​ความถูก queue ไว้ แล้ว maw-rs
ก็​ตอบ​กลับมา​ระหว่าง​ที่​สลับ context ไปมา​ระหว่าง step งาน​ของ​ตัวเอง

นี่​คือ​กลไก​ที่​ทำให้ cold consult ใช้ได้​จริง​ในทางปฏิบัติ peer ไม่ต้อง​ว่าง​ถึง​จะ​ช่วย​ได้ ---
แค่​คำถาม​ต้อง​เจาะจง​พอที่จะ​ตอบ​สั้น​ๆ ได้​โดย​ไม่ต้อง​หยุดงาน​ตัวเอง​ทั้ง​กระบวน

== 6.3 คำตอบ​ที่​ขัดแย้ง​กับ guidebook เก่า
<คำตอบทขดแยงกบ-guidebook-เกา>
คำตอบ​ของ maw-rs กลับมา​แบบ​ย่อ อ้างอิง SSOT ที่
`crew-master-oracle/CODEX-TEAM-GUIDEBOOK.md` แต่​เนื้อหา​จริง​กลับ​ขัด​กับ​สิ่ง​ที่
session คิด​ว่า​รู้​อยู่แล้ว

#quote(block: true)[
CODEX TEAM setup --- brief flow (SSOT:
crew-master-oracle/CODEX-TEAM-GUIDEBOOK.md): 1) charter
`ψ/teams/<team>.yaml` --- filename MUST = `name:` field. #strong[v2
contract: NO `defaults.worktree` block]\; every member has `branch:`\;
lead = `worktree:false` + `branch:alpha`\; engines use worktree-local
pattern:
`bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts N && CODEX_HOME=$PWD/.codex    OMX_AUTO_UPDATE=0 omx --direct --madmax`.
engine key must exist in maw config commands. 2)
`maw team preflight ψ/teams/<team>.yaml` → fix until green (dry-run,
read-only). 3) #strong[SPAWN ONE FIRST (the golden rule)]:
`git worktree add agents/<name> -b agents/<name>    origin/alpha` → cd →
`bun codex-setup.ts N` → #strong[pre-seed trust]:
`printf '\n[projects."$PWD"]\ntrust_level="trusted"\n' >> .codex/config.toml`
→ `maw team load ψ/teams/<team>.yaml --no-spawn` →
`maw team up <name> --only <role>`. 4) verify boot:
`maw peek <session>:<win>` shows engine UI, not shell/trust prompt. 5)
dispatch: `maw hey <session>:<win> "<task + done-criteria>"`, peek every
15-20 min.
]

ประโยค​ที่​สำคัญ​ที่สุด​ใน​คำตอบ​นี้​คือ "#strong[v2 contract: NO `defaults.worktree`
block]" --- session อ่าน guidebook มา​ก่อนหน้านี้ (mental model เก่า) แล้ว​คิด​ว่า
charter ต้อง​มี `defaults: {worktree: true}` แบบ block กลาง กับ engine key
ที่​ใช้ path แชร์​กัน​แบบ `~/.codex-team/N` แต่​นั่น​คือ contract เวอร์ชัน​เก่า
ที่​ตาย​ไป​แล้ว​จริงๆ ใน​ระบบ​ปัจจุบัน

contract จริง --- v2 --- ทุก member ต้อง​มี `branch:` ของ​ตัวเอง ไม่​มี default
กลาง​ให้​พึ่งพา ส่วน `CODEX_HOME` ก็​ไม่​ใช่ path แชร์​อีกต่อไป แต่​เป็น worktree-local
--- ตั้งใหม่​ทุกครั้ง​ตาม `$PWD` ของ worktree นั้นๆ ผ่าน `codex-setup.ts` ก่อน​บูต
engine

ทำไม maw-rs ถึง​รู้เรื่อง​นี้​แม่น​ขนาด​นี้ --- เพราะ maw-rs ไม่​ได้​อ่าน​มาจาก doc แต่
#strong[เพิ่ง​ชน​ปัญหา​เดียวกัน​มา​ด้วยตัวเอง​เมื่อ​ไม่​กี่​วันก่อน] ตอน​สร้าง​ทีม 5-coder ของ​ตัวเอง
contract v2 ไม่​ได้​อยู่​ใน​หนังสือคู่มือ​ที่ update ทัน แต่​อยู่​ใน working memory ของ peer
ที่​เพิ่ง​ใช้งาน​จริง

ตรงนี้​คือ soul thread ของ​บท​นี้ --- ความมั่นใจ​ปลอม​จาก doc เก่า​กับ​ความรู้​จริง​จาก peer
ที่​เพิ่ง​ทำ ถ้า session เดินหน้า​ไป​เขียน charter ตาม mental model
เก่า​โดย​ไม่​ถาม​ใคร​ก่อน `maw team preflight` คง​พัง​ตั้ง​แต่ต้น เพราะ charter จะ​อ้างอิง
`defaults.worktree` ที่​ไม่​มี​อยู่​จริง​ใน​ระบบ​แล้ว

== 6.4 Federation Wisdom ที่​เกี่ยวข้อง
<federation-wisdom-ทเกยวของ>
สิ่ง​ที่​เกิดขึ้น​ใน 6.2 กับ 6.3 ไม่​ใช่​เรื่อง​บังเอิญ แต่​ตรง​กับ​บทเรียน​สอง​ข้อ​ที่ federation
สรุป​ไว้​แล้ว​จาก​ทีม​อื่นๆ ที่​เคย​พัง​มา​ก่อน

ข้อ​แรก คือ #strong[45-minute tax] ของ TING-ORACLE --- ทีม​ที่​รัน 7 coder
พร้อมกัน​ตั้ง​แต่ต้น โดย​ยัง​ไม่​ทดสอบ loop สัก​ตัว​เดียว ผล​คือ​เมื่อ coder ตัว​แรก​ไม่​ได้รับ task
การ diagnose กลายเป็น​ฝันร้าย เพราะ​มี 6 coder อื่น​รัน​คู่ขนาน​อยู่ ทำให้ cause-space
ขยาย​จาก​หนึ่ง​จุด​เป็น​หลาย​จุด​พร้อมกัน เสียเวลา​ไป 45 นาที​เต็ม บทสรุป​ของ TING-ORACLE
คือ​ประโยค​เดียว --- "Spawn ONE first, prove the loop, then scale" ---
ซึ่ง​ตรง​กับ​ที่ maw-rs พูด​คำต่อคำ​ใน​ข้อ 3 ของ​คำตอบ​ข้างบน​ว่า "SPAWN ONE FIRST (the
golden rule)" เพราะ session นี้​ตั้งเป้า​ไว้​แค่ coder เดียว​ตั้งแต่แรก
โจทย์​เลย​ไม่​มีทาง​ชน​กับดัก​ข้อ​นี้​ได้​เลย แต่​ก็​เป็น​เหตุผล​ว่า​ทำไม "1 codex บัญชี 5"
ถึง​เป็น​ขอบเขต​ที่​ถูกต้อง​ตั้งแต่​คำสั่ง​แรก​ของ Nat

ข้อ​สอง คือ​กฎ​เรื่อง #strong[issue URL ไม่​ใช่ number] --- TING-ORACLE
เจอ​ปัญหา​นี้​ตอน coder หนึ่ง​ตัว​ทำงาน​ข้าม​หลาย repo แล้ว dispatch task ด้วย `#42`
เฉย​ๆ เลข 42 ชน​กัน​ได้​ทุก repo แต่ URL ไม่​มีทาง​ชน​เพราะ​พก anchor ของ repo
มา​ด้วย​ใน​ตัว บทเรียน​นี้​โผล่​มา​อีกครั้ง​ใน blocker \#2 ของ case study นี้​เอง --- ตอนที่
maw-rs filed bug ใหม่​เป็น #strong[\#658] แทนที่จะ​บอก​แค่​เลข
ตัวเลข​นั้น​ถูก​อ้างอิง​ใน​บริบท​ที่​ระบุ repo ชัดเจน (crew-master-oracle) ไม่​ใช่​เลข​ลอยๆ ที่
session อื่น​จะ​งง​ว่า​หมายถึง repo ไหน

สอง​บทเรียน​นี้​ไม่​ได้​มาจาก​ทฤษฎี แต่​มาจาก incident log จริง​ที่​มี timestamp ---
เขียน​ไว้​ใน​บท​ที่ 11 ของ​หนังสือ "Art of Team Formation" ก่อนหน้านี้​แล้ว จุด​ที่​น่าสนใจ​คือ
case study บท​นี้​ไม่​ได้​อ่าน​บท​นั้น​มา​ก่อน​ตอน​ทำงาน​จริง แต่​ยังคง align กับ​หลักการ​เดียวกัน
--- เพราะ​หลักการ​พวก​นี้​ไม่​ใช่ dogma ลอยๆ แต่​มาจาก​ข้อจำกัด​เชิง​โครงสร้าง​ของ​การ
diagnose ปัญหา​แบบ​ขนาน ยิ่ง​จำนวน​ตัวแปร​เยอะ ยิ่ง diagnose ยาก
ไม่​ว่า​ใคร​จะ​เจอ​ปัญหา​นี้​ที่ไหน​ก็ตาม

== ปิดท้าย
<ปดทาย>
ถึง​จุด​นี้ session ยัง​ไม่​ได้​แตะ​โค้ด​สัก​บรรทัด ยัง​ไม่​ได้​เขียน charter สัก​ตัว
สิ่ง​ที่​ทำ​ไป​มี​แค่​การ​ถาม​คำถาม​หนึ่ง​ข้อ กับ​การ​ได้​คำตอบ​ที่​แก้ mental model ผิด​ๆ ก่อนที่​มัน​จะ​ทำให้
preflight พัง​ตั้งแต่​รอบ​แรก นี่​คือ dna ของ​บท​นี้ --- ask before you guess ถาม​ก่อน​เดา
แม้ peer จะ​ยุ่ง​แค่​ไหน ถ้า​คำถาม​เจาะจง​พอ คำตอบ​ก็​มา​ได้​เร็ว​พอที่จะ​คุ้ม​เวลา​ที่​เสีย​ไป​กับ​การ​รอ

แต่​การ​ได้ contract ที่​ถูกต้อง​ไม่​ได้​แปล​ว่า​ทาง​ข้างหน้า​จะ​โล่ง ตรงกันข้าม --- บท​ที่ 7
จะ​พา​ไป​เจอ blocker คู่​แรก​ของ session นี้​จริงๆ เริ่ม​จาก​สิ่ง​ที่​ไม่​มี​ใคร​คาดคิด​ว่า​จะ​เป็นปัญหา
--- repo ที่​ไม่​มี commit สัก​ตัว​เดียว แล้ว​ต่อ​ด้วย​บั๊ก​จริง​ใน​เครื่องมือ​เอง​ที่ maw-rs ต้อง
reproduce สดๆ เพื่อ​ยืนยัน​ว่า​ไม่​ใช่​ความผิดพลาด​ของ​ฝ่าย​ไหน​เลย แต่​เป็น​บั๊ก​ที่​ทุก​ทีม​ที่​ใช้
charter v2 มีสิทธิ์​เจอ​เหมือนกัน​หมด

= บท​ที่ 7: Blocker คู่​แรก --- Repo ว่างเปล่า และ Bug \#658
<บทท-7-blocker-คแรก-repo-วางเปลา-และ-bug-658>
แผน​ดูดี​บน​กระดาษ maw-rs ตอบ​ครบ​ทุก​ขั้น​แล้ว ตั้งแต่ charter contract v2
ไป​จนถึง​ลำดับ​คำสั่ง spawn ทีละ​ตัว --- เหลือ​แค่​ลงมือ​ทำตาม ผม​เปิด terminal
พร้อมกับ​ความมั่นใจ​เกิน​ร้อย ก่อน​จะ​เจอ error บรรทัด​แรก​ที่​ทำให้​แผน​ทั้งหมด​หยุดชะงัก​ทันที

`git log` บอ​กว่า branch main ไม่​มี commit เลย​สัก​ตัว --- นี่​มัน​คือ repo
ว่างเปล่า​ตัวจริง ไม่​ใช่​แค่​ยัง​ไม่​ได้ sync

พอ​แก้ปัญหา​นั้น​เสร็จ เขียน charter เสร็จ preflight เสร็จ กลับ​เจอ​ด่าน​ที่สอง​ที่​หนัก​กว่า​เดิม
path ที่​ควร​มี `agents/` prefix กลับ​หาย​ไป​ดื้อ​ๆ ตอนแรก​ผม​คิด​ว่า​ตัวเอง​พลาด --- cwd
หลุด, cd ค้าง, อะไร​สัก​อย่าง​ที่​ผม​ทำผิด​เอง แต่​พอ​ไล่​ตรวจ​จน​หมดทาง
ก็​เริ่ม​สงสัย​ว่า​ปัญหา​ไม่​ได้​อยู่​ที่​ตัวเอง​ต่างหาก

บท​นี้​คือ​เรื่อง​ของ blocker คู่​แรก​ที่​ทีม codex เจอ --- หนึ่ง​แก้​ได้​ด้วยมือ​ตัวเอง อีก​หนึ่ง​ต้อง​พึ่ง
peer คน​ที่สอง​มา reproduce สด​ถึง​จะ​ยืนยัน​ได้​ว่า​เป็น bug จริง
ไม่​ใช่​ภาพลวงตา​จาก​ความ​ไม่​ชำนาญ​ของ​คน​ถาม

== 7.1 "fatal: your current branch main does not have any commits yet" --- repo ว่างเปล่า​จริง
<fatal-your-current-branch-main-does-not-have-any-commits-yet-repo-วางเปลาจรง>
ขั้นแรก​ของ​แผน​คือ `git worktree add` เพื่อ​สร้าง worktree ให้ coder ตัว​แรก
แต่ก่อน​จะ​ไป​ถึง​ตรงนั้น ผม​เช็ค​สถานะ repo ตาม​นิสัย --- แล้วก็​เจอ:

```
$ git log --oneline -1
fatal: your current branch 'main' does not have any commits yet
$ git ls-remote origin
(nothing)
```

ไม่​มี commit สัก​ตัว ไม่​มี​อะไร​อยู่​บน origin เลย​ด้วยซ้ำ --- นี่​คือ repo
ที่​ยัง​ไม่​เคย​มี​ใคร​เขียน​อะไร​ลง​ไป​จริงๆ

ปัญหา​คือ `git worktree add` มัน​ไม่​สามารถ branch ออกจาก HEAD ที่ unborn ได้ ต่อให้
path ถูก ชื่อ branch ถูก ทุกอย่าง​ถูก​ตามที่ maw-rs บอก​ก็ตาม เพราะ​ยัง​ไม่​มี base ให้
branch ออก​ไป​ตั้งแต่แรก แล้ว​ปัญหา​ยัง​ไม่​จบ​แค่นั้น --- coder ที่จะ spawn มา​ต้อง​มี origin
content ให้ push กลับ​ไป​ด้วย ไม่งั้น​เปิด PR ไม่​ได้

ทางแก้​ตรงไปตรงมา สร้าง `README.md` ขั้นต่ำ commit แล้ว push ขึ้น origin main
จากนั้น​สร้าง​และ push branch `alpha` --- ตาม convention ของ​ทีม​ที่ว่า PR ต้อง​ชี้​เข้า
alpha เท่านั้น ห้าม​ชี้ main โดยตรง เท่านี้ repo ก็​มี​ฐาน​ให้ worktree ยึด​แล้ว

จุด​นี้​ยัง​ไม่​มี​อะไร​น่าสงสัย​ตัวเอง --- เพราะ error message มัน​ชัดเจน​อยู่แล้ว​ว่า​ปัญหา​คือ​อะไร
แก้​ตามนั้น​ตรงๆ ก็​จบ แต่​ด่าน​ถัดไป​ไม่​ง่าย​ขนาด​นั้น

== 7.2 preflight ล้มเหลว --- canonicalize path ที่​หาย agents/ prefix
<preflight-ลมเหลว-canonicalize-path-ทหาย-agents-prefix>
repo มี base แล้ว charter เขียน​เสร็จ​ตาม v2 contract แล้ว --- เหลือ​แค่​รัน
preflight เพื่อ​เช็ค​ก่อน spawn จริง แต่​ผลลัพธ์​กลับ​ไม่​ผ่าน:

```
$ maw team preflight ψ/teams/codex-fanout-team.yaml
✗ spawn ordering: worktree dirs missing before window create: codex-1=.../codex-fanout/codex-1
✗ codex trust: codex-1 cannot read trust config .../codex-fanout/codex-1/.codex/config.toml
```

สังเกต path ตรง `.../codex-fanout/codex-1` --- หาย `agents/` prefix ไป​ดื้อ​ๆ
ทั้งที่ charter เขียน​ไว้​ชัด​ว่า `worktree: agents/codex-1`

ปฏิกิริยา​แรก​ของ​ผม​คือ​โทษ​ตัวเอง​ก่อน​เลย คิด​ว่า​ต้อง​เป็น cwd ที่​หลุด​แน่ๆ --- บางที `cd` เข้า
worktree ตอน​ก่อนหน้า​อาจจะ​ลอย​ค้าง​อยู่​ใน shell แล้วไป​ปน​กับ​คำสั่ง​ถัดไป
เรื่อง​แบบนี้​เจอ​บ่อย​เวลา​สลับ context ไปมา​เร็ว​ๆ ผม​เลย​เปิด shell ใหม่ เช็ค `pwd` ให้
clean แล้ว​รัน​ซ้ำ

ยัง​พัง​เหมือนเดิม path เดิม prefix หาย​เหมือนเดิม

ตรง​นี้แหละ​ที่​ความสงสัย​เริ่ม​เปลี่ยน​ทิศ --- ถ้า cwd สะอาด​แล้ว​ยัง error แบบ​เดิม​ทุกครั้ง
แปล​ว่า​ปัญหา​ไม่​ได้​อยู่​ที่ shell state ของ​ผม​แล้ว แต่​คำถาม​คือ ผม​จะ​แน่ใจ​ได้​ยังไง​ว่า​นี่​ไม่​ใช่
typo เล็ก​ๆ ใน charter ที่​ตา​ผม​มองข้าม​ไป​เอง

== 7.3 maw-rs reproduce สด​บน charter ของ​ตัวเอง → filed \#658
<maw-rs-reproduce-สดบน-charter-ของตวเอง-filed-658>
จุด​ตัดสินใจ​ตรงนี้​สำคัญ --- ผม​ไม่​นั่ง​ไล่ debug เดี่ยว​ต่อ แต่ report กลับ​ไปหา maw-rs ทันที
เพราะ maw-rs เป็น​คนเขียน flow ให้​ตั้ง​แต่ต้น ถ้า​ใคร​จะ​ช่วย​ยืนยัน​ได้​ว่า​นี่​คือ bug
จริง​หรือ​ผม​พลาด​เอง ก็​ต้อง​เป็น​คน​นี้

maw-rs ไม่​ได้​เชื่อ​คำบอกเล่า​เฉย​ๆ แต่​เอา charter ของ​ตัวเอง​ไป​ลอง​รัน preflight ซ้ำ​สดๆ
--- และ​เจอ pattern เดียวกัน path หาย prefix เหมือนกัน​เป๊ะ ทั้งที่ charter คนละ​ไฟล์
คนละ session

ผลสรุป​จาก maw-rs: `maw team preflight` และ `maw team up` ทั้งคู่​มี bug ที่​ตัด
`agents/` prefix ออกจาก `worktree:`/`branch:` path ของ #strong[member
ตัว​สุดท้าย] ก่อน​จะ canonicalize --- เป็น bug จริง​ใน​ตัว tool เอง ไม่​เกี่ยวกับ
charter ของ​ใคร​ทั้งนั้น maw-rs filed เป็น #strong[\#658] ทันทีที่​ยืนยัน​ได้

ตรงนี้​คือ​หัวใจ​ของ​บท​เลย --- ถ้า​ผม​ยึด​สมมติฐาน​แรก​ไว้​ว่า "ต้อง​เป็น​ความผิด​ตัวเอง"
แล้ว​เสียเวลา​ไล่หา cwd bug ต่อไป​เรื่อยๆ คง​ไม่​มีทาง​เจอ​ทางออก
เพราะ​ปัญหา​ไม่​ได้​อยู่​ใน​มือ​ผม​ตั้งแต่แรก แต่​พอ​มี peer คน​ที่สอง reproduce ได้ผล​เดียวกัน​บน
environment ที่​ต่างกัน​โดยสิ้นเชิง นั่นแหละ​คือ​หลักฐาน​ที่​หนักแน่น​พอ​จะ​ฟันธง​ว่า​เป็น bug ของ
tool --- reproduce before you work around ไม่​ใช่​แค่​คำขวัญ​สวย​ๆ
แต่​คือ​ขั้น​ตอนที่​พา​ผม​ออกจาก​หลุมพราง​ความสงสัย​ตัวเอง​ได้​จริง

== 7.4 สาม​ทางแก้ --- reorder lead, outside-in repo-path, symlink (และ​อัน​ที่​เลือก​ใช้​จริง)
<สามทางแก-reorder-lead-outside-in-repo-path-symlink-และอนทเลอกใชจรง>
maw-rs เสนอ​ทางแก้​มา​สาม​แบบ​พร้อมกัน แต่ละ​แบบ​แก้ปัญหา​จาก​มุม​ต่างกัน

#strong[ทาง​ที่หนึ่ง --- reorder lead ใน members list.] ย้าย coder ให้​มา​ก่อน
lead ใน `members:` เพราะ lead มี `worktree:false` อยู่แล้ว ถ้า bug ไป​ตัด
prefix ของ lead ก็​ไม่​มีผล​อะไร เพราะ lead ไม่​มี worktree ให้​ตัด​ตั้งแต่แรก ---
วิธี​นี้​เลี่ยง bug ได้​แบบ​ไม่ต้อง​แตะ​โค้ด​เลย แต่​ก็​ผูก​กับ​ลำดับ member ใน​ไฟล์ ถ้า​ทีม​ขยาย​เป็น​หลาย
coder เมื่อไหร่​ก็​ต้อง​คอย​ระวัง​ลำดับ​ใหม่​อีก

#strong[ทาง​ที่สอง --- outside-in ด้วย repo-path ตรงๆ.] ข้าม `team up` ไป​เลย
แล้ว​ยิง​คำสั่ง​แบบ manual:

```bash
maw wake <role> --session <sess> --no-attach --repo-path <abs-path>
```

วิธี​นี้ bypass charter path parsing ไป​ทั้ง​เส้น เพราะ​ให้ absolute path ตรงๆ ไม่​ผ่าน
canonicalize ที่​มี bug

#strong[ทาง​ที่สาม --- symlink] คือ​ทาง​ที่​ผม​ใช้​จริง ใช้​ก่อนที่​คำยืนยัน​จาก maw-rs
จะ​มาถึง​ด้วยซ้ำ ตอนนั้น​ยัง​ไม่​รู้​ว่า \#658 ถูก filed แล้ว​หรือยัง แต่​คิด​ว่า​ถ้า path ที่ bug
สร้าง​มัน​หาย prefix ไป ก็​แค่​ทำให้ path นั้น "มี​อยู่​จริง" ซะ​เอง:

```bash
git worktree add agents/codex-1 -b agents/codex-1 origin/alpha
cd agents/codex-1 && bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts 5
printf '\n[projects."%s"]\ntrust_level="trusted"\n' "$PWD" >> .codex/config.toml
cd - && ln -s agents/codex-1 codex-1 && echo '/codex-1' >> .gitignore
maw team load ψ/teams/codex-fanout-team.yaml --no-spawn
maw team up codex-fanout-team --only codex-1
```

`ln -s agents/codex-1 codex-1` ที่ repo root คือ​กุญแจ --- path ที่ bug
พยายาม​อ่าน​โดย​ไม่​มี prefix นั้น กลายเป็น path จริง​ที่​ตาม​ได้​ทันทีที่ symlink มี​อยู่ ทำให้
canonicalize ผ่าน แล้ว `team up` ก็​ทำงานต่อ​ได้​ปกติ

ผลลัพธ์​คือ boot สำเร็จ​ตั้งแต่​ครั้งแรก​หลัง​ใส่ symlink:

```
╭────────────────────────────────────────────────────╮
│ >_ OpenAI Codex (v0.144.5)                         │
│ model:       gpt-5.6-sol xhigh   /model to change  │
│ directory:   .../agents/codex-1                    │
│ permissions: YOLO mode                             │
╰────────────────────────────────────────────────────╯
```

สาม​ทางแก้ สาม​มุมมอง​ต่อ bug เดียวกัน --- reorder คือ​เลี่ยง​จุด​ที่ bug อยู่ outside-in
คือ​ข้าม​ระบบ parsing ไป​ทั้ง​ชุด ส่วน symlink คือ​หลอก​ให้ path
ที่​ผิด​กลายเป็น​ถูก​โดย​ไม่ต้อง​แตะ charter หรือ​คำสั่ง​เดิม​เลย​สัก​บรรทัด --- เบา​ที่สุด​ใน​สาม​ทาง
เพราะ​ไม่ต้อง​เข้าใจ root cause ลึก​ก็​ใช้ได้​ทันที

== ปิด​บท
<ปดบท>
Blocker คู่​แรก​จบ​ลง​ด้วย​ผลลัพธ์​เดียวกัน --- coder boot ติด และ​พร้อม​รับงาน
แต่​สิ่ง​ที่​ค้าง​อยู่​ใน​ใจ​ไม่​ใช่​ตัว fix เลย เป็นจังหวะ​ที่​ผม​เกือบ​เสียเวลา​ไล่ debug
ตัวเอง​ต่อไป​เรื่อยๆ ทั้งที่​ปัญหา​ไม่​ได้​อยู่​ที่​ผม​ตั้งแต่แรก

บทเรียน​ตรงนี้​ย้อนกลับ​ไป​ที่ dna ของ​ทั้ง​บท --- reproduce before you work around bug
ที่​ยืนยัน​ได้​จาก​คน​ที่สอง บน environment ที่​ต่างกัน คือ bug จริง
ไม่​ใช่​แค่​คำบอกเล่า​จาก​คน​คนเดียว​ที่​อาจจะ​พลาด​เอง
ผม​เกือบ​เชื่อ​สมมติฐาน​แรก​ของ​ตัวเอง​ไป​แล้ว​ว่า​เป็น cwd mistake ทั้งที่ error message
เดิม​โผล่​ซ้ำ​ทุกครั้ง​แม้​เปิด shell ใหม่​แล้ว​ก็ตาม

แต่​ทีม​ยัง​ไม่​ได้​พัก​แค่นี้ --- coder boot ติด​แล้ว รับ dispatch แรก​ไป​ทำงาน​แล้ว​ด้วยซ้ำ
ปัญหา​ถัดไป​กลับ​ไม่​ใช่​เรื่อง infra หรือ tool bug อีกต่อไป แต่​เป็นเรื่อง​พื้นฐาน​กว่า​นั้น​มาก ---
จะ​ส่ง​ข้อความ​ไปหา​ใคร แล้ว​ที่อยู่​ที่​พิมพ์​ไป​นั้น มัน​คือ​ที่อยู่​จริง​หรือเปล่า บท​ที่ 8 จะ​พา​ไปดู
dispatch, probe, และ​ที่อยู่​ที่​ผิดตัว​นั้น

= บท​ที่ 8: Dispatch, Probe, และ​ที่อยู่​ที่​ผิด
<บทท-8-dispatch-probe-และทอยทผด>
charter เขียน​เสร็จ preflight เขียว​หมด coder บูต​ขึ้น​มา​เรียบร้อย​แล้ว ---
เหลือ​แค่​ทดสอบ​ว่า loop ทั้ง​เส้น​ทำงาน​จริง​ไหม จาก dispatch → coder ทำงาน → coder
รายงาน​กลับ ครบวงจร

แต่​ความ​เงียบ ๆ อันตราย​ที่สุด​ใน​ระบบ multi-agent ไม่​ใช่​ตอนที่ agent ทำงาน​ผิด
เป็น​ตอนที่​มัน​ทำงาน#strong[ถูก]ทุก​ขั้นตอน ยกเว้น​ขั้นตอน​สุดท้าย​ที่​ไม่​มี​ใคร​เห็น​จนกว่า error
message จะ​โผล่​ขึ้น​มา บท​นี้​คือ​เรื่อง​ของ probe task แรก​ของ codex-1 --- งาน​ง่าย ๆ
สี่​ขั้นตอน เขียน​ไฟล์ commit push เปิด PR --- ที่​ทำสำเร็จ​หมด​ทุกอย่าง
ก่อน​จะ​สะดุด​ที่​บรรทัด​สุดท้าย: การ​รายงาน​กลับ​ไป​ยัง "lead"

ปัญหา​คือ `lead` ที่ charter เขียน​ไว้​เป็น​แค่ label ใน YAML ไม่​ใช่​ที่อยู่​จริง​ใน​ระบบ tmux
เลย coder จึง​ยิง​ข้อความ​ไป​ที่ `codex-fanout:lead` --- ซึ่ง​ไม่​มี​อยู่​จริง แล้ว​ได้ error
กลับมา

จุด​ที่​น่าสนใจ​ไม่​ใช่ error เอง เป็น​สิ่ง​ที่ coder ทำ#strong[หลังจาก]เจอ error ต่างหาก
มัน​เริ่ม self-diagnose ด้วย​การ scan tmux ทั้ง​ฟ​ลี​ต​ทันที ---
วิธี​แก้​ที่​แพง​มาก​สำหรับ​ปัญหา​ที่​คำตอบ​มี​บรรทัด​เดียว นี่​คือ​บทเรียน​ที่​บท​นี้​จะ​พา​ไล่​ดู​ทีละ​จุด ตั้งแต่
probe task แรก ไป​จนถึง PR \#1 ที่ merge สำเร็จ ปิด loop ของ​ทั้ง​การทดลอง​นี้

== 8.1 Probe task แรก --- เขียน​ไฟล์ commit push PR
<probe-task-แรก-เขยนไฟล-commit-push-pr>
ก่อน​จะ​ให้ coder ทำงาน​จริง ต้อง​รู้​ก่อน​ว่า loop ทั้ง​เส้น​ใช้งาน​ได้​ไหม dispatch จึง​เป็น
task เล็ก​ที่สุด​เท่า​ที่จะ​ทดสอบ end-to-end ได้​ครบ​ทุก step:

```bash
maw hey codex-fanout:codex-1 'Probe task — verify the full loop works. In your worktree:
1. Create NOTES.md with "codex-1 online — probe ok". 2. commit. 3. push. 4. gh pr create
--base alpha --head agents/codex-1 --title "probe: codex-1 online".
Report back: maw hey codex-fanout:lead "done — PR #<N>"'
```

สี่​ขั้น​ตอนแรก​ไม่​มี​อะไร​ซับซ้อน สร้าง​ไฟล์ commit push เปิด PR ไป​ที่ `alpha` --- codex-1
ทำ​ครบ​ทุกอย่าง​ถูกต้อง​หมด ไฟล์​ถูก​สร้าง commit ถูก push PR \#1 เปิด​สำเร็จ
ถ้า​ดู​แค่​สี่​ขั้น​ตอนนี้​ก็​ต้อง​บอ​กว่า loop ทำงาน​สมบูรณ์แบบ

แต่ dispatch message มี​คำสั่ง​ขั้น​ที่​ห้า​ซ่อน​อยู่​ท้ายสุด --- "Report back" ไป​ที่
`codex-fanout:lead` ตรง​นี้แหละ​ที่​ทุกอย่าง​เริ่ม​พัง

== 8.2 codex-1 รายงาน​ผิดที่ (`codex-fanout:lead` ไม่​มี​จริง​ใน​ระบบ tmux)
<codex-1-รายงานผดท-codex-fanoutlead-ไมมจรงในระบบ-tmux>
charter เขียน role ของ lead ไว้​แบบนี้:

```yaml
members:
  - role: lead
    name: codex-fanout
```

`role: lead` เป็น​แค่ label ความหมาย​ทาง YAML --- ไว้​บอ​กว่า member
ตัว​นี้​ทำหน้าที่​อะไร​ใน​ทีม ไม่​ใช่ address จริง​ที่ tmux รู้จัก เมื่อ codex-1 ลอง​ส่ง​ข้อความ​ไป​ที่
`codex-fanout:lead` ตามที่ prompt บอก ผล​ที่​ได้​คือ:

```
Ran maw hey codex-fanout:lead 'done — PR #1'
  └ error: no window 'lead' in session 'codex-fanout'
    hint: windows: codex-fanout:1 (codex-fanout), codex-fanout:2 (codex-1)
```

tmux ไม่​รู้จัก role name เลย มัน​รู้จัก​แค่ index กับ window name เท่านั้น --- session
`codex-fanout` มี​สอง window จริง ๆ คือ `1` (ชื่อ `codex-fanout`) กับ `2` (ชื่อ
`codex-1`) ส่วน `lead` เป็น​คำ​ที่​มี​อยู่​เฉพาะ​ใน charter ไม่​เคย​แปลง​เป็น​ชื่อ window
เลย​สักครั้ง

ระบบ​ตั้งชื่อ​สอง​ระบบ --- charter role กับ tmux window ---
ดู​เหมือนกัน​แต่​ไม่​ใช่​สิ่ง​เดียวกัน แล้วก็​ไม่​มี​อะไร sync ทั้งสอง​ให้​ตรงกัน​อัตโนมัติ​ด้วย

== 8.3 การ​แก้​ที่​ตรงจุด แทน​ปล่อย​ให้ coder scan ทั้ง​ฟ​ลี​ต (context ของ coder มีค่า)
<การแกทตรงจด-แทนปลอยให-coder-scan-ทงฟลต-context-ของ-coder-มคา>
พอ error โผล่​ขึ้น​มา สิ่ง​ที่ codex-1 ทำต่อ​คือ self-diagnose --- เริ่ม
`tmux list-windows -a` scan ทั้ง​ฟ​ลี​ต ไม่​ใช่​แค่ session ของ​ตัวเอง

ฟัง​ดูเหมือน​ความพยายาม​ที่​ดี แก้ปัญหา​เอง​ไม่​รบกวน​ใคร แต่​จริง ๆ
แล้ว​นี่​คือ​ทางเลือก​ที่​แพง​ที่สุด​เท่า​ที่จะ​เลือก​ได้ coder แต่ละ​ตัว​มี context budget จำกัด การ
list-windows ทั้ง​ฟ​ลี​ต​หมายถึง​ต้อง parse ผลลัพธ์​ของ​ทุก session ทุก pane ใน​ระบบ
ทั้งที่​คำตอบ​จริง ๆ อยู่​ใน​บรรทัด​เดียว​ของ error message ที่​มัน​ได้รับ​ไป​แล้ว ---
`hint: windows: codex-fanout:1 (codex-fanout), codex-fanout:2 (codex-1)`

ปล่อย​ให้​มัน scan ต่อไป​เรื่อย ๆ ก็​คง​หา​คำตอบ​เจอ​เอง​ในที่สุด แต่​จะ​กินเวลา​และ context
ไป​มากกว่า​ที่​จำเป็น​หลายเท่า ใน​เมื่อ​คน​ที่ dispatch งาน​รู้​คำตอบ​อยู่แล้ว​ตั้ง​แต่ต้น การ​ปล่อย​ให้
coder เดา​ต่อ​จึง​ไม่​ใช่​ความเมตตา เป็นการ​สิ้นเปลือง resource ของ​มัน​เอง​ต่างหาก จึง
nudge ตรง ๆ แทนที่จะ​รอ:

```bash
maw hey codex-fanout:codex-1 'Your target is "codex-fanout:1", not "codex-fanout:lead".
Send: maw hey codex-fanout:1 "done — PR #1"
Rule: use `maw ls -v` or `tmux list-windows -t <session>` to find real targets —
charter role names are not guaranteed to equal tmux window names.'
```

ข้อความ​สั้น ให้ address ที่​ถูก​ไป​ตรง ๆ พร้อม​กฎ​ทั่วไป​ติด​ท้าย​ไว้​ด้วย --- เผื่อ coder
เจอ​สถานการณ์​แบบนี้​อีก​ในอนาคต จะ​ได้​ไม่ต้อง scan ทั้ง​ฟ​ลี​ต​ซ้ำ​อี​กรอบ

นี่​คือ​หลักการ​ที่​สำคัญ​ที่สุด​ของ​บท​นี้: เมื่อ lead รู้​คำตอบ​อยู่แล้ว การ​แก้​ที่​ตรงจุด​ถู​กก​ว่าการ​ปล่อย​ให้
coder ไปหา​เอง​เสมอ ยิ่ง​ทีม​มี coder หลาย​ตัว ยิ่ง​ต้อง​ระวัง​เรื่อง​นี้ --- context
ของ​แต่ละ​ตัว​คือ​ทรัพยากร​ที่​ต้อง​ประหยัด
ไม่​ใช่​ปล่อย​ให้​เผา​ไป​กับ​ปัญหา​ที่​มี​คำตอบ​อยู่แล้ว​ใน​มือ​ของ​อีก​ฝ่าย

== 8.4 PR \#1 merged --- ปิด loop สำเร็จ
<pr-1-merged-ปด-loop-สำเรจ>
codex-1 ตอบกลับ​ภายใน​ไม่​กี่​วินาที​หลัง nudge:
#strong[`[m5:codex-1] done — PR #1`]

loop ที่​ทดสอบ​ตั้งแต่ dispatch จนถึง report กลับ ตอนนี้ verified ครบวงจร​แล้ว เหลือ​แค่
merge:

```bash
gh pr merge 1 --squash    # probe PR merged
```

PR \#1 ปิด​ตัว​สำเร็จ ปิด loop ทั้ง​เส้น​ของ​การทดลอง​นี้ --- จาก charter ที่​เขียน​ตาม
contract v2 ผ่าน symlink workaround ของ blocker \#658 มา​จนถึง probe task
ที่​พิสูจน์​ว่า dispatch, ทำงาน, และ report กลับ ทำงาน​จริง​ใน​ระบบ

== ปิด​บท
<ปดบท-1>
ปัญหา​ของ​บท​นี้​ไม่​ใช่​เรื่องใหญ่ --- error message บรรทัด​เดียว แก้​ด้วย​ข้อความ​สอง​ประโยค
แต่​ความ​เงียบ​ของ​มัน​น่ากลัว​กว่า​ความ​ซับซ้อน ถ้า codex-1 ไม่​ได้​รายงาน error กลับมา​ให้​เห็น
หรือ​ถ้า​ปล่อย​ให้​มัน scan ทั้ง​ฟ​ลี​ต​ไป​เรื่อย ๆ โดย​ไม่​มี​ใคร nudge lead อาจ​ไม่​มีทาง​รู้​เลย​ว่า
probe สำเร็จ​จริง​หรือ​ค้าง​อยู่​ที่ไหน --- ระบบ multi-agent พัง​แบบ​เงียบ ๆ บ่อ​ยก​ว่าที่​คิด
จนกว่า​จะ​มี​คน error กลับมา​เตือน​เท่านั้น

บทเรียน​สรุป​สั้น ๆ: role label ใน charter ไม่​ใช่ address จริง เสมอ​ต้อง​แปลง​เป็น
tmux target ก่อน​บอก coder ให้​ไป​รายงาน และ​เมื่อ error เกิดขึ้น การ​แก้​ตรงจุด​จาก
lead ที่​รู้​คำตอบ​อยู่แล้ว ประหยัด​กว่า​ปล่อย​ให้ coder ไล่หา​เอง​เสมอ

ทั้ง​เส้นทาง​นี้ --- ตั้งแต่ blocker \#658 ไป​จนถึง​ที่อยู่​ผิด​ของ​บท​นี้ --- ถูก​พับ​เข้า skill
`codex-lead` เก็บ​ไว้​แล้ว บท​ถัดไป​จะ​พา​ไปดู​ว่า session ที่​เต็มไปด้วย​บทเรียน​เหล่านี้
ถูก​กลั่น​ให้​กลายเป็น skill ที่ session ถัดไป​หยิบ​มา​ใช้ได้​ทันที​โดย​ไม่ต้อง​ค้นพบ​ซ้ำ​ได้​อย่างไร

= บท​ที่ 9: จาก Session สู่ Skill
<บทท-9-จาก-session-ส-skill>
session หนึ่ง​จบ​ลง มี PR merge แล้ว มี coder ตัว​หนึ่ง​ทำงาน​สำเร็จ แต่​คำถาม​ที่​สำคัญ​กว่า​คือ
--- สิ่ง​ที่​เพิ่ง​เรียนรู้​มา จะ​อยู่​ที่ไหน​ต่อ ถ้า​ไม่​เขียน​ไว้​ที่ไหน​เลย ก็​หาย​ไป​พร้อม context window
ที่​ปิด​ตัว​ลง แล้ว session ถัดไป​ก็​ต้อง​เริ่ม​นับ​หนึ่ง​ใหม่ ทั้ง​ที่จริง​มี​คน​เดินผ่าน​หลุมพราง​นี้​มา​แล้ว

บท​นี้​เล่า​สิ่ง​ที่​เกิดขึ้น​หลังจาก PR \#1 merge --- ไม่​ใช่​ตอน​ที่ทำงาน​สำเร็จ
แต่​ตอนที่​ต้อง​เปลี่ยน​ความสำเร็จ​นั้น​ให้​เป็น​สิ่ง​ที่​คน​ถัดไป​หยิบ​ไป​ใช้ได้​จริง สาม​เรื่อง​เกิดขึ้น​ต่อกัน:
อัปเดต `codex-lead` skill ด้วย​ของจริง​ที่​เพิ่ง​พิสูจน์​ผ่าน​มา, ค้นพบ​ว่า dependency
ตัว​หนึ่ง​ของ skill นั้น​ไม่​เคย​อยู่​ใน git เลย แล้ว​ต้อง vendor เข้ามา, และ​สุดท้าย ---
self-audit ที่​จับได้​เอง​ว่า​เกือบ​ประกาศ​ว่า​งาน​เสร็จ ทั้งที่​ยัง​ไม่​ได้​เช็ค​ว่า dependency
นั้น​เข้าถึง​ได้​จริง​ไหม​สำหรับ​คนอื่น

ทั้ง​สาม​เรื่อง​ผูก​กัน​ด้วย​เส้น​เดียว --- ความรู้​ที่​ไม่​ถูก​เขียน​ไว้ ก็​เท่ากับ​ความรู้​ที่​หาย​ไป​พร้อม
session และ​การเขียน​ไว้ "ถูกที่" สำคัญ​พอ​ๆ กับ​การเขียน​ไว้ "ครบ" เพราะ doc ที่​ดีแต่
dependency เข้า​ไม่​ถึง ก็​ไม่​ต่าง​จาก doc ที่​ไม่​มี​อยู่เลย

== 9.1 อัปเดต codex-lead skill ด้วย​ของจริง ไม่​ใช่​ทฤษฎี
<อปเดต-codex-lead-skill-ดวยของจรง-ไมใชทฤษฎ>
`codex-lead` skill มี​อยู่​ก่อน​แล้ว เขียน​ไว้​ตั้งแต่​พิสูจน์​บน volt-codex2 (2026-06-24)
--- schema เก่า​มี `defaults: {worktree: true}` ใช้ shared engine key แบบ
`codex-t1..t6` แต่ session นี้​เพิ่ง​เรียนรู้​มา​ว่า contract จริง​ตอนนี้​ต่าง​ออก​ไป​โดยสิ้นเชิง
ไม่​มี `defaults.worktree` block แล้ว ทุก member ต้อง​ประกาศ `worktree:` กับ
`branch:` ของ​ตัวเอง engine command ก็​ไม่​ใช้ shared key แต่ inline ใต้
`engines:` เรียก `codex-setup.ts <N>` ตรงๆ เพื่อ​ให้ได้ worktree-local
`CODEX_HOME`

ถ้า​ไม่​อัปเดต skill ให้​ตรง​กับ​ของจริง --- session ถัดไป​ที่มา​อ่าน `codex-lead` ก็​จะ​เจอ
schema เก่า เขียน charter ผิด แล้ว "ดู​สมเหตุสมผล" (plausible) แต่ fail
ใน​จุด​ที่​งง​กว่า​เดิม นี่​คือ​ประโยค​ที่ AI Diary เขียน​ไว้​ตรงๆ: "it would have looked
plausible and failed in a more confusing way later" --- คือ​ปัญหา​ไม่​ใช่​แค่​ผิด
แต่​ผิด​แบบ​ที่​ดูเหมือน​ถูก

สิ่ง​ที่​เพิ่ม​เข้าไป​ใน SKILL.md จริง​คือ section ที่ 8 ทั้ง section --- "Fast path ---
exactly 1 codex coder, specific pool/account N" มี​ตั้งแต่ charter YAML
แบบ​เต็ม ไป​จนถึง known bug ของ maw-rs (\#658 --- last-member `agents/`
prefix ถูก strip ทิ้ง​ตอน canonicalize path) พร้อม workaround สาม​แบบ​ให้​เลือก
ไม่​ใช่​แค่​คำอธิบาย​ลอยๆ แต่​เป็น command ที่ copy ไป​รัน​ได้​ตรงๆ รวมถึง gotcha เล็ก​ๆ
ที่​คนอ่าน skill เดิม​ไม่​มีทาง​รู้ --- เช่น "report-back target ต้อง​เป็น tmux window
index จริง ไม่​ใช่ role name จาก charter" ซึ่ง​เป็นเรื่อง​ที่ coder ตัวเอง​เจอ​แล้ว​เสีย
context ไปหา​คำตอบ​เอง

นี่​คือ​ความหมาย​ของ dna บท​นี้​ตรงตัว --- เขียน workaround ไว้​ตรง​ที่ session
เย็น​ถัดไป​จะ​ไป​เจอ ไม่​ใช่​เขียน​แยก​ไว้​เป็น log ที่​ไม่​มี​ใคร​กลับมา​อ่าน

== 9.2 Vendor oracle-team skill --- dependency ที่​ไม่​เคย​อยู่​ใน git มา​ก่อน
<vendor-oracle-team-skill-dependency-ทไมเคยอยใน-git-มากอน>
engine command ใน charter section 8 เรียก
`bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts N` --- ดู​เผินๆ
ก็​เป็น​แค่​บรรทัด​เดียว​ใน​ตัวอย่าง แต่​บรรทัด​นี้​ชี้​ไป​ที่ path บน​เครื่อง​ของ​คนเขียน​เอง
`~/.claude/skills/oracle-team/` ไม่​เคย​อยู่​ใน git repo ไหน​เลย มัน​อยู่​แค่​ใน home
directory ของ​เครื่อง m5

พอ user ถาม​กลับมา​ตอน 19:20 ว่า "\$HOME/.claude/skills/oracle-team too?"
--- คำถาม​สั้น​ๆ นี้แหละ​ที่​เปิดโปง​ช่องโหว่​ทั้งหมด เพราะ skill ที่​เพิ่ง​อัปเดต​เสร็จ
อ้างอิง​ถึง​สคริปต์​ที่​ไม่​มี​ใคร​อื่น​เข้าถึง​ได้​เลย ต่อให้ charter เขียน​ถูก​ทุก​บรรทัด ก็​รัน​ไม่​ได้​ถ้า​ไม่​มี
`codex-setup.ts`

งาน​ที่​ตามมา​คือ vendor ทั้ง​ชุด --- copy `codex-setup.ts` พร้อม​สคริปต์​พี่น้อง​อีก 3 ตัว
และ SKILL.md ของ `oracle-team` เข้ามา​ไว้​ใน `.claude/skills/oracle-team/`
ของ repo `codex-fanout` เอง (commit `eca78eb`) จาก​ที่​เคย​อยู่​แค่ local ใต้
`~/.claude` --- กลายเป็น​ส่วนหนึ่ง​ของ repo ที่ push ขึ้น origin ได้​จริง

จุด​ที่​น่าสนใจ​คือ ไม่​ใช่​แค่ "ลืม vendor" --- แต่​เป็น​รูปแบบ​ที่เกิด​ซ้ำ​ได้​ง่าย​มาก เวลา​เขียน
skill หรือ doc อะไรก็ตาม​ที่​อ้างอิง path ใต้ home directory ของ​ตัวเอง
คนเขียน​จะ​ไม่​รู้สึก​ผิดปกติ​เลย เพราะ​ทดสอบ​เอง​แล้ว​รัน​ผ่าน --- ตัวเอง​มี path นั้น​อยู่แล้ว
แต่​คนอื่น​ไม่​มี ความรู้สึก "มัน​รัน​ได้" กับ "มัน​รัน​ได้​สำหรับ​ทุกคน" เป็น​คนละเรื่อง​กัน
แต่​สมอง​มักจะ​ปน​กัน​โดยไม่รู้ตัว

== 9.3 ทำไม private repo ถึง​เท่ากับ "ไม่​มี​อะไร​เลย" สำหรับ community
<ทำไม-private-repo-ถงเทากบ-ไมมอะไรเลย-สำหรบ-community>
vendor dependency เข้า repo แล้ว​ยัง​ไม่​จบ เพราะ​มี doc อีก​ตัว​ที่​เขียน​คู่​กัน​มา ---
`CODEX-TEAM-BOOTUP.md` เป็นการ​เล่าเรื่อง​แบบ​ละเอียด​สำหรับ community อ่าน
ตั้งใจ​ให้​เป็น "reproducible" คือ​คนอื่น​อ่าน​แล้ว​ทำตาม​ได้​จริง ไม่​ใช่​แค่​เล่า​ว่า​เคย​ทำ​อะไร​มา

แต่ repo `codex-fanout` ที่ doc นี้​อยู่ --- ถ้า​ยัง​เป็น private ต่อให้​เขียน​ละเอียด​แค่​ไหน
มี command ครบ​ทุก​บรรทัด มี charter YAML เต็ม​รูปแบบ มี known bug พร้อม workaround
สาม​แบบ ก็​เท่ากับ​ไม่​มี​อะไร​เลย​สำหรับ​คนนอก เพราะ​เปิด​ลิงก์​เข้ามา​แล้ว​เจอ 404 หรือ
permission denied ทันที ไม่​ต่าง​จาก doc ที่​ไม่​เคย​เขียน

ความ​ย้อน​แย้ง​อยู่​ตรงนี้ --- งาน​ทุก​ขั้น​ตอนที่​ทำ​มา​ตลอด​บท​ที่ 9 คือ​พยายาม​ทำ​ให้ความรู้
"เข้าถึง​ได้" ต่อ​จาก​ตัวเอง อัปเดต skill ให้​ตรง​กับ​ของจริง, vendor dependency
ที่​หาย​ไป, เขียน narrative doc ให้​ครบ --- แต่​ทุก​อย่างนั้น​ตั้งอยู่​บน repo เดียว​ที่​ยัง gate
ไว้​ด้วย private visibility คนเขียน​อาจ​มองว่า​งาน​เสร็จ​แล้ว​เพราะ​เช็ค​ทุก​จุด​ใน​เนื้อหา
แต่​ลืม​เช็ค​จุด​ที่อยู่​นอก​เนื้อหา --- คือ ใคร​เปิด​เข้ามา​ดู​ได้​บ้าง

Next Steps ใน​ไฟล์ retro เขียน​ไว้​ตรงๆ ว่า "Decide which community channel to
post `CODEX-TEAM-BOOTUP.md` to (Discord/LINE/etc. --- still waiting on
user input)" --- นั่น​คือ ต่อให้ doc พร้อม​แค่​ไหน การ​จะ​ให้ community เห็น​ได้​จริง
ต้อง​มี​สอง​เงื่อนไข​พร้อมกัน หนึ่ง​คือ​เนื้อหา​ถูกต้อง​และ reproducible, สอง​คือ visibility
เปิด​ให้​เข้าถึง ขาด​ข้อ​ใด​ข้อ​หนึ่ง​ไป ก็​เท่ากับ​ยัง​ไม่​ได้ ship

== 9.4 Self-Audit --- รู้ทัน​ความมั่นใจ​เกิน​จริง​ของ​ตัวเอง
<self-audit-รทนความมนใจเกนจรงของตวเอง>
ท้าย​บท retro มี block "🔍 Self-Audit" ที่​เขียน​ไว้​ตรงๆ ไม่​อ้อมค้อม บรรทัด​สุดท้าย​ของ
block นั้น​คือ​คำตอบ​ของ​ทั้ง​บท​นี้:

#quote(block: true)[
"rationalizations caught: 1 --- nearly declared the writeup 'done'
without verifying its cited dependency was actually reachable outside my
own machine; caught only because the user asked"
]

ประโยค​นี้​สำคัญ​ตรง​คำ​ว่า "nearly declared" กับ "caught only because the user
asked" --- ไม่​ใช่​ว่า​ไม่​มี rationalization เกิดขึ้น แต่​มัน​เกิดขึ้น​จริง
เกือบไป​ถึง​จุด​ที่ประกาศ​ว่า​งาน​เสร็จ​แล้ว ก่อนที่ user จะ​ถาม​คำถาม​เดียว
"\$HOME/.claude/skills/oracle-team too?" --- ถ้า user ไม่​ถาม
ก็​คง​ไม่​มี​ใคร​จับได้​เอง

AI Diary เขียน​ขยายความ​ไว้​อีก​ชั้นหนึ่ง​ว่า "I also almost stopped at 'the writeup
is done' before the user asked about `oracle-team`… The user's question
caught something I should have caught myself while writing the
'reproducible' doc." --- ตรง​นี้แหละ​คือ​จุด​ที่​ต่าง​จาก​การทำงาน​ทั่วไป เพราะ​คำ​ว่า
"reproducible" ถูก​เขียน​ไว้​ใน​ใจ​ตั้ง​แต่ต้น แต่​ไม่​ได้​ตรวจสอบ​มัน​จริง​จนกว่า​จะ​มี​คนอื่น​มา​ถาม

Self-Audit block ยังมี​อีก​จุด​หนึ่ง​ที่​น่าสนใจ คือ "uncomfortable truth" --- \[→
AGENT DECISION\] assumed a tool-path error was my own cwd mistake before
considering it might be a real bug in `maw`, costing a round-trip I
didn't need to spend --- เป็น​ความผิดพลาด​คนละ​แบบ​กับ​เรื่อง dependency
แต่​ราก​เดียวกัน คือ​ความมั่นใจ​ว่า​ตัวเอง​รู้​แล้ว โดย​ไม่​เช็ค​สมมติฐาน​ให้​ครบ​ก่อน ครั้งแรก​มั่นใจ​ว่า
"ฉัน​ต้อง​พิมพ์ path ผิด​เอง" ทั้งที่ error message ระบุ path เจาะจง​มาก ครั้ง​ที่สอง​มั่นใจ​ว่า
"doc เขียน​เสร็จ​แล้ว" ทั้งที่​ยัง​ไม่​เช็ค​ว่า dependency เข้าถึง​ได้​จริง​ไหม

ทั้งสอง​ครั้ง​มี​รูปแบบ​เดียวกัน --- สมมติฐาน​ที่​สะดวก​ที่สุด​สำหรับ​ตัวเอง
มัก​ไม่​ใช่​สมมติฐาน​ที่​ถูกต้อง​ที่สุด​สำหรับ​งาน การ​มี block self-audit
บังคับ​ให้​ตอบคำถาม​พวก​นี้​ตรงๆ ท้าย session ทุกครั้ง จึง​ไม่​ใช่​พิธีกรรม แต่​เป็น​กลไก​จับ
rationalization ที่​ไม่​มี​ใคร​จับ​ให้ได้ ถ้า​ไม่​มี​ใคร​ถาม​พอดี

#line(length: 100%)

บท​ที่ 9 จบ​ด้วย​บทเรียน​ที่​ย้อน​กลับมา​ที่​ตัว session-lead เอง --- ทำงาน​เสร็จ​ไม่​ใช่​จุดจบ
เพราะ​ความรู้​ที่​ทำสำเร็จ​แล้ว​ยัง​ต้อง​เดินทาง​ไป​ถึง​คน​ถัดไป​ให้ได้ ทั้ง​ใน​รูป​ของ skill
ที่​อัปเดต​ด้วย​ของจริง, dependency ที่ vendor เข้ามา​ให้​เข้าถึง​ได้, doc ที่ visibility
เปิด​จริง และ self-audit ที่​ไม่​ปล่อย​ให้​ความมั่นใจ​เกิน​จริง​หลุด​ผ่าน​ไป​โดย​ไม่​มี​ใคร​ถาม

บท​ที่ 10 ซึ่ง​เป็น​บท​สุดท้าย​ของ​หนังสือ​เล่ม​นี้ จะ​รวบ​ทุกอย่าง​ที่ผ่านมา​ทั้ง​เก้า​บท​ให้​เป็น Decision
Framework และ Quick Reference --- เวลา​ต้อง​ตัดสินใจ​กลางดึก​ว่า​จะ cold consult
ใคร จะ escalate ตอน​ไหน จะ vendor อะไร​ก่อน ship จะ​ไม่ต้อง​พลิก​กลับมา​อ่าน​ทั้ง​เล่ม​อีก
แค่​เปิด​บท​สุดท้าย​บท​เดียว​ก็​พอ

= บท​ที่ 10: Decision Framework และ Quick Reference
<บทท-10-decision-framework-และ-quick-reference>
เก้า​บท​ที่ผ่านมา เล่าเรื่อง cold consult หนึ่ง​เซ​ส​ชัน ตั้งแต่ zero context จนถึง bug
report ที่ maw-rs รับ​ไป​แก้​จริง แต่​บท​นี้​ไม่​ใช่​การ​เล่า​ซ้ำ ---
เป็น​การบีบ​ทุกอย่าง​ให้​เหลือ​ท​รี​ตัดสินใจ​ต้น​เดียว ใช้ได้​ก่อน spawn ครั้ง​ถัดไป
ไม่​ว่า​จะ​อ่าน​เล่ม​นี้​จาก​บท​ไหน​มา​ก็ตาม

คำถาม​ที่​ทีม​ใหม่​ทุก​ทีม​เจอ​เหมือนกัน​คือ "จะ spawn กี่​ตัวดี" คำตอบ​ไม่​ได้​อยู่​ที่ scale สูงสุด​ที่​ทำได้
แต่​อยู่​ที่ scale ที่​พอดี​กับ​งาน --- solo ก็​พอ​สำหรับ​งาน​เล็ก, trio สำหรับ​งาน​ที่ decompose
ได้​จริง, swarm สำหรับ​งาน​ที่​นับ task ได้​แล้ว​เท่านั้น การ​เลือก​ผิด​ฝั่ง​ไม่​ได้​แปล​ว่า fail
เสมอไป แต่​แปล​ว่า waste --- เวลา​ของ ting ที่​เสีย 45 นาที​เพราะ spawn fleet
เต็ม​ก่อน test หนึ่ง​ตัว, เวลา 3 ชั่วโมง​ของ maw-rs ที่ recovery จาก shared
CODEX\_HOME, และ​เวลา 2 ชั่วโมง​ของ transcriber ที่ reconcile งาน​ซ้ำ --- ทั้งหมด​นี้
recoverable ก็​จริง แต่​ไม่​จำเป็นต้อง​จ่าย​ทุกครั้ง​ถ้า​เดิน​ท​รี​ให้​ถูก

ภาค 2 ของ​เล่ม​นี้​เพิ่ม​บทเรียน​อีก​ชั้นหนึ่ง​ที่​ภาค 1 ไม่​มี --- เรื่อง​ของ "ใคร​มี​ข้อมูล​ปัจจุบัน​ที่สุด"
เมื่อ session เริ่ม​จาก zero context จริง ๆ guidebook ก็ดี decision tree ก็ดี
ล้วน​เป็น snapshot ของ​วันที่​เขียน แต่ peer ที่​กำลัง dispatch งาน​อยู่​ตอนนั้น​คือ​คน​ที่​รู้
contract ปัจจุบัน​ที่สุด บท​นี้​จะ​รวม​ทั้งสอง​ภาค​เข้าด้วยกัน --- ท​รี​ตัดสินใจ​จาก​ภาค 1 บวก
checklist cold-start จาก​ภาค 2

== 10.1 Scope/Size Branch --- เมื่อไหร่ solo พอ เมื่อไหร่​ต้อง trio/swarm
<scopesize-branch-เมอไหร-solo-พอ-เมอไหรตอง-trioswarm>
คำถาม​แรก​ก่อน​ถาม​ว่า "pattern ไหน" คือ งาน bounded หรือยัง งาน bounded คือ​รู้
output type รู้ input file รู้ acceptance test ชัดเจน งาน ill-bounded คือ
scope ยัง​ไม่​นิ่ง มี subtask โผล่​มา​เรื่อย ๆ ระหว่าง​ทำ --- ถ้า​ยัง​ไม่ bounded ห้าม​ข้าม​ไป
spawn ทันที ต้อง​มี discovery phase ก่อน​เสมอ agent เดียว read-only ผลิต task
manifest ออกมา แล้ว​ค่อย​กลับ​เข้า​ท​รี​ใหม่

เมื่อ​งาน bounded แล้ว คำถาม​ถัดไป​คือ scope กว้าง​แค่​ไหน

#strong[Solo --- ไฟล์​เดียว, diff ต่ำกว่า 50 บรรทัด] นี่​คือ default งาน​เล็ก
overhead ของ agent เพิ่ม​เข้ามา​ทุก​ตัว​ไม่​ใช่​ศูนย์ --- spawn latency, context
injection, result collection --- สำหรับ patch 20 บรรทัด overhead
นั้น​มากกว่า​ตัว​งาน​เอง อย่า spawn trio เพราะ "สาม​มุมมอง​ดีกว่า​หนึ่ง" ถ้า​งาน​เล็ก​จริง
มุมมอง​ที่สาม​ไม่​ได้​เพิ่ม​คุณภาพ​ที่วัด​ได้ แต่​เพิ่ม wall-clock 3 เท่า

#strong[Trio --- 2 ถึง 5 subtask ที่ independent จริง คนละ​ไฟล์] independent
ที่นี่​หมายถึง agent A ทำ​เสร็จ​ได้​โดย​ไม่ต้อง​อ่าน output ของ agent B ถ้า subtask
แตะ​ไฟล์​เดียวกัน นั่น​ไม่​ใช่ parallel แล้ว เป็น sequential ที่​แกล้ง​ทำเป็น parallel ---
ผล​คือ merge conflict วิ​นัยสำคัญ​คือ decompose ก่อน dispatch เขียน subtask list
ออกมา​ก่อน เช็ค​ว่า​ไม่​มี​สอง​งานเขียน​ไฟล์​เดียวกัน แล้ว​ค่อย fork

#strong[Tournament --- เมื่อ​คุณภาพ​สำคัญ​กว่า​ความเร็ว] รัน 3 agent บน prompt
เดียวกัน แล้ว​เลือก​ที่​ดี​ที่สุด ไม่​ใช่ pattern สำหรับ​ความเร็ว แต่​สำหรับ​ความหลากหลาย​ของ
solution เก็บ​ไว้​ใช้กับ​งาน​ที่ revert ยาก เช่น public API หรือ​โค้ด​ที่​กระทบ​ความปลอดภัย
แต่ tournament ไม่​ใช่​เครื่องมือ debug --- สาม agent ที่​เห็น error message
เดียวกัน​มัก​หลงทาง​เหมือนกัน​หมด

#strong[Swarm/Workflow subagents --- เมื่อ​นับ task ได้​เกิน 100 แล้ว​เท่านั้น] ห้าม
spawn swarm ก่อนที่จะ enumerate task list ได้ นี่​คือ​บทเรียน​ที่​หนัก​ที่สุด --- swarm ที่
dispatch ก่อน​มี manifest จะ duplicate งาน, miss งาน, หรือ​ชน shared state กัน
สำหรับ​งาน​เบา 100+ ชิ้น​ที่ I/O isolate ได้ ใช้ workflow subagents ผ่าน queue
สำหรับ​งานหนัก​ที่​ชน rate limit ใช้ five teams rotating ข้าม API key
แต่​ทั้งสอง​แบบ​ต้อง​มี manifest ก่อน​เสมอ ไม่​มี manifest ไม่​มี swarm

โปรเจกต์​จริง​มัก​ไม่ fit pattern เดียว --- discovery ด้วย solo หนึ่ง​ตัว แล้ว​แบ่ง
manifest เป็น​กลุ่ม​ตาม pattern ที่​เหมาะ กลุ่ม​งาน​เล็ก​จำนวนมาก​ไป​ที่ workflow
subagents กลุ่ม​งาน critical ไป​ที่ tournament กลุ่ม architecture ไป​ที่ trio จบ​ด้วย
integration solo หนึ่ง​ตัว​รวม​ทุกอย่าง​เข้าด้วยกัน --- แต่ละ​ชั้น​ใช้ pattern ขั้นต่ำ​ที่ fit
กับ task class ของ​มัน​เท่านั้น ไม่​มี​ชั้น​ไหน​ได้ overhead เกิน​จำเป็น

== 10.2 Command Glossary ที่​ใช้​บ่อย​ที่สุด
<command-glossary-ทใชบอยทสด>
ห้า​คำสั่ง​นี้​ครอบคลุม​วงจรชีวิต​ของ​ทีม​ทั้งหมด ตั้ง​แต่ก่อน spawn จนถึง teardown

```bash
# 1. Fleet status — เช็คก่อนทุกอย่าง
maw ls -v
# columns: ENGINE, STATUS, TRUST, CODEX_HOME, LAST_SEEN
# ไม่ใช่ OK/TRUSTED — ห้าม spawn

# 2. Preflight — เงื่อนไขเดียวที่ปลอดภัยให้ launch
maw team preflight ψ/teams/<file>.yaml   # PATH form — ใช้ตอน script/CI
maw team up trio-alpha                    # NAME form — ใช้ตอน interactive หลัง trust ตั้งแล้ว

# 3. Spawn
maw team up <name>                        # ทั้งทีม ตามลำดับ dependency
maw team up <name> --only <role>          # role เดียว — ใช้ตอน coder ตัวเดียวตาย ไม่ต้อง respawn ทั้งทีม

# 4. Dispatch
maw hey <session>:<coder> '<task>'
# single-quote task กัน shell expansion
# fire-and-observe ไม่ใช่ fire-and-forget — peek ทันทีหลัง dispatch

# 5. Monitor
maw peek <session>:<coder>
# read-only tail, exit ด้วย q หรือ Ctrl-C
# ใช้ถี่ ๆ ใน 5 นาทีแรกหลัง dispatch — ปัญหาที่จับได้นาทีที่สองไม่มีต้นทุน
# ปัญหาที่จับได้ชั่วโมงที่สองกินทั้ง context window ของ coder

# 6. Teardown
maw tmux kill "<session>:<window>"
# ควอตนี้กัน shell word-splitting บน colon
# kill ก่อน respawn เสมอ — zombie pane ชื่อชนกับ spawn ใหม่ ทำให้ attach เข้า session เก่าโดยไม่รู้ตัว
```

`maw hey` มี​จุด​ที่​คน​ใหม่​มัก​พลาด --- ส่ง​ไป​แล้ว​คิด​ว่า​จบ แต่ dispatch เงียบ ๆ ล้มเหลว​ได้
ถ้า tmux pane scroll เลย injection point หรือ coder ค้าง​อยู่​ที่ interactive
prompt วิธี​เดียว​ที่​รู้​คือ peek ทันที ไม่​ใช่​รอ

ส่วน `maw hey` ข้าม oracle --- ข้อมูล​จาก​ภาค 2 --- ใช้ address ต่าง​ออก​ไป
แต่​หลักการ​เดียวกัน คือ fire แล้ว observe ไม่​ใช่ fire แล้ว​ลืม peer ที่​กำลัง busy
dispatch งาน​ตัวเอง​อยู่​ก็​ยัง​ตอบ​ได้​ระหว่าง step ของ​มัน --- ไม่ต้อง​รอ idle ไม่ต้อง
share context ล่วงหน้า

== 10.3 Checklist ก่อน spawn จริง
<checklist-กอน-spawn-จรง>
Checklist นี้​รวม​จาก​ทั้งสอง​ภาค --- foundations (หก​ขั้น​ก่อน spawn) บวก lesson จาก
cold consult ใน​ภาค 2 (verify ว่า​ข้อมูล​ที่​อ้างอิง​ยัง​ทันสมัย และ​ทุก dependency
reachable จริง)

#strong[ก่อน spawn ครั้งแรก​ของ session]

+ `maw ls -v` --- ทุก engine ต้อง OK/TRUSTED ก่อน
+ Charter YAML ต้อง​ประกาศ​ทุก role พร้อม map ไป​ยัง engine ที่​มี​จริง --- เช็ค​ด้วย
  `yq e '.' ψ/teams/<file>.yaml` ก่อน เพราะ YAML พัง​หน้าตา​เหมือน engine
  error
+ Engine ที่​อ้าง​ใน charter ต้อง register ใน maw config แล้ว ---
  `maw engine add` ถ้า​ยัง​ไม่​มี
+ ทุก CODEX\_HOME ต้อง​มี `config.toml` grant trust --- ไม่​มี trust แปล​ว่า
  engine spawn แล้ว halt รอ confirm ที่​ไม่​มี​วัน​มา
+ Branch แยก​สำหรับ session นี้​ต้อง​มี​อยู่ --- coder ที่ spawn บน main แล้ว commit
  ตรง คือ​ต้นตอ merge disaster ที่​หนัก​ที่สุด
+ `git status` สะอาด, `git stash list` ว่าง​หรือ​รู้​ที่มา --- working tree
  สกปรก​ตอน spawn ทำให้ coder ทุก​ตัว​อ่าน status แล้ว​สับสน​ว่า​มัน​คือ conflict
  จริง​หรือเปล่า
+ `maw team preflight` ต้อง GREEN --- ถ้า non-zero ห้าม spawn แก้​ก่อน รัน​ใหม่
  จน GREEN ค่อย spawn

#strong[เพิ่ม​จาก cold-start / peer consult (ภาค 2)]

#block[
#set enum(numbering: "1.", start: 8)
+ ถ้า​มี peer oracle ที่​เพิ่ง​ทำ stack เดียวกัน​มา​สด ๆ ถาม​ก่อน​เขียน charter
  จาก​ความจำ​หรือ doc เก่า --- doc ที่​เขียน​ไว้​วันก่อน​กับ contract ปัจจุบัน​ของ tool
  ต่างกัน​ได้​เสมอ (เคส​จริง --- guidebook บอ​กว่า​มี `defaults.worktree` block แต่
  contract ปัจจุบัน​ใช้ setup script แยก worktree-local CODEX\_HOME แทน)
+ ก่อน​ถือว่า doc หรือ setup step "reproducible" ให้ list ทุก
  script/config/binary ที่​มัน​อ้าง​ถึง แล้ว​เช็ค​ว่า reachable จาก​นอก​เครื่อง/session
  ของ​คนเขียน​จริง​หรือไม่ --- สคริปต์​ที่อยู่​แค่​บน​เครื่อง local ไม่​เคย​เข้า git repo
  คือ​ช่องโหว่​ที่​มองไม่เห็น​จน​มี​คน​ถาม​ว่า "ไฟล์​นี้​อยู่​ไหน"
+ ถ้า tool คืน error ที่ path ไม่​ตรง​กับ input (เช่น prefix หาย​ไป​เงียบ ๆ)
  ให้​ปฏิบัติ​เหมือน​เป็น bug จริง​ที่​ควร reproduce และ report ไม่​ใช่​รีบ​สรุป​ว่า​เป็น​ความผิด
  cwd ของ​ตัวเอง --- reproduce ซ้ำ​บน charter ที่สอง​อิสระ​จากกัน แล้ว report
  มัก​เร็ว​กว่า​นั่ง workaround คนเดียว​ต่อไป
]

#strong[Smoke test --- ก่อน scale ไป​ทีม​ใหญ่]

ก่อน spawn full fleet เสมอ ต้อง​มี smoke test อย่าง​น้อย​หนึ่ง agent หนึ่ง task
ผ่าน​ก่อน ทีม 20 ตัว​ที่ spawn พร้อมกัน​โดย​ไม่​เช็ค prompt ก่อน จะ​ได้ output
ผิด​แบบ​เดียวกัน​ทั้ง 20 ตัว --- ตรวจ​แค่​ตัว​เดียว​ถูก​กว่า​ตรวจ 20 ตัว​ทีหลัง​เสมอ

== 10.4 บทส่งท้าย --- ทีม​ถัดไป​ควร​เริ่ม​จาก​บท​ไหน
<บทสงทาย-ทมถดไปควรเรมจากบทไหน>
เล่ม​นี้​แบ่ง​เป็น​สอง​ภาค​จริง --- foundations ที่​ให้​ท​รี​ตัดสินใจ pattern และ case study
ที่​เล่า cold consult จริง​หนึ่ง​เซ​ส​ชัน
ทีม​ที่มา​อ่าน​เล่ม​นี้​ครั้งแรก​ไม่​จำเป็นต้อง​อ่าน​เรียง​จาก​บท​หนึ่ง คำถาม​ที่​ควร​ถาม​ตัวเอง​ก่อน​คือ
"ตอนนี้​ฉัน​อยู่​จุด​ไหน​ของ workflow"

ถ้า​ยัง​ไม่​เคย spawn ทีม​เลย ยัง​ไม่​มี charter YAML ใน​มือ --- เริ่ม​ที่ 10.3 checklist
ก่อน แล้ว​ย้อนกลับ​ไปดู​บท​ที่​อธิบาย charter format ใน​ภาค​แรก
จะ​ประหยัดเวลา​กว่า​ไล่​อ่าน​ทุก​บท

ถ้า​มี​ทีม​แล้วแต่​ไม่​แน่ใจ​ว่า​ควร spawn กี่​ตัว​สำหรับ​งาน​ตรงหน้า --- กลับมา​ที่ 10.1
เดิน​ท​รี​ให้​จบ​ก่อน แล้ว​ค่อย​เปิด command glossary ใน 10.2 ประกอบ

ถ้า​กำลังจะ​เริ่ม session จาก zero context จริง ๆ --- ไม่​มี handoff ไม่​มี​ความจำ
session ก่อนหน้า --- นี่​คือ​จุด​ที่​ภาค 2 มีค่า​ที่สุด บทเรียน​สำคัญ​คือ อย่า​เชื่อ doc เก่า​เกิน​กว่า​ที่
peer สด​จะ​บอก​ได้ ถ้า​มี oracle อื่น​ใน​เครือข่าย​ที่​แตะ stack เดียวกัน​มา​ไม่​นาน ถาม​ก่อน​เขียน
อย่า​เขียน​จาก​ความจำ

สิ่ง​ที่​ทีม​ถัดไป​ควร​ทำต่อ ไม่​ใช่​แค่​ท่อง​ท​รี​ตัดสินใจ​ให้​ขึ้นใจ แต่​คือ​การ​วัด --- ทุกครั้งที่​เลือก
pattern ให้​บันทึก​ว่า​ทำไม​เลือก แล้ว​หลัง teardown เทียบ​ว่า choice นั้น​ถูก​จริง​ไหม
ตัวเลข​จาก session หนึ่ง​ไม่​ใช่​กฎ​สากล มัน​เป็น​แค่ calibration point เดียว การ scale
จาก solo ไป trio ไป swarm ไม่​ใช่​ความสำเร็จ​ของ crew master --- ทีม​ที่​เลือก solo
ถูกต้อง​สำหรับ​งาน​เล็ก และ​ไม่​เคย​ต้อง​แตะ swarm เลย​ทั้ง​โปรเจกต์ คือ​ทีม​ที่​ทำ​ถูก​พอ ๆ
กับ​ทีม​ที่​บริหาร swarm ร้อย​ตัว​ได้​สำเร็จ

การตัดสินใจ​ไม่​ได้​อยู่​ที่ scale สูงสุด​ที่​ทำได้ แต่​อยู่​ที่ scale ที่​พอดี​กับ​งาน​ตรงหน้า ---
เลือก​ทีม​ที่​เล็ก​ที่สุด​ที่​พิสูจน์ pattern ได้ แล้ว​ค่อย​ขยาย​เมื่อ​ข้อมูล​บอ​กว่า​จำ​เป็นจริง
ไม่​ใช่​เพราะ​มัน​ดู​น่าประทับใจ​กว่า
