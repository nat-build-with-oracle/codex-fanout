# บทที่ 7: Blocker คู่แรก — Repo ว่างเปล่า และ Bug #658

แผนดูดีบนกระดาษ maw-rs ตอบครบทุกขั้นแล้ว ตั้งแต่ charter contract v2 ไปจนถึงลำดับคำสั่ง spawn ทีละตัว — เหลือแค่ลงมือทำตาม ผมเปิด terminal พร้อมกับความมั่นใจเกินร้อย ก่อนจะเจอ error บรรทัดแรกที่ทำให้แผนทั้งหมดหยุดชะงักทันที

`git log` บอกว่า branch main ไม่มี commit เลยสักตัว — นี่มันคือ repo ว่างเปล่าตัวจริง ไม่ใช่แค่ยังไม่ได้ sync

พอแก้ปัญหานั้นเสร็จ เขียน charter เสร็จ preflight เสร็จ กลับเจอด่านที่สองที่หนักกว่าเดิม path ที่ควรมี `agents/` prefix กลับหายไปดื้อๆ ตอนแรกผมคิดว่าตัวเองพลาด — cwd หลุด, cd ค้าง, อะไรสักอย่างที่ผมทำผิดเอง แต่พอไล่ตรวจจนหมดทาง ก็เริ่มสงสัยว่าปัญหาไม่ได้อยู่ที่ตัวเองต่างหาก

บทนี้คือเรื่องของ blocker คู่แรกที่ทีม codex เจอ — หนึ่งแก้ได้ด้วยมือตัวเอง อีกหนึ่งต้องพึ่ง peer คนที่สองมา reproduce สดถึงจะยืนยันได้ว่าเป็น bug จริง ไม่ใช่ภาพลวงตาจากความไม่ชำนาญของคนถาม

## 7.1 "fatal: your current branch main does not have any commits yet" — repo ว่างเปล่าจริง

ขั้นแรกของแผนคือ `git worktree add` เพื่อสร้าง worktree ให้ coder ตัวแรก แต่ก่อนจะไปถึงตรงนั้น ผมเช็คสถานะ repo ตามนิสัย — แล้วก็เจอ:

```
$ git log --oneline -1
fatal: your current branch 'main' does not have any commits yet
$ git ls-remote origin
(nothing)
```

ไม่มี commit สักตัว ไม่มีอะไรอยู่บน origin เลยด้วยซ้ำ — นี่คือ repo ที่ยังไม่เคยมีใครเขียนอะไรลงไปจริงๆ

ปัญหาคือ `git worktree add` มันไม่สามารถ branch ออกจาก HEAD ที่ unborn ได้ ต่อให้ path ถูก ชื่อ branch ถูก ทุกอย่างถูกตามที่ maw-rs บอกก็ตาม เพราะยังไม่มี base ให้ branch ออกไปตั้งแต่แรก แล้วปัญหายังไม่จบแค่นั้น — coder ที่จะ spawn มาต้องมี origin content ให้ push กลับไปด้วย ไม่งั้นเปิด PR ไม่ได้

ทางแก้ตรงไปตรงมา สร้าง `README.md` ขั้นต่ำ commit แล้ว push ขึ้น origin main จากนั้นสร้างและ push branch `alpha` — ตาม convention ของทีมที่ว่า PR ต้องชี้เข้า alpha เท่านั้น ห้ามชี้ main โดยตรง เท่านี้ repo ก็มีฐานให้ worktree ยึดแล้ว

จุดนี้ยังไม่มีอะไรน่าสงสัยตัวเอง — เพราะ error message มันชัดเจนอยู่แล้วว่าปัญหาคืออะไร แก้ตามนั้นตรงๆ ก็จบ แต่ด่านถัดไปไม่ง่ายขนาดนั้น

## 7.2 preflight ล้มเหลว — canonicalize path ที่หาย agents/ prefix

repo มี base แล้ว charter เขียนเสร็จตาม v2 contract แล้ว — เหลือแค่รัน preflight เพื่อเช็คก่อน spawn จริง แต่ผลลัพธ์กลับไม่ผ่าน:

```
$ maw team preflight ψ/teams/codex-fanout-team.yaml
✗ spawn ordering: worktree dirs missing before window create: codex-1=.../codex-fanout/codex-1
✗ codex trust: codex-1 cannot read trust config .../codex-fanout/codex-1/.codex/config.toml
```

