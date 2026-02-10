# Delegation Object Protocol (DOP)
## Self-like Inheritance for LLMs

*Inspired by the SELF language (Ungar & Smith) and Ted Nelson's everything-is-intertwingled*

---

## 1. Philosophy

> *"SELF is a network, not a node."* — David Ungar

Traditional class inheritance doesn't work well for LLMs because:
- LLMs don't compute MRO algorithms reliably
- Hidden inheritance graphs confuse navigation
- Implicit rules get forgotten across turns

**DOP replaces inheritance with delegation:**
- Explicit ordered lookup
- Files as objects
- Directories as namespaces
- First-match-wins resolution
- Human-readable at every step

---

## 2. Core Concepts

### Object
A directory containing files that describe behavior, state, or configuration.

### Prototype Stack
An ordered list of directories to search when resolving a file.
First match wins.

### Overlay
Local files that shadow prototype files.
The instance IS the overlay.

### Delegation
When a file isn't found locally, look in prototypes.

---

## 3. PROTOTYPES.yml

Every delegating object has this file:

```yaml
# PROTOTYPES.yml
prototypes:
  - path: ".skills/ui-embed"
  - path: ".skills/memory-palace"
  - path: ".skills/adventure"

resolution:
  strategy: "first-match-wins"
  
notes: "UI takes precedence, then memory, then adventure"
```

### Fields

| Field | Type | Description |
|-------|------|-------------|
| `prototypes` | array | Ordered list of parent directories |
| `prototypes[].path` | string | Path to prototype directory |
| `resolution.strategy` | string | Always "first-match-wins" |

---

## 4. Resolution Algorithm

To resolve logical file `F`:

```
1. Check local: ./F or ./overrides/F
   If found → return it
   
2. For each prototype P in PROTOTYPES.yml order:
   Check: P/files/F or P/template/F
   If found → return it
   
3. Not found → unresolved
```

### Namespaces

DOP defines three namespaces:

| Namespace | Location | Purpose |
|-----------|----------|---------|
| Local overlay | `./` or `./overrides/` | Instance-specific |
| Prototype payload | `prototype/files/` | Inherited defaults |
| State | `./state/` | Never inherits (local only) |

---

## 5. Example Structure

### Prototype (Skill)

```
.skills/
  ui-embed/
    SKILL.md
    PROTOTYPE.yml
    files/                    # Inheritable payload
      render-protocol.md
      components.yml
      styles.css
    template/                 # For instantiation
      TASK.yml.tmpl
      CHECKLIST.md
```

### Instance

```
.agent/sessions/.../instances/
  my-task-0001/
    INSTANCE.yml
    PROTOTYPES.yml            # Points to .skills/ui-embed
    overrides/                # Local overlay
      render-protocol.md      # Shadows prototype's version
    state/                    # Local-only state
      progress.yml
```

### Resolution Example

Request: `render-protocol.md`

