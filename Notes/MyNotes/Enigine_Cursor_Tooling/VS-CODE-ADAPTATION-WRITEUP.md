# MOOLLM → VS Code: How It Works and How We Get There

## What This Document Is

A ground-level write-up on adapting Don Hopkins' MOOLLM simulation engine for
VS Code + GitHub Copilot. Not a road map, not a pitch — a technical honest look at
how the thing actually runs, what VS Code gives us, what it doesn't, and the
cleanest path to getting worlds like Mayberry and the Danny Thomas Show running
for people who just want to open a folder and play.

---

## Part 1: How MOOLLM Actually Works (No Smoke)

### The Core Insight

MOOLLM is not software you install. There is no server, no runtime, no binary.
It is a collection of YAML files and Markdown documents that, taken together,
turn an LLM into a simulation engine.

The LLM is the CPU. The filesystem is RAM. YAML files are instructions.
Directories are rooms. The chat window is the console.

When you "boot" MOOLLM, you are really just stuffing a very carefully organized
set of text files into the LLM's context window, in a specific order, so that
the LLM starts behaving like a Dungeon Master / Sims controller / interactive
fiction engine.

There is no eval() call. The LLM IS eval().

### The Boot Sequence

Don built this for Cursor. Cursor has `.cursorrules` — a file that gets silently
injected into every chat request as a system prompt. That's the keystone.

Here's what happens when someone types "BOOT" in Cursor with MOOLLM:

```
1. Read .moollm/hot.yml          ← "What matters RIGHT NOW"
2. Read skills/INDEX.yml         ← "What skills exist"
3. PROBE                         ← Check tools, workspace, model (no terminal)
4. DETECT-DRIVER                 ← Am I in Cursor? Claude Code? Something else?
5. SETUP .moollm/                ← Create scratch files (logs, working-set)
6. Read constitution + protocols ← The rules of engagement
7. ORIENT                        ← "What am I? What can I see? What can I do?"
8. WARM-CONTEXT                  ← Load critical files into the conversation
9. STARTUP                       ← Pick mode: adventure | development | custom
```

If mode = adventure:

```
10. Read WORLD.yml               ← World rules, epochs, simulation parameters
11. Read .moollm/config.yml      ← Bootstrap config (what to load, in what order)
12. Read .moollm/state.yml       ← Resume point (or fresh start)
13. Build prompt from prompt.yml ← The system prompt template for this world
14. Cold-start: load GLANCEs     ← 50-token summaries of every entity
    -or-
    Warm-start: resume state     ← Pick up where we left off
15. Enter simulation loop
```

### The Simulation Loop (Per Tick)

One "tick" = 10-15 minutes of world time. Each tick:

1. Check what epoch it is (morning / afternoon / evening / night)
2. For each active character (max 4-6):
   - Load their GLANCE (~50 tokens)
   - Load their room's GLANCE (~50 tokens)
   - Evaluate available "advertisements" (actions scored 1-100)
   - Check each ad's guard condition (natural language: "character.needs.social < 40")
   - Pick the highest-scoring valid ad
   - Execute: update needs, generate narrative
3. Output transcript entry (teleplay format)
4. Log state changes
5. At epoch boundary: persist everything to YAML files

### Speed of Light (The Big Innovation)

Instead of calling the LLM once per character per tick, MOOLLM batches
**up to 8 turns in a single LLM call**. All characters are simulated
inside one context window. They "speak" using a floor protocol
(TAKE_FLOOR / YIELD_FLOOR / POINT_OF_ORDER / CALL_QUESTION) inherited
from Robert's Rules of Order.

One API call. Zero network latency between characters. Perfect coherence
because one model holds the whole scene.

This is what Don calls "speed of light" — working with vectors directly
inside a single model context, instead of tokenizing, sending, waiting,
decoding, re-tokenizing between separate agents.

### The File Hierarchy (Progressive Disclosure)

Every entity (room, character, object) can have up to 4 tiers of detail:

| Tier | File       | Tokens | When Loaded                      |
| ---- | ---------- | ------ | -------------------------------- |
| 1    | GLANCE.yml | ~50    | Always (cold start, every tick)  |
| 2    | CARD.yml   | ~200   | When character enters or acts    |
| 3    | README.md  | ~500   | Deep narrative context on demand |
| 4    | SKILL.md   | ~300   | Extended capability docs         |

This is a token budget system. You don't dump the whole world into context.
You load GLANCEs for everything, CARDs for what's relevant, and READMEs
only when someone asks "tell me more about this place."

Like level-of-detail mipmapping in 3D graphics — cheap at a distance,
rich up close.

---

## Part 2: What VS Code Gives Us (February 2026)

### The Direct Mapping

Every critical Cursor feature has a VS Code Copilot equivalent:

| Cursor                 | VS Code Copilot                                          |
| ---------------------- | -------------------------------------------------------- |
| `.cursorrules`         | `.github/copilot-instructions.md` (auto-injected always) |
| `codebase_search`      | `#codebase` (semantic workspace search)                  |
| `read_file`            | Agent mode reads files autonomously                      |
| `run_terminal_command` | Agent mode runs terminal commands                        |
| `list_dir`             | Agent mode lists directories                             |
| `edit_file`            | Agent mode creates/edits files                           |

VS Code actually has MORE than Cursor in several areas:

- **Custom agents** (`.agent.md`) — Define specialized personas with specific
  tools, instructions, and model preferences. You could have `@dm` for the
  Dungeon Master and `@worldbuilder` for authoring.
- **Prompt files** (`.prompt.md`) — Reusable `/commands` for common actions
  like `/look`, `/go north`, `/episode`.
- **Per-filetype instructions** (`.instructions.md`) — Target specific file
  types: "when editing `*.yml` in this project, validate against MOOLLM schema."
- **Agent handoffs** — Chain workflows: Plan Episode → Run Episode → Review.
- **MCP integration** — Plug in external tool servers.
- **AGENTS.md** — Alternative to `.github/copilot-instructions.md`, designed
  for multi-agent cross-tool repos.

### Agent Mode vs. Chat

VS Code Copilot Chat has three modes:

- **Ask** — Answer questions only. Read-only. Good for "explain this room."
- **Plan** — Generate a plan before acting. Good for "design a new episode."
- **Agent** — Autonomous. Reads files, runs commands, edits files, uses tools.
  This is the simulation engine driver.

Agent mode is what replaces Cursor's agentic behavior. You type a command,
the agent decides which files to read, pulls them into context, generates the
response, and writes outputs (session logs, state files) — all in one turn.

### What We Get for Free (Zero Code)

By creating a handful of Markdown and YAML files, with no extension, no code,
no build step:

1. **`.github/copilot-instructions.md`** — Always-on identity prompt:
   "You are a simulation engine. The filesystem is your world. Directories
   are rooms. YAML files are state."

2. **`.github/agents/dm.agent.md`** — The Dungeon Master agent:
   - Persona, rules, voice guidelines
   - Which tools it can use (file read/write, terminal)
   - Which model to prefer (strongest available)
   - Instructions for the tick loop protocol

3. **`.github/prompts/look.prompt.md`** — `/look` command
4. **`.github/prompts/go.prompt.md`** — `/go <direction>` command
5. **`.github/prompts/episode.prompt.md`** — `/episode` to run N ticks
6. **`.github/prompts/boot.prompt.md`** — `/boot` to initialize

7. **`.github/instructions/yaml-schema.instructions.md`** — With
   `applyTo: "**/*.yml"` so the agent understands MOOLLM YAML format
   when you're editing world files.

That's it. Open the world folder. Type `/boot` in Copilot Chat Agent mode.
It reads WORLD.yml, loads GLANCEs, assembles the prompt, and you're playing.

### What We Don't Get Without Code

