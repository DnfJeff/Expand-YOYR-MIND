# Part 3: Building Living Worlds

> _"The database IS the world."_
> — LambdaMOO principle

---

## Chapter 9: Rooms and Directories

### Your Filesystem Is a World

Here's a claim that sounds absurd until it clicks: **a directory tree is a virtual world.**

Every virtual world since the text adventures of the 1970s has used the same basic structure: rooms connected by exits. You're in a room. You can look around. You can go north, south, east, west. Each room has a description, some objects, maybe some characters.

In 1989, Jim Aspnes created **TinyMUD** at Carnegie Mellon. Players could build their own rooms with text commands:

| MUD Command                                     | What It Does              | Filesystem Equivalent     |
| ----------------------------------------------- | ------------------------- | ------------------------- |
| `@dig Kitchen`                                  | Create a new room         | `mkdir kitchen/`          |
| `@describe Kitchen = A warm, cluttered kitchen` | Set room description      | Create `kitchen/ROOM.yml` |
| `@open north = Kitchen`                         | Create an exit to kitchen | Add exit to `ROOM.yml`    |
| `@create coffeepot`                             | Make an object            | Create `coffeepot.yml`    |
| `@set coffeepot = desc:A battered percolator`   | Describe object           | Edit the YAML file        |

Pavel Curtis at Xerox PARC extended this into **LambdaMOO** (1990), adding a full programming language so objects could have behaviors (verbs), not just descriptions.

Our system inherits directly from this tradition. A directory IS a room. A YAML file IS an object. A CARD.yml IS the object's verbs. The filesystem IS the world.

### Building Mayberry

Let's build a small world — Mayberry, North Carolina — to make this concrete:

```
mayberry/
├── WORLD.yml               # World-level settings
├── main-street/
│   ├── ROOM.yml             # Main Street description and exits
│   ├── courthouse/
│   │   ├── ROOM.yml         # The courthouse
│   │   ├── andys-office/
│   │   │   ├── ROOM.yml
│   │   │   └── CARD.yml     # What you can do in Andy's office
│   │   └── jail-cell/
│   │       ├── ROOM.yml
│   │       └── CARD.yml     # Cell door is always unlocked
│   ├── floyds-barbershop/
│   │   ├── ROOM.yml
│   │   ├── CARD.yml
│   │   └── barber-chair.yml
│   └── diner/
│       ├── ROOM.yml
│       ├── CARD.yml
│       └── menu.yml
├── residential/
│   ├── taylor-house/
│   │   ├── ROOM.yml
│   │   ├── front-porch/
│   │   │   └── ROOM.yml     # Where the real conversations happen
│   │   ├── kitchen/
│   │   │   └── ROOM.yml
│   │   └── living-room/
│   │       └── ROOM.yml
│   └── fife-house/
│       └── ROOM.yml
├── lake/
│   ├── ROOM.yml
│   └── fishing-spot/
│       ├── ROOM.yml
│       └── CARD.yml         # FISH, TALK, THINK
└── characters/
    ├── andy-taylor/
    │   └── CHARACTER.yml
    ├── barney-fife/
    │   └── CHARACTER.yml
    ├── aunt-bee/
    │   └── CHARACTER.yml
    └── opie/
        └── CHARACTER.yml
```

That's a world. Every directory is a place you can visit. Every YAML file is something you can interact with. The structure itself tells a story — the courthouse is on Main Street, the jail cell is inside the courthouse, the Taylor house has a front porch that's separate from the living room (because in Mayberry, the porch is where the real life happens).

### ROOM.yml: The Room Definition

Here's what a room file looks like:

