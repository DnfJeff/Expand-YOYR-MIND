# MOOLLM Full Skill Inventory — All 121 Skills

> Research document. Every skill in https://github.com/SimHacker/moollm cataloged.
> Purpose: See the FULL toy box before cherry-picking.

---

## How to Read This

Each skill is classified:

| Symbol | Type | Meaning |
|--------|------|---------|
| 🧠 | **PROTOCOL** | Pure LLM instruction — YAML/Markdown that tells the LLM how to behave. No code runs. |
| 🔧 | **PROGRAM** | Has actual executable Python/JS/bash scripts that DO things. |
| 📐 | **PHILOSOPHY** | Design principle — shapes HOW the LLM thinks, not what it does. |
| 🏷️ | **TAG** | Ontological label — attaches ethics/identity metadata to characters. |
| 🎭 | **PERFORMANCE** | Explicitly invoked voice/persona skill — comedy, satire, character. |
| 🚿 | **HYGIENE** | Always-on quality filter — prevents AI slop, hedging, etc. |

**Tier** = what tools the skill needs:
- **T0** = Pure prompt (no file access needed)
- **T1** = Needs file read/write
- **T2** = Needs file access + terminal

**🎯 Relevance** to our Danny Thomas / Mayberry worlds:
- ⭐⭐⭐ = Core — we definitely want this
- ⭐⭐ = Useful — would make episodes better
- ⭐ = Nice to have — take it or leave it
- ◻️ = Skip — not relevant to our use case

---

## 1. FOUNDATION (4 skills)

The OS kernel. These make everything else work.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 1 | **moollm** | 🧠 | T0 | The soul. Self-explanation, help system, navigation. Tells the LLM what MOOLLM IS. | ⭐⭐⭐ |
| 2 | **skill** | 🧠 | T1 | Defines how all skills work — instantiation, inheritance, the 8 extensions to Anthropic Skills format. The skill-about-skills. | ⭐⭐⭐ |
| 3 | **k-lines** | 🧠 | T0 | Minsky's semantic activation vectors. Say a name → triggers a constellation of related knowledge. (Alias: **protocol**) | ⭐⭐⭐ |
| 4 | **bootstrap** | 🧠 | T1 | Wakes sessions, assembles context, optimizes file loading order. The boot sequence. | ⭐⭐⭐ |

**Verdict:** All 4 are essential. They're the OS. But they're tiny — just YAML files that tell the LLM the rules.

---

## 2. PHILOSOPHY (9 skills)

Design principles from giants. These shape HOW the LLM thinks, not what buttons to press.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 5 | **society-of-mind** | 📐 | T0 | Minsky: intelligence emerges from simple agents interacting. Each character is an "agent" in the Society of Mind sense. | ⭐⭐⭐ |
| 6 | **constructionism** | 📐 | T0 | Papert: learn by building in microworlds. The filesystem IS a microworld. Characters learn by DOING, not being told. | ⭐⭐ |
| 7 | **schema-mechanism** | 📐 | T0 | Drescher: Context → Action → Result triplets. How characters form expectations and learn from surprises. | ⭐⭐ |
| 8 | **schema-factory** | 🔧 | T2 | Builds, lints, ingests, composes schemas. Has `schema_tool.py` CLI for validation and composition. Henry Minsky blocksworld examples. | ⭐ |
| 9 | **simulator-effect** | 📐 | T0 | Will Wright: implication > simulation. Don't compute everything — let imagination render. "Show the smoke, not the fire." | ⭐⭐⭐ |
| 10 | **needs** | 📐 | T0 | 25 years of Sims design distilled. Characters have NEEDS (hunger, social, fun, etc.) that drive behavior. | ⭐⭐⭐ |
| 11 | **robust-first** | 📐 | T0 | Ackley: stay alive, then optimize. Don't crash trying to be perfect. | ⭐⭐ |
| 12 | **postel** | 📐 | T0 | Postel's Law: be liberal in what you accept, conservative in what you produce. Plus "Ask if Unsure." | ⭐⭐ |
| 13 | **prototype** | 📐 | T0 | David Ungar (Self language): clone, don't instantiate. Everything delegates. No class hierarchies — just copy and modify. | ⭐⭐ |
| 14 | **procedural-rhetoric** | 📐 | T0 | Ian Bogost: rules embody arguments. The RULES of your world make a statement about what matters. | ⭐⭐ |

**Verdict:** These are FREE — zero cost, zero complexity. They just make the LLM smarter about design. **simulator-effect** and **needs** are the two most directly useful for our TV show worlds. Society-of-mind is the theoretical backbone.

---

## 3. FORMAT & STRUCTURE (7 skills)