1. Check `my-task-0001/render-protocol.md` → not found
2. Check `my-task-0001/overrides/render-protocol.md` → **FOUND!**
3. Return it (don't check prototypes)

Request: `components.yml`

1. Check `my-task-0001/components.yml` → not found
2. Check `my-task-0001/overrides/components.yml` → not found
3. Check `.skills/ui-embed/files/components.yml` → **FOUND!**
4. Return it

---

## 6. Multiple Inheritance

DOP supports multiple prototypes:

```yaml
prototypes:
  - path: ".skills/ui-embed"      # First priority
  - path: ".skills/memory-palace" # Second priority
  - path: ".skills/adventure"     # Third priority
```

### Conflict Handling

When multiple prototypes define the same file:

1. **Order wins (default)**: Earlier prototype takes precedence
2. **Local override**: Best way to resolve intentionally
3. **Document conflicts**: Write to `CONFLICTS.md`

```markdown
# CONFLICTS.md

## render-protocol.md

Both `ui-embed` and `memory-palace` define this file.

**Resolution**: Using ui-embed version (order precedence)

**Rationale**: UI rendering takes priority over memory visualization

**TODO**: Consider merging approaches in a custom override
```

---

## 7. Explicit Merges

By default, DOP does NOT merge files. Override or accept.

For cases requiring merging, create `MERGES.yml`:

```yaml
# MERGES.yml
protocol: DOP/0.1

merges:
  - file: "config.yml"
    strategy: "yaml-deep-merge"
    sources:
      - "local"
      - "prototypes"  # All of them
    
  - file: "tags.txt"
    strategy: "concatenate"
    deduplicate: true
```

**Merges are opt-in.** Without MERGES.yml, no merging happens.

---

## 8. State vs Inherited

### State Directory

`state/` NEVER inherits:

```yaml
# ./state/ is ALWAYS local
state/
  progress.yml      # This instance's progress
  cache/            # This instance's cache
  temp/             # This instance's temp
```

### Why?

State is instance-specific. Inheriting state would break isolation.

### Inherited vs Local

| Type | Inherits? | Example |
|------|-----------|---------|
| Protocol docs | Yes | SKILL.md, CHECKLIST.md |
| Configuration | Yes | config.yml, settings.yml |
| Templates | Yes | *.tmpl files |
| State | **NO** | progress.yml, results.json |
| Instance metadata | **NO** | INSTANCE.yml |

---

## 9. LLM-Friendly Patterns

### Pattern 1: Explicit Lookup

Don't assume. Always check:

```
"Let me check if render-protocol.md exists locally..."
fs.ls("./overrides/")

"Not found locally. Checking prototype..."
fs.ls(".skills/ui-embed/files/")

"Found! Reading from prototype..."
fs.read(".skills/ui-embed/files/render-protocol.md", why="Get rendering rules")
```

### Pattern 2: Resolution Notes

Document what was resolved from where:

```markdown
# RESOLUTION.md

| File | Source | Version |
|------|--------|---------|
| render-protocol.md | .skills/ui-embed | 0.3.1 |
| components.yml | local override | - |
| styles.css | .skills/ui-embed | 0.3.1 |
```

### Pattern 3: Precedence Comments

In override files, note what you're overriding:

```yaml
# components.yml
# OVERRIDE: Shadows .skills/ui-embed/files/components.yml
# REASON: Added custom component for this task

components:
  # ... custom content ...
```

---

## 10. Prototype Chains

Prototypes can have their own prototypes:

```
my-task-0001
  └── .skills/ui-embed
        └── .skills/base-skill
              └── .skills/core
```

### Resolution with Chains

When searching prototypes:
1. Check prototype's own files/
2. If prototype has PROTOTYPES.yml, recurse
3. Maximum depth recommended: 3

### Circular Detection

Circular prototype references are errors:

```yaml
# ILLEGAL: A → B → A
.skills/a/PROTOTYPES.yml:
  prototypes:
    - path: ".skills/b"

.skills/b/PROTOTYPES.yml:
  prototypes:
    - path: ".skills/a"  # CIRCULAR!
```

Detect and error on circular references.

---

## 11. MOOLLM Integration

DOP maps to MOOLLM concepts:

| DOP Concept | MOOLLM Equivalent |
|-------------|-------------------|
| Prototype | Trading card / skill template |
| Instance | Room activation / character |
| Delegation | Pet inheritance |
| Resolution | K-line activation |
| Override | Local customization |

### Characters as DOP Objects

A MOOLLM character is a DOP object:

```
00-Characters/
  yaml-coltrane/
    PROTOTYPES.yml       # Inherits from traditions
    yaml-coltrane.yml    # Soul (local state)
    yaml-coltrane.md     # Body (local docs)
    overrides/           # Custom behaviors
```

```yaml
# yaml-coltrane/PROTOTYPES.yml
prototypes:
  - path: "00-Characters/john-coltrane-tradition"
  - path: "00-Characters/jazz-musician-archetype"
  - path: ".skills/yaml-jazz"
```

---

## 12. Debugging DOP

### List Effective Files

```bash
# Show what files are resolved from where
for f in $(find . -name "*.yml" -o -name "*.md"); do
  echo "$f → $(resolve_source $f)"
done
```

### Trace Resolution

```yaml
# TRACE.md (generated for debugging)
## Resolution Trace for "render-protocol.md"

1. Checked ./render-protocol.md → NOT FOUND
2. Checked ./overrides/render-protocol.md → NOT FOUND
3. Checked .skills/ui-embed/files/render-protocol.md → FOUND

**Source**: .skills/ui-embed/files/render-protocol.md
**Version**: 0.3.1
```

---

## 13. Dovetails With

- **Skill Instantiation Protocol (SIP)**: Skills use DOP
- **Constitution**: DOP objects follow constitution
- **Character Architecture**: Characters as objects
- **Parenting Protocol**: Mutual inheritance
- **SELF Language**: Original inspiration

---

*Inheritance is just delegation over files.*
*First match wins.*
*Everything is explicit.*
*LLMs navigate, they don't compute.*