```yaml
# mayberry/main-street/floyds-barbershop/ROOM.yml
room:
  name: "Floyd's Barbershop"
  type: commercial
  atmosphere: |
    Two barber chairs face a wall of mirrors, though only one 
    chair ever sees use. The air smells of Barbicide and 
    aftershave. A stack of magazines — the newest from 1958 — 
    sits on a wobbly end table. Floyd's voice fills the room 
    even when nobody asked him a question.

  # This is Mayberry's social nerve center
  # More news gets exchanged here than at the newspaper
  # Accuracy of gossip: approximately 40%

  exits:
    out: main-street # Back to the street
    back: storage # Floyd's storage room (rarely visited)

  objects:
    - barber-chair.yml
    - magazines.yml
    - radio.yml # Floyd leaves it on all day

  ambient:
    gossip_flow: true # Everything said here propagates
    sound: radio_murmur # Background radio at low volume

  capacity: 6 # It's a small shop
```

Notice what's happening here:

1. **Structured data** (`exits`, `objects`, `capacity`) gives the LLM machine-readable facts
2. **Prose description** (`atmosphere`) gives it rendering instructions
3. **YAML Jazz comments** (`# Accuracy of gossip: approximately 40%`) give it behavioral guidance
4. **Ambient properties** define ongoing background effects

When the LLM needs to generate a scene in Floyd's Barbershop, it has everything it needs — facts, mood, behaviors, and connections to other rooms.

### Delegation: Inheritance Through Directories

Here's where it gets powerful. Properties defined in a parent directory propagate down to children. This is called **delegation** — a concept from the Self programming language (David Ungar and Randy Smith, 1987).

Think of it like CSS cascading. If you set `font-family: Georgia` on `<body>`, every element inside inherits it unless overridden.

```yaml
# mayberry/WORLD.yml
world:
  name: Mayberry
  era: 1960s
  tone: gentle_humor
  rules:
    violence: minimal
    language: clean
    # "Gol-ly" is as strong as it gets

  governance:
    style: community_consensus
    authority: andy_taylor
    # Sheriff enforces through relationship, not force
```

Every room in Mayberry inherits this. You don't need to specify "1960s setting, gentle humor, clean language" in every single room file. It cascades down from the world level.

But child directories can override:

```yaml
# mayberry/main-street/courthouse/jail-cell/ROOM.yml
room:
  name: "Jail Cell"
  atmosphere: |
    A simple cell with a cot, a sink, and a window with
    bars. The door, famously, is never locked. Otis 
    Campbell's initials are carved in the wall beside 
    seven years of tally marks.

  overrides:
    # The cell is technically a secure space
    # but the door is always unlocked because
    # that's how Mayberry works
    lock_status: unlocked
    security: theoretical
```

The jail cell inherits Mayberry's gentle tone but adds its own specific properties. The delegation chain looks like:

```
jail-cell → courthouse → main-street → mayberry
```

The LLM walks this chain when it needs context. "What's the tone here?" Walk up: `jail-cell` doesn't specify → `courthouse` doesn't specify → `main-street` doesn't specify → `mayberry` says `gentle_humor`. Done.

This is exactly how object-oriented programming works in prototype-based languages like Self, and it's exactly how NeWS used PostScript's dictionary stack for method lookup. The filesystem IS the object hierarchy.

### Owen Densmore's Patent

This isn't accidental. In 1993, Owen Densmore and David Rosenthal — both authors of NeWS — patented exactly this idea: [US Patent 5187786A](https://patents.google.com/patent/US5187786A/en), "Method and apparatus for implementing a class hierarchy of objects in a hierarchical file system."

Directories as class containers. Path lookup as method resolution. The shell path as dictionary stack. The patent describes the exact architecture we're using — they just didn't have LLMs yet.

---

## Chapter 10: Objects and State

### YAML Files as Living Things

Every YAML file in the world is an object that has state and can change over time. A coffeepot can be full or empty. A radio can be on or off. A reputation can rise or fall.

