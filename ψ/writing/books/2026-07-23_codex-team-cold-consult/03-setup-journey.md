# บทที่ 3: การเดินทางของ Setup

repo ว่างเปล่าไม่ได้แปลว่าพร้อม — ประโยคนี้ฟังดูเหมือนเรื่องเบสิกที่ไม่น่าต้องพูด แต่พอ codex-fanout session เจอเข้ากับตัวเอง ถึงรู้ว่ามันคือบล็อกเกอร์จริงที่รอทุกทีมอยู่ ก่อนจะมี coder สักตัวเขียนโค้ดได้ ต้องมี worktree ก่อน ก่อนจะมี worktree ต้องมี branch บน remote ก่อน ก่อนจะมี branch บน remote ต้องมี commit สักตัวหนึ่ง — chain ทั้งหมดนี้พังได้ตั้งแต่ข้อแรกสุด และมันมักจะพังเงียบๆ ด้วย

บทนี้เดินตาม 4 หัวข้อ เริ่มจาก Trust Prerequisite ที่ทำให้ coder ทำงานได้จริงไม่ใช่แค่ดูเหมือนทำงาน ต่อด้วย 5-Phase Protocol ที่กลั่นจาก 22 ขั้นตอนภาคสนามของ Ting เหลือแค่ 5 gate ที่ต้องผ่านตามลำดับ จากนั้นลงลึกที่บล็อกเกอร์ตัวจริงจาก session 2026-07-23 — repo ที่ไม่มี commit สักบรรทัดเดียว พร้อม error message ตัวเป็นๆ ที่ยืนยันปัญหา ปิดท้ายด้วยเรื่อง pool/account contention ที่เกิดตอนสองทีมใช้บัญชีเดียวกันพร้อมกัน

ภาค 1 สอนว่า trust config คือ prerequisite ที่มองไม่เห็นจนกว่าจะพัง บทนี้เพิ่มอีกชั้นหนึ่ง — repo เองก็เป็น prerequisite ที่มองไม่เห็นเหมือนกัน มันดูมีอยู่แล้ว (`git status` รันได้ ไฟล์อยู่ครบ) แต่ถ้าไม่มี commit สักตัว worktree ก็ผูกกิ่งไม่ได้ ทุกอย่างที่ดูเหมือนพร้อมกลับกลายเป็นภาพลวงตา

---

## 3.1 Trust Prerequisite — ทำไม codex ค้างที่ prompt ถ้าไม่ pre-seed

`CODEX_HOME` ทุกตัวต้องมี `config.toml` พร้อม `trust_level = "trusted"` ก่อนจะสั่ง spawn อะไรทั้งนั้น ไม่ใช่ default ไม่ใช่ optional เพราะถ้าไม่มี codex จะรันในโหมด sandbox — อ่านไฟล์ได้ วิเคราะห์ได้ แต่เขียนไม่ได้เงียบๆ coder ที่ขาด trust จะดูเหมือน active ใช้ token ไปเรื่อยๆ แต่ผลลัพธ์คือศูนย์

crew-master-oracle เจอเรื่องนี้ตอน Round 3 Swarm — สอง coder เลือกไฟล์เดียวกันโดยไม่เขียนอะไรลง disk เลยสักไบต์ ต้นตอไม่ใช่การชนกันของ task แต่เป็น `~/.codex-team/1` ที่ถูกรีเซ็ตระหว่าง cleanup โดยไม่มีใครสังเกต **coder ที่ไม่มี trust จะเขียนอะไรไม่ได้และไม่บอกด้วยว่ามีอะไรผิด** ต้อง verify ก่อนเสมอ

```bash
grep trust_level "$CODEX_HOME/config.toml"
# ต้องได้: trust_level = "trusted"
```

ฝั่ง codex-fanout session ไปไกลกว่านั้นอีกขั้น — pre-seed trust เข้าไปตรงๆ ก่อน spawn เลย แทนที่จะรอเช็คทีหลังแล้วค่อยแก้:

```bash
printf '\n[projects."%s"]\ntrust_level="trusted"\n' "$PWD" >> .codex/config.toml
```

ขั้นตอนนี้มาจากคำแนะนำของ maw-rs ตอนถูกถามสดๆ ว่า "gotcha สำหรับ fresh worktree มีอะไรบ้าง" — คำตอบคือ pre-seed ก่อนเลย อย่ารอให้ preflight ไปเจอเอง เพราะถ้าเจอตอนนั้นแปลว่า worktree ตัวนั้นยังไม่พร้อม ต้อง full stop