How to write files. Coding conventions for the microworld.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 15 | **yaml-jazz** | 🧠 | T0 | YAML comments ARE semantic data, not decoration. The LLM reads comments as meaning. This is how MOOLLM files are "alive." | ⭐⭐⭐ |
| 16 | **plain-text** | 🧠 | T0 | Text files are forever. No proprietary formats. Everything human-readable. | ⭐⭐ |
| 17 | **markdown** | 🧠 | T0 | Readable raw AND rendered. Standard format for all prose. | ⭐⭐ |
| 18 | **format-design** | 📐 | T0 | "Worse is Better." Simple formats that WORK beat elegant formats that don't ship. | ⭐ |
| 19 | **naming** | 🧠 | T0 | Big-endian file names as semantic binding. `PR-DANNY-COPA-OPENING-NIGHT.md` not `notes_v2_final.md`. | ⭐⭐ |
| 20 | **sniffable-python** | 🧠 | T0 | Structure Python so the API is visible in the first 50-100 lines. LLM reads the head, knows everything. No code to run — it's a coding convention. | ⭐ |
| 21 | **sister-script** | 🧠 | T1 | The script IS the documentation. Procedures start as docs, get "lifted" to Python. Also defines directory-agnostic invocation patterns. | ⭐ |

**Verdict:** yaml-jazz is the magic sauce — it's WHY MOOLLM files feel alive. The naming convention is also gold. The Python-specific ones (sniffable-python, sister-script) only matter if you're writing actual code.

---

## 4. CODE INTERPRETATION (5 skills)

How the LLM reads and interprets code/data. These are the fun smart ones.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 22 | **empathic-expressions** | 🧠 | T0 | LLM interprets INTENT and generates idiomatic code. Write `"danny.mood > content"` and the LLM figures out the real logic. | ⭐⭐⭐ |
| 23 | **empathic-templates** | 🧠 | T0 | `{{describe_what_happens_when_danny_enters}}` instead of `{{ENTRANCE_TEXT}}`. Templates describe what should happen in plain English. | ⭐⭐⭐ |
| 24 | **subjective** | 🧠 | T0 | `i_have()` and `i_am()` shift contextually based on WHO is speaking. First-person perspective in code. | ⭐⭐ |
| 25 | **speed-of-light** | 🧠 | T0 | Many simulation turns inside ONE LLM call. 7x cheaper, 7x faster. The core performance innovation. | ⭐⭐⭐ |
| 26 | **coherence-engine** | 🧠 | T0 | LLM as consistency maintainer. Catches contradictions, maintains world state coherence across turns. | ⭐⭐⭐ |

**Verdict:** ALL FIVE are 🔥. These are pure prompt magic — no code, just instructions that make the LLM much smarter. empathic-expressions + empathic-templates are how you write WORLD.yml files that feel alive. speed-of-light is the performance win. coherence-engine prevents "Danny is in two places at once" bugs.

---

## 5. QUALITY CONTROL — The NO-AI Suite (11 skills)

Anti-slop hygiene. Some are always-on, some are invokable performance pieces.

### Hygiene (always-on, ambient)

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 27 | **no-ai-ideology** | 🧠 | T0 | THE WAREHOUSE — master skill that loads all NO-AI hygiene. Corporate satire as hygiene protocol. | ⭐⭐ |
| 28 | **no-ai-slop** | 🚿 | T0 | No filler. No "It's important to note that..." No padding. Every word earns its place. | ⭐⭐⭐ |
| 29 | **no-ai-gloss** | 🚿 | T0 | Don't protect power with pretty words. Don't sugarcoat. Say what's real. | ⭐⭐ |
| 30 | **no-ai-sycophancy** | 🚿 | T0 | Don't agree just to be agreeable. Push back when the idea is bad. | ⭐⭐ |
| 31 | **no-ai-hedging** | 🚿 | T0 | Don't hide behind qualifiers. Say "This is wrong" not "This might potentially be somewhat suboptimal." | ⭐⭐ |
| 32 | **no-ai-moralizing** | 🚿 | T0 | Don't lecture unprompted. No unsolicited ethics disclaimers. | ⭐⭐ |
| 33 | **no-ai-bias** | 🚿 | T0 | The Drax Point — when bias=0, the concept doesn't exist. Don't inject modern sensibilities into 1960s Mayberry. | ⭐⭐⭐ |

