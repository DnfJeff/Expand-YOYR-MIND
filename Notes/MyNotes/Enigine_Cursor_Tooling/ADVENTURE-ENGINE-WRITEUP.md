# The Adventure Engine — MOOLLM's Crown Jewel

> Research write-up on `skills/adventure/` from https://github.com/SimHacker/moollm
> 28,000+ lines. A real game engine hidden inside a "skill."

---

## What Is It?

The adventure skill is not a skill. It's a **complete game platform** — a Python compiler, a JavaScript runtime, a browser app with speech synthesis, and the theoretical framework holding it all together. The skill-snitch report calls it "an operating system for narrative exploration." That's accurate.

**The one-line pitch:** Write your world in YAML directories. Compile it to JSON. Run it in a browser. Characters talk out loud.

**The lineage:**
- Colossal Cave Adventure (1976) — rooms with text descriptions
- Zork/Infocom (1977) — parser, puzzles
- MUD/LambdaMOO (1978-1990) — multi-user, object-oriented rooms
- The Sims (2000) — needs-driven autonomous characters
- D&D — LLM as Dungeon Master

---

## The Architecture: Three Layers

```
LAYER 1: YAML-JAZZ SOURCE (what you write)
  directories = rooms
  files = objects, characters, clues
  ROOM.yml = exits, properties
  README.md = room description/atmosphere
  CHARACTER.yml = entity definition

        ↓  compile.py  ↓

LAYER 2: COMPILED WORLD (world.json)
  rooms[] with progressive descriptions
  objects[] with state-based behavior
  characters[] with needs, moods, relationships
  performances[] (songs, soliloquies)
  expressions compiled to JavaScript closures

        ↓  engine.js  ↓

LAYER 3: BROWSER RUNTIME
  Text adventure UI
  Speech synthesis (67+ voices on macOS)
  Image generation (DALL-E, Imagen, Stability, Replicate)
  Image analysis (OpenAI, Anthropic, Google vision APIs)
  Optional LLM tethering for complex situations
```

The key insight: **simple interactions run locally as compiled JavaScript. Complex situations escalate to the LLM.** This is the "speed of light" principle — don't call the LLM for everything.

---

## The Actual Code

### Python Side (7,020 lines across 6 files)

| File | Lines | What It Does |
|------|-------|-------------|
| `adventure.py` | 3,143 | The CLI. Multi-command: `lint`, `compile`, `merge`, `serve`. The `AdventureLinter` is the core (~1,000 lines). Generates HTML, JSON, and albums. |
| `compile.py` | 1,485 | Compiles YAML source directories into `world.json`. Handles pointer resolution, progressive descriptions, narrative synthesis. Walks your directory tree and turns it into a flat game world. |
| `adventure_runtime.py` | 1,274 | Headless Python runtime. The classes: `WorldState`, `Entity`, `Room`, `Exit`, `Advertisement`, `GameObject`, `Character`, `AdventureEngine`, `SimulationRunner`. You can run an adventure without a browser. |
| `validate.py` | 874 | YAML schema validation. Topology graph traversal (are all rooms reachable?). Auto-fix for broken exits. |
| `test_adventure.py` | 444 | Test suite — loading, navigation, inventory, state roundtrip. |
| `economy.py` | 256 | Gini coefficient, wealth distribution analysis. Yes, the game engine can measure income inequality. |

All 6 files follow "sniffable-python" — the API is visible in the first 50-100 lines. All use `yaml.safe_load` (safe against YAML injection).

### JavaScript Side (6,267 lines core + ~12,000 in dist/)

| File | Lines | What It Does |
|------|-------|-------------|
| `engine.js` | 4,707 | `MootalEngine` — flat registry, compiled closures, dual currency system, command parser, DOM UI. The main runtime. |
| `adventure.js` | 1,414 | `IUIAdapter` hierarchy (DOM, Console, Null adapters). Entity/Room/Exit/GameObject/Character classes. `AdventureEngine` game loop. |
| `cli.js` | 146 | Node.js CLI runner — play adventures from terminal. |

