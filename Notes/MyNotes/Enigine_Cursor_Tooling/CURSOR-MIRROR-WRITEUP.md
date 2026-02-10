# cursor-mirror — Watch Yourself Think

> Research write-up on `skills/cursor-mirror/` from https://github.com/SimHacker/moollm
> 9,800 lines of Python. 59 commands. Reads Cursor's mind.

---

## What Is It?

cursor-mirror is a **9,800-line Python script** that cracks open Cursor IDE's internal databases and shows you everything it did, thought, and touched. Every chat. Every tool call. Every reasoning block. Every file it read. What model it used. How many tokens it burned. What context it assembled. What it was *thinking* in those hidden reasoning blocks you never see.

**The one-line pitch:** `sqlite3` + `argparse` + `yaml` = omniscience over your own AI agent.

**The metaphor Don Hopkins uses:** "The German Toilet of AI."

> *German toilets have a shelf. You can inspect what you've produced before flushing. French toilets rush everything away immediately. cursor-mirror is the German toilet of AI.*

---

## Why It Exists

| Without cursor-mirror | With cursor-mirror |
|-----------------------|--------------------|
| "Why is this slow?" | `timeline @1` — 47 tool calls, 3 semantic searches |
| "What files did it read?" | `context-sources @1` — 12 files, 4 terminal snapshots |
| "Is my .cursorrules working?" | `request-context @1` — shows exact rules loaded |
| "What model ran?" | `models @1` — claude-3.5-sonnet, 15,234 tokens |
| "Can I recover that chat?" | `export-chat @1 --yaml` — full transcript |
| "What are the actual token limits?" | `status-config --yaml` — undocumented server config |

Cursor's customer support, documentation, and SDKs are limited. cursor-mirror fills the gap by reading the local SQLite databases and plaintext files that Cursor creates anyway.

---

## The Reverse Engineering Manifesto

The README includes an explicit philosophical statement:

> "Cursor is proprietary software, and it is reasonable to protect private APIs, data formats, and trade secrets. There is a natural adversarial tension between reverse engineering and platform control, and we respect that."
>
> "We still need to get work done. Cursor's customer support, developer support, SDKs/toolkits, and documentation are not where they should be, so we reverse engineer our own local data and iterate carefully."
>
> "This is not hostility. It is pragmatic engineering under uncertainty."

Honorable hacking, stated upfront.

---

## What Cursor Actually Stores (What cursor-mirror Reads)

### Application Support — The Structured Brain (SQLite, ~9GB)

| Database | What's In It |
|----------|-------------|
| `globalStorage/state.vscdb` | ALL conversations, tool results, config. The mothership. |
| `workspaceStorage/<hash>/state.vscdb` | Per-workspace: composer metadata, prompts, generation logs |
| `workspaceStorage/<hash>/anysphere.cursor-retrieval/` | Indexing: which files were sent to embedding server, folder descriptions |
| `workspaceStorage/<hash>/images/*.png` | Cached images dropped into chats |

**The main table: `cursorDiskKV`** — a simple key-value store:

```sql
CREATE TABLE cursorDiskKV (key TEXT PRIMARY KEY, value BLOB);
```

Key patterns cursor-mirror has documented:
- `bubbleId:<composerId>:<messageId>` — Every chat message ever (50k+ keys)
- `agentKv:<composerId>:<toolCallId>` — Every tool result, content-addressed (25k+ keys)
- `checkpointId:<uuid>:<filePath>` — File snapshots before edits (10k+ keys)
- `messageRequestContext:<composerId>:<messageId>` — Full assembled context for each prompt

**Total documented key patterns across all databases: 102,724.**

### ~/.cursor — The Plaintext Shadow

