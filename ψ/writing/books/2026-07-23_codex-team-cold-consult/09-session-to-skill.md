# บทที่ 9: จาก Session สู่ Skill

session หนึ่งจบลง มี PR merge แล้ว มี coder ตัวหนึ่งทำงานสำเร็จ แต่คำถามที่สำคัญกว่าคือ — สิ่งที่เพิ่งเรียนรู้มา จะอยู่ที่ไหนต่อ ถ้าไม่เขียนไว้ที่ไหนเลย ก็หายไปพร้อม context window ที่ปิดตัวลง แล้ว session ถัดไปก็ต้องเริ่มนับหนึ่งใหม่ ทั้งที่จริงมีคนเดินผ่านหลุมพรางนี้มาแล้ว

บทนี้เล่าสิ่งที่เกิดขึ้นหลังจาก PR #1 merge — ไม่ใช่ตอนที่ทำงานสำเร็จ แต่ตอนที่ต้องเปลี่ยนความสำเร็จนั้นให้เป็นสิ่งที่คนถัดไปหยิบไปใช้ได้จริง สามเรื่องเกิดขึ้นต่อกัน: อัปเดต `codex-lead` skill ด้วยของจริงที่เพิ่งพิสูจน์ผ่านมา, ค้นพบว่า dependency ตัวหนึ่งของ skill นั้นไม่เคยอยู่ใน git เลย แล้วต้อง vendor เข้ามา, และสุดท้าย — self-audit ที่จับได้เองว่าเกือบประกาศว่างานเสร็จ ทั้งที่ยังไม่ได้เช็คว่า dependency นั้นเข้าถึงได้จริงไหมสำหรับคนอื่น

ทั้งสามเรื่องผูกกันด้วยเส้นเดียว — ความรู้ที่ไม่ถูกเขียนไว้ ก็เท่ากับความรู้ที่หายไปพร้อม session และการเขียนไว้ "ถูกที่" สำคัญพอๆ กับการเขียนไว้ "ครบ" เพราะ doc ที่ดีแต่ dependency เข้าไม่ถึง ก็ไม่ต่างจาก doc ที่ไม่มีอยู่เลย

## 9.1 อัปเดต codex-lead skill ด้วยของจริง ไม่ใช่ทฤษฎี

`codex-lead` skill มีอยู่ก่อนแล้ว เขียนไว้ตั้งแต่พิสูจน์บน volt-codex2 (2026-06-24) — schema เก่ามี `defaults: {worktree: true}` ใช้ shared engine key แบบ `codex-t1..t6` แต่ session นี้เพิ่งเรียนรู้มาว่า contract จริงตอนนี้ต่างออกไปโดยสิ้นเชิง ไม่มี `defaults.worktree` block แล้ว ทุก member ต้องประกาศ `worktree:` กับ `branch:` ของตัวเอง engine command ก็ไม่ใช้ shared key แต่ inline ใต้ `engines:` เรียก `codex-setup.ts <N>` ตรงๆ เพื่อให้ได้ worktree-local `CODEX_HOME`

ถ้าไม่อัปเดต skill ให้ตรงกับของจริง — session ถัดไปที่มาอ่าน `codex-lead` ก็จะเจอ schema เก่า เขียน charter ผิด แล้ว "ดูสมเหตุสมผล" (plausible) แต่ fail ในจุดที่งงกว่าเดิม นี่คือประโยคที่ AI Diary เขียนไว้ตรงๆ: "it would have looked plausible and failed in a more confusing way later" — คือปัญหาไม่ใช่แค่ผิด แต่ผิดแบบที่ดูเหมือนถูก

