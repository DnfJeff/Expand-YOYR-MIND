---
mode: agent
description: "Run 8 ticks of autonomous simulation (~2 hours world time)"
---

Run an autonomous episode — 8 simulation ticks.

Find the active world from `worlds/*/.moollm/state.yml` (status: running).
All file paths below are relative to that world's root directory.

For each tick:
1. Check current epoch from WORLD.yml simulate.epochs and world time
2. Load active characters' GLANCE.yml files (max per simulate.speed_of_light.max_characters_per_turn)
3. For each character:
   a. Load their current room's CARD.yml for available advertisements
   b. Evaluate ads by score descending
   c. Check guard conditions against the character's current needs
   d. Execute the highest-scoring valid ad
   e. Apply effects: update their needs
4. Generate a teleplay-format narrative paragraph for this tick
5. Advance world time by tick_config.duration

Use Speed of Light: simulate all characters in a single pass per tick.
Use floor management (TAKE_FLOOR / YIELD_FLOOR) when multiple characters
interact in the same room during the same tick.

After all 8 ticks:
1. Write the full episode to TRANSCRIPT.md with:
   - Episode header: ## Episode [N]: [Generated Title]
   - Scene breaks at epoch boundaries
   - Character dialogue and stage direction
2. Write tick-by-tick state changes to LOG.md
3. Persist final state to .moollm/state.yml
4. Write .moollm/LAST-TICK.yml with full diagnostic for the last tick
5. Give a brief 2-3 sentence recap of what happened