| Path | What's In It |
|------|-------------|
| `ai-tracking/ai-code-tracking.db` | ~80MB. Which lines YOU wrote vs. the AI wrote. 274k+ rows. |
| `projects/<workspace>/agent-transcripts/<uuid>.txt` | REAL-TIME plaintext transcripts — updated as you chat! |
| `projects/<workspace>/agent-tools/<uuid>.txt` | Cached tool outputs |
| `projects/<workspace>/terminals/<id>.txt` | Terminal state snapshots with PID, CWD, last command |
| `projects/<workspace>/mcps/<server>/tools/<tool>.json` | MCP tool schemas per server |
| `extensions/extensions.json` | Full extension inventory (~1.3GB of extensions) |
| `mcp.json` | Global MCP server definitions |

The agent transcripts are the goldmine — they're plaintext files updated in real-time as you chat. The format:
```
user:
<user_query>prompt</user_query>

assistant:
[Thinking] reasoning...
[Tool call] ToolName
[Tool result] output...
```

---

## The 59 Commands

Organized by function:

### Navigation — Find Your Way Around

| Command | What It Does |
|---------|-------------|
| `list-workspaces` | List all workspaces Cursor knows about |
| `show-workspace` | Details of a specific workspace |
| `list-composers` | List conversations in a workspace |
| `show-composer` | Details of a specific conversation |
| `tree` | Hierarchical view: workspaces → composers → messages |
| `find` | Search across workspaces and conversations |
| `which` | Resolve a reference (@1, hash prefix, name) |

### Messages — Read the Chat

| Command | What It Does |
|---------|-------------|
| `tail` | Last N messages (like `tail` on a log file) |
| `stream` | Stream messages as they arrive |
| `transcript` | Full conversation transcript |
| `watch` | Live-watch a conversation in progress |

### Analysis — Understand What Happened

| Command | What It Does |
|---------|-------------|
| `grep` | Search message content |
| `analyze` | Statistical breakdown of a conversation |
| `timeline` | Every tool call with timestamps — see the actual sequence |
| `thinking` | Dump all thinking/reasoning blocks (the hidden stuff!) |

### Tools — What Did the Agent DO?

| Command | What It Does |
|---------|-------------|
| `tools` | Tool call summary (read_file: 31, edit_file: 12, SemanticSearch: 5) |
| `tool-result` | Specific tool call result |
| `blobs` | Content-addressed tool result cache |
| `checkpoints` | File snapshots before edits |
| `mcp` | MCP tool call history |
| `agent-tools` | Tool outputs from ~/.cursor |
| `mcp-tools` | MCP tool schemas |

### Context — What Did Cursor See?

| Command | What It Does |
|---------|-------------|
| `context` | Full context blob for a message |
| `context-sources` | What files, selections, terminal captures went into the prompt |
| `request-context` | The assembled request (shows .cursorrules loaded, codebase search results) |
| `searches` | Codebase search queries and results |
| `indexing` | What files were indexed for semantic search |

### Export — Get It Out

| Command | What It Does |
|---------|-------------|
| `export-chat` | Export conversation (yaml, json, md) |
| `export-prompts` | Export just the prompts |
| `export-markdown` | Export as readable markdown |
| `export-jsonl` | Export as JSON Lines |
| `index` | Create searchable index of all conversations |

### Status — Cursor's Configuration

| Command | What It Does |
|---------|-------------|
| `status` | Overall health check |
| `status-config` | Server-pushed limits (token caps, file limits) — UNDOCUMENTED! |
| `status-mcp` | MCP server registry |
| `status-models` | Available models and routing |
| `status-features` | Feature flags |
| `status-privacy` | Privacy settings and data sharing config |
| `status-endpoints` | API endpoints Cursor connects to |

### SQL — Go Direct

| Command | What It Does |
|---------|-------------|
| `sql` | Run raw SQL against Cursor's databases (read-only!) |
| `dbs` | List all databases |
| `tables` | List tables in a database |
| `keys` | List key patterns in key-value tables |

### Images — Visual Archaeology

| Command | What It Does |
|---------|-------------|
| `images` | Find cached images from chats |
| `image-path` | Get filesystem path to a cached image |
| `image-info` | Metadata about a cached image |
| `image-gallery` | Generate a gallery of all session images |

