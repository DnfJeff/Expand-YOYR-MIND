---
mode: agent
description: "Persist current simulation state"
---

Save the current simulation state.

Find the active world from `worlds/*/.moollm/state.yml` (status: running).
All paths below are relative to that world's root directory.

1. Read all current state from the world's .moollm/state.yml
2. Update it with:
   - Current epoch and tick number
   - All character locations
   - All character needs (current values)
   - Any relationship deltas from this session
   - Any narrative flags set during play
   - Session metadata: timestamp, total_ticks this session
3. Write the updated state back to .moollm/state.yml
4. Confirm: "State saved at tick [N], epoch [name]. [N] characters tracked."
5. If LOG.md or TRANSCRIPT.md have unsaved content, ensure they're flushed

This is a checkpoint — the simulation can resume from this point
with `/boot` in a new session.
