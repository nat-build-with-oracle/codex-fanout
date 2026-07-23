# บทที่ 2: กายวิภาคของ Charter

Charter หนึ่งไฟล์ ตัดสินได้ว่าทีมจะเกิดหรือทีมจะตาย ไม่ใช่คำพูดเกินจริง — ก่อน `maw team up` จะรันแม้แต่บรรทัดเดียว charter ต้องถูก parse ผ่าน preflight ก่อน และถ้า field ไหนหายหรือผิดตำแหน่ง ทีมทั้งทีมจะไม่มีวันขึ้นมา

ในภาค 1 บทที่ 2 ของ crew-master-oracle วางกายวิภาคไว้ชัดแล้ว — หกคีย์หลักระดับบนสุด (`name`, `project`, `session`, `engines`, `members`, และ implicit `lifecycle`) แต่ละคีย์มีหน้าที่ของตัวเอง ไม่ overlap กัน บทนั้นเตือนไว้ว่า name/path trap ฆ่าทีมได้มากกว่า bug ไหนๆ ในโค้ด

บทนี้เอา charter จริงจาก session codex-fanout วันที่ 2026-07-23 มาผ่าตัดดู ไฟล์ `ψ/teams/codex-fanout-team.yaml` ที่ใช้งานจริงในบทที่ 1 มี field ครบตามทฤษฎี แต่ก็มี twist ที่ทฤษฎีจากภาค 1 ไม่ได้ครอบคลุมไว้ทั้งหมด — โดยเฉพาะ v2 contract ที่ตัด `defaults.worktree` block หายไปเลย แล้วก็ field เดียวที่ทำให้ lead กับ coder เป็นคนละสายพันธุ์กัน: `worktree: false`

นี่คือ charter ทั้งไฟล์ ใช้เป็น reference ตลอดบท

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

สี่ subtopic ต่อไปนี้ผ่าไฟล์นี้ทีละชั้น เทียบกับ pattern เดิมจากภาค 1 ตลอดทาง

## 2.1 name / project / session — สามฟิลด์ที่พังทีมได้ถ้าหาย

`name: codex-fanout-team` คือ identifier ที่ `maw team up` และ `maw team down` ใช้ค้นหาทีม ส่วน `maw team preflight` รับ path ของไฟล์ ไม่ใช่ name — asymmetry นี้ตรงกับที่ 02-architecture.md ย้ำไว้ตั้งแต่ต้น: preflight อ่านไฟล์ ส่วน up/down ทำงานกับทีมที่รันอยู่แล้วโดยอ้างชื่อ สลับสองอย่างนี้คือ trap อันดับหนึ่งที่คนตั้งทีมใหม่ชนบ่อยสุด

`project: nat-build-with-oracle/codex-fanout` วางเป็น org/repo แบบ relative ไม่ใช่ absolute path แบบตัวอย่างในภาค 1 (`/opt/Code/github.com/acme/backend`) — นี่คือจุดที่ charter จริงต่างจาก pattern เดิมชัดที่สุด ทุก worktree ของทีมนี้ resolve จาก path นี้ ถ้า path ไม่มีอยู่จริงตอน `up` spawn sequence จะ abort ตั้งแต่ preflight ทันที

`session: codex-fanout` ในไฟล์จริงเป็น string ธรรมดา ไม่ใช่ ISO-8601 timestamp แบบที่ 02-architecture.md ใช้เป็นตัวอย่าง (`2026-06-18T09:00:00Z`) — session ทำหน้าที่เป็น routing key สำหรับ `maw hey` และ log namespacing แต่ไฟล์จริงเลือกใช้ session name ที่คงที่แทน timestamp ที่เปลี่ยนทุกรัน สามฟิลด์นี้ดูเหมือนแค่ metadata แต่หายฟิลด์ไหนไป ทีมไม่มีวันขึ้น

## 2.2 engine resolution — charter engines block ชนะ config เสมอ