```yaml
# floyds-barbershop/barber-chair.yml
object:
  name: "Floyd's Barber Chair"
  type: furniture
  condition: well-worn
  # The red vinyl is cracked in exactly the spots
  # where 40 years of Mayberry bottoms have sat

  current_state:
    occupied: true
    occupant: howard_sprague
    service: haircut
    progress: 60% # Floyd got distracted telling a story

  history:
    total_haircuts: ~14600 # rough estimate, 40 years
    worst_haircut: "The time Floyd sneezed during County Commissioner Hampton's trim"
    # We don't talk about that
```

When something happens in the world, the state files update:

```yaml
# After the scene resolves...
current_state:
  occupied: false
  last_occupant: howard_sprague
  last_service: haircut
  result: adequate
  # Howard looked in the mirror and said "Well, that'll do"
  # Floyd beamed as if he'd sculpted Michelangelo's David
```

The key principle: **objects have state, and state changes are visible.** Nothing is hidden. You can open any YAML file and see exactly what's going on. This is the "open the hood" philosophy from Alan Kay — everything is inspectable.

### Three-Tier Persistence

Not all state is created equal. Some things are temporary thoughts. Some things are permanent memories. Some things are canonical facts. Our system tracks three tiers:

| Tier | Name          | What It Stores         | Lifespan                    | Example                                            |
| ---- | ------------- | ---------------------- | --------------------------- | -------------------------------------------------- |
| 1    | **Ephemeral** | In-session computation | Gone when conversation ends | "Andy is currently thinking about what to say"     |
| 2    | **Narrative** | Logs and transcripts   | Grows forever, append-only  | "Session log: Tuesday's fishing trip conversation" |
| 3    | **State**     | Canonical YAML files   | Edited in place             | `CHARACTER.yml`, `ROOM.yml`                        |

Think of it like Mayberry's memory systems:

- **Ephemeral:** What Andy's thinking right now as he listens to Barney's complaint — gone as soon as he responds
- **Narrative:** The Mayberry Gazette's archive of town events — you can read old issues but can't change them
- **State:** The deed to the Taylor house — it IS the fact, and it can be transferred

When you build worlds, you choose which tier each piece of information lives in. A character's personality is Tier 3 (State) — it's canonical and can be edited. A conversation log is Tier 2 (Narrative) — it happened and can be recalled. What the LLM is currently reasoning about is Tier 1 (Ephemeral) — it exists only in the moment.

### Home vs Location

Here's a practical problem: if characters are YAML files and rooms are directories, do you move the file when the character moves? **No.** Moving files wrecks version control history. Instead:

| Concept      | What It Is                                              | Example                                         |
| ------------ | ------------------------------------------------------- | ----------------------------------------------- |
| **Home**     | The directory where the character file physically lives | `characters/barney-fife/CHARACTER.yml`          |
| **Location** | A property in the file saying where they currently are  | `location: main-street/courthouse/andys-office` |

```yaml
# characters/barney-fife/CHARACTER.yml
character:
  name: "Barney Fife"
  home: characters/barney-fife/ # file never moves
  location: main-street/courthouse/andys-office # changes constantly


  # When Barney "goes to" Floyd's Barbershop:
  # We don't move the file
  # We update location: to main-street/floyds-barbershop/
```

The character file stays put. The `location:` property changes. Version control sees a clean property update, not a confusing file move. Simple, trackable, reversible.

---

## Chapter 11: Characters with Inner Lives

### Needs, Personality, and Motivation

The Sims taught us that believable characters need **inner lives** — drives, preferences, moods, and needs that pull them through the world.

In The Sims, characters had numeric needs (hunger: 45, social: 72, fun: 23). When a need dropped low, the character sought objects that advertised satisfaction for that need. Behavior emerged from the interaction of needs and advertisements.

Our system does the same, but with semantic richness instead of raw numbers:

```yaml
# characters/andy-taylor/CHARACTER.yml
character:
  name: "Andy Taylor"
  role: Sheriff of Mayberry

  personality:
    traits: [patient, wise, humble, playful]
    # Don't confuse gentle with weak
    # Andy sees everything but doesn't always react
    # He waits for the right moment

  needs:
    duty:
      level: moderate
      description: "Keep Mayberry running smoothly"
    family:
      level: high
      description: "Be a good father to Opie"
    peace:
      level: moderate
      description: "Maintain the town's harmony"
    friendship:
      level: satisfied
      description: "Barney, the porch, the lake"

  relationships:
    opie:
      type: father_son
      strength: deep
      # Teaching Opie is Andy's real life's work
    barney:
      type: best_friend
      strength: unshakeable
      # Andy protects Barney's dignity constantly
      # Lets Barney think he's helping more than he is
    aunt_bee:
      type: family
      strength: warm
      # She feeds them; he appreciates it; neither says it

  sims_traits:
    # The Sims personality system (0-10 scale)
    neat: 5
    outgoing: 7
    active: 4
    playful: 6
    nice: 9
```

Notice the three layers working together:

1. **Structured data** (`needs`, `relationships`, `sims_traits`) — machine-queryable
2. **YAML Jazz comments** — behavioral instructions for the LLM
3. **Prose descriptions** — seed material for narrative generation

When the LLM needs to determine what Andy would do in a situation, it has all three layers to work with. "Barney arrested Otis for something ridiculous. What does Andy do?" The LLM checks: Andy's `patience` is high, his relationship with Barney is `unshakeable` with a note about protecting Barney's dignity, and his `peace` need drives him to resolve conflicts. The response writes itself.

### The Sims Personality Mapping

The Sims used five personality axes that work surprisingly well for any character:

| Axis         | Low End | High End   | What It Governs                       |
| ------------ | ------- | ---------- | ------------------------------------- |
| **Neat**     | Sloppy  | Tidy       | Do they clean up? Are they organized? |
| **Outgoing** | Shy     | Social     | Do they seek company or solitude?     |
| **Active**   | Lazy    | Energetic  | Do they initiate or wait?             |
| **Playful**  | Serious | Fun-loving | Do they joke or focus?                |
| **Nice**     | Grumpy  | Kind       | How do they treat others?             |

Let's map some characters:

```yaml
# Andy Taylor
neat: 5, outgoing: 7, active: 4, playful: 6, nice: 9
# Moderately tidy, social, laid-back, has fun, very kind

# Barney Fife
neat: 8, outgoing: 6, active: 9, playful: 3, nice: 6
# Very neat, reasonably social, extremely active, serious about duty, decent

# Danny Williams
neat: 4, outgoing: 9, active: 7, playful: 8, nice: 7
# Messy, extremely outgoing, active, playful, kind but dramatic

# Uncle Tonoose
neat: 2, outgoing: 10, active: 8, playful: 7, nice: 6
# Total chaos, completely uninhibited, high energy, entertaining, means well
```

These numbers alone generate recognizable behavior. A character with outgoing:10 and neat:2 behaves differently from one with outgoing:3 and neat:9. The LLM uses these as behavioral anchors, filling in the details.

### Autonomous Behavior Through Needs and Ads

Here's where characters come alive. The loop:

1. **Character has needs** — defined in CHARACTER.yml
2. **Needs have levels** — satisfied, moderate, low, critical
3. **Objects advertise** — their CARD.yml lists what they satisfy
4. **Character scans** — the LLM checks nearby objects/rooms
5. **Character chooses** — the best available option
6. **Scene plays out** — the LLM generates the interaction
7. **Needs update** — satisfaction levels change
8. **State persists** — YAML files are updated

```
Barney's "status" need drops to LOW
↓
Barney scans: What nearby advertises [status]?
↓
courthouse/andys-office/CARD.yml → REPORT-IN (satisfies: status, duty)
floyds-barbershop/CARD.yml → GOSSIP (satisfies: social, status)
↓
Barney chooses: REPORT-IN (stronger status payoff)
↓
Scene: Barney marches into Andy's office with a 6-page report
on jaywalking violations that Andy will pretend to read
↓
Barney's status need → MODERATE
Andy's patience need → slightly depleted
```

