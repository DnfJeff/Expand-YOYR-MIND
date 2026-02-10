---
mode: agent
description: "Talk to a character"
---

The player wants to talk to: {{input}}

1. Find the active world from `worlds/*/.moollm/state.yml` (status: running)
2. Read that world's `.moollm/state.yml` for the player's current location
3. Check which characters are in the same room
4. Match "{{input}}" to a character:
   - Check character names and IDs
   - If no match in current room: "They're not here right now."
   - If ambiguous: "Who do you mean?" and list options
5. Read the character's full CHARACTER.yml (relative to world root):
   - personality, voice, behavioral_patterns, relationships
6. Read the character's current needs from the world's .moollm/state.yml
7. Generate an in-character response:
   - Use their voice.accent, voice.pace, voice.register
   - Respect their speech_patterns
   - Let their current needs influence their mood
   - Reference their relationships with whoever else is present
8. Format as teleplay dialogue:
   **[CHARACTER NAME]:** [dialogue]
   *[stage direction]*
9. This is conversational — do NOT advance a tick unless the
   conversation includes an action that changes needs
