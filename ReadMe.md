# Expand-YOYR-MIND

A crude VS Code implementation of [MOOLLM](https://github.com/SimHacker/moollm) — my best shot at making the paradigm approachable.

MOOLLM is a framework where **the LLM is `eval()`**, the **filesystem is the world**, and **YAML files are living objects**. It's a genuinely new way to think about what language models can do. But the upstream repo is a deep, sprawling codebase built by people who've been thinking about this for decades. I found it overwhelming at first — and figured others might too.

So this is an experiment: can we take MOOLLM's ideas and make an **introductory implementation** that runs entirely inside VS Code Copilot, with no extension, no runtime, no dependencies? Separate the engine from the worlds, make worlds selectable, add templates so someone new can build a room in 5 minutes, and let the simulation output speak for itself.

**This is not a fork or a replacement.** It's a fan letter with working code, offered to the MOOLLM team to consider, critique, or ignore entirely. They're the pros — I'm just hoping to be useful.

---

## Repository Structure

| Folder                                                 | What's Inside                                                                                      |
| ------------------------------------------------------ | -------------------------------------------------------------------------------------------------- |
| [**.github/**](.github/)                               | The engine adapter — instruction files that teach VS Code Copilot to be a MOOLLM simulation engine |
| [**worlds/**](worlds/)                                 | Playable simulation worlds (Mayberry, Danny Thomas) — boot one and go                              |
| [**OurVersion/**](OurVersion/)                         | Organized engine skills (121 skills across 10 layers) + reference material                         |
| [**Upstream/**](Upstream/)                             | Pristine upstream MOOLLM files for comparison                                                      |
| [**Notes/**](Notes/)                                   | Design documents, analysis, philosophical grounding                                                |
| [**Mayberry-A-Moral-Mecca/**](Mayberry-A-Moral-Mecca/) | The book: _Eval Incarnate: A Builder's Curriculum_ (EPUB/HTML)                                     |
| [**Misc/**](Misc/)                                     | Images and supporting material                                                                     |

---

## How It Works

The entire "engine" is **6 files in `.github/`** that VS Code Copilot reads automatically:

```
.github/
├── copilot-instructions.md    ← always-on: "you are a MOOLLM engine"
├── agents/dm.agent.md         ← the Dungeon Master persona
├── prompts/                   ← slash commands: /boot, /episode, /scenario, etc.
├── instructions/              ← YAML schema rules
└── worlds.yml                 ← world registry
```

No extension. No runtime. No `npm install`. You open the repo in VS Code, open Copilot Chat, and type `/boot mayberry`. The LLM reads the world files, loads character needs, evaluates room advertisements, and generates teleplay-format narrative — writing state back to the filesystem as it goes.

### Commands

| Command                   | What It Does                                    |
| ------------------------- | ----------------------------------------------- |
| `/boot mayberry`          | Boot a world — load characters, rooms, state    |
| `/episode`                | Run 8 autonomous ticks — a full episode emerges |
| `/scenario [description]` | Scripted scenario with scene-by-scene pacing    |
| `/look`                   | Describe the current room and who's here        |
| `/talk [character]`       | Talk to a character in the current room         |
| `/go [room]`              | Move to an adjacent room                        |
| `/save`                   | Persist current state                           |

---

## What I Tried To Do Differently

I want to be clear: I'm sure most of these ideas exist in MOOLLM already. I just tried to surface them in a way that's more immediately graspable for someone who's never seen the project before.

- **Separated engine from worlds** — The `.github/` adapter is generic. Worlds live in `worlds/`. Adding a new world means adding a folder, not editing engine code.
- **World selection** — `worlds.yml` is a registry. `/boot` lists available worlds. `/boot danny-thomas` switches. State is saved per-world.
- **Templates** — Each world has a `_templates/` folder with annotated starter files: `NEW-ROOM.yml`, `NEW-CHARACTER.yml`, `NEW-CARD.yml`, etc. Fill in the blanks, drop it in a directory, it works.
- **Onboarding** — Each world has a `PLAY.md` that explains how to play in ~30 seconds.
- **Diagnostic output** — Every tick writes `.moollm/LAST-TICK.yml` with what files were loaded, what ads were evaluated, what guards passed/failed, what needs changed. Makes the "why did that happen?" question answerable.

---

## Sample Output

The simulation has run 3 episodes (24 ticks) in the Mayberry world so far. Here's what the output actually looks like — unedited, straight from the [TRANSCRIPT](worlds/mayberry/TRANSCRIPT.md).

### Narrative (from Episode 1: "The Man in Goober's Hat")

> **BARNEY:** FREEZE! Nobody move! Deputy Fife, Mayberry Sheriff's Department!
>
> _Goober looks up from his magazine._
>
> **GOOBER:** Hey, Barney.
>
> _Barney freezes. His hand is on his holster._
>
> **BARNEY:** ...Goober?
>
> **GOOBER:** You want a magazine? This one's got a real good article about transmissions. I think. The pictures are kinda confusing.

### Narrative (from Episode 2: "The Ancient Art")

> **ANDY:** I'm not saying adopt sumo. I'm saying the man walked in here with a typed proposal, a cover letter, and a budget request, and you didn't read past the title.
>
> _The mayor shifts in his chair._
>
> **ANDY:** You've got that county commissioner coming Thursday. How about instead of sumo, you let Barney put together a departmental readiness demonstration?
>
> **MAYOR STONER:** ...That's actually not bad. The commissioner sees a well-run department, reflects well on my administration...
>
> **ANDY:** And Barney gets his hearing.

### Simulation Log (from [LOG.md](worlds/mayberry/LOG.md) — one tick)

```
### [TICK 005] — EPOCH: morning — TIME: 9:00AM

Active characters: barney-fife, goober-pyle, floyd-lawson, andy-taylor
Location: floyds-barbershop

Advertisements evaluated:
- floyds-barbershop/HAIRCUT (score: 80, guard: passed) → queued
- BARNEY_OVERREACT (character ad, score: 85, guard: passed) → selected
- floyds-barbershop/HANG_OUT (score: 65, guard: passed) → selected for goober

Floor management (4 characters, same room):
1. barney-fife TAKE_FLOOR → "FREEZE! Nobody move!"
2. goober-pyle TAKE_FLOOR → "Hey, Barney."
3. floyd-lawson TAKE_FLOOR → "That's the stranger!"
4. andy-taylor TAKE_FLOOR → "Morning, Goober."
   All YIELD_FLOOR.
```

### Diagnostic (from [LAST-TICK.yml](worlds/mayberry/.moollm/LAST-TICK.yml))

```yaml
episode_summary:
  ticks: 8
  characters_active: 10
  rooms_visited: 7
  key_events:
    - "Barney arrives at 6:45AM — 15 minutes early, stopwatch and floor plan ready"
    - "Four full rehearsals: Goober arrested 3 times, handcuffs snag on belt loop"
    - "Floyd gives Barney free haircut — 'for the commissioner'"
    - "Barney checks trunk one last time, places checklist next to bullet in breast pocket"

pending_threads:
  - "Thursday: The commissioner demonstration — climax of the multi-episode arc"
  - "Will Otis be sober for the visit?"
  - "The sumo book is still in Barney's desk drawer — will it surface?"
```

### Persisted State (from [state.yml](worlds/mayberry/.moollm/state.yml))

```yaml
state:
  status: running
  current_epoch: evening
  current_tick: 24
  world_time: "6:00PM"
  world_day: wednesday

  character_locations:
    andy-taylor: taylor-house
    barney-fife: main-street # heading home after Floyd's haircut
    otis-campbell: courthouse/jail-cell
    floyd-lawson: floyds-barbershop

  flags:
    commissioner_visit_thursday: true
    barney_demonstration_approved: true
    barney_checklist_in_breast_pocket: true
    demonstration_timed_at: 16_minutes_40_seconds
```

---

## Engine Organization

The [OurVersion/engine/](OurVersion/engine/) directory organizes MOOLLM's 121 skills into 10 layers, my attempt at making the skill architecture scannable:

| Layer | Name          | Skills | Purpose                                                    |
| ----- | ------------- | ------ | ---------------------------------------------------------- |
| 0     | core          | 18     | Identity, YAML jazz, progressive disclosure, Postel's Law  |
| 1     | boot          | 7      | World detection, cold/warm start, config loading           |
| 2     | world         | 8      | Room topology, prototype inheritance, world rules          |
| 3     | characters    | 20     | Needs model, relationships, voice, personality             |
| 4     | sims          | 8      | Advertisements, guards, scoring, need effects              |
| 5     | simulation    | 10     | Tick loop, Speed of Light, floor management, epochs        |
| 6     | quality       | 16     | Tone, era-appropriate language, narrative coherence        |
| 7     | communication | 10     | Teleplay format, dialogue, stage direction                 |
| 8     | memory        | 14     | State persistence, transcripts, logs, diagnostics          |
| 9     | programs      | —      | Adventure engine (Python + web), reference implementations |

---

## The Ideas Behind It

For the full deep dive, see the [Notes/](Notes/) directory. The short version:

**Skills are programs. The LLM is `eval()`. Empathy is the interface.**

- A language model is a _linguistic motherboard_ — a universal interpreter with slots for capability cards
- Directories are rooms. YAML files are objects. The filesystem is the world.
- Objects _advertise_ what they can do. Characters choose based on their needs. Behavior emerges.
- SIM hides its assumptions. EVAL makes them visible, inspectable, and editable.
- Ethics is architecture, not policy — built into the directory structure, not bolted on after.

**Lineage:** PostScript (1984) → NeWS (1986) → The Sims (2000) → MOOLLM (2025) → this experiment.

---

## What's Probably Wrong

I fully expect the MOOLLM team to look at this and see things I oversimplified, misunderstood, or missed entirely. That's the point — I'd rather ship something concrete and get corrected than theorize in the dark. Some things I'm already unsure about:

- My tick loop is a simplified version of what MOOLLM does — I'm sure the real ad evaluation is more nuanced
- The "Speed of Light" floor management is my interpretation of the multi-agent-in-one-call pattern
- I may be underselling the prototype inheritance system — the real thing probably handles edge cases I haven't hit
- State persistence is minimal — real MOOLLM likely has richer history tracking
- The VS Code adapter approach trades extensibility for approachability — a real extension could do much more

---

## Getting Started

1. Clone this repo
2. Open in VS Code with GitHub Copilot enabled
3. Open Copilot Chat
4. Type `/boot mayberry`
5. Then `/episode` to run a full episode, or `/look` to explore

No build step. No dependencies. Just a language model reading YAML files and telling stories.

<p align="center">
  <img src="Misc/BeingSuave.jpg" alt="Gosh, Mr. Williams, I could never be suave." width="400"><br>
  <em>"Gosh, Mr. Williams, I could never be suave."</em>
</p>
