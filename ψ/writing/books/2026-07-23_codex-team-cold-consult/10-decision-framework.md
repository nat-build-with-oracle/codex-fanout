# บทที่ 10: Decision Framework และ Quick Reference

เก้าบทที่ผ่านมา เล่าเรื่อง cold consult หนึ่งเซสชัน ตั้งแต่ zero context จนถึง bug report ที่ maw-rs รับไปแก้จริง แต่บทนี้ไม่ใช่การเล่าซ้ำ — เป็นการบีบทุกอย่างให้เหลือทรีตัดสินใจต้นเดียว ใช้ได้ก่อน spawn ครั้งถัดไป ไม่ว่าจะอ่านเล่มนี้จากบทไหนมาก็ตาม

คำถามที่ทีมใหม่ทุกทีมเจอเหมือนกันคือ "จะ spawn กี่ตัวดี" คำตอบไม่ได้อยู่ที่ scale สูงสุดที่ทำได้ แต่อยู่ที่ scale ที่พอดีกับงาน — solo ก็พอสำหรับงานเล็ก, trio สำหรับงานที่ decompose ได้จริง, swarm สำหรับงานที่นับ task ได้แล้วเท่านั้น การเลือกผิดฝั่งไม่ได้แปลว่า fail เสมอไป แต่แปลว่า waste — เวลาของ ting ที่เสีย 45 นาทีเพราะ spawn fleet เต็มก่อน test หนึ่งตัว, เวลา 3 ชั่วโมงของ maw-rs ที่ recovery จาก shared CODEX_HOME, และเวลา 2 ชั่วโมงของ transcriber ที่ reconcile งานซ้ำ — ทั้งหมดนี้ recoverable ก็จริง แต่ไม่จำเป็นต้องจ่ายทุกครั้งถ้าเดินทรีให้ถูก

ภาค 2 ของเล่มนี้เพิ่มบทเรียนอีกชั้นหนึ่งที่ภาค 1 ไม่มี — เรื่องของ "ใครมีข้อมูลปัจจุบันที่สุด" เมื่อ session เริ่มจาก zero context จริง ๆ guidebook ก็ดี decision tree ก็ดี ล้วนเป็น snapshot ของวันที่เขียน แต่ peer ที่กำลัง dispatch งานอยู่ตอนนั้นคือคนที่รู้ contract ปัจจุบันที่สุด บทนี้จะรวมทั้งสองภาคเข้าด้วยกัน — ทรีตัดสินใจจากภาค 1 บวก checklist cold-start จากภาค 2

## 10.1 Scope/Size Branch — เมื่อไหร่ solo พอ เมื่อไหร่ต้อง trio/swarm

คำถามแรกก่อนถามว่า "pattern ไหน" คือ งาน bounded หรือยัง งาน bounded คือรู้ output type รู้ input file รู้ acceptance test ชัดเจน งาน ill-bounded คือ scope ยังไม่นิ่ง มี subtask โผล่มาเรื่อย ๆ ระหว่างทำ — ถ้ายังไม่ bounded ห้ามข้ามไป spawn ทันที ต้องมี discovery phase ก่อนเสมอ agent เดียว read-only ผลิต task manifest ออกมา แล้วค่อยกลับเข้าทรีใหม่

เมื่องาน bounded แล้ว คำถามถัดไปคือ scope กว้างแค่ไหน

**Solo — ไฟล์เดียว, diff ต่ำกว่า 50 บรรทัด** นี่คือ default งานเล็ก overhead ของ agent เพิ่มเข้ามาทุกตัวไม่ใช่ศูนย์ — spawn latency, context injection, result collection — สำหรับ patch 20 บรรทัด overhead นั้นมากกว่าตัวงานเอง อย่า spawn trio เพราะ "สามมุมมองดีกว่าหนึ่ง" ถ้างานเล็กจริง มุมมองที่สามไม่ได้เพิ่มคุณภาพที่วัดได้ แต่เพิ่ม wall-clock 3 เท่า

**Trio — 2 ถึง 5 subtask ที่ independent จริง คนละไฟล์** independent ที่นี่หมายถึง agent A ทำเสร็จได้โดยไม่ต้องอ่าน output ของ agent B ถ้า subtask แตะไฟล์เดียวกัน นั่นไม่ใช่ parallel แล้ว เป็น sequential ที่แกล้งทำเป็น parallel — ผลคือ merge conflict วินัยสำคัญคือ decompose ก่อน dispatch เขียน subtask list ออกมาก่อน เช็คว่าไม่มีสองงานเขียนไฟล์เดียวกัน แล้วค่อย fork