Resolution chain ตามภาค 1 มีสี่ชั้น เรียงจาก member's `engine` field ในไฟล์ ไปที่ `engines` block ของ charter ไปที่ `maw config commands` แล้วค่อย fallback แบบ hard-coded — v26.6.14 เคยพังตรง lookup ของ engines block เอง alias สั้นๆ อย่าง `fast` ถูกส่งตรงเข้า API เป็น model identifier แทนที่จะ resolve ผ่าน block ก่อน ทีมดูเหมือนขึ้นสำเร็จ (tmux window เปิด process start) แต่ coder error แล้วออกทันที

charter ของ codex-fanout เลี่ยงปัญหานี้ทั้งหมดด้วยการไม่ใช้ alias สั้นเลย engines block มีแค่ตัวเดียวคือ `omx-5` ที่ผูกกับ shell command เต็มรูปแบบ — ไม่ใช่แค่ model name แต่เป็นทั้ง bootstrap chain: เรียก `codex-setup.ts` ก่อน ตั้ง `CODEX_HOME` ตั้ง `OMX_AUTO_UPDATE=0` แล้วค่อย exec `omx --direct --madmax` เข้าไป field `engine: omx-5` ในสมาชิก codex-1 ก็ชี้ตรงมาที่ key นี้ ไม่มีชั้น alias คั่นกลางให้พังซ้ำ

ส่วน lead ใช้ `engine: claude` ตรงๆ ไม่ผ่าน engines block เลย เพราะ `claude` เป็น engine ที่ maw รู้จักอยู่แล้วในระดับ config global สองแนวทางนี้อยู่ในไฟล์เดียวกันได้ — coder ใช้ engines block เพราะต้อง bootstrap ซับซ้อน ส่วน lead ใช้ fully-qualified name ตรงตามคำแนะนำของภาค 1 ที่ให้เลี่ยง alias lookup เมื่อไม่แน่ใจเวอร์ชัน maw

## 2.3 v1 vs v2 contract — defaults.worktree หายไปยังไง

pattern จากภาค 1 ไม่มี top-level `lifecycle` block เลย — charter ตัวอย่างจบที่ `members` list สมาชิกแต่ละคนมี `branch` field เดี่ยวๆ ไม่มี field ชื่อ `worktree` แยกออกมาต่างหาก นั่นคือ contract แบบ v1 ที่สมมติว่าทุก member ต้องมี worktree เสมอ ไม่ต้องประกาศชัด

charter ของ codex-fanout เป็น contract คนละแบบ มี `lifecycle: { worktree: true, merge_on_shutdown: false }` อยู่ท้ายไฟล์ และในแต่ละ member ก็มี `worktree` field ของตัวเองแยกจาก `branch` — v2 contract นี้ไม่มี `defaults.worktree` เป็น block กลางให้ inherit ทุก member ต้องประกาศ `worktree` เองตรงๆ ในระดับ member ไม่ใช่ปล่อยให้ lifecycle block เป็นตัวกำหนด default แทน

ตรงนี้แหละที่คอมเมนต์บนสุดของไฟล์เตือนไว้เป็นพิเศษ — bug maw-rs #658 ทำให้ `worktree:`/`branch:` path ของสมาชิกคนสุดท้ายในไฟล์โดนตัด prefix `agents/` ออกตอน preflight กับ team up (canonicalize fail) เพราะ codex-1 เป็นคนสุดท้ายในไฟล์นี้ ทีมงานเลยต้องสร้าง symlink `codex-1 -> agents/codex-1` ไว้ที่ root ของ repo เป็นทางแก้ชั่วคราว จนกว่า #658 จะ ship ถ้าไม่อยากพึ่ง symlink ก็แค่ย้าย lead ให้เป็นสมาชิกคนสุดท้ายแทน — proof ตรงๆ ว่า v2 contract ยังมี edge case ที่ v1 ไม่เคยเจอ เพราะ v1 ไม่มี per-member worktree path ให้ bug แบบนี้เกิดได้ตั้งแต่ต้น