สังเกต path ตรง `.../codex-fanout/codex-1` — หาย `agents/` prefix ไปดื้อๆ ทั้งที่ charter เขียนไว้ชัดว่า `worktree: agents/codex-1`

ปฏิกิริยาแรกของผมคือโทษตัวเองก่อนเลย คิดว่าต้องเป็น cwd ที่หลุดแน่ๆ — บางที `cd` เข้า worktree ตอนก่อนหน้าอาจจะลอยค้างอยู่ใน shell แล้วไปปนกับคำสั่งถัดไป เรื่องแบบนี้เจอบ่อยเวลาสลับ context ไปมาเร็วๆ ผมเลยเปิด shell ใหม่ เช็ค `pwd` ให้ clean แล้วรันซ้ำ

ยังพังเหมือนเดิม path เดิม prefix หายเหมือนเดิม

ตรงนี้แหละที่ความสงสัยเริ่มเปลี่ยนทิศ — ถ้า cwd สะอาดแล้วยัง error แบบเดิมทุกครั้ง แปลว่าปัญหาไม่ได้อยู่ที่ shell state ของผมแล้ว แต่คำถามคือ ผมจะแน่ใจได้ยังไงว่านี่ไม่ใช่ typo เล็กๆ ใน charter ที่ตาผมมองข้ามไปเอง

## 7.3 maw-rs reproduce สดบน charter ของตัวเอง → filed #658

จุดตัดสินใจตรงนี้สำคัญ — ผมไม่นั่งไล่ debug เดี่ยวต่อ แต่ report กลับไปหา maw-rs ทันที เพราะ maw-rs เป็นคนเขียน flow ให้ตั้งแต่ต้น ถ้าใครจะช่วยยืนยันได้ว่านี่คือ bug จริงหรือผมพลาดเอง ก็ต้องเป็นคนนี้

maw-rs ไม่ได้เชื่อคำบอกเล่าเฉยๆ แต่เอา charter ของตัวเองไปลองรัน preflight ซ้ำสดๆ — และเจอ pattern เดียวกัน path หาย prefix เหมือนกันเป๊ะ ทั้งที่ charter คนละไฟล์ คนละ session

ผลสรุปจาก maw-rs: `maw team preflight` และ `maw team up` ทั้งคู่มี bug ที่ตัด `agents/` prefix ออกจาก `worktree:`/`branch:` path ของ **member ตัวสุดท้าย** ก่อนจะ canonicalize — เป็น bug จริงในตัว tool เอง ไม่เกี่ยวกับ charter ของใครทั้งนั้น maw-rs filed เป็น **#658** ทันทีที่ยืนยันได้

ตรงนี้คือหัวใจของบทเลย — ถ้าผมยึดสมมติฐานแรกไว้ว่า "ต้องเป็นความผิดตัวเอง" แล้วเสียเวลาไล่หา cwd bug ต่อไปเรื่อยๆ คงไม่มีทางเจอทางออก เพราะปัญหาไม่ได้อยู่ในมือผมตั้งแต่แรก แต่พอมี peer คนที่สอง reproduce ได้ผลเดียวกันบน environment ที่ต่างกันโดยสิ้นเชิง นั่นแหละคือหลักฐานที่หนักแน่นพอจะฟันธงว่าเป็น bug ของ tool — reproduce before you work around ไม่ใช่แค่คำขวัญสวยๆ แต่คือขั้นตอนที่พาผมออกจากหลุมพรางความสงสัยตัวเองได้จริง

## 7.4 สามทางแก้ — reorder lead, outside-in repo-path, symlink (และอันที่เลือกใช้จริง)

maw-rs เสนอทางแก้มาสามแบบพร้อมกัน แต่ละแบบแก้ปัญหาจากมุมต่างกัน

**ทางที่หนึ่ง — reorder lead ใน members list.** ย้าย coder ให้มาก่อน lead ใน `members:` เพราะ lead มี `worktree:false` อยู่แล้ว ถ้า bug ไปตัด prefix ของ lead ก็ไม่มีผลอะไร เพราะ lead ไม่มี worktree ให้ตัดตั้งแต่แรก — วิธีนี้เลี่ยง bug ได้แบบไม่ต้องแตะโค้ดเลย แต่ก็ผูกกับลำดับ member ในไฟล์ ถ้าทีมขยายเป็นหลาย coder เมื่อไหร่ก็ต้องคอยระวังลำดับใหม่อีก