**Tournament — เมื่อคุณภาพสำคัญกว่าความเร็ว** รัน 3 agent บน prompt เดียวกัน แล้วเลือกที่ดีที่สุด ไม่ใช่ pattern สำหรับความเร็ว แต่สำหรับความหลากหลายของ solution เก็บไว้ใช้กับงานที่ revert ยาก เช่น public API หรือโค้ดที่กระทบความปลอดภัย แต่ tournament ไม่ใช่เครื่องมือ debug — สาม agent ที่เห็น error message เดียวกันมักหลงทางเหมือนกันหมด

**Swarm/Workflow subagents — เมื่อนับ task ได้เกิน 100 แล้วเท่านั้น** ห้าม spawn swarm ก่อนที่จะ enumerate task list ได้ นี่คือบทเรียนที่หนักที่สุด — swarm ที่ dispatch ก่อนมี manifest จะ duplicate งาน, miss งาน, หรือชน shared state กัน สำหรับงานเบา 100+ ชิ้นที่ I/O isolate ได้ ใช้ workflow subagents ผ่าน queue สำหรับงานหนักที่ชน rate limit ใช้ five teams rotating ข้าม API key แต่ทั้งสองแบบต้องมี manifest ก่อนเสมอ ไม่มี manifest ไม่มี swarm

โปรเจกต์จริงมักไม่ fit pattern เดียว — discovery ด้วย solo หนึ่งตัว แล้วแบ่ง manifest เป็นกลุ่มตาม pattern ที่เหมาะ กลุ่มงานเล็กจำนวนมากไปที่ workflow subagents กลุ่มงาน critical ไปที่ tournament กลุ่ม architecture ไปที่ trio จบด้วย integration solo หนึ่งตัวรวมทุกอย่างเข้าด้วยกัน — แต่ละชั้นใช้ pattern ขั้นต่ำที่ fit กับ task class ของมันเท่านั้น ไม่มีชั้นไหนได้ overhead เกินจำเป็น

## 10.2 Command Glossary ที่ใช้บ่อยที่สุด

ห้าคำสั่งนี้ครอบคลุมวงจรชีวิตของทีมทั้งหมด ตั้งแต่ก่อน spawn จนถึง teardown

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

`maw hey` มีจุดที่คนใหม่มักพลาด — ส่งไปแล้วคิดว่าจบ แต่ dispatch เงียบ ๆ ล้มเหลวได้ ถ้า tmux pane scroll เลย injection point หรือ coder ค้างอยู่ที่ interactive prompt วิธีเดียวที่รู้คือ peek ทันที ไม่ใช่รอ

ส่วน `maw hey` ข้าม oracle — ข้อมูลจากภาค 2 — ใช้ address ต่างออกไป แต่หลักการเดียวกัน คือ fire แล้ว observe ไม่ใช่ fire แล้วลืม peer ที่กำลัง busy dispatch งานตัวเองอยู่ก็ยังตอบได้ระหว่าง step ของมัน — ไม่ต้องรอ idle ไม่ต้อง share context ล่วงหน้า

## 10.3 Checklist ก่อน spawn จริง

Checklist นี้รวมจากทั้งสองภาค — foundations (หกขั้นก่อน spawn) บวก lesson จาก cold consult ในภาค 2 (verify ว่าข้อมูลที่อ้างอิงยังทันสมัย และทุก dependency reachable จริง)

**ก่อน spawn ครั้งแรกของ session**

1. `maw ls -v` — ทุก engine ต้อง OK/TRUSTED ก่อน
2. Charter YAML ต้องประกาศทุก role พร้อม map ไปยัง engine ที่มีจริง — เช็คด้วย `yq e '.' ψ/teams/<file>.yaml` ก่อน เพราะ YAML พังหน้าตาเหมือน engine error
3. Engine ที่อ้างใน charter ต้อง register ใน maw config แล้ว — `maw engine add` ถ้ายังไม่มี
4. ทุก CODEX_HOME ต้องมี `config.toml` grant trust — ไม่มี trust แปลว่า engine spawn แล้ว halt รอ confirm ที่ไม่มีวันมา
5. Branch แยกสำหรับ session นี้ต้องมีอยู่ — coder ที่ spawn บน main แล้ว commit ตรง คือต้นตอ merge disaster ที่หนักที่สุด
6. `git status` สะอาด, `git stash list` ว่างหรือรู้ที่มา — working tree สกปรกตอน spawn ทำให้ coder ทุกตัวอ่าน status แล้วสับสนว่ามันคือ conflict จริงหรือเปล่า
7. `maw team preflight` ต้อง GREEN — ถ้า non-zero ห้าม spawn แก้ก่อน รันใหม่ จน GREEN ค่อย spawn

**เพิ่มจาก cold-start / peer consult (ภาค 2)**