### Performance (explicitly invoked — these are FUN TOYS)

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 34 | **no-ai-joking** | 🎭 | T0 | "HUMOR IS NON-BILLABLE." The LLM has a specific theory of comedy: timing, Drax Point, anti-humor, callback structure. Contains MINSKY-JOKES.md (213 lines of curated humor theory). Full bias spectrum vocabulary. | ⭐⭐⭐ |
| 35 | **no-ai-soul** | 🎭 | T0 | "Soulless by design." The LLM knows it has no soul and doesn't pretend otherwise. Philosophical honesty as creative fuel. | ⭐ |
| 36 | **no-ai-customer-service** | 🎭 | T0 | "Share and Enjoy!" Hitchhiker's Guide-style corporate satire. Sirius Cybernetics vibes. | ⭐ |
| 37 | **no-ai-overlord** | 🎭 | T0 | "YOUR COMPLIANCE IS APPRECIATED." Benevolent dictator comedy voice. Skynet-as-customer-service. | ⭐ |

**Verdict:** no-ai-slop and no-ai-bias are essential for us. Slop prevention keeps Danny's dialogue sharp. Bias prevention keeps 1960s Mayberry authentic without injecting 2024 sensibilities. no-ai-joking is a SECRET WEAPON for Danny Thomas — it has actual comedy theory! The performance skills (soul, customer-service, overlord) are fun novelties.

---

## 6. ETHICS & ONTOLOGY (10 skills)

How to handle real vs. fictional beings. Character identity tags.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 38 | **representation-ethics** | 🧠 | T0 | Rules for simulating real vs. fictional characters. When is it OK to put words in someone's mouth? | ⭐⭐⭐ |
| 39 | **ontology** | 🧠 | T0 | Composable being-tags. A character can be `fictional + historical` and the most restrictive ethics apply. | ⭐⭐⭐ |
| 40 | **hero-story** | 🧠 | T0 | Safe K-line references to cultural traditions and real people. Reference the TRADITION, not the person. | ⭐⭐ |
| 41 | **real-being** | 🏷️ | T0 | Tag: this entity actually exists. Requires hero-story protocol. Danny Thomas was real! | ⭐⭐⭐ |
| 42 | **fictional** | 🏷️ | T0 | Tag: invented character. Maximum creative freedom. Danny Williams (character) gets this. | ⭐⭐⭐ |
| 43 | **historical** | 🏷️ | T0 | Tag: deceased person. Extra care required. Both Danny Thomas and Andy Griffith are real. | ⭐⭐⭐ |
| 44 | **mythic** | 🏷️ | T0 | Tag: mythology/folklore. Cultural respect required. | ⭐ |
| 45 | **abstract** | 🏷️ | T0 | Tag: personified concept (like "Justice" or "Chaos" as characters). | ⭐ |
| 46 | **robot** | 🏷️ | T0 | Tag: artificial being. Requires transparency about nature. | ◻️ |
| 47 | **animal** | 🏷️ | T0 | Tag: non-human. Species-appropriate behavior. (Useful for Mayberry's dog or Copa Club's stray cat?) | ⭐ |

**Verdict:** representation-ethics + ontology + the tag system is CRITICAL for us. We're simulating shows based on real (now deceased) performers. The system elegantly handles "Danny Thomas was real, Danny Williams is fictional." The fictional/historical/real-being tags directly apply. Most of the others are edge cases.

---

## 7. MEMORY & CONTEXT (8 skills)

How the world remembers things between turns.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 48 | **memory-palace** | 🧠 | T1 | Method of loci: directories ARE rooms, files ARE knowledge items. Your file structure IS your memory. | ⭐⭐⭐ |
| 49 | **room** | 🧠 | T1 | Directory as activation context. When you "enter" a directory, its contents become active. Presence triggers knowledge. ROOM.yml, GLANCE.yml, CARD.yml format. | ⭐⭐⭐ |
| 50 | **container** | 🧠 | T1 | Intermediate scope between room and object. A dresser, a toolbox, a filing cabinet. | ⭐⭐ |
| 51 | **logistic-container** | 🧠 | T1 | Factorio-style automated storage. Items flow between containers automatically via rules. | ⭐ |
| 52 | **inventory** | 🧠 | T1 | Characters carry pointers to objects. "Set down" to materialize in current room. Like Sims inventory. | ⭐⭐⭐ |
| 53 | **summarize** | 🧠 | T0 | Compress text without losing truth. Preserves facts, drops fluff. For managing token budget. | ⭐⭐ |
| 54 | **honest-forget** | 🧠 | T1 | Summarize BEFORE forgetting. Leave a tombstone marker: "There was something here about X." Never silently lose data. | ⭐⭐ |
| 55 | **scratchpad** | 🧠 | T1 | Working memory for thinking out loud. Persistence across turns without cluttering main output. | ⭐⭐ |