---

## 3.2 5-Phase Protocol (repo prep → verify → spawn one → probe → scale)

Ting เคยมี checklist 22 ขั้นตอนกระจายอยู่ 4 หน้า field notes จาก 7 coder กว่า 20 PR โครงสร้างที่กลั่นออกมาเหลือ 5 phase — **Repo Prep → Verify → Spawn One → Probe → Scale** — แต่ละ phase มี go/no-go gate ของตัวเอง ถ้า gate ไหนไม่ผ่าน ห้ามเดินต่อ

| Phase | ชื่อ | เงื่อนไขผ่าน |
|-------|------|---------------|
| 1 | Repo Prep | มี remote branch, worktree สะอาด |
| 2 | Verify | `preflight.sh` exit 0, worktree list ตรงตามที่คาด |
| 3 | Spawn One | coder ตัวเดียวรันอยู่, `maw peek` เห็นว่า active |
| 4 | Probe | loop เต็มพิสูจน์แล้ว: dispatch → code → push → PR → merge |
| 5 | Scale | coder ที่เหลือ spawn บน task ที่ไม่ทับกัน |

**ห้ามรัน Phase 5 ก่อน Phase 4 เสร็จ** — นี่คือความผิดพลาดที่พบบ่อยที่สุดใน multi-coder deployment ทีมที่รีบ spawn ทั้งสามตัวพร้อมกันมักจะไปชนกันที่ role เดียวกันตอน Phase 4 (อย่างกรณี `QUICK-START.md` ถูกมอบหมายให้สองคน) แล้วต้องเสียเวลา 20 นาทีคลี่ merge ที่ไม่มีวันเกิดถ้า loop แรกถูกพิสูจน์ก่อน

session codex-fanout เดินตาม logic เดียวกันนี้ แม้จะไม่ได้เรียกชื่อ phase ตรงๆ ก็ตาม — ขั้นตอนจาก maw-rs ระบุชัดว่า "SPAWN ONE FIRST (the golden rule)" พร้อมลำดับ: `git worktree add` → cd → setup script → pre-seed trust → `maw team load --no-spawn` → `maw team up --only <role>` แล้วค่อย verify boot ด้วย `maw peek` ว่าเห็น engine UI จริง ไม่ใช่แค่ shell หรือ trust prompt ค้างอยู่ ก่อนจะขยับไป dispatch task จริง

Phase 4 ในเคสนี้คือ probe task ง่ายๆ — สร้าง `NOTES.md`, commit, push, เปิด PR แล้วรายงานกลับ codex-1 ทำครบทุกขั้นตอน แค่ตอนรายงานกลับดันส่งผิดที่ (เดี๋ยวจะเล่าในบทที่ 4) แต่ loop หลักคือ dispatch → code → push → PR → merge ผ่านครบ พิสูจน์ว่า environment พร้อมก่อนจะไปคิดเรื่อง scale

---

## 3.3 บล็อกเกอร์จริง — repo ว่างเปล่า ไม่มี commit ไม่มี origin

นี่คือจุดที่ทฤษฎีชนกับของจริง — codex-fanout เป็น repo ที่เพิ่งสร้างใหม่ ไม่มี commit สักตัวเดียว พอลอง `git worktree add` ปุ๊บ พังทันที เพราะ `HEAD` ยัง unborn อยู่ ผูกกิ่งอะไรไม่ได้เลย

```
$ git log --oneline -1
fatal: your current branch 'main' does not have any commits yet
$ git ls-remote origin
(nothing)
```

error message นี้ตรงตัว — ไม่มี commit แปลว่าไม่มีจุดอ้างอิงให้ worktree แตกกิ่งออกไป และ coder เองก็ต้องมี content บน `origin` ให้ push กลับไปทับ เปิด PR ได้ ถ้า origin ว่างเปล่าเหมือนกัน push ก็ไม่มีเป้าหมาย

ทางแก้ตรงไปตรงมา — สร้าง `README.md` ขั้นต่ำ commit push ขึ้น `origin main` แล้วสร้างพร้อม push branch `alpha` (เป้าหมายของ PR ตาม convention "PR → alpha only, never main"):

```bash
git add . && git commit -m "chore: initial scaffold"
git push -u origin main
git checkout -b alpha
git push -u origin alpha
```

