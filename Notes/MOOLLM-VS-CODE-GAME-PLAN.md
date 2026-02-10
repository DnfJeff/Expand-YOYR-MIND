# MOOLLM in VS Code — Research & Game Plan

> **Status:** Research complete. Game plan drafted. NOT building yet.  
> **Date:** 2026-02-09  
> **Goal:** Run MOOLLM-style "Episodes & Seasons" against our Danny Thomas Show and Mayberry worlds, in VS Code with GitHub Copilot — NOT Cursor.

---

## Part 1: What MOOLLM Actually Is (The Toy, Not the Nuke)

### The Simple Version

MOOLLM is **not software you install**. There is no `npm install moollm`. There is no server, no database, no build step.

It is a **repo full of YAML + Markdown files** that an LLM reads as instructions. The LLM **is** the runtime. The chat window **is** the game engine.

```
Human types: "LOOK"
  → LLM reads the ROOM.yml in the current directory
  → LLM describes what you see
  → LLM updates state files if needed

That's it. That's the whole runtime.
```

### The Key Parts

| Component | What It Is | Where It Lives | Do We Need It? |
|-----------|-----------|----------------|----------------|
| `.cursorrules` | System prompt injected every chat | Root of repo | YES — we need a VS Code equivalent |
| `WORLD.yml` | Top-level world settings | Root of world dir | **WE ALREADY HAVE THESE** |
| `ROOM.yml` | Room description + exits | Each directory | **WE ALREADY HAVE THESE** |
| `GLANCE.yml` | Quick summary for LLM skimming | Each directory | **WE ALREADY HAVE THESE** |
| `CARD.yml` | Detailed interface definition | Each directory | **WE ALREADY HAVE THESE** |
| `CHARACTER.yml` | Character personality + state | `characters/` subdirs | **WE HAVE THESE (per-character dirs)** |
| `skills/` | 117 "programs" the LLM interprets | `skills/` directory | **CHERRY-PICK ~8-10** |
| `kernel/` | Boot protocol, drivers, rules | `kernel/` directory | **SIMPLIFY TO 1 FILE** |
| `.moollm/` | Runtime state, logs, scratch | Gitignored dir | YES — lightweight |
| `examples/adventure-4/` | Their demo world | Single adventure | **OUR WORLDS REPLACE THIS** |

### What They Have That We Don't (Yet)

1. **A system prompt** (`.cursorrules` / `.github/copilot-instructions.md`) that tells the LLM "you are a Dungeon Master"
2. **Session logs** — append-only markdown files that record what happened
3. **The "Speed of Light" pattern** — simulate many turns in one chat message
4. **Episode structure** — we want Seasons/Episodes, they use Adventures

### What We Have That They Don't

1. **Two separate worlds** already built to spec (Mayberry + Danny Thomas)
2. **Richer character separation** (individual directories per character)
3. **Period-accurate research** (transcripts, real episode references)

---

## Part 2: How Cursor Runs It vs How VS Code Would

### Cursor's Mechanism

```
1. User opens repo in Cursor
2. Cursor reads .cursorrules → injects into EVERY chat message as system prompt
3. Cursor indexes entire repo for semantic search
4. User types "LOOK" in chat
5. Claude reads relevant ROOM.yml, CHARACTER.yml files
6. Claude responds in-character as Dungeon Master
7. Claude writes state changes to files
```

**Key Cursor features they depend on:**
- `.cursorrules` — auto-injected system prompt
- Semantic search (codebase indexing) — find relevant files
- File read/write tools — LLM can read YAML and update state
- Terminal access — run Python scripts

### VS Code + GitHub Copilot Equivalent

| Cursor Feature | VS Code Equivalent | Status |
|----------------|-------------------|--------|
| `.cursorrules` | `.github/copilot-instructions.md` | ✅ Supported natively |
| Semantic search | Copilot `@workspace` | ✅ Built-in |
| File read/write | Copilot Agent mode tools | ✅ Available |
| Terminal | Copilot `run_in_terminal` | ✅ Available |
| Auto-indexing | VS Code workspace indexing | ✅ Automatic |
| Chat interface | Copilot Chat | ✅ Built-in |