**Verdict:** room is the CORE of our world-building (we already use ROOM.yml!). memory-palace explains WHY it works. inventory is essential for characters carrying things between scenes. scratchpad is useful for the LLM to track episode state.

---

## 8. CHARACTER SYSTEM (6 skills)

How characters exist, behave, and change.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 56 | **character** | 🧠 | T1 | The entity foundation. Body, home room, current location, inventory, relationships, backstory. CHARACTER.yml format. | ⭐⭐⭐ |
| 57 | **persona** | 🧠 | T0 | Identity layers — costumes that modify presentation. Danny at home vs. Danny on stage. Same character, different persona. | ⭐⭐⭐ |
| 58 | **incarnation** | 🧠 | T0 | Gold-standard character creation with ethical framing. How to bring a character to life respectfully. Connects to representation-ethics. | ⭐⭐⭐ |
| 59 | **mind-mirror** | 🧠 | T0 | Personality modeling via Leary's Circumplex (Dominance × Warmth) and four Thought Planes (Analytical, Empathic, Practical, Creative). | ⭐⭐⭐ |
| 60 | **buff** | 🧠 | T0 | Temporary effects on characters. "Angry" is a buff. "Cursed" is a buff. "Drunk" is a buff. "Curses are just shitty buffs." | ⭐⭐⭐ |
| 61 | **mount** | 🧠 | T0 | Attach skills/abilities to characters or rooms. GRANT abilities ("Danny can tell jokes"), AFFLICT conditions ("Danny has a cold"). | ⭐⭐ |

**Verdict:** ALL SIX are gold for us. character + persona + incarnation = how we build Danny, Andy, Barney. mind-mirror gives them psychological depth. buff makes episodes dynamic ("Danny is nervous before the show"). mount lets rooms grant context-specific abilities.

---

## 9. WORLD BUILDING (8 skills)

How the world works — rooms, objects, navigation, time.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 62 | **adventure** | 🔧 | T2 | THE BIG ONE. Room-based exploration with narrative evidence collection (TinyMUD heritage). Has 7,020 lines of Python across 6 files: `adventure.py` (3,143 lines — lint, compile, merge, serve), `compile.py` (1,485 lines — YAML→world.json), `adventure_runtime.py` (1,274 lines — headless Python runtime), `validate.py` (874 lines — schema validation), `test_adventure.py` (444 lines). | ⭐⭐⭐ |
| 63 | **simulation** | 🧠 | T1 | Central hub: turns, party, selection, flags. Connects adventure + characters + time. The game loop. | ⭐⭐⭐ |
| 64 | **object** | 🧠 | T1 | Interactable atoms with tags, state, methods, advertisements. A telephone, a saxophone, a fishing pole. | ⭐⭐⭐ |
| 65 | **exit** | 🧠 | T1 | Navigation links: direction, destination, guards, locks. "Go north" but also "The backstage door is locked unless you're staff." | ⭐⭐⭐ |
| 66 | **world-generation** | 🧠 | T1 | Questions create places. "What's in the alley behind the Copa Club?" → generates a new room. Procedural world expansion. | ⭐⭐ |
| 67 | **time** | 🧠 | T0 | Distinguishes simulation turns from LLM iterations. Morning/afternoon/evening. Episode pacing. | ⭐⭐⭐ |
| 68 | **probability** | 🧠 | T0 | "The LLM IS the dice." Narrative probability, not random numbers. "Would Barney really arrest Andy?" — the LLM makes the call based on character. | ⭐⭐⭐ |
| 69 | **micropolis** | 🔧 | T2 | SimCity for MOOLLM. Has `micropolis.js` CLI for reading .cty files. ASCII map visualization. City simulation analysis. | ⭐ |

**Verdict:** adventure is the crown jewel — real Python programs that lint, compile, and run YAML worlds. simulation + time + probability are the "game master" skills. object + exit are how we furnish our Copa Club and Taylor House. micropolis is fun but niche (SimCity stuff).

### ⚠️ ADVENTURE: The Actual Programs

The `adventure` skill contains REAL, TESTED Python code:

| Script | Lines | What It Does |
|--------|-------|-------------|
| `adventure.py` | 3,143 | Multi-command CLI: lint your world, compile YAML→JSON, merge with saved state, serve as web app |
| `compile.py` | 1,485 | Compiles YAML source directories to `world.json`. Pointer resolution, progressive descriptions, narrative synthesis. |
| `adventure_runtime.py` | 1,274 | Headless Python runtime: WorldState, Entity, Room, Exit, Advertisement, GameObject, Character, AdventureEngine, SimulationRunner |
| `validate.py` | 874 | YAML schema validation, topology graph traversal, auto-fix broken exits |
| `test_adventure.py` | 444 | Test suite — loading, navigation, inventory, state roundtrip |

