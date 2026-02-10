---
mode: agent
description: "Initialize a MOOLLM world simulation"
---

# Boot Protocol

**If the user specifies a world** (e.g. `/boot mayberry`):

1. Read `.github/worlds.yml`
2. Find matching world entry (case-insensitive, partial match OK)
3. Use that world's `path` to locate the world directory

**If no world specified** (just `/boot`):

1. Check `.moollm/state.yml` in any loaded world for `status: running` — offer to resume
2. Otherwise, read `.github/worlds.yml` and list available worlds:
   ```
   Available worlds:
     mayberry     — Mayberry, North Carolina (1960s, gentle humor)
     danny-thomas — Danny Williams' New York (1950s-60s, warm chaos)
   Type: /boot <name>
   ```

**If `.github/worlds.yml` is missing or empty** (auto-discovery):

1. Scan `worlds/` directory for subdirectories containing WORLD.yml
2. For each found: read WORLD.yml, extract name/era/tone/description
3. Write discovered entries to `.github/worlds.yml`
4. List them and ask which to boot

**Boot sequence** (once world is identified):

1. Read `{world-path}/WORLD.yml` for name, era, tone, rules, simulate block
2. Read `{world-path}/.moollm/config.yml` for bootstrap protocol
3. Check `{world-path}/.moollm/state.yml`:
   - If `status: running` → resume from saved epoch and tick
   - If `status: ready` → cold start: read all `**/GLANCE.yml` in that world
4. Announce:

   ```
   Booting: [World Name]
   Starting location: [Room Name]
   Time: [Epoch], [World Time]

   [Opening narration from WORLD.yml atmosphere]

   Type /look to see around, /episode to advance time.
   ```

5. Set `{world-path}/.moollm/state.yml` to `status: running`, record `current_world`
6. Write `{world-path}/.moollm/LAST-TICK.yml` with boot diagnostic
