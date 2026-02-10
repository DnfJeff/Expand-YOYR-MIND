---
mode: agent
description: "Reload modified world files and show impacts"
---

Check which world files have been modified and reload them.

Find the active world from `worlds/*/.moollm/state.yml` (status: running).
All file paths below are relative to that world's root directory.

1. Check for recently modified .yml files in the active world directory:
   - Look at file timestamps or use git status
   - Compare against what was loaded in .moollm/LAST-TICK.yml context_loaded
2. For each modified file:
   a. Re-read the file fully (ignore any cached GLANCE)
   b. Identify what changed (fields added, values changed, new content)
   c. Report the change in plain language:
   "Reloaded barney-fife/CHARACTER.yml: outgoing changed 8→3
   (will reduce social-seeking behavior, less likely to choose
   HANG_OUT ads)"
3. If character needs changed: update .moollm/state.yml
4. If a room was modified: note which characters are currently there
   and how the changes affect available advertisements
5. Confirm: "Changes are live. Next tick will use the updated files."