สิ่งที่เพิ่มเข้าไปใน SKILL.md จริงคือ section ที่ 8 ทั้ง section — "Fast path — exactly 1 codex coder, specific pool/account N" มีตั้งแต่ charter YAML แบบเต็ม ไปจนถึง known bug ของ maw-rs (#658 — last-member `agents/` prefix ถูก strip ทิ้งตอน canonicalize path) พร้อม workaround สามแบบให้เลือก ไม่ใช่แค่คำอธิบายลอยๆ แต่เป็น command ที่ copy ไปรันได้ตรงๆ รวมถึง gotcha เล็กๆ ที่คนอ่าน skill เดิมไม่มีทางรู้ — เช่น "report-back target ต้องเป็น tmux window index จริง ไม่ใช่ role name จาก charter" ซึ่งเป็นเรื่องที่ coder ตัวเองเจอแล้วเสีย context ไปหาคำตอบเอง

นี่คือความหมายของ dna บทนี้ตรงตัว — เขียน workaround ไว้ตรงที่ session เย็นถัดไปจะไปเจอ ไม่ใช่เขียนแยกไว้เป็น log ที่ไม่มีใครกลับมาอ่าน

## 9.2 Vendor oracle-team skill — dependency ที่ไม่เคยอยู่ใน git มาก่อน

engine command ใน charter section 8 เรียก `bun ~/.claude/skills/oracle-team/scripts/codex-setup.ts N` — ดูเผินๆ ก็เป็นแค่บรรทัดเดียวในตัวอย่าง แต่บรรทัดนี้ชี้ไปที่ path บนเครื่องของคนเขียนเอง `~/.claude/skills/oracle-team/` ไม่เคยอยู่ใน git repo ไหนเลย มันอยู่แค่ใน home directory ของเครื่อง m5

พอ user ถามกลับมาตอน 19:20 ว่า "$HOME/.claude/skills/oracle-team too?" — คำถามสั้นๆ นี้แหละที่เปิดโปงช่องโหว่ทั้งหมด เพราะ skill ที่เพิ่งอัปเดตเสร็จ อ้างอิงถึงสคริปต์ที่ไม่มีใครอื่นเข้าถึงได้เลย ต่อให้ charter เขียนถูกทุกบรรทัด ก็รันไม่ได้ถ้าไม่มี `codex-setup.ts`

งานที่ตามมาคือ vendor ทั้งชุด — copy `codex-setup.ts` พร้อมสคริปต์พี่น้องอีก 3 ตัว และ SKILL.md ของ `oracle-team` เข้ามาไว้ใน `.claude/skills/oracle-team/` ของ repo `codex-fanout` เอง (commit `eca78eb`) จากที่เคยอยู่แค่ local ใต้ `~/.claude` — กลายเป็นส่วนหนึ่งของ repo ที่ push ขึ้น origin ได้จริง

จุดที่น่าสนใจคือ ไม่ใช่แค่ "ลืม vendor" — แต่เป็นรูปแบบที่เกิดซ้ำได้ง่ายมาก เวลาเขียน skill หรือ doc อะไรก็ตามที่อ้างอิง path ใต้ home directory ของตัวเอง คนเขียนจะไม่รู้สึกผิดปกติเลย เพราะทดสอบเองแล้วรันผ่าน — ตัวเองมี path นั้นอยู่แล้ว แต่คนอื่นไม่มี ความรู้สึก "มันรันได้" กับ "มันรันได้สำหรับทุกคน" เป็นคนละเรื่องกัน แต่สมองมักจะปนกันโดยไม่รู้ตัว

## 9.3 ทำไม private repo ถึงเท่ากับ "ไม่มีอะไรเลย" สำหรับ community

vendor dependency เข้า repo แล้วยังไม่จบ เพราะมี doc อีกตัวที่เขียนคู่กันมา — `CODEX-TEAM-BOOTUP.md` เป็นการเล่าเรื่องแบบละเอียดสำหรับ community อ่าน ตั้งใจให้เป็น "reproducible" คือคนอื่นอ่านแล้วทำตามได้จริง ไม่ใช่แค่เล่าว่าเคยทำอะไรมา

แต่ repo `codex-fanout` ที่ doc นี้อยู่ — ถ้ายังเป็น private ต่อให้เขียนละเอียดแค่ไหน มี command ครบทุกบรรทัด มี charter YAML เต็มรูปแบบ มี known bug พร้อม workaround สามแบบ ก็เท่ากับไม่มีอะไรเลยสำหรับคนนอก เพราะเปิดลิงก์เข้ามาแล้วเจอ 404 หรือ permission denied ทันที ไม่ต่างจาก doc ที่ไม่เคยเขียน

ความย้อนแย้งอยู่ตรงนี้ — งานทุกขั้นตอนที่ทำมาตลอดบทที่ 9 คือพยายามทำให้ความรู้ "เข้าถึงได้" ต่อจากตัวเอง อัปเดต skill ให้ตรงกับของจริง, vendor dependency ที่หายไป, เขียน narrative doc ให้ครบ — แต่ทุกอย่างนั้นตั้งอยู่บน repo เดียวที่ยัง gate ไว้ด้วย private visibility คนเขียนอาจมองว่างานเสร็จแล้วเพราะเช็คทุกจุดในเนื้อหา แต่ลืมเช็คจุดที่อยู่นอกเนื้อหา — คือ ใครเปิดเข้ามาดูได้บ้าง

Next Steps ในไฟล์ retro เขียนไว้ตรงๆ ว่า "Decide which community channel to post `CODEX-TEAM-BOOTUP.md` to (Discord/LINE/etc. — still waiting on user input)" — นั่นคือ ต่อให้ doc พร้อมแค่ไหน การจะให้ community เห็นได้จริง ต้องมีสองเงื่อนไขพร้อมกัน หนึ่งคือเนื้อหาถูกต้องและ reproducible, สองคือ visibility เปิดให้เข้าถึง ขาดข้อใดข้อหนึ่งไป ก็เท่ากับยังไม่ได้ ship

## 9.4 Self-Audit — รู้ทันความมั่นใจเกินจริงของตัวเอง

ท้ายบท retro มี block "🔍 Self-Audit" ที่เขียนไว้ตรงๆ ไม่อ้อมค้อม บรรทัดสุดท้ายของ block นั้นคือคำตอบของทั้งบทนี้:

> "rationalizations caught: 1 — nearly declared the writeup 'done' without verifying its cited dependency was actually reachable outside my own machine; caught only because the user asked"

ประโยคนี้สำคัญตรงคำว่า "nearly declared" กับ "caught only because the user asked" — ไม่ใช่ว่าไม่มี rationalization เกิดขึ้น แต่มันเกิดขึ้นจริง เกือบไปถึงจุดที่ประกาศว่างานเสร็จแล้ว ก่อนที่ user จะถามคำถามเดียว "$HOME/.claude/skills/oracle-team too?" — ถ้า user ไม่ถาม ก็คงไม่มีใครจับได้เอง

AI Diary เขียนขยายความไว้อีกชั้นหนึ่งว่า "I also almost stopped at 'the writeup is done' before the user asked about `oracle-team`... The user's question caught something I should have caught myself while writing the 'reproducible' doc." — ตรงนี้แหละคือจุดที่ต่างจากการทำงานทั่วไป เพราะคำว่า "reproducible" ถูกเขียนไว้ในใจตั้งแต่ต้น แต่ไม่ได้ตรวจสอบมันจริงจนกว่าจะมีคนอื่นมาถาม

Self-Audit block ยังมีอีกจุดหนึ่งที่น่าสนใจ คือ "uncomfortable truth" — [→ AGENT DECISION] assumed a tool-path error was my own cwd mistake before considering it might be a real bug in `maw`, costing a round-trip I didn't need to spend — เป็นความผิดพลาดคนละแบบกับเรื่อง dependency แต่รากเดียวกัน คือความมั่นใจว่าตัวเองรู้แล้ว โดยไม่เช็คสมมติฐานให้ครบก่อน ครั้งแรกมั่นใจว่า "ฉันต้องพิมพ์ path ผิดเอง" ทั้งที่ error message ระบุ path เจาะจงมาก ครั้งที่สองมั่นใจว่า "doc เขียนเสร็จแล้ว" ทั้งที่ยังไม่เช็คว่า dependency เข้าถึงได้จริงไหม

ทั้งสองครั้งมีรูปแบบเดียวกัน — สมมติฐานที่สะดวกที่สุดสำหรับตัวเอง มักไม่ใช่สมมติฐานที่ถูกต้องที่สุดสำหรับงาน การมี block self-audit บังคับให้ตอบคำถามพวกนี้ตรงๆ ท้าย session ทุกครั้ง จึงไม่ใช่พิธีกรรม แต่เป็นกลไกจับ rationalization ที่ไม่มีใครจับให้ได้ ถ้าไม่มีใครถามพอดี

---

บทที่ 9 จบด้วยบทเรียนที่ย้อนกลับมาที่ตัว session-lead เอง — ทำงานเสร็จไม่ใช่จุดจบ เพราะความรู้ที่ทำสำเร็จแล้วยังต้องเดินทางไปถึงคนถัดไปให้ได้ ทั้งในรูปของ skill ที่อัปเดตด้วยของจริง, dependency ที่ vendor เข้ามาให้เข้าถึงได้, doc ที่ visibility เปิดจริง และ self-audit ที่ไม่ปล่อยให้ความมั่นใจเกินจริงหลุดผ่านไปโดยไม่มีใครถาม

บทที่ 10 ซึ่งเป็นบทสุดท้ายของหนังสือเล่มนี้ จะรวบทุกอย่างที่ผ่านมาทั้งเก้าบทให้เป็น Decision Framework และ Quick Reference — เวลาต้องตัดสินใจกลางดึกว่าจะ cold consult ใคร จะ escalate ตอนไหน จะ vendor อะไรก่อน ship จะไม่ต้องพลิกกลับมาอ่านทั้งเล่มอีก แค่เปิดบทสุดท้ายบทเดียวก็พอ