## 2.4 lead vs coder — worktree:false คือสิ่งที่แยกสองบทบาท

field เดียวที่ทำให้ lead กับ coder เป็นคนละบทบาทกันจริงๆ ในไฟล์นี้ไม่ใช่ `role` แต่เป็น `worktree` — lead มี `worktree: false` ส่วน codex-1 มี `worktree: agents/codex-1` เป็น path จริง

`role: lead` เขียนไว้ก็จริง แต่ `role` แค่บอก label สำหรับ prompt กับ log ไม่ได้ผูกกับ behavior อัตโนมัติ behavior จริงที่แยก lead ออกจาก coder คือ `worktree: false` — lead ทำงานอยู่บน checkout หลักของ repo ตรงๆ ไม่มี worktree แยก ส่วน branch ของ lead คือ `alpha` ซึ่งเป็นเป้าหมายของทุก PR ตาม goal ที่เขียนไว้บนสุด (`PR -> alpha only, never main`)

ทำไมต้องแยกแบบนี้ เพราะ lead มีหน้าที่ merge — prompt ของ lead เขียนชัดว่า "Lead orchestrator. NEVER write code yourself" และ "Merge is the lead's job" ถ้า lead มี worktree แยกของตัวเอง การ merge PR จาก coder เข้า alpha จะต้องสลับ context ไปมาระหว่าง worktree สองที่ ในขณะที่ coder ต้องแยก worktree เพราะต้อง "implement MINIMAL precise code" โดยไม่ชนกับใคร — ตรงตาม worktree isolation principle จากภาค 1 ที่บอกว่าหน่วยแยก parallel work ที่แท้จริงคือ git worktree ไม่ใช่ process

`worktree: false` จึงไม่ใช่แค่ optional flag ที่ปิดไว้เฉยๆ แต่เป็นตัวกำหนด role ทางสถาปัตยกรรมจริงๆ lead คือคนเดียวที่แตะ checkout หลัก ส่วนใครมี worktree เป็น path จริง คนนั้นคือ coder ที่ต้องทำงานแยกตัว ห้ามแตะ checkout ของ lead หรือ worktree ของคนอื่นเด็ดขาด ตามที่ prompt ของ codex-1 กำกับไว้ตรงๆ ว่า "Never touch lead's checkout or other worktrees"

---

Charter หนึ่งไฟล์ผ่าตัดออกมาแล้วเห็นชัดว่าไม่มี field ไหน "แค่ metadata" จริงๆ เลย — `name` ผิดที่ก็หาทีมไม่เจอ `project` เขียน relative ผิดจุดก็ resolve worktree พลาด `engines` alias ผิดชั้นก็ตายเงียบตั้งแต่ boot และ `worktree` ที่ดูเหมือน flag เล็กๆ กลับเป็นตัวตัดสินว่าใครทำหน้าที่อะไรในทีม

v2 contract ที่ตัด `defaults.worktree` ออกไปแลกมาด้วยความชัดเจนต่อ member แต่ก็แลกมาด้วย bug อย่าง #658 ที่ยังไม่ ship fix เต็มรูปแบบ — นี่คือราคาที่ต้องจ่ายเมื่อ contract เปลี่ยนรุ่นเร็วกว่า tooling จะตามทัน

แต่ charter ที่ถูกต้องทุก field ยังไม่พอจะทำให้ทีมขึ้นมาได้จริง — ไฟล์บนดิสก์เป็นแค่พิมพ์เขียว การเดินทางจาก `maw team preflight` ไปจนถึง `maw team up` ที่ใช้งานได้จริง ต้องผ่าน symlink workaround, canonicalize fail, และ boot pitfall อีกหลายจุดที่ 02-architecture.md เขียนเป็นทฤษฎีไว้ แต่ session จริงของ codex-fanout เจอมาคนละแบบ — บทที่ 3 จะตามรอยการเดินทางนั้นทีละก้าว