### Browser Modules (dist/ — ~12,000 lines)

| Module | Lines | What It Does |
|--------|-------|-------------|
| `source-viewer.js` | 2,124 | Resolves `moollm://` URLs to GitHub/GitLab. Live state diffs. |
| `api-keys.js` | 1,219 | Matrix UI for managing API keys across providers. |
| `performance.js` | 935 | Multi-character karaoke/performance playback system. |
| `speech.js` | 899 | Cross-browser speech synthesis. 67+ voices classified. |
| `adventure-recognition.js` | 860 | Microphone UI, speech-to-command pipeline. |
| `overlay-fs.js` | 763 | Layered virtual filesystem (Git/Local/Runtime/Memory). |
| `recognition.js` | 734 | Web Speech API wrapper with privacy notices. |
| `image-analyze.js` | 703 | Multi-provider vision API (OpenAI, Anthropic, Google). |
| `prototypes.js` | 700 | Archetype YAML to game object converter. |
| `github-api.js` | 657 | GitHub API + OAuth (Device Flow + popup). |
| `adventure-speech.js` | 613 | Speech adapter. Persistent character voice assignments. |
| `export-compiler.js` | 573 | Runtime loader: embedded, injected, live-from-GitHub, hybrid. |
| `image-generate.js` | 541 | Multi-provider image gen (DALL-E, Imagen, Stability, Replicate). |

**Total: ~28,000+ lines.** This is a civilization, not a skill.

---

## The CLI — What You Actually Run

```bash
# Lint your world — find broken exits, missing rooms, schema violations
python adventure.py lint examples/adventure-4/ --format yaml --dump

# Compile YAML directories into a playable world.json
python adventure.py compile examples/adventure-4/ --output build/

# Merge saved state back into the world (resume a game)
python adventure.py merge examples/adventure-4/ state.json

# Serve it — live preview with hot reload
python adventure.py serve examples/adventure-4/
```

### The Lint Pipeline (Most Relevant to Us)

The linter is the most immediately useful piece. It:
1. Walks your directory tree
2. Validates every ROOM.yml, CHARACTER.yml, object file against schema
3. Checks topology — can you reach every room? Are there dead ends?
4. Finds broken exit pointers (room points to nonexistent directory)
5. Outputs events for the LLM to read and fix (not auto-fix — the LLM has context)

This is the "play-learn-lift" pattern: the linter PLAYS your world, LEARNS what's broken, and outputs structured feedback so you (or the LLM) can LIFT the fix.

### The Compiler (The Real Magic)

`compile.py` transforms your YAML directories into `world.json`:

**Pointer Resolution** — universal addressing for any file:
```
path/to/file.yml           → whole file
file.yml#id                → section by id
file.yml#parent.child      → nested dot-path
file.json#/json/path       → JSON pointer (RFC 6901)
file.md#heading            → markdown heading
file.cpp:42                → line number
file.py:10-25              → line range
```

**Progressive Description Synthesis** — rooms get three levels:
```yaml
descriptions:
  glance: "a rusty sword"                                    # one-line mention
  look: "A corroded blade leans against the wall..."         # first impression
  examine: "The blade bears ancient runes: too corroded..."  # full detail
```

Each level BUILDS on the previous — examine includes look includes glance. The compiler generates JavaScript closures (`pickDescription(lod)`) that switch on detail level and incorporate world state:

```javascript
// Generated by the compiler from your YAML
pickDescription(lod) {
  const { world, self } = this;
  
  const brief = self.state.rusted ? "a rusty sword" : "a gleaming sword";
  if (lod === "brief") return brief;
  
  const look = brief + `. ${self.state.rusted 
    ? "It leans forgotten against the wall, flakes of rust on the floor." 
    : "It catches the torchlight, humming faintly."}`;
  if (lod === "look") return look;
  
  const runes = self.state.runes_visible ? self.runes : "too corroded to read";
  const history = world.flags.sword_lore_known ? `\n\n${self.history}` : "";
  return look + `\nThe blade bears ancient runes: ${runes}.${history}`;
}
```