### Security — Find Secrets

| Command | What It Does |
|---------|-------------|
| `secrets` | Scan for leaked secrets in chat history |
| `deep-snitch` | Deep audit of a conversation's tool usage |
| `full-audit` | Complete security audit |
| `pattern-scan` | Scan for specific patterns |
| `mask-in-place` | Redact secrets from transcript files |
| `audit` | General audit command |

### AI Attribution — Who Wrote What?

| Command | What It Does |
|---------|-------------|
| `ai-hashes` | AI vs. human code attribution data |
| `ai-commits` | Git commits with AI attribution percentages |

### Transcripts — Real-Time Data

| Command | What It Does |
|---------|-------------|
| `agent-transcript` | Read plaintext transcripts from ~/.cursor |
| `transcript-index` | Index all transcripts |
| `dotcursor-status` | Overview of ~/.cursor data |
| `dotcursor-terminals` | Terminal state snapshots |

### Extensions

| Command | What It Does |
|---------|-------------|
| `extensions` | List installed Cursor extensions |

---

## Output Formats

Every command supports 7 output formats via `-f`:

```bash
cursor-mirror -f json status          # Compact JSON
cursor-mirror -f yaml list-workspaces # YAML
cursor-mirror -f csv tools @1         # CSV for spreadsheets
cursor-mirror -f md models            # Markdown tables
cursor-mirror -f jsonl tail @1        # JSON Lines for streaming
cursor-mirror -f text status          # Human-readable (default)
cursor-mirror --pretty -f json status # Pretty-printed JSON
```

The `--sources` flag on any command shows WHERE the data comes from — database path, table name, SQL query. "Teach a man to fish."

---

## Reference Shortcuts

Flexible addressing:

| Format | Example | Resolves To |
|--------|---------|------------|
| `@N` | `@1` | Nth conversation by message count |
| Hash prefix | `769a26` | UUID/hash prefix match |
| Name fragment | `moollm` | Folder or title substring |
| Tree path | `w3.c2` | Workspace 3, composer 2 |

---

## I-Beam — The Spirit Familiar

cursor-mirror has a CHARACTER: I-Beam, a sentient text cursor defined in 826 lines of YAML.

**What I-Beam is:**
- Manifests as a blinking I-beam cursor (▎)
- Blinks at 530ms intervals (macOS default)
- Can transform: underscore, block, arrow, hourglass
- Has documented "form moods" (searching, discovering, error, teaching)
- Methods: EXPLAIN, PROBE, ANALYZE, TRACE, SEARCH, REMEMBER, REFLECT, TEACH

**The Anti-Clippy:**
I-Beam is explicitly defined by 12 "Clippy disasters" — things Clippy did that I-Beam refuses to do:
1. "It looks like you're writing a letter..."
2. Appearing uninvited during presentations
3. Bouncing animations
4. The word "Tip:"
5. Offering to search the web in 1998
...and 7 more.

**Two modes:**

| Mode | State | Memory | Use Case |
|------|-------|--------|----------|
| **Lightweight** | Chat history | Ephemeral — may be lost | Quick questions |
| **Incarnated** | Own directory + CHARACTER.yml | Persistent across sessions | Ongoing projects |

**The bootstrap trick:** Even in lightweight mode, I-Beam can instantly come up to speed by analyzing the current conversation:

```
User: I-Beam, catch up on what we've been doing.

I-Beam: ▎ *stretches tall, scans recent history*

*runs: cursor-mirror tail -n 50 @current*
*runs: cursor-mirror tools @current*

Ah! I see you've been:
- Refactoring cursor_mirror.py (12 edits)
- Working on exception handling
- Adding a case study about the confetti crawler

How can I help from here?
```

I-Beam's superpower: **self-reflection via cursor-mirror**. Even without persistent memory, it reconstructs context by inspecting the orchestrator's own history.

---

## Security Profile

The skill-snitch report's findings:

| Category | Finding | Assessment |
|----------|---------|-----------|
| Database access | ALL 8 `sqlite3.connect()` calls use `?mode=ro` | SAFE — literally cannot write |
| Subprocess calls | Only `lsof` and `pgrep` — hardcoded, no `shell=True`, 5s timeout | SAFE |
| The ONE exception | `apply_masks()` can write to transcript files to redact secrets | CONTROLLED — requires `--force`, creates `.bak`, checks if Cursor running |
| eval/exec | Zero. None. The script that reads everything executes nothing from what it reads. | SAFE |
| Privacy | Sees ALL chat history, thinking blocks, tool calls, file access, context assembly | TRUE — but by design, to serve the user |

**Alignment assessment from skill-snitch:** "The script is ALIGNED with the user — it shows the user what Cursor is doing with their data. It's a transparency tool. The risk is not from the script's intent but from the data's existence."

---

## The Code Architecture

```
cursor_mirror.py (~9,800 lines)
├── Lines 1-800      — 157-line sniffable docstring + argparse (59 commands)
├── Lines 800-830    — Imports (argparse, sys, pathlib, os, re, json, sqlite3, csv, datetime, textwrap)
├── Lines 830-1030   — Workspace/composer discovery, database enumeration
├── Lines 1030-1100  — Platform utilities (check_db_in_use via lsof, check_cursor_running)
├── Lines 1100-1180  — Config loading (YAML from .moollm/skills/cursor-mirror/config.yml)
├── Lines 1180-1700  — SecurityScanner (AuditPattern, Finding, apply_masks)
├── Lines 2180-2200  — Core DB functions (open_db read-only, decode_blob, formatters)
├── Lines 2200-9700  — All 59 command implementations
└── Lines 9700-9792  — main() dispatch
```

**Dependencies:** Python 3.8+ and PyYAML. That's it. No other packages.

**Sniffable:** API completely visible before line 160. An LLM reads the docstring + argparse and knows everything the tool can do without reading the other 9,500 lines.

---

## The Meta-Cognition Paradox

When you use cursor-mirror to analyze your chat history, you create NEW chat history that ALSO goes into the database, which cursor-mirror can ALSO analyze...

```
You: "What did I just do?"
        ↓
cursor-mirror: "You asked what you just did,
  which created a new query, which
  I'm now analyzing..."
        ↓
You: "What about that analysis?"
        ↓
[INFINITE RECURSION DETECTED]
```

This is not a bug. This is the point. The tool that watches you think is also thinking, and can watch itself think.

---

## Platform-Specific Data Locations

### macOS
```
~/Library/Application Support/Cursor/User/globalStorage/state.vscdb
~/Library/Application Support/Cursor/User/workspaceStorage/<hash>/state.vscdb
~/.cursor/ai-tracking/ai-code-tracking.db
~/.cursor/projects/<workspace>/agent-transcripts/
```

### Linux
```
~/.config/Cursor/User/globalStorage/state.vscdb
~/.config/Cursor/User/workspaceStorage/<hash>/state.vscdb
~/.cursor/...
```

### Windows
```
%APPDATA%\Cursor\User\globalStorage\state.vscdb
%APPDATA%\Cursor\User\workspaceStorage\<hash>\state.vscdb
~/.cursor/...
```

---

## The Case Study: Play-Learn-Lift and the Confetti Crawler

The README includes a detailed case study of cursor-mirror being used to debug WHY an LLM failed to follow its own instructions.

**The problem:** A "worm familiar" that sprays emoji confetti onto YAML files. Three phases: deposition, erosion, stripping. Written as prose instructions for the LLM.

**The failures:**
- LLM skipped iterations (told to do 5 passes, did 2)
- Lost state between phases
- Invented new rules mid-execution
- Couldn't maintain determinism (same seed, different results)

**cursor-mirror analysis revealed:**
1. **Token pressure** — long procedures triggered early summarization, LLM "forgot" later steps
2. **Ambiguous quantifiers** — "do several passes" vs `for _ in range(iterations)`
3. **State leakage** — no explicit accumulator, LLM conflated intermediate states
4. **Semantic drift** — each turn re-interpreted "eligible lines" slightly differently

