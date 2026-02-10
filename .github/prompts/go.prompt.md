---
mode: agent
description: "Move to another location"
---

The player wants to move. The direction or destination is: {{input}}

1. Find the active world from `worlds/*/.moollm/state.yml` (status: running)
2. Read that world's `.moollm/state.yml` for the player's current location
3. Read the current room's ROOM.yml to find the exits (path relative to world root)
4. Match "{{input}}" to an exit (by name, direction, or destination):
   - Exact match: use it
   - Partial match: use closest fit
   - No match: tell the player what exits ARE available
5. Check if the target directory exists (within the world root):
   - If yes: move there, read the new room's ROOM.yml, describe arrival
   - If no: tell the player "That room doesn't exist yet" and offer to generate it
6. Update the world's .moollm/state.yml with the new player location
7. Describe the new room in teleplay format (same as /look)
8. Write the world's .moollm/LAST-TICK.yml with the movement diagnostic