The zero-code approach handles the **simulation loop** — the LLM reads files,
generates narrative, writes logs. But it can't do:

- **Rich visual UI** — No world map, no character dashboard, no transcript
  panel with formatted teleplay. Just chat text.
- **Sidebar navigation** — No Explorer tree view showing World → Locations →
  Rooms → Characters. You browse folders manually.
- **State validation** — No red squiggles when a ROOM.yml references an exit
  that doesn't exist. No schema checking.
- **Reliable persistence** — The agent will TRY to write state.yml and LOG.md,
  but it's instruction-following, not programmatic. It might forget.
- **Programmatic simulation** — The tick loop runs because the LLM follows
  instructions. A code-driven loop would be more deterministic.

---

## Part 3: Should It Be an Extension?

### The Honest Answer: Start Without One

An extension is a significant engineering commitment — TypeScript, build
pipeline, activation events, API contracts, publish to Marketplace. It adds
value, but it also adds inertia. And this is still Don's project architecture.
We're adapting, not forking.

**Phase 1: Zero-code. Instruction files + custom agents + prompt files.**

This gets worlds running TODAY. It validates the approach. It proves the
concept with zero maintenance burden. If the LLM is good enough to follow
the protocols reliably, you might never need an extension.

**Phase 2: MCP server (if we need reliable tools).**

If Phase 1 shows that the agent forgets to update state, or can't reliably
navigate the world, or needs custom tools (rollDice, advanceClock,
validateWorld), an MCP server is a lightweight step up. It's a standalone
process that provides typed tools to the agent. No VS Code API dependency.
Works with Copilot, Claude Desktop, anything that speaks MCP.

**Phase 3: Extension (if we want rich UI).**

If we want a sidebar world browser, a webview transcript panel, a visual
map, character status dashboards — that's extension territory. But those
are polish, not prerequisites. They make it consumer-facing, but the
simulation runs fine without them.

### What an Extension Would Actually Provide

| Feature                       | Value            | Effort |
| ----------------------------- | ---------------- | ------ |
| `@dm` Chat Participant        | Own the prompt   | Medium |
| Sidebar world tree view       | Browse visually  | Medium |
| Webview transcript panel      | Rich output      | High   |
| YAML schema validation        | Authoring QoL    | Medium |
| World template scaffolding    | Onboarding       | Low    |
| State persistence guarantees  | Reliability      | Medium |
| `pickDescription(lod)` hover  | Preview entities | Medium |
| Language Model API simulation | Code-driven loop | High   |

### Don's Worlds Still Work

A crucial design constraint: Don's existing MOOLLM worlds should load
without modification. Our approach must be ADDITIVE — we add the VS Code
instruction layer ON TOP of the existing world file structure. We don't
reorganize his rooms or rename his files.

His worlds have: WORLD.yml, .moollm/config.yml, .moollm/prompt.yml,
.moollm/state.yml, characters/CHARACTER.yml, rooms/ROOM.yml. All of that
stays exactly as-is. We add a `.github/` directory with our Copilot
instructions that know how to read his format.

---

## Part 4: How Worlds Load

### Your Worlds Are Already 85-90% Ready

Both Mayberry and the Danny Thomas Show have everything the engine needs:

| Component                          | Mayberry  | Danny Thomas |
| ---------------------------------- | --------- | ------------ |
| WORLD.yml with simulate block      | ✓         | ✓            |
| .moollm/config.yml (bootstrap)     | ✓         | ✓            |
| .moollm/prompt.yml (system prompt) | ✓         | ✓            |
| .moollm/state.yml (state tracker)  | ✓         | ✓            |
| ROOM.yml for every room            | ✓ (25)    | ✓ (16)       |
| CARD.yml with advertisements       | ✓         | ✓            |
| GLANCE.yml for every entity        | ✓ (1 gap) | ✓            |
| CHARACTER.yml for all characters   | ✓ (20)    | ✓ (15)       |
| Abstract prototype archetypes      | ✓ (35)    | ✓ (27)       |
| LOG.md / TRANSCRIPT.md templates   | ✓         | ✓            |