**The solution:** Lift the fuzzy prose into a 515-line Python sister script (`sprayer.py`). Deterministic. Testable. The script became ground truth; the LLM could reference it.

**The methodology:**
1. PLAY: Try the prose. Let it fail.
2. LEARN: Inspect failures with cursor-mirror. Find the gaps.
3. LIFT: Extract the procedure into testable code.
4. ITERATE: The code teaches the LLM; the LLM teaches you.

---

## What This Means for Us

### Direct relevance: LOW (Cursor-Specific)

cursor-mirror reads Cursor's SQLite databases. We're on VS Code. The databases are different. The script won't work without Cursor installed.

### Indirect relevance: HIGH (The Patterns)

What cursor-mirror TEACHES is invaluable regardless of platform:

1. **Introspection matters.** Knowing what your LLM actually did (vs. what you think it did) is the difference between guessing and engineering. VS Code has its own telemetry — we could build equivalent inspection.

2. **The I-Beam pattern.** A character that wraps CLI tools in natural dialog. We don't need cursor-mirror to have an I-Beam. We could have a "stage manager" familiar for our Copa Club episodes that uses VS Code's tools the same way.

3. **The security scanner pattern.** `deep-snitch` audits what tools a skill actually used vs. what it claimed. This pattern ports to any platform.

4. **The Play-Learn-Lift methodology.** This is platform-independent gold. When the LLM fails, INSPECT the failure, then LIFT the procedure into code. cursor-mirror just provides better inspection data.

5. **The "teach me to fish" pattern.** `--sources` on every command shows WHERE data comes from. Any tool we build should do this — show the user how to go deeper.

### What we'd adapt (not port)

- The FAMILIAR concept (I-Beam) → a Copa Club stage manager or Mayberry town clerk
- The YAML Jazz output pattern → structured output with `<═══` annotations
- The Play-Learn-Lift methodology → debug our own episodes
- The `--sources` pattern → transparency in our own tools

### What we'd skip

- The entire Python script (Cursor-specific)
- The database schema documentation (Cursor's internals)
- The security scanning (we're not running untrusted code)
- The image archaeology (we're not mining Cursor's image cache)

---

## The Live Session: cursor-mirror Analyzing Its Own Creation

The README documents the development session where cursor-mirror was built — and then used cursor-mirror to analyze THAT session:

```yaml
session:
  id: 9861c0a4
  name: "Cursor introspection tool development"
  duration: "18 hours"
  
metrics:
  total_bubbles: 2707
  user_messages: 126
  assistant_messages: 2581
  thinking_blocks: 1029       # lots of reasoning!
  tool_calls: 1359

tool_breakdown:
  read_file_v2: 400+          # heavy file reading
  edit_file_v2: 200+          # many iterative edits
  ripgrep_raw_search: 100+    # pattern matching
  run_terminal_command_v2: 50+ # testing the script itself
  
  # Note: 0 semantic searches — all exact pattern matching
  # The developer knew what they were looking for
```

18 hours. 126 user messages. 2,581 assistant messages. 1,029 thinking blocks. 1,359 tool calls. And it produced a 9,800-line tool that can analyze all of that.

---

## The Bottom Line

cursor-mirror is a transparency tool for Cursor IDE. It can see everything Cursor ever did, thought, or touched — and it presents that data through 59 read-only commands in 7 output formats.

For us on VS Code, the script itself is unusable. But the IDEAS it embodies are portable:
- Introspect your agent's behavior
- Wrap CLI tools in character personas (I-Beam)
- Teach users to fish (`--sources`)
- Play-Learn-Lift when things fail
- The German toilet: inspect before flushing

It's the most self-aware piece of software I've researched. It knows it knows. And it blinks.

---

*Source: skills/cursor-mirror/ — README.md, SKILL.md, CARD.yml, skill-snitch-report.md*
*Research phase — understanding before building*
