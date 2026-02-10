---
mode: agent
description: "Describe the current location"
---

Look around the current room.

1. Find the active world: check `worlds/*/. moollm/state.yml` for `status: running`,
   or read `.github/worlds.yml` to find the current world path
2. Read that world's `.moollm/state.yml` to find the player's current location
3. Read that room's ROOM.yml for the full atmosphere description (path relative to world root)
4. Read that room's CARD.yml for available advertisements
5. Check which characters are currently in this room (from state.yml character_locations)
6. For each character present, read their GLANCE.yml

Describe the scene in teleplay format:

- Start with a scene heading: INT./EXT. [ROOM NAME] — [EPOCH]
- Describe the atmosphere (from ROOM.yml)
- Mention who's here and what they're doing (based on their last action or default behavior)
- List exits naturally ("A door leads north to Main Street. The back room is through a curtain.")
- Do NOT list raw data or YAML — narrate it