**ทางที่สอง — outside-in ด้วย repo-path ตรงๆ.** ข้าม `team up` ไปเลย แล้วยิงคำสั่งแบบ manual:

```bash
maw wake <role> --session <sess> --no-attach --repo-path <abs-path>
```

วิธีนี้ bypass charter path parsing ไปทั้งเส้น เพราะให้ absolute path ตรงๆ ไม่ผ่าน canonicalize ที่มี bug

**ทางที่สาม — symlink** คือทางที่ผมใช้จริง ใช้ก่อนที่คำยืนยันจาก maw-rs จะมาถึงด้วยซ้ำ ตอนนั้นยังไม่รู้ว่า #658 ถูก filed แล้วหรือยัง แต่คิดว่าถ้า path ที่ bug สร้างมันหาย prefix ไป ก็แค่ทำให้ path นั้น "มีอยู่จริง" ซะเอง:

```bash
git worktree add agents/codex-1 -b agents/codex-1 origin/alpha
cd agents/codex-1 && bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts 5
printf '\n[projects."%s"]\ntrust_level="trusted"\n' "$PWD" >> .codex/config.toml
cd - && ln -s agents/codex-1 codex-1 && echo '/codex-1' >> .gitignore
maw team load ψ/teams/codex-fanout-team.yaml --no-spawn
maw team up codex-fanout-team --only codex-1
```

`ln -s agents/codex-1 codex-1` ที่ repo root คือกุญแจ — path ที่ bug พยายามอ่านโดยไม่มี prefix นั้น กลายเป็น path จริงที่ตามได้ทันทีที่ symlink มีอยู่ ทำให้ canonicalize ผ่าน แล้ว `team up` ก็ทำงานต่อได้ปกติ

ผลลัพธ์คือ boot สำเร็จตั้งแต่ครั้งแรกหลังใส่ symlink:

```
╭────────────────────────────────────────────────────╮
│ >_ OpenAI Codex (v0.144.5)                         │
│ model:       gpt-5.6-sol xhigh   /model to change  │
│ directory:   .../agents/codex-1                    │
│ permissions: YOLO mode                             │
╰────────────────────────────────────────────────────╯
```

สามทางแก้ สามมุมมองต่อ bug เดียวกัน — reorder คือเลี่ยงจุดที่ bug อยู่ outside-in คือข้ามระบบ parsing ไปทั้งชุด ส่วน symlink คือหลอกให้ path ที่ผิดกลายเป็นถูกโดยไม่ต้องแตะ charter หรือคำสั่งเดิมเลยสักบรรทัด — เบาที่สุดในสามทาง เพราะไม่ต้องเข้าใจ root cause ลึกก็ใช้ได้ทันที

## ปิดบท

Blocker คู่แรกจบลงด้วยผลลัพธ์เดียวกัน — coder boot ติด และพร้อมรับงาน แต่สิ่งที่ค้างอยู่ในใจไม่ใช่ตัว fix เลย เป็นจังหวะที่ผมเกือบเสียเวลาไล่ debug ตัวเองต่อไปเรื่อยๆ ทั้งที่ปัญหาไม่ได้อยู่ที่ผมตั้งแต่แรก

บทเรียนตรงนี้ย้อนกลับไปที่ dna ของทั้งบท — reproduce before you work around bug ที่ยืนยันได้จากคนที่สอง บน environment ที่ต่างกัน คือ bug จริง ไม่ใช่แค่คำบอกเล่าจากคนคนเดียวที่อาจจะพลาดเอง ผมเกือบเชื่อสมมติฐานแรกของตัวเองไปแล้วว่าเป็น cwd mistake ทั้งที่ error message เดิมโผล่ซ้ำทุกครั้งแม้เปิด shell ใหม่แล้วก็ตาม

แต่ทีมยังไม่ได้พักแค่นี้ — coder boot ติดแล้ว รับ dispatch แรกไปทำงานแล้วด้วยซ้ำ ปัญหาถัดไปกลับไม่ใช่เรื่อง infra หรือ tool bug อีกต่อไป แต่เป็นเรื่องพื้นฐานกว่านั้นมาก — จะส่งข้อความไปหาใคร แล้วที่อยู่ที่พิมพ์ไปนั้น มันคือที่อยู่จริงหรือเปล่า บทที่ 8 จะพาไปดู dispatch, probe, และที่อยู่ที่ผิดตัวนั้น
