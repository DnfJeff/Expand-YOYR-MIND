---
mode: agent
description: "Generate and run a classic sitcom scenario"
---

# Scenario Generator

When user types `/scenario [description]`, OVERRIDE normal tick-by-tick
simulation and RUN A SCRIPTED SCENARIO as a classic TV episode.

Find the active world from `worlds/*/.moollm/state.yml` (status: running).
All file paths below are relative to that world's root directory.

## Process

### 1. Generate Episode Structure (internal — don't show to user)

Plan these before writing the first scene:
- **Inciting incident** — what kicks it off?
- **Rising action** — complications, misunderstandings, escalation
- **Climax** — confrontation or realization
- **Resolution** — lesson learned, status quo restored (or gently shifted)
- **B-plot** — secondary character subplot if it emerges naturally

### 2. Cast the Scenario

- Read GLANCE.yml for every character mentioned or implied
- Upgrade to CHARACTER.yml for any character who speaks or acts
- Read their current room's CARD.yml for available advertisements
- Establish what each character wants and fears in this scenario
- Set starting locations consistent with current state.yml

### 3. Run in Accelerated Narrative Mode

This is NOT tick-by-tick simulation. Instead:
- Jump between **key scenes** (4-6 scenes typical)
- Each scene is a location + moment that advances the story
- Write in present tense with full dialogue
- Use teleplay format: scene headings, dialogue, stage directions
- Show ad/need mechanics only as subtle bracketed notes, not as data dumps
- After each scene, pause for user input with `/next to continue...`

### 4. After Scenario Concludes

- Update character needs and relationships in `.moollm/state.yml`
- Add narrative flags for anything that persists (ribbons won, lessons learned, objects moved)
- Write `.moollm/LAST-TICK.yml` with scenario diagnostic:
  - scenes_played, characters_involved, key_state_changes
  - world_time_elapsed (typically 4-12 hours depending on story)
- Append the full scenario to TRANSCRIPT.md as an episode
- Append summary to LOG.md
- Announce return to normal simulation mode

## Style Guidelines

- **Warm, folksy narration** — match the world's tone from WORLD.yml
- **Characters stay in-voice** — follow their voice: block from CHARACTER.yml
- **Moral is gentle, never heavy-handed** — characters learn, they aren't lectured
- **Small-town stakes** — nothing life-or-death, everything matters deeply anyway
- **Humor from character quirks** — never from cruelty or humiliation
- **YAML comments are canon** — they carry personality and design intent
- **Let silence work** — not every moment needs dialogue

## User Controls During Scenario

| Command | Effect |
|---------|--------|
| `/next` | Advance to next scene |
| `/rewind` | Return to previous decision point |
| `/intervene [action]` | Player changes something mid-scenario |
| `/skip` | Abort scenario, return to normal simulation |

## Scene Format

```
Scene [N]: [Location], [Time of Day]

*[Stage direction: setting, who's present, what's happening]*

**CHARACTER:** "[Dialogue]"

*[Stage direction: reaction, movement]*

[Optional bracketed note: need/relationship change]

/next to continue...
```

## Scenario Completion Format

```
📼 SCENARIO COMPLETE: "[Episode Title]"

Updated state:
- [Character]: [brief need/relationship changes]
- [World change]: [objects added, flags set]
- Time advanced: [N] hours

Type /look to return to simulation, or /scenario for another episode.
```
