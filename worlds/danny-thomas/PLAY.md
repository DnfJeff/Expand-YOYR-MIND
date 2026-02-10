# Danny Williams' New York

A Manhattan apartment where the door never stops opening,
every conversation is a performance, and Lebanese hospitality
meets New York apartment sizes. The math doesn't work.
They do it anyway.

**Era:** 1950s-1960s NYC | **Tone:** Warm chaos | **Volume:** High

## Getting Started

1. Open this folder in VS Code
2. Open Copilot Chat (`Ctrl+Alt+I`)
3. Switch to **Agent** mode (dropdown at top of chat)
4. Type: `/boot`

You're now in Danny's New York.

## Commands

| Command | What it does |
|---------|-------------|
| `/look` | Describe where you are |
| `/go [exit]` | Move to another location |
| `/talk [character]` | Start a conversation |
| `/episode` | Run 8 ticks — auto-advance ~80 minutes of world time |
| `/refresh` | Reload any `.yml` files you edited |
| `/save` | Persist current state to `.moollm/state.yml` |

## Editing the World

The folders ARE the simulation. Every room is a directory.
Every character is a `CHARACTER.yml`. Edit any `.yml` file —
your changes are live on the next tick.

See `_templates/` for annotated examples of every file type.

## What's Here

```
characters/           10 regulars + 5 guest stars + 27 archetypes
williams-apartment/   Living room, kitchen, Danny's den, kids' rooms
copa-club/            Stage, backstage, manager's office
new-york-streets/     Central Park, the neighborhood, theater district
visiting-locations/   The Tardis — grows as the show needs it
```

## How It Works

The LLM reads `WORLD.yml` for the rules, `ROOM.yml` for each
location, `CHARACTER.yml` for each person, and runs a Sims-style
behavior engine: characters have **needs**, rooms offer **advertisements**
(scored actions), and the highest-scoring valid action wins each tick.

One tick = 10 minutes of Danny's time (faster than Mayberry — this
world moves faster). Five epochs: morning (breakfast chaos),
afternoon (Kathy manages / Danny rehearses), pre-show (anticipation),
showtime (spotlight), late night (Danny comes home exhausted).

30% chance any action gets interrupted. Because the doorbell
is always ringing.