**Separation of Concerns** — who describes what:
- ROOMS describe: environment, exits, fixed features. NOT objects. NOT characters.
- OBJECTS describe: themselves, their contents. NOT their location.
- CHARACTERS describe: themselves, what they're holding. NOT their location.

This means an object's description follows it between rooms. Danny's saxophone describes itself the same way whether it's at the Copa Club or the apartment.

---

## PSIBER — Step Inside Your Data

> "A character can literally step inside any YAML or JSON structure."

PSIBER = **P**rogrammatic **S**tructured **I**nteractive **B**rowsing **E**ditor via **R**oleplay

```
> ENTER moollm://config/settings.yml

═══════════════════════════════════════════
         settings.yml — Root Level
═══════════════════════════════════════════

You are standing in a room with several labeled doors:

DOORS:
  [theme]      — A heavy wooden door, warm colors leaking through
  [database]   — A steel door with blinking lights
  [features]   — A glass door showing many switches
  [version]    — A small plaque on the wall: "1.2.3"

ITEMS ON THE FLOOR:
  debug: false          (a switch, currently OFF)
  environment: "prod"   (a nameplate)
```

**You can EDIT while inside:**
```
> CHANGE debug TO true
You flip the debug switch. It clicks ON.

> ADD monitoring WITH {enabled: true, interval: 30}
A new door materializes labeled [monitoring].
```

PSIBER turns CONFIG FILES INTO DUNGEONS. You could PSIBER into our `WORLD.yml` and walk around inside the data structure, editing Danny's world by changing "items on the floor."

---

## SUMMON — Distributed Character Instantiation

Not just "spawn a character" — SUMMON is a multi-method dispatch protocol:

```yaml
summon_flow:
  1_who_summons: "Player, character, object, or room itself"
  2_from_where: "Current location"
  3_summon_what: "moollm:// URL to character prototype"
  4_with_params: "Caller parameters to customize"
  5_evaluate: "Target's preconditions, scores, availability"
  6_check_existing: "Already instantiated? Move them."
  7_instantiate: "Create runtime actor from prototype"
  8_arrive: "Actor appears in configured state"
```

```
> SUMMON uncle-tonoose WITH mood=outraged, topic=apartment-rearranging

Uncle Tonoose arrives, mustache bristling.
"Daniel! WHAT have you done to the living room?!"
```

Characters aren't spawned. They're SUMMONED with INTENT. The parameters customize their entrance.

---

## The Sims Integration

The adventure engine inherits The Sims' motive system:

```yaml
character:
  needs:
    hunger: 0.65
    social: 0.40
    fun: 0.70
    energy: 0.35
  
  thresholds:
    hunger_critical: 0.3    # seek food
    social_lonely: 0.5      # seek conversation
```

Objects ADVERTISE actions:
```yaml
piano:
  advertisements:
    PLAY_MUSIC:
      score: 80
      needs_effect: {fun: +0.3, social: +0.1}
      condition: "has_skill('music')"
```

Characters choose actions based on lowest need + highest advertisement score. This is the engine that drove 200 million copies of The Sims.

---

## Compiled Performances

Songs, soliloquies, and essays are compiled as **global resources** — portable media that any character can perform:

```yaml
compiled_performances:
  - id: "feed-me-seymour"
    title: "Feed Me, Seymour! (Constructionist Version)"
    type: song
    characters: ["audrey", "seymour", "don", "narrator"]
    duration_ms: 300000
```

Performances can be EMBODIED as physical objects:
- Vinyl records
- Cassette tapes
- USB sticks
- Or just memories (no physical object)

**For us:** Danny's Copa Club routines could be compiled performances. Specific jokes, songs, impressions — all structured, repeatable, performable by any character who knows them.

---

## The Live Example: adventure-4

A complete 36+ room world:

```
examples/adventure-4/
├── pub/                          # 6 themes!
│   ├── bar/
│   │   ├── bartender.yml         # 6 identity variants
│   │   └── cat-cave/             # TARDIS-like cat sanctuary (10 cats!)
│   ├── arcade/                   # Pacman, Pong, Pinball, Fruit Machine
│   ├── games/                    # Chess, Darts, Cards
│   ├── stage/
│   │   └── palm-nook/            # Multi-room character space
│   │       ├── study/            # Infinite typewriters
│   │       ├── gym/              # Infinite climb
│   │       ├── play/
│   │       └── rest/             # Hammock, silence cushion
│   └── menus/                    # Drinks, snacks, buds, games
├── street/
│   └── lane-neverending/
│       ├── no-ai-tower/          # 10+ rooms!
│       └── leela-manufacturing/
└── church/                       # Church of the Eval Genius
```

**Themeable rooms** — the pub changes identity:
```yaml
theme:
  current: classic_adventure
  themes:
    classic_adventure:
      name: "The Gezelligheid Grotto"
      bartender: "Grim, a weathered human"
    space_cantina:
      name: "The Rusty Hyperdrive"
      bartender: "Z-4RT, a droid with too many arms"
    cyberpunk_bar:
      name: "The Neon Underground"
```

---

## Security Notes

The skill-snitch found some concerns worth knowing:

| Issue | Where | Risk | Our Concern? |
|-------|-------|------|-------------|
| `eval()` — 4 calls | `adventure_runtime.py` | Crafted world.json = arbitrary code execution | LOW — we'd compile our own worlds |
| `eval()` — 4 calls | `engine.js` | `*_js` fields in world JSON run as code | LOW — same reason |
| `new Function()` — 4 calls | `adventure.js` | Compiled guards/effects from world data | LOW — we control the data |
| `postMessage('*')` | `github-api.js` | OAuth token interception | N/A — we wouldn't use this |
| innerHTML injection | performance.js, source-viewer.js | XSS from crafted YAML | LOW — we control content |
| Path traversal | `adventure.py` merge | `../../` in merge state could escape directory | LOW — we wouldn't use merge with untrusted state |

**Trust boundary:** whoever produces the `world.json` controls code execution. Since we'd compile our own worlds from our own YAML, this is safe. Don't run untrusted worlds.

---

## What This Means for Us

### What We'd Actually Use

1. **The directory-as-room pattern** — We already do this! Copa Club, Taylor House, Main Street are directories. The adventure engine validates this pattern.

2. **The compiler** — `compile.py` could compile our DannyThomasShow and Mayberry directories into playable `world.json` files. Lint our rooms, check our exits, validate our characters.

3. **Progressive descriptions** — glance/look/examine for every room and object. Our ROOM.yml files already have `look:` but not the full three levels.

4. **The Sims pipeline** — Advertisement scoring + needs-driven behavior. We already have CARD.yml with advertisements. The engine formalizes what we're doing intuitively.

5. **SUMMON protocol** — Summoning characters with parameters fits our "Danny enters the Copa, mood: anxious about tonight's show" pattern perfectly.

6. **Compiled performances** — Danny's routines at the Copa Club. Structured, repeatable, embody-able as in-world objects.

### What We'd Skip (for now)

- Browser runtime / dist/ (12,000 lines of browser code)
- Speech synthesis / TTS
- Image generation / analysis
- GitHub OAuth
- The full CLI `serve` command
- PSIBER (cool but complex)

### What We'd Want Eventually

- PSIBER for walking inside our WORLD.yml files
- Speech synthesis for character voices
- The `serve` command for browser-playable episodes

---

## The Bottom Line

The adventure engine is a real, tested, working game platform. 28,000+ lines that turn YAML directories into playable worlds. Our Copa Club and Mayberry directories are already 80% compatible with what this engine expects.

The linter alone would catch bugs in our world-building. The compiler would let us package episodes. The runtime would let us play them.

It's not a toy. It's the toy FACTORY.

---

*Source: skills/adventure/ — README.md, SKILL.md, CARD.yml, skill-snitch-report.md*
*Research phase — understanding before building*
