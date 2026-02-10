# Mayberry

A small Southern town where everybody knows everybody,
the doors don't lock, and the biggest crisis is usually
Aunt Bee's pickles or Barney's latest scheme.

**Era:** 1960s North Carolina | **Tone:** Gentle humor | **Population:** ~5,000

## Getting Started

1. Open this folder in VS Code
2. Open Copilot Chat (`Ctrl+Alt+I`)
3. Switch to **Agent** mode (dropdown at top of chat)
4. Type: `/boot`

You're now in Mayberry.

## Commands

| Command | What it does |
|---------|-------------|
| `/look` | Describe where you are |
| `/go [exit]` | Move to another location |
| `/talk [character]` | Start a conversation |
| `/episode` | Run 8 ticks — auto-advance ~2 hours of world time |
| `/refresh` | Reload any `.yml` files you edited |
| `/save` | Persist current state to `.moollm/state.yml` |

## Editing the World

The folders ARE the simulation. Every room is a directory.
Every character is a `CHARACTER.yml`. Edit any `.yml` file —
your changes are live on the next tick.

See `_templates/` for annotated examples of every file type.

## What's Here

```
characters/     20 residents + 4 guest stars + 35 archetypes
main-street/    Courthouse, Floyd's, Diner, Bank, Drug Store...
taylor-house/   Front porch, living room, kitchen, Opie's room
church/         Sunday services and fellowship hall
myers-lake/     The fishing hole — where problems solve themselves
schoolhouse/    Helen Crump's domain
mt-pilot/       The big city next door (relatively speaking)
```

## How It Works

The LLM reads `WORLD.yml` for the rules, `ROOM.yml` for each
location, `CHARACTER.yml` for each person, and runs a Sims-style
behavior engine: characters have **needs** (hunger, social, fun...),
rooms offer **advertisements** (scored actions with guard conditions),
and the highest-scoring valid action wins each tick.

One tick = 15 minutes of Mayberry time. The world runs through
four epochs: morning (courthouse opens), afternoon (quiet streets),
evening (front porches and guitars), night (crickets and stars).

Everything said at Floyd's reaches every porch by sundown.
Accuracy: 40%.