**Bottom line: Everything maps 1:1.** The translation is straightforward.

---

## Part 3: Token Usage Analysis

### How MOOLLM Consumes Tokens

MOOLLM is **context-hungry by design**. Each chat turn, the LLM needs to read:

| What | Approx Tokens | When |
|------|--------------|------|
| System prompt (`.cursorrules`) | ~800-1,500 | Every message |
| Current ROOM.yml | ~200-500 | Every "LOOK" or scene |
| Active CHARACTER.yml files (2-3) | ~300-800 each | When characters are present |
| WORLD.yml (world rules) | ~400-600 | Referenced for tone/rules |
| Relevant skill files | ~200-2,000 each | When needed (speed-of-light, etc.) |
| Session log (recent context) | ~500-2,000 | For continuity |
| User message | ~20-100 | Each turn |

**Per-turn estimate (simple scene):** ~2,000-4,000 tokens input  
**Per-turn estimate (complex multi-character):** ~5,000-10,000 tokens input  
**Speed-of-Light multi-turn simulation:** ~10,000-30,000 tokens input, ~5,000-15,000 output

### Their Model Requirements

From the repo's experiment templates and session logs:

```yaml
# What they recommend
recommended_models:
  - claude-opus-4          # Top tier, expensive
  - claude-sonnet-4        # Good balance
minimum_context: 100000    # 100K context window
max_tokens: 50000          # Up to 50K output

# What they actually use (from session logs)
actual_models_used:
  - claude-4.5-opus-high-thinking
  - gpt-5.1-codex-max
  
# Cursor limits
fullContextTokenLimit: 30000
```

### Can Lightweight Models Handle This?

| Model | Context | Character Voice? | Multi-Turn Sim? | Cost | Verdict |
|-------|---------|-----------------|-----------------|------|---------|
| **Claude Haiku 3.5** | 200K | Decent for 2-3 chars | Simple scenes only | ~0.33x Sonnet | ⚠️ Maybe for simple episodes |
| **Claude Sonnet 4** | 200K | Excellent | Yes, 10-20 turns | 1x baseline | ✅ Sweet spot |
| **Claude Opus 4** | 200K | Best | Yes, 30+ turns | 5x Sonnet | Overkill for episodes |
| **GPT-4o-mini** | 128K | Good for 2-3 chars | Simple scenes | ~0.2x Sonnet | ⚠️ Adequate for basic play |
| **Llama 3.3 70B (local)** | 128K | Moderate | Struggles past 5 chars | Free | ⚠️ Needs testing |
| **Mistral Small (local)** | 32K | Basic | 2-3 chars max | Free | ❌ Too limited |
| **Phi-4 (local)** | 16K | Weak for roleplay | No | Free | ❌ Wrong tool |

### The Haiku Question

You asked about Haiku at 0.33x token cost. Here's the honest assessment:

**What Haiku CAN do:**
- Simple two-character scenes (Andy + Barney at the courthouse)
- Basic room descriptions ("LOOK", "GO NORTH")
- Read and follow YAML instructions
- Maintain basic character voice for 1-2 characters

**What Haiku STRUGGLES with:**
- Maintaining 4+ distinct character voices simultaneously
- Complex multi-turn Speed-of-Light simulations
- Subtle character dynamics (Uncle Tonoose's grandiosity vs Danny's exasperation)
- Remembering nuanced state across many turns

**Recommendation:** Start with whatever model Copilot provides (currently Claude Sonnet 4 / GPT-4o). Haiku could work for "rehearsal runs" — quick testing of scenes before doing a "real" episode with a better model. Think of it as the table read vs the filming.

### Local Models