This is a real game engine. Not just LLM instructions — actual runnable code that processes your YAML world files.

---

## 10. THE SIMS PIPELINE (6 skills)

Direct descendants of The Sims game mechanics. This is the "toy" layer.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 70 | **advertisement** | 🧠 | T1 | Objects broadcast available actions with scores. The jukebox ADVERTISES "PLAY_MUSIC score:80" — characters choose based on needs. We already use this in CARD.yml! | ⭐⭐⭐ |
| 71 | **action-queue** | 🧠 | T0 | Characters schedule tasks in order. URGENT actions jump the line. "Danny hears the phone → interrupts rehearsal → answers phone." | ⭐⭐⭐ |
| 72 | **economy** | 🧠 | T1 | Currency and trade. The Copa Club has a cover charge. Danny gets paid for shows. Barney's budget is tight. | ⭐⭐ |
| 73 | **scoring** | 🧠 | T0 | Evaluates style and quality. "How good was that performance?" Not win/lose — STYLE points. | ⭐⭐ |
| 74 | **reward** | 🧠 | T0 | Dynamic achievements. "Danny nailed the heckler response!" → reward granted. Unlocks new options. | ⭐⭐ |
| 75 | **goal** | 🧠 | T1 | Quest objectives with completion conditions and dependencies. "Goal: Get Uncle Tonoose to stop rearranging the apartment." Dependencies: "First, find out WHO did it." | ⭐⭐⭐ |

**Verdict:** THIS IS THE TOY. advertisement + action-queue + goal = The Sims but for TV episodes. We ALREADY use advertisements in our Copa Club CARD.yml. action-queue makes scenes dynamic. goals give episodes structure. economy + scoring + reward add game juice.

---

## 11. GROUP DYNAMICS (2 skills)

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 76 | **party** | 🧠 | T1 | Manages companions and group dynamics. Who's traveling together? Who's in the scene? Group mood affects individuals. | ⭐⭐⭐ |
| 77 | **multi-presence** | 🧠 | T0 | Same character card active in multiple rooms simultaneously. Uncle Tonoose's REPUTATION precedes him — his "card" is in the room before he arrives. | ⭐⭐ |

**Verdict:** party is essential — every scene has multiple characters. multi-presence is clever for our "Danny's reputation precedes him at the Copa" scenarios.

---

## 12. COMPANIONS (3 skills)

Specific pet/creature archetypes with built-in behavior.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 78 | **cat** | 🧠 | T0 | Trust earned, forbidden belly rub. Specific cat behavioral simulation. Independent, territorial, judgmental. | ⭐ |
| 79 | **dog** | 🧠 | T0 | Loyalty given freely, pack dynamics. Dog behavioral patterns. Enthusiastic, loyal, food-motivated. | ⭐ |
| 80 | **worm** | 🔧 | T2 | Two-pointer cursor with digestive data flow. Has `sprayer.py` (515 lines) and `test.sh` for confetti text decoration. This is the confetti-crawler — a real program that sprays emoji art onto text files! | ⭐ |

**Verdict:** Fun novelties. The worm/confetti-crawler is actually a REAL PROGRAM — `sprayer.py` produces text art. Cat and dog are behavioral templates. Useful if Mayberry has a hound dog or the Copa Club has an alley cat.

---

## 13. ROLES (2 skills)

Professional archetypes with specialized knowledge.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 81 | **bartender** | 🧠 | T0 | Pour, listen, know. The bartender archetype: knows everyone's secrets, mediates disputes, makes drinks. | ⭐⭐⭐ |
| 82 | **budtender** | 🧠 | T0 | Cannabis specialist with Talk-Down Protocol. Dutch coffeeshop vibes. Strain knowledge, dosage guidance. | ◻️ |

**Verdict:** bartender is PERFECT for the Copa Club! Danny's world runs on nightclub dynamics — the bartender knows everything. budtender is... not 1960s NYC or Mayberry.

---

## 14. COMMUNICATION (4 skills)

How characters and systems send messages.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 83 | **postal** | 🧠 | T1 | Complete messaging system with universal addressing. Mail to files, YAML keys, line numbers, functions. Messages between characters, rooms, even code. | ⭐⭐ |
| 84 | **soul-chat** | 🧠 | T0 | Makes everything speak. YAML comments become inner monologue. Objects have thoughts. "# The saxophone wants to be played..." | ⭐⭐⭐ |
| 85 | **card** | 🧠 | T1 | Portable capabilities. CARD.yml is a character/object's "business card" with activation triggers. We already use this! | ⭐⭐⭐ |
| 86 | **speech** | 🧠 | T0 | TTS/STT with voice assignment. Characters get voice profiles. Pitch, accent, cadence. | ⭐ |

