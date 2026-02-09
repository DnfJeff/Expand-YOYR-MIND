# Danny Thomas Show Simulation Log

> **Persistence tier:** Narrative (read-mostly)
> **Purpose:** Append-only record of simulation events, state changes, and system decisions
> **Format:** One entry per simulation tick, newest at bottom

---

## Log Format

Each entry follows this structure:

```
### [TICK ###] — EPOCH: epoch_name — TIME: in_world_time

**Active characters:** [list]
**Location:** room_id

**Advertisements evaluated:**
- AD_NAME (score: N, guard: passed/failed) → selected/skipped

**Actions taken:**
- character_id: action_description
  - effect: what_changed
  - satisfies: [needs_list]

**State changes:**
- character_id.field: old_value → new_value

**Notes:** [optional LLM reasoning or narrative observations]
```

---

## Session Log

<!-- Simulation entries append below this line -->