For truly local/free:
- **Ollama + Llama 3.3 70B** — needs ~40GB VRAM or quantized version
- **Ollama + Mistral Nemo 12B** — runs on modest hardware but limited
- These would work for testing world structure, NOT for quality episodes
- The "Speed of Light" pattern specifically needs strong instruction-following

---

## Part 4: Our Structure — Episodes & Seasons

### Mapping Their Concepts to Ours

| MOOLLM Term | Our Term | Example |
|-------------|----------|---------|
| Adventure | Season | Season 1 of Danny Thomas Show |
| Session | Episode | "Danny's Big Night" |
| Speed-of-Light Run | Scene | Multi-character scene within episode |
| Room | Location | Copa Club, Taylor House, Floyd's |
| Character | Character | Same — Andy, Barney, Danny, etc. |
| Experiment | Special Episode | "What if Barney visited the Copa?" |

### Proposed Directory Structure

```
Research/
├── DannyThomasShow/           # WORLD — already exists
│   ├── WORLD.yml              # ✅ exists
│   ├── characters/            # ✅ exists (12+ characters)
│   ├── copa-club/             # ✅ exists (rooms built)
│   ├── williams-apartment/    # ✅ exists
│   ├── new-york-streets/      # ✅ exists
│   ├── visiting-locations/    # ✅ exists
│   ├── seasons/               # NEW — episode output
│   │   └── season-1/
│   │       ├── SEASON.yml     # Season metadata
│   │       ├── ep-01-dannys-big-night/
│   │       │   ├── EPISODE.yml
│   │       │   ├── SESSION.md     # The actual play log
│   │       │   └── NOTES.md       # Post-episode notes
│   │       └── ep-02-.../
│   ├── LOG.md                 # ✅ exists (append-only)
│   └── TRANSCRIPT.md          # ✅ exists
│
├── Mayberry/                  # WORLD — already exists
│   ├── WORLD.yml              # ✅ exists
│   ├── characters/            # ✅ exists
│   ├── main-street/           # ✅ exists (rooms built)
│   ├── taylor-house/          # ✅ exists
│   ├── seasons/               # NEW
│   │   └── season-1/
│   │       ├── ep-01-quiet-afternoon/
│   │       │   ├── EPISODE.yml
│   │       │   └── SESSION.md
│   │       └── ...
│   └── ...
```

### What an EPISODE.yml Looks Like

```yaml
episode:
  title: "Danny's Big Night"
  season: 1
  number: 1
  world: DannyThomasShow
  
  # The setup — what triggers the story
  premise: |
    Danny has a big show tonight at the Copa, but Uncle Tonoose 
    has arrived unexpectedly with his entire philosophy on how 
    Danny should perform. Meanwhile, Kathy needs Danny to handle 
    a school situation with Terry before he leaves.
  
  # Starting conditions
  setup:
    location: williams-apartment/
    time: afternoon
    characters_present:
      - danny-williams
      - kathy-williams
      - uncle-tonoose
    mood: escalating_chaos
  
  # Scenes to hit (loose outline, not rigid script)
  beats:
    - "Tonoose arrives with opinions"
    - "Kathy drops the school bomb"
    - "Danny tries to rehearse amid chaos"
    - "Copa show — Danny channels the chaos into comedy"
    - "Resolution back home"
  
  # Which characters might appear
  cast:
    primary: [danny-williams, kathy-williams, uncle-tonoose]
    secondary: [phil-brokaw, terry-williams]
    possible: [rusty-williams, charley-halper]
```

---

## Part 5: The Game Plan — Steps To Run This

### Phase 0: Research (THIS DOCUMENT) ✅

### Phase 1: The System Prompt (30 min)

Create `.github/copilot-instructions.md` with instructions telling Copilot:
- You are a Dungeon Master / TV show runner
- Directories are rooms, YAML files are state
- How to read WORLD.yml, ROOM.yml, CHARACTER.yml
- The "LOOK", "GO", "EXAMINE" commands
- Episode structure and logging
- Simplified Speed-of-Light for multi-character scenes