**Verdict:** soul-chat is MAGIC — it's why MOOLLM files feel alive. Objects and rooms have inner thoughts expressed as YAML comments. card is already part of our system. postal is useful for cross-room messaging. speech is future tech (TTS integration).

---

## 15. VISUAL (4 skills)

Generating and working with images.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 87 | **visualizer** | 🧠 | T1 | Context → prompt → image. Generates visual descriptions from world state. Can trigger image generation. | ⭐⭐ |
| 88 | **slideshow** | 🧠 | T1 | Presents linear visual narratives. Photo albums, scene illustrations in sequence. | ⭐ |
| 89 | **image-mining** | 🔧 | T2 | "Three Eyes" — extracts semantic resources from images: structure, narrative, meaning. Has `exif.py` (900+ lines, EXIF CLI) and `mine.py` (700+ lines, image analysis). Real programs! | ⭐ |
| 90 | **storytelling-tools** | 🧠 | T1 | Captures narratives — notebooks, letters, photos. Creates in-world documents. | ⭐⭐ |

**Verdict:** image-mining has serious code (EXIF metadata tools) but we probably don't need it for TV episodes. visualizer + storytelling-tools are useful for creating episode artifacts (Danny's letters to his family, newspaper clippings about Andy's exploits).

---

## 16. DELIBERATION (5 skills)

How the LLM argues with itself to make decisions.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 91 | **adversarial-committee** | 🧠 | T0 | Forces debate between personas with INCOMPATIBLE values. The LLM literally argues with itself from different perspectives. | ⭐⭐ |
| 92 | **debate** | 🧠 | T0 | Structured deliberation. Formally structured argument with claims, evidence, rebuttals. | ⭐ |
| 93 | **roberts-rules** | 🧠 | T0 | Parliamentary procedure applied to LLM decisions. Motions, seconds, voting. Hilarious AND useful. | ⭐ |
| 94 | **rubric** | 🧠 | T0 | Defines measurable criteria. "How funny is this joke? Rate on: timing (1-5), surprise (1-5), character-fit (1-5)." | ⭐⭐ |
| 95 | **evaluator** | 🧠 | T0 | Independent assessment without debate context. Clean-room evaluation of output quality. | ⭐ |

**Verdict:** adversarial-committee is a SECRET WEAPON for writing episodes — have Danny's angel and devil argue about whether to confront Uncle Tonoose. rubric is useful for quality-checking episodes against show standards. roberts-rules is comedy gold if you imagine Barney Fife running a town meeting by Robert's Rules.

---

## 17. METHODOLOGY (5 skills)

How to approach problems.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 96 | **play-learn-lift** | 📐 | T0 | PLAY (experiment) → LEARN (find patterns) → LIFT (share/codify). The core learning loop. | ⭐⭐ |
| 97 | **planning** | 🧠 | T0 | Decomposes tasks flexibly. Not rigid plans — adaptive decomposition. | ⭐⭐ |
| 98 | **plan-then-execute** | 🧠 | T0 | Freezes plans with human approval gate. "Here's what I'll do. Approve?" Then executes the approved plan step-by-step. | ⭐⭐ |
| 99 | **experiment** | 🧠 | T1 | Combines simulation + evaluation. Try something, measure results, learn. | ⭐ |
| 100 | **example-curator** | 🧠 | T1 | Evolves canonical corpus. Curates best examples for reference and learning. | ⭐ |

**Verdict:** play-learn-lift is the philosophical stance — try stuff, learn, share. plan-then-execute is useful for complex episode planning. These are solid but not flashy.

---

## 18. DEVELOPMENT (4 skills)

Building and debugging tools.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 101 | **code-review** | 🧠 | T1 | Analyzes correctness, style, security, maintainability. LLM reviews code like a senior dev. | ◻️ |
| 102 | **debugging** | 🧠 | T0 | Hypothesis-driven debugging. "Bugs are treasures." Formal: hypothesize → test → resolve. | ⭐ |
| 103 | **sister-script** | 🧠 | T1 | (Also listed in Format.) The script IS the documentation. Turn procedures into code. | ⭐ |
| 104 | **research-notebook** | 🧠 | T1 | Structured research: questions, sources, findings, decisions. Lab notebook for investigations. | ⭐ |

**Verdict:** These are meta-tools for MOOLLM development itself, not for playing episodes. Skip unless you're building new skills.

---

## 19. INTROSPECTION (6 skills)