Minor gaps (easily fixed):

- `locations/abstract/` directory referenced by inheritance but never created
- Object .yml files referenced in rooms but never created
- 1 missing GLANCE (Andy's office in Mayberry)
- Guard conditions are natural language (fine for LLM, not for a parser)

These worlds were hand-built by someone who deeply understands MOOLLM. They
are designed to be consumed by an LLM. The natural-language guards, the
atmospheric descriptions, the inheritance comments — all of it is semantic
data for the model. A traditional parser would choke. An LLM reads it fluently.

### Loading a World

The user experience should be:

```
1. Open J:\ResearchAI\Research\Mayberry\ in VS Code
2. Copilot detects .moollm/ and .github/ (or the always-on instructions)
3. Type /boot (or the agent auto-boots on folder open)
4. Agent reads WORLD.yml → learns it's Mayberry, 1960s, gentle humor
5. Agent reads .moollm/config.yml → learns the cold-start protocol
6. Agent reads .moollm/state.yml → fresh start or resume
7. Agent loads all GLANCE.yml files → knows every room and character cheaply
8. Agent says: "Welcome to Mayberry, North Carolina..."
9. You type: "LOOK" or /look
10. Agent reads current room's ROOM.yml + CARD.yml → describes the scene
```

Switching worlds = opening a different folder. That's it. Every world is a
self-contained directory. Open Danny Thomas Show instead, you're in 1950s NYC.

### Loading Don's Worlds

Don's worlds (in the upstream MOOLLM repo) use the identical format. His
`examples/` directory has worlds like `i-beam` and demo adventures. The
`.github/copilot-instructions.md` we create should be placed in each world's
root — or better yet, in a shared config that applies regardless of which
world folder is open.

If we use a VS Code multi-root workspace:

```
ResearchAI.code-workspace
  ├── Research/Mayberry/          (world 1)
  ├── Research/DannyThomasShow/   (world 2)
  └── OurVersion/engine/          (the engine skills)
```

The `.github/copilot-instructions.md` goes in the workspace root and applies
to all folders. The agent detects which world you're in by reading `WORLD.yml`.

---

## Part 5: The Template World

A user should be able to generate a minimal starting world and immediately
begin playing. One room. One character. Enough structure to generate the
next room on demand.

### Minimum Viable World: 7 Files

```
my-world/
├── .moollm/
│   ├── config.yml        ← Bootstrap config (reading protocol, cold start)
│   ├── prompt.yml        ← System prompt template
│   └── state.yml         ← State tracker (status: ready)
├── WORLD.yml             ← World name, era, tone, rules, simulate block
├── LOG.md                ← Session log (empty template)
├── TRANSCRIPT.md         ← Episode transcript (empty template)
├── characters/
│   └── protagonist/
│       ├── CHARACTER.yml ← The player-adjacent character
│       └── GLANCE.yml    ← 8-line summary
└── starting-room/
    ├── ROOM.yml          ← Name, atmosphere, exits, objects
    ├── CARD.yml          ← 1-2 advertisements (things to do here)
    └── GLANCE.yml        ← 8-line summary
```

The key insight: you don't need to pre-build every room. WORLD.yml describes
the world well enough that when a player goes through an exit to a room that
doesn't exist yet, the agent GENERATES IT — creates the directory, writes
ROOM.yml, CARD.yml, GLANCE.yml based on the world's tone, era, and rules.

This is the power of prototype inheritance + LLM generation:

- WORLD.yml says "1960s small-town America, gentle humor"
- Exit says "north: general-store/"
- Player types "GO NORTH"
- general-store/ doesn't exist
- Agent creates it, inheriting the world's defaults
- The world grows organically from play

### What the Template World Defines

**WORLD.yml** must have:

- `name`, `era`, `tone`, `population` — enough for the LLM to ground generation
- `rules` — behavioral constraints (violence level, language, conflict style)
- `simulate` block — speed_of_light, epochs, tick_config, persistence
- `delegation` — what properties cascade to child directories
- `generation_hints` — guidelines for on-demand room/character generation

**CHARACTER.yml** must have:

- `name`, `id`, `type`, `location` — identity and where they start
- `personality` — enough to drive voice and decisions
- `sims_traits` — 5-axis personality (neat/outgoing/active/playful/nice)
- `needs` — at minimum hunger, energy, social, fun, hygiene, comfort
- `voice` — accent, register, patterns

**ROOM.yml** must have:

- `name`, `type`, `atmosphere` — what it feels and looks like
- `exits` — at least one (relative directory path)
- `ambient` — background sounds, smells, lighting
- `ambient_ads` — 1-2 default activities always available here

### Regenerating From Scratch

The template is small enough to ship as a command:

```
/new-world "A sleepy fishing village in 1970s Maine"
```

The agent generates all 7 files from that one sentence, using the world
description to set era, tone, rules, and starting room atmosphere.

---

## Part 6: Output, Persistence, and Copilot Integration

### Output

MOOLLM generates two kinds of output:

1. **TRANSCRIPT.md** — Teleplay-format episode transcript
   - Scene headings in `INT./EXT.` format
   - Character dialogue in bold with parenthetical stage direction
   - Meant to read like a script

2. **LOG.md** — Structured simulation log
   - Tick-by-tick state changes
   - Ads evaluated, actions taken, needs updated
   - Machine-readable history

Both live in the world directory and grow per session. In VS Code, these
files are just Markdown — they render beautifully in the editor's preview
panel. No special handling needed.

**For consumer-facing polish**, output should get special attention:

- **Split pane**: TRANSCRIPT.md open in preview on the right, Copilot Chat
  on the left. The player interacts in chat, and the teleplay builds up
  in real time in the preview pane.
- **Auto-scroll**: Use VS Code's preview auto-scroll to keep the latest
  scene visible without manual scrolling.
- **Session markers**: Each play session gets a dated header in TRANSCRIPT.md
  so you can see where sessions start/end.
- **Episode boundaries**: After N ticks or at natural story beats, the agent
  auto-generates an `## Episode N: [Title]` header and a brief recap.

### Persistence

State must survive between sessions. MOOLLM's approach: everything is files.

- **`.moollm/state.yml`** — Current epoch, tick, character locations, needs,
  relationship deltas, narrative flags. Written at epoch boundaries and
  session end.
- **Character needs drift** — Between sessions, needs decay realistically.
  On resume, the agent reads state.yml, adjusts needs based on elapsed
  world time, and continues.
- **Warm start** — When you reopen the folder and `/boot`, the agent sees
  `status: running` in state.yml, reads the last state, and picks up where
  things left off.
- **Git integration** — MOOLLM's simulation CARD.yml has `git.auto_commit`
  and `git.auto_push` flags. Each epoch boundary can auto-commit state
  changes. Your play history becomes your git history. You can literally
  `git log` your story.

### Copilot Integration Points

Beyond the chat interaction, VS Code Copilot touches the simulation in
several natural ways:

1. **Autocomplete in YAML** — When editing a CHARACTER.yml, Copilot's
   inline suggestions know the schema from `.instructions.md` files.
   Add a new character trait — Copilot suggests the format.

2. **Code Actions** — If we add YAML schema validation (extension Phase 3),
   Copilot can offer quick fixes: "This exit references a room that doesn't
   exist. Create it?"

3. **@workspace queries** — "Which characters have social needs below 40?"
   Copilot searches across all CHARACTER.yml files semantically.

4. **Inline Chat** — Select a ROOM.yml, Ctrl+I, "add more detail to the
   atmosphere of this room." Copilot edits in place.

5. **Task integration** — Custom tasks for "Start Episode," "Resume Session,"
   "Export Season PDF" that invoke the agent with specific prompt files.

---

## Part 7: The Approach (What We Actually Do)

### The Stack (Simplest to Most Complex)

```
Layer 0: World files     ← Already done (Mayberry, Danny Thomas)
Layer 1: Instructions    ← .github/copilot-instructions.md
Layer 2: Custom agent    ← .github/agents/dm.agent.md
Layer 3: Prompt files    ← .github/prompts/boot.prompt.md, look.prompt.md, etc.
Layer 4: Schema hints    ← .github/instructions/yaml.instructions.md
Layer 5: MCP server      ← Only if agents aren't reliable enough
Layer 6: Extension       ← Only if we want rich UI
```

We start at Layer 1 and stop when it works. Each layer is additive.
Nothing gets thrown away. Nothing needs to be rewritten.

### Compatibility with Don's Project

This is Don's architecture. We're not forking it. We're showing that it
runs on VS Code + Copilot as well as it does on Cursor. The adaptation
layer (our `.github/` files) sits cleanly on top:

- Don's WORLD.yml: untouched
- Don's .moollm/config.yml: untouched
- Don's room/character/skill format: untouched
- Don's boot sequence: adapted to VS Code's instruction system
- Don's driver detection: a new "vs-code-copilot" driver alongside
  cursor/claude-code/custom/generic

He could load his worlds in our setup. We can load our worlds in his.
The format is the contract.

### What We Build First

1. **The instruction files** — `.github/copilot-instructions.md` that
   teaches Copilot the MOOLLM protocols. This is the single most
   important file. It replaces `.cursorrules`.

2. **The DM agent** — `.github/agents/dm.agent.md` that defines the
   Dungeon Master persona, tools, and simulation rules.

3. **The prompt commands** — `/boot`, `/look`, `/go`, `/episode`, `/save`.

4. **The template world** — A minimal 7-file world that demonstrates
   the format and can be regenerated from a one-line description.

5. **Placement of these in each world** — Copy `.github/` into Mayberry,
   Danny Thomas, and any future worlds (or use workspace-level config).

### What We DON'T Do

- Don't build an extension yet
- Don't modify Don's file formats
- Don't rename his fields or reorganize his room structure
- Don't add dependencies or build steps
- Don't over-document half-built things

### Open Questions

1. **Where do the .github/ files live?** Per-world, or at workspace root?
   Per-world is self-contained. Workspace root is DRY. Could do both —
   shared instructions at workspace root, world-specific agents per folder.

2. **How much of the engine/ skills should the DM agent know about?**
   All 111 skills are design patterns, not code. The agent doesn't "run"
   them — it reads them as documentation of how to behave. We could
   include key ones (speed-of-light, adventure, simulation, room,
   character) as referenced context in the agent definition.

3. **Should world generation be aggressive or conservative?** When a
   player exits to a room that doesn't exist, auto-generate it? Or ask
   first? Default should probably be: generate with confirmation.

4. **Git integration — how tight?** Auto-commit every epoch? Every session?
   Manual only? Configurable in WORLD.yml's simulate block (which it
   already is — `git.auto_commit: true/false`).

5. **Multi-world sessions?** Can you have Mayberry AND Danny Thomas
   loaded simultaneously and move between them? MOOLLM's adventure system
   calls this "multi-presence." Interesting but not first priority.

---

## Summary

MOOLLM runs on VS Code Copilot with zero code changes. The architecture is
filesystem + LLM, and VS Code's Agent mode speaks exactly that language.
Cursor's `.cursorrules` becomes `.github/copilot-instructions.md`. Cursor's
tools become Agent mode's built-in capabilities. Don's worlds load unchanged.

The only new things we author are instruction files that teach Copilot the
protocols — about 5 files in a `.github/` directory. The worlds already exist.
The engine is documentation. The LLM is the runtime.

Start with instructions. See how it plays. Add MCP tools if the agent needs
help. Add an extension if we want a beautiful UI. But the simulation itself
is just files and a well-prompted LLM, and we already have both.