**This is the single most important file.** It replaces their entire `.cursorrules` + `kernel/` + 80% of `skills/`.

### Phase 2: Runtime Scaffolding (15 min)

Create minimal support structure:
- `.moollm/` directory (gitignored) for scratch state
- A `seasons/` directory template in each world
- A simple `EPISODE.yml` template

### Phase 3: First Episode — Proof of Concept (The Fun Part)

Pick one world (probably Mayberry — simpler cast). Open Copilot chat. Type:

```
Read Research/Mayberry/WORLD.yml and main-street/ROOM.yml.
We're starting Season 1, Episode 1: "A Quiet Afternoon."
Andy is at the courthouse. Barney arrives with big news.
LOOK.
```

See what happens. Iterate.

### Phase 4: Evaluate & Adjust

- Does the model maintain character voice?
- Are the YAML files being read correctly?
- Is the session log useful?
- Do we need more/fewer skills ported?

### Phase 5: Optional — Try Lighter Models

- Test same episode with Haiku or GPT-4o-mini
- Compare quality vs cost
- Decide if local Ollama is worth the setup

---

## Part 6: What We're NOT Doing

To keep this the toy and not the nuke:

| DON'T | WHY |
|-------|-----|
| Port all 117 skills | We need ~5-8 max |
| Build Python runtime scripts | We're using the LLM as the runtime |
| Create a kernel/ directory | One instructions file covers it |
| Implement complex boot sequences | VS Code + Copilot handles this natively |
| Try to replicate cursor-mirror | That's Cursor introspection, not relevant |
| Build an experiment framework | Episodes are simpler |
| Set up MCP servers | Not needed for basic play |
| Worry about `.cursorrules` format | `.github/copilot-instructions.md` is our equivalent |

### Skills Worth Cherry-Picking (Concepts Only, Not Files)

| Skill Concept | What We Take | Lines of Instructions |
|---------------|-------------|----------------------|
| Speed of Light | Multi-turn simulation in one message | ~20 lines in our prompt |
| Room | Directory = room pattern | ~10 lines |
| Character | CHARACTER.yml reading protocol | ~10 lines |
| Adventure | LOOK/GO/EXAMINE commands | ~15 lines |
| Simulation | Time/turn tracking | ~10 lines |
| Session Log | Append-only episode recording | ~5 lines |
| YAML Jazz | Comments carry meaning | ~5 lines |
| Postel's Law | Be generous interpreting player input | ~3 lines |

**Total: ~80 lines of instructions** vs their ~50,000 lines of skills.

---

## Part 7: Key Files in Their Repo (Reference Map)

If you ever need to dig back into moollm for a specific pattern:

| Need | Look Here |
|------|-----------|
| How rooms work | `skills/room/SKILL.md` |
| How characters work | `skills/character/SKILL.md` |
| Speed of Light protocol | `skills/speed-of-light/SKILL.md` |
| Adventure commands | `skills/adventure/SKILL.md` |
| Example session log | `examples/adventure-4/.../marathon-session.md` |
| Their system prompt | `.cursorrules` |
| Cursor driver config | `kernel/drivers/cursor.yml` |
| World manifest | `MOOLLM.yml` |
| Quick start guide | `QUICKSTART.md` |
| How experiments/runs work | `skills/experiment/SKILL.md` |
| Full design philosophy | `designs/eval/EVAL-INCARNATE-FRAMEWORK.md` |

---

## Summary

**What MOOLLM is:** A repo of instructions an LLM reads. The LLM is `eval()`. Files are state. Directories are rooms. Chat is the game.

**What we need to do:** Write one good system prompt, create an episode template, and start playing. We already built the worlds.

**Token cost:** Modest for simple scenes (~3K tokens/turn). Copilot's default model handles it fine. Haiku works for rehearsals. Local models are marginal.

**Risk:** Very low. Worst case: we write a `.md` file and have a chat. Best case: immersive TV show simulation.

---

*Ready to build Phase 1 when you are.*