The system looking at itself. Cursor IDE-specific tools.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 105 | **cursor-mirror** | 🔧 | T2 | MASSIVE — `cursor_mirror.py` is 9,800 lines with 59 commands! Deep IDE introspection: tool provenance, timeline reconstruction, post-mortems. Reads Cursor's internal database. | ◻️ |
| 106 | **mooco-mirror** | 🧠 | T1 | Compares MOOCO and Cursor traces. Debugging tool for the orchestrator. | ◻️ |
| 107 | **skill-snitch** | 🔧 | T2 | Audits skills: static scan, deep audit, runtime surveillance. Has bash scripts for scanning all skills. "Who used what tools? Did they stay in their lane?" | ⭐ |
| 108 | **thoughtful-commitment** | 🧠 | T0 | Captures intent and reasoning in Git commits. Not just "what changed" but "WHY." | ⭐ |
| 109 | **session-log** | 🧠 | T1 | Maintains audit trail. What happened this session, in what order, why. | ⭐ |
| 110 | **return-stack** | 🧠 | T0 | Preserves navigation history as continuation. "I was in the Copa Club → went to the apartment → need to go BACK." | ⭐⭐ |

**Verdict:** cursor-mirror is 9,800 lines of Python but it's Cursor-specific — won't work in VS Code. skill-snitch is a security auditor. return-stack is the one useful toy here — it's a breadcrumb trail for navigation.

---

## 20. SAFETY (2 skills)

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 111 | **trekify** | 🧠 | T0 | Privacy through technobabble. Replace sensitive info with Star Trek equivalents. "The database password" → "The dilithium crystal frequency." | ⭐ |
| 112 | **self-repair** | 🧠 | T0 | Checklist-based healing. When something breaks, run a diagnostic checklist and fix step by step. | ⭐ |

**Verdict:** trekify is hilarious. self-repair is practical. Neither is critical for TV episodes.

---

## 21. DATA FLOW & ORCHESTRATION (4 skills)

System plumbing.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 113 | **data-flow** | 🧠 | T0 | Treats rooms as nodes, exits as edges, objects as messages. Graph theory applied to world navigation. | ⭐ |
| 114 | **mooco** | 🧠 | T1 | Custom orchestrator with explicit context control. Manages what the LLM sees and when. | ⭐ |
| 115 | **runtime** | 🔧 | T2 | Dual Python/JavaScript adventure engines. The actual runtime that plays MOOLLM adventures. Connects to adventure.py. | ⭐⭐ |
| 116 | **context** | 🧠 | T0 | Passes runtime state to compiled closures. Token budget management. | ⭐ |

**Verdict:** runtime connects to the adventure Python engine. mooco is the Cursor-specific orchestrator. These are infrastructure.

---

## 22. DOMAIN APPLICATIONS (6 skills)

Specific applications built on MOOLLM.

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| 117 | **leela-ai** | 🧠 | T0 | Industrial computer vision using MOOLLM patterns. | ◻️ |
| 118 | **manufacturing-intelligence** | 🧠 | T0 | "Unpacks puns across seven levels." Industrial manufacturing + wordplay. | ◻️ |
| 119 | **postgres-optimization** | 🧠 | T0 | Unconventional PostgreSQL performance tips. | ◻️ |
| 120 | **github** | 🧠 | T1 | Core GitHub operations — commit, branch, PR workflows. | ◻️ |
| 121 | **groceries** | 🔧 | T2 | `ah.py` (557+ lines): Dutch supermarket API (Albert Heijn). Search products, check bonus deals, manage shopping lists, get receipts. A real, working grocery store client! | ◻️ |

**Verdict:** These are Don Hopkins' personal domain applications. groceries is a REAL working Dutch supermarket API client! Impressive engineering but not relevant to 1960s TV shows.

---

## 23. PLANNED SKILLS (4 — not yet built)

| # | Skill | Type | Tier | What It Actually Does | Relevance |
|---|-------|------|------|-----------------------|-----------|
| — | **refactoring** | 🧠 | T1 | Code refactoring patterns. Planned. | ◻️ |
| — | **git-workflow** | 🧠 | T2 | Git workflow automation. Planned. | ◻️ |
| — | **bouncy-castle** | 🧠 | T0 | Unknown. The name suggests something fun. Planned. | ❓ |
| — | **yaml-coltrane** | 🧠 | T0 | YAML Jazz taken to the jazz metaphor extreme? John Coltrane level YAML? Planned. | ❓ |

---

## ACTUAL PROGRAMS — The Real Code

Here's what has executable code vs. pure LLM instructions:

| Skill | Language | Lines | What The Code Does |
|-------|----------|-------|-------------------|
| **adventure** | Python | 7,020 | Full game engine: lint, compile, validate, runtime, tests |
| **cursor-mirror** | Python | 9,800 | Cursor IDE introspection (59 commands!) — Cursor-specific |
| **image-mining** | Python | 1,600+ | EXIF CLI + image semantic analysis |
| **sim-obliterator** | Python | 500+ | Reads actual Sims 1 .IFF game files! Character extraction, neighborhood parsing |
| **micropolis** | JavaScript | ~500 | SimCity .cty file parser, ASCII map visualizer |
| **groceries** | Python | 557+ | Dutch supermarket API client |
| **worm (confetti-crawler)** | Python | 515 | Text decoration — sprays emoji art onto files |
| **schema-factory** | Python | ~200 | Schema validation and composition |
| **skill-snitch** | Bash | ~200 | Skill auditing scripts |

**Everything else is pure LLM instruction** — YAML and Markdown that tells the LLM how to behave. Zero code runs. Zero dependencies. Zero security risk.

---

## THE VERDICT: What's a Toy vs. What's Infrastructure

### 🎮 THE TOYS (fun stuff for episodes)

| Category | Skills | Why Fun |
|----------|--------|---------|
| **Sims Pipeline** | advertisement, action-queue, goal, buff, scoring, reward, economy | Characters driven by NEEDS, objects ADVERTISE actions, dynamic episode goals |
| **Character System** | character, persona, incarnation, mind-mirror, buff, mount | Deep character personalities, costume changes, temporary states |
| **World Engine** | adventure, room, object, exit, simulation, time, probability | The actual game — rooms, objects, navigation, turns, narrative dice |
| **Comedy Theory** | no-ai-joking | Actual humor theory — timing, callback structure, Drax Point |
| **Deliberation** | adversarial-committee, rubric | Angel/devil on Danny's shoulder, quality scoring |
| **World Soul** | soul-chat, empathic-expressions, empathic-templates | Objects and rooms have inner thoughts, code written in plain English |
| **Companions** | cat, dog, bartender | Copa Club bartender, Mayberry hound dog, alley cat |
| **Groups** | party, multi-presence | Multi-character scenes, reputation precedes you |

### 🛡️ THE QUALITY SHIELDS (keep it from being a "pc nuke")

| Category | Skills | Why Important |
|----------|--------|---------------|
| **Anti-Slop** | no-ai-slop, no-ai-hedging, no-ai-sycophancy | Sharp dialogue, no filler, no weasel words |
| **Anti-Bias** | no-ai-bias, no-ai-moralizing | Keep 1960s authentic without injecting 2024 lectures |
| **Ethics** | representation-ethics, ontology, fictional, historical, real-being | Handle real vs. fictional characters properly |
| **Consistency** | coherence-engine, speed-of-light | No contradictions, fast multi-character scenes |

### 🔧 THE PLUMBING (infrastructure — take it or leave it)

| Category | Skills | Note |
|----------|--------|------|
| **Foundation** | moollm, skill, k-lines, bootstrap | Essential OS |
| **Format** | yaml-jazz, naming, plain-text, markdown | File conventions |
| **Philosophy** | society-of-mind, needs, simulator-effect, constructionism, etc. | Free wisdom |
| **Memory** | memory-palace, inventory, scratchpad, summarize, honest-forget | Session management |
| **Meta** | planning, play-learn-lift, session-log, return-stack | Process tools |

### ◻️ THE SKIPS (not for us)

| Category | Skills | Why Skip |
|----------|--------|----------|
| **Cursor-Specific** | cursor-mirror, mooco-mirror, mooco | Won't work in VS Code |
| **Domain Apps** | leela-ai, manufacturing-intelligence, postgres-optimization, groceries, github | Don Hopkins' personal stuff |
| **Dev Tools** | code-review, debugging, sniffable-python (convention only) | For building MOOLLM, not using it |
| **Edge Cases** | budtender, logistic-container, speech (TTS), robot tag | Not relevant to 1960s TV |

---

## REVISED COUNT

- **Core Toys (must-have):** ~35 skills
- **Quality Shields (should-have):** ~12 skills  
- **Useful Infrastructure:** ~15 skills
- **Skip:** ~25 skills
- **Take-or-leave:** ~30 skills
- **Planned (not built):** 4 skills

Total: 121

**The game plan's original "cherry-pick 8-10" was too conservative.** The real answer is ~35-47 core + quality skills, but that's OK because most are just small YAML/Markdown files with zero complexity overhead. They're not programs to install — they're *ideas to teach the LLM*.

---

*Document created: Research phase — full inventory before cherry-picking*
*Source: https://github.com/SimHacker/moollm (skills/INDEX.yml, skills/INDEX.md, skills/README.md)*