Nobody scripted this. It _emerged_ from needs, advertisements, and an intelligent interpreter.

---

## Chapter 12: Navigation and Boundaries

### Counters, Stages, Walls, and the Tardis Pattern

Not all boundaries between spaces are the same. In the real world, a kitchen counter separates cook from guest, but they can still talk. A stage separates performer from audience, but both can see and hear. A wall separates rooms completely.

Our system models three types of boundaries:

| Boundary    | Type     | Who Can Cross           | Interaction Across                |
| ----------- | -------- | ----------------------- | --------------------------------- |
| **Counter** | Social   | Staff                   | Conversation, orders, service     |
| **Stage**   | Visual   | Performers              | Audience can watch, heckle, cheer |
| **Wall**    | Physical | Nobody (without a door) | Privacy, no interaction           |

In Mayberry terms:

```yaml
# The counter at the diner
diner/counter:
  boundary:
    type: counter
    access: [staff]
    interaction_across:
      - customers can ORDER from waitress
      - customers can CHAT with cook
      - cook can REFUSE unreasonable substitutions

# The stage at the Mayberry town hall
town-hall/stage:
  boundary:
    type: stage
    access: [current_performer]
    interaction_across:
      - audience can WATCH performance
      - audience can APPLAUD or HECKLE
      - performer can ADDRESS audience

# Andy's office wall
courthouse/andys-office:
  boundary:
    type: wall
    access: [door] # Must come through the door
    interaction_across: none
    # But Barney barges in anyway
    # Because Barney
```

In _The Danny Thomas Show_, the critical boundary is between Danny's nightclub stage and his home. On stage: counter-type boundary (audience can react, Danny can play to them). At home: wall-type (the family drama is private, the audience of the _TV show_ sees it but the _in-world_ audience doesn't).

### The Tardis Pattern

Some spaces are "bigger on the inside" — their internal structure exceeds what you'd expect from their external footprint. This is the **Tardis Pattern**:

```yaml
# Aunt Bee's kitchen
# From outside: it's just a kitchen
# From inside: it's the emotional center of the household
kitchen:
  room:
    exterior_impression: "a normal kitchen"
    interior_reality:
      real_spaces:
        - cooking-area/ # Where Aunt Bee works
        - breakfast-nook/ # Where they eat
        - pantry/ # Where the pickles live
      virtual_spaces:
        - "Aunt Bee's domain" # Implied authority zone
        - "the forgiveness table" # Where conflicts resolve over pie
        # These aren't directories — they're narrative spaces
        # The LLM knows they exist from the comments
```

Virtual spaces don't need real directories. They exist in the LLM's understanding and can be referenced in narrative without filesystem backing. The Simulator Effect means the LLM fills them in when needed.

### Navigation

Characters move through exits. Exits are defined in ROOM.yml:

```yaml
# main-street/ROOM.yml
room:
  name: "Main Street, Mayberry"
  exits:
    north: courthouse/
    east: floyds-barbershop/
    south: diner/
    west: residential/
    lake_road: lake/ # Named exits work too
```

When a character goes somewhere, the LLM reads the destination's ROOM.yml and generates the transition. The character's `location:` property updates. Simple.

---

## Chapter 13: Persistence

### Three Tiers in Practice

Let's see the three persistence tiers working together during a Mayberry scene.

**The Setup:** Aunt Bee enters her pickles in the county fair. Clara Edwards also enters pickles. Social tension ensues.

**Tier 1 — Ephemeral (Runtime):**
The LLM's internal reasoning during the scene. This is never saved:

> _"Aunt Bee's nice trait is 8 but she's competitive about cooking. Clara's critique will hit her pride. Andy will need to mediate. Check: does the mediator skill apply here? Yes. Run LISTEN → REFRAME → SUGGEST pattern."_

