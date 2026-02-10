---
applyTo: "**/*.yml"
---

# MOOLLM YAML Schema

When editing `.yml` files in this workspace, follow the MOOLLM schema:

## WORLD.yml

Root-level world definition. Must have: `world.name`, `world.era`,
`world.tone`, `world.rules`, `world.simulate` (with `speed_of_light`,
`epochs`, `tick_config`, `persistence`), `world.delegation.cascades`.

## ROOM.yml

Room definition inside a directory. Must have: `room.name`, `room.type`,
`room.atmosphere` (prose), `room.exits` (relative directory paths),
`room.ambient`. Optional: `framing`, `ambient_ads`, `room.objects`,
`room.capacity`.

## CARD.yml

Advertisements (actions available in a room). Must have: `skill.name`,
`skill.id`, `skill.advertisements` where each ad has: `description`,
`score` (1-100), `guard` (natural language condition), `effect` (need
changes + narrative), `satisfies` (need categories). Optional:
`inherits`, `ontology`, `participants`, `duration`, `side_effects`.

## CHARACTER.yml

Character definition. Must have: `character.name`, `character.id`,
`character.type`, `character.location`, `character.personality.traits`,
`character.sims_traits` (neat/outgoing/active/playful/nice, 0-10),
`character.needs`, `character.voice`. Optional: `inherits`, `ontology`,
`character.mind_mirror`, `character.relationships`,
`character.behavioral_patterns`, `character.emoji_identity`.

## GLANCE.yml

Compact summary (~10 lines). Must have: `glance.id`, `glance.type`,
`glance.name`, `glance.emoji` (5 emoji), `glance.vibe`, `glance.top_ads`.

## YAML Jazz Convention

Comments in MOOLLM YAML are **semantic data**, not documentation.
They contain character voice, design rationale, behavioral hints.
Preserve them. Read them. They matter to the simulation.