8. ถ้ามี peer oracle ที่เพิ่งทำ stack เดียวกันมาสด ๆ ถามก่อนเขียน charter จากความจำหรือ doc เก่า — doc ที่เขียนไว้วันก่อนกับ contract ปัจจุบันของ tool ต่างกันได้เสมอ (เคสจริง — guidebook บอกว่ามี `defaults.worktree` block แต่ contract ปัจจุบันใช้ setup script แยก worktree-local CODEX_HOME แทน)
9. ก่อนถือว่า doc หรือ setup step "reproducible" ให้ list ทุก script/config/binary ที่มันอ้างถึง แล้วเช็คว่า reachable จากนอกเครื่อง/session ของคนเขียนจริงหรือไม่ — สคริปต์ที่อยู่แค่บนเครื่อง local ไม่เคยเข้า git repo คือช่องโหว่ที่มองไม่เห็นจนมีคนถามว่า "ไฟล์นี้อยู่ไหน"
10. ถ้า tool คืน error ที่ path ไม่ตรงกับ input (เช่น prefix หายไปเงียบ ๆ) ให้ปฏิบัติเหมือนเป็น bug จริงที่ควร reproduce และ report ไม่ใช่รีบสรุปว่าเป็นความผิด cwd ของตัวเอง — reproduce ซ้ำบน charter ที่สองอิสระจากกัน แล้ว report มักเร็วกว่านั่ง workaround คนเดียวต่อไป

**Smoke test — ก่อน scale ไปทีมใหญ่**

ก่อน spawn full fleet เสมอ ต้องมี smoke test อย่างน้อยหนึ่ง agent หนึ่ง task ผ่านก่อน ทีม 20 ตัวที่ spawn พร้อมกันโดยไม่เช็ค prompt ก่อน จะได้ output ผิดแบบเดียวกันทั้ง 20 ตัว — ตรวจแค่ตัวเดียวถูกกว่าตรวจ 20 ตัวทีหลังเสมอ

## 10.4 บทส่งท้าย — ทีมถัดไปควรเริ่มจากบทไหน

เล่มนี้แบ่งเป็นสองภาคจริง — foundations ที่ให้ทรีตัดสินใจ pattern และ case study ที่เล่า cold consult จริงหนึ่งเซสชัน ทีมที่มาอ่านเล่มนี้ครั้งแรกไม่จำเป็นต้องอ่านเรียงจากบทหนึ่ง คำถามที่ควรถามตัวเองก่อนคือ "ตอนนี้ฉันอยู่จุดไหนของ workflow"

ถ้ายังไม่เคย spawn ทีมเลย ยังไม่มี charter YAML ในมือ — เริ่มที่ 10.3 checklist ก่อน แล้วย้อนกลับไปดูบทที่อธิบาย charter format ในภาคแรก จะประหยัดเวลากว่าไล่อ่านทุกบท

ถ้ามีทีมแล้วแต่ไม่แน่ใจว่าควร spawn กี่ตัวสำหรับงานตรงหน้า — กลับมาที่ 10.1 เดินทรีให้จบก่อน แล้วค่อยเปิด command glossary ใน 10.2 ประกอบ

ถ้ากำลังจะเริ่ม session จาก zero context จริง ๆ — ไม่มี handoff ไม่มีความจำ session ก่อนหน้า — นี่คือจุดที่ภาค 2 มีค่าที่สุด บทเรียนสำคัญคือ อย่าเชื่อ doc เก่าเกินกว่าที่ peer สดจะบอกได้ ถ้ามี oracle อื่นในเครือข่ายที่แตะ stack เดียวกันมาไม่นาน ถามก่อนเขียน อย่าเขียนจากความจำ

สิ่งที่ทีมถัดไปควรทำต่อ ไม่ใช่แค่ท่องทรีตัดสินใจให้ขึ้นใจ แต่คือการวัด — ทุกครั้งที่เลือก pattern ให้บันทึกว่าทำไมเลือก แล้วหลัง teardown เทียบว่า choice นั้นถูกจริงไหม ตัวเลขจาก session หนึ่งไม่ใช่กฎสากล มันเป็นแค่ calibration point เดียว การ scale จาก solo ไป trio ไป swarm ไม่ใช่ความสำเร็จของ crew master — ทีมที่เลือก solo ถูกต้องสำหรับงานเล็ก และไม่เคยต้องแตะ swarm เลยทั้งโปรเจกต์ คือทีมที่ทำถูกพอ ๆ กับทีมที่บริหาร swarm ร้อยตัวได้สำเร็จ

การตัดสินใจไม่ได้อยู่ที่ scale สูงสุดที่ทำได้ แต่อยู่ที่ scale ที่พอดีกับงานตรงหน้า — เลือกทีมที่เล็กที่สุดที่พิสูจน์ pattern ได้ แล้วค่อยขยายเมื่อข้อมูลบอกว่าจำเป็นจริง ไม่ใช่เพราะมันดูน่าประทับใจกว่า