Gate 1 ของ Phase Repo Prep คือ `git branch -r | grep alpha` ต้อง exit 0 ตอนนี้ผ่านแล้ว ประเด็นสำคัญคือ empty repo ไม่ได้ error ให้เห็นตอนวางแผน มันจะโผล่มาตอน `git worktree add` พังเท่านั้น — เป็น prerequisite ที่มองไม่เห็นจนกว่าจะพัง ตรงกับ dna ของบทนี้เป๊ะๆ

แล้วทำไมไม่ตรวจตั้งแต่แรกล่ะ? เพราะ repo ที่มีไฟล์อยู่ครบ `git status` รันผ่าน ดูเผินๆ เหมือนพร้อมทุกอย่าง แต่ commit history คือสิ่งที่ต้องเช็คแยกต่างหาก ไม่ใช่แค่ไฟล์บน disk

---

## 3.4 pool/account contention — บัญชีเดียวกัน ขีดจำกัดเดียวกัน

ก่อนจะแตะ pool 5 session codex-fanout เช็คก่อนว่าใช้ได้จริงไหม:

```bash
ls ~/.codex-team/5/auth.json   # exists — pool 5 auth ไว้แล้ว
```

pool 5 auth ไว้แล้วก็จริง แต่ปัญหาคือ maw-rs เองก็กำลังรัน 4 coder อยู่บน pool 1/2/5/6 พร้อมกัน — pool 5 เฉพาะเจาะจงถูกใช้อยู่โดย coder ชื่อ `infra` ของ maw-rs สถานการณ์นี้ต้องส่งแผนกลับไปให้ maw-rs ดูก่อนแตะอะไรทั้งนั้น เพราะการแชร์บัญชีเดียวกันมีผลกระทบข้ามทีม ไม่ใช่แค่ในทีมตัวเอง

maw-rs ยืนยันว่าใช้ร่วมกันได้ — **shared credential, shared rate limit แต่แต่ละ coder มี worktree-local `CODEX_HOME` แยกกัน** (SQLite/lock แยกกันคนละชุด) contention ที่จะเกิดคือ rate-limit ทำให้ช้าลง ไม่ใช่ hard conflict และรับได้สำหรับ coder เบาๆ ตัวเดียว ส่วน pool 3/4/7 ที่ dedicated ไว้กลับยังไม่ auth — ต้อง manual `codex login` ซึ่งอยู่นอก scope ของ "fast" ไปเลย เลยเลือก pool 5 ตามเดิม

จุดนี้ต่างจาก trap #2 ในภาค 1 (shared CODEX_HOME ทำให้ SQLite lock ชน จนพัง 12% ของ agent) ตรงที่ประเด็นในภาค 2 ไม่ใช่ CODEX_HOME ที่แชร์กัน — เพราะแต่ละ coder แยก worktree-local CODEX_HOME กันอยู่แล้ว แต่เป็น**บัญชี** ที่แชร์กัน ผลคือ rate limit ไม่ใช่ lock contention คนละชั้นของปัญหา แม้จะฟังดูคล้ายกันตอนแรก

---

setup ที่ดูเหมือนงานเตรียมการเล็กๆ กลายเป็นครึ่งหนึ่งของเวลาทั้ง session — จาก consult เย็นชากับ maw-rs ไปจนถึง commit แรกบน `alpha` ก่อนจะมี coder สักตัวขยับได้จริง 4 หัวข้อในบทนี้ผูกกันเป็นเส้นเดียว trust ต้อง pre-seed, phase ต้องเรียงลำดับ, repo ต้องมี commit, pool ต้องเช็คก่อนแตะ — พลาดจุดไหนจุดหนึ่ง ทั้ง chain ก็สะดุด

บทที่ 4 จะพาไปดูว่าทีมขนาด 1 คนขยายไปเป็นพันได้ยังไง จาก probe task เดียวของ codex-1 ที่ยิงกลับผิดที่ ("no window 'lead' in session") ไปจนถึง 1,000 Haiku agent ที่วิ่งพร้อมกันได้ใน 103 วินาที — เส้นทางจาก Solo ถึง Thousand ที่พิสูจน์ว่า architecture ที่ถูกต้องตั้งแต่ setup คือสิ่งที่ทำให้ scale ได้จริง ไม่ใช่แค่ workaround เฉพาะหน้า