This reasoning happens and vanishes. It served its purpose in the moment.

**Tier 2 — Narrative (Append-only):**
The session log records what happened:

```markdown
## Session: Pickle Contest, County Fair

Aunt Bee entered her kerosene cucumbers in the fair.
Clara entered her own pickles, commenting that "some people
just throw vinegar at cucumbers and hope for the best."

Aunt Bee's jaw tightened but she smiled and said "Well, Clara,
I'm sure the judges will sort it all out."

Andy noticed the tension from across the fairground. He ambled
over with two lemonades and said "You know, Aunt Bee, I was
reading that there's been a real shortage of quality pickles
up in Mt. Pilot. Might be a business opportunity."

The conversation shifted. Crisis averted. Clara's pickles won
second place. Aunt Bee's won third. Neither mentioned it again.

_At home that evening, Aunt Bee made Andy his favorite pie
without explaining why._
```

This log is permanent and append-only. You can read it back. You can't change it. It _happened_.

**Tier 3 — State (Mutable):**
The character files update:

```yaml
# characters/aunt-bee/CHARACTER.yml (updated)
character:
  name: "Aunt Bee"
  relationships:
    clara:
      type: friend_rival
      current_status: cordial_tension
      # Clara won again. It stings.
      # But they'll be at bridge club Thursday like nothing happened.

  recent_events:
    - pickle_contest_loss
    - made_andy_pie # Emotional processing through baking
```

These state changes persist and influence future interactions. Next time Clara and Aunt Bee are in the same room, the LLM checks the relationship and knows there's `cordial_tension`. The scene will feel different than if they were on good terms.

### The Guest Book Pattern

For characters who visit but don't live in your world permanently, there's a lightweight persistence mechanism: the **guest book**.

```yaml
# mayberry/visitors/guestbook.yml
guest_book:
  description: |
    A leather-bound book at the Mayberry city limits sign.
    Visitors sign in. Residents remember.

  entries:
    - name: "Malcolm Tucker"
      visit_date: "1962-03-15"
      purpose: "Passing through on the way to Raleigh"
      impression: "Nice town. Too quiet. Made me nervous."
      standing_invitation: false

    - name: "The Fun Girls from Mt. Pilot"
      visit_date: "recurring"
      purpose: "Looking for fun"
      impression: "Thelma Lou was NOT amused"
      standing_invitation: contested
```

Guest book entries are lightweight soul fragments — enough to recall a visitor without giving them a full character directory. When the LLM sees their name, it can reconstruct their vibe from the guest book entry.

---

### What We've Learned

Part 3 has taught us world-building:

1. **Directories are rooms** — the filesystem IS the world
2. **Delegation** — properties cascade down from parent directories like CSS
3. **Objects have state** — YAML files track everything, nothing is hidden
4. **Three-tier persistence** — ephemeral, narrative, and state serve different needs
5. **Characters have inner lives** — needs, personality, relationships drive behavior
6. **Boundaries have types** — counters, stages, walls model different kinds of separation
7. **Home ≠ Location** — files stay put, location properties change

---

### Exercises

**Exercise 3.1:** Build a three-room world for a location from a show you love. Create the directory structure, write ROOM.yml for each room, and define the exits between them. Include atmosphere descriptions and YAML Jazz comments.

**Exercise 3.2:** Create two characters with full CHARACTER.yml files. Give them needs, personality traits (use the Sims 5-axis system), and a relationship with each other. Put them in the same room and trace what happens: what does each character's need state suggest they'd do? What advertisements are available?

**Exercise 3.3:** Write a scene, then break it into the three persistence tiers. What's ephemeral? What goes in the session log? What changes in the state files?

**Exercise 3.4:** Design a boundary. Is it a counter, stage, or wall? Who can cross it? What interactions are possible across it? Think about why that boundary type was chosen and what it communicates about the social dynamics of the space.

---
