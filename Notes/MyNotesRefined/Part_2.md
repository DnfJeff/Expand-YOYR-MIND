# Part 2: The Linguistic Motherboard

> _"PostScript is a linguistic 'mother board', which has 'slots' for several 'cards'. The first card we built was a graphics card. We're considering other cards..."_
> — John Warnock, Adobe

---

## Chapter 5: What Is an Interpreter?

### From PostScript to LLMs

An interpreter is something that reads instructions and carries them out. That's it. Your microwave has one — you press buttons, it interprets them, it heats food. The interesting question is: how sophisticated is the interpreter?

Let's walk through three levels of interpreter sophistication, because this progression is exactly the history that leads to our systems.

### Level 1: The Dumb Renderer

Before PostScript, printers were dumb renderers. Your computer did all the hard work — calculated every dot, every curve, every letter shape — and sent the printer a bitmap: "Put a dot here. Put a dot here. Put a dot here." Millions of dots.

The printer had no understanding of what it was printing. It couldn't tell a letter from a photograph from random noise. It just placed dots.

```
Computer: [calculates everything]
Computer → Printer: "Here are 8 million dots"
Printer: [places dots mechanically]
```

This is how most software still works. The application does all the thinking. The output channel is dumb.

### Level 2: The Programmable Interpreter (PostScript)

PostScript changed the game. Instead of sending dots, you sent a program:

```postscript
/Helvetica findfont 12 scalefont setfont
100 700 moveto
(Welcome to Mayberry) show
```

The printer reads this and _understands_ it: "Find the Helvetica font, scale it to 12 points, move to position (100,700), and draw the text 'Welcome to Mayberry.'" The printer has intelligence. It knows about fonts, coordinates, curves, and fills.

The genius of PostScript was that text, graphics, and computation were all the same thing. A PostScript file is simultaneously:

- **Code** — it contains procedures, loops, conditionals
- **Data** — it describes structured information (fonts, positions)
- **Graphics** — it renders visual output

One language. Three dimensions. One interpreter.

John Warnock called this the **"linguistic motherboard"** — a universal interpreter with slots for different capability cards. The first card they plugged in was graphics. But the architecture wasn't limited to graphics. Any card would fit.

### Level 3: The Universal Interpreter (LLM)

Now fast-forward forty years. A large language model is the next linguistic motherboard. Instead of understanding PostScript, it understands _everything you can express in language_:

```yaml
# This is simultaneously code, data, and graphics
character:
  name: Andy Taylor
  role: Sheriff of Mayberry
  approach: gentle_authority
  # Never leads with force
  # Asks questions instead of giving orders
  # Treats everyone with dignity, even Otis

  methods:
    - MEDIATE: resolve conflict between townspeople
    - COUNSEL: guide Opie through moral dilemma
    - DE_ESCALATE: calm down Barney's overreaction
```

When the LLM reads this, it understands Andy Taylor as a character. It can:

- **Execute** the methods (generate a mediation scene)
- **Query** the data (what's Andy's approach?)
- **Render** it visually (describe Andy walking down Main Street)

Same text. Three dimensions. One interpreter.

The LLM is the linguistic motherboard. Skills are the cards you plug into it.

### The NeWS Connection

In 1986, James Gosling (who later created Java) built **NeWS** — the Network extensible Window System at Sun Microsystems. NeWS ran PostScript on the _server_. Your computer didn't send pixels or even drawing commands — it sent entire programs across the network. The server ran them.

This was radical. Instead of the old model:

```
Client does everything → sends pixels → Server displays them
```

NeWS did:

```
Client sends program → Server understands and executes it → Results appear
```

The server had intelligence. It could handle events, manage windows, run animations — all from programs sent as text over the wire.

This is exactly what we do with LLMs. You send a skill (program) to the LLM (interpreter). The LLM understands it and executes it. Results come back as text.

| NeWS (1986)                        | Our System (2025)                 |
| ---------------------------------- | --------------------------------- |
| Send PostScript program to server  | Send skill description to LLM     |
| Server interprets and executes     | LLM interprets and executes       |
| Server manages windows, events     | LLM manages characters, narrative |
| Programs sent as text over network | Skills sent as text in context    |
| Server has intelligence            | LLM has intelligence              |

The technology changed. The architecture didn't.

---

## Chapter 6: The Axis of Eval

### Code, Data, and Graphics Unified

Don Hopkins coined the phrase **"Axis of Eval"** to describe HyperLook's unification of three dimensions. In PostScript and NeWS, the same text could be:

- **Code** — procedures to execute
- **Data** — structures to query
- **Graphics** — visuals to render

This wasn't a trick or a hack. It was fundamental. PostScript _is_ text that _describes_ graphics through _executable procedures_. The three dimensions aren't separate — they're three views of the same thing.

### The Axis in Our Systems

In the systems we build, YAML and Markdown replace PostScript, and the LLM replaces the PostScript interpreter. But the axis holds:

```
     Skills (Code)
          │
          ├── LLM interprets as behavior
          │
Prose (Graphics) ────────── YAML (Data)
          │
          ├── LLM renders as narrative
          │
          ▼
    Response (Output)
```

Let's make this concrete. Here's a character file:

```yaml
character:
  name: "Danny Williams"
  profession: nightclub_entertainer
  location: home/living_room
  traits: [dramatic, loving, exasperated, generous]
  # His stage persona is confident; at home he's bewildered
  # Kathy runs the house; Danny just thinks he does
  # Uncle Tonoose's visits are natural disasters

  current_state:
    mood: frazzled
    reason: "Uncle Tonoose arriving tomorrow"
```

This single file is simultaneously three things:

| Dimension    | What the LLM Sees                   | Example                                                             |
| ------------ | ----------------------------------- | ------------------------------------------------------------------- |
| **Data**     | Structured traits the LLM can query | `traits: [dramatic, loving, exasperated, generous]`                 |
| **Code**     | Comments that instruct behavior     | `# His stage persona is confident; at home he's bewildered`         |
| **Graphics** | Descriptions that generate scenes   | "Danny paced the living room, running his hand through his hair..." |

The LLM **pivots** between these dimensions automatically. Ask it "what are Danny's traits?" and it reads data. Ask it "how would Danny react to Tonoose arriving early?" and it executes the behavioral code. Ask it "describe the scene" and it renders graphics in prose.

### The Pivot Recipe

You can deliberately invoke different stances:

| Stance       | What You Ask                                | What the LLM Does                                 |
| ------------ | ------------------------------------------- | ------------------------------------------------- |
| **Data**     | "What's Danny's mood?"                      | Extract and report the YAML value                 |
| **Code**     | "What does Danny do when Tonoose shows up?" | Interpret the comments as behavioral instructions |
| **Graphics** | "Describe the living room right now"        | Generate a prose scene from the structured data   |

This isn't three different systems. It's one system, one file, three lenses. The Axis of Eval means you never have to choose. The same YAML file is your database, your script, and your scene description.

### YAML Jazz: Comments as Intelligence

Here's something subtle but powerful. In most programming contexts, comments are throwaway — notes for humans that the computer ignores. In our systems, comments are **semantic data**.

Look at this:

```yaml
room:
  name: "Floyd's Barbershop"
  type: commercial
  atmosphere: "warm, gossipy, slightly outdated"
  # The social nerve center of Mayberry
  # If you want to know anything, come here
  # Floyd tells you what you want to hear, not what's true
  # Two chairs but only one is ever used
  # The magazines are from 1958

  objects:
    barber_chair:
      status: occupied
      # Floyd is cutting hair and talking at the same time
      # He's not great at either one simultaneously
```

The LLM reads those comments. It understands them. When it generates a scene in Floyd's Barbershop, it knows that Floyd is unreliable, that the place is a gossip hub, that the magazines are ancient. The comments aren't decoration — they're instructions for the interpreter.

This is **YAML Jazz** — using the comment channel to convey meaning, emotion, behavioral guidance, and narrative voice. The YAML structure gives you queryable data. The comments give you soul.

### Input vs Output Formats

One more distinction that matters:

| Format       | Best For                            | Why                                            |
| ------------ | ----------------------------------- | ---------------------------------------------- |
| **YAML**     | Representing and manipulating state | Comments carry meaning, structure is editable  |
| **Markdown** | Narrative, documentation, prose     | Human-readable, embeds structure naturally     |
| **HTML/SVG** | Rendering visual output             | Display-ready                                  |
| **JSON**     | Machine-to-machine exchange         | No comments = less expressive, avoid for state |

YAML and Markdown are **input/working formats** — you read them, write them, and the LLM manipulates them. HTML and JSON are **output formats** — generated for display or exchange. This matters because you want to work in formats that carry the most meaning (YAML Jazz) and generate into formats appropriate for the consumer.

---

## Chapter 7: Skills as Programs

### Why Skills Aren't Documentation

Here's the paradigm shift that everything else depends on. In most AI systems, a "skill" or "prompt" is documentation: "You are a helpful assistant. When the user asks about weather, provide forecasts." It's a description. A manual. A README.

In our approach, a skill is a **program the LLM executes.**

The difference is not philosophical. It's operational:

| Documentation           | Program                               |
| ----------------------- | ------------------------------------- |
| Describes what to do    | IS what to do                         |
| Read once, then wing it | Executed step by step                 |
| Static                  | Can create, modify, and delete files  |
| Stateless               | Tracks and persists state             |
| One-size-fits-all       | Instantiated with specific parameters |

### The Incarnation Spectrum

Skills exist on a spectrum of "aliveness":

| Level         | Form                          | Persistence             | Example                                                   |
| ------------- | ----------------------------- | ----------------------- | --------------------------------------------------------- |
| **Mentioned** | Name invoked in conversation  | Gone when chat ends     | "Be polite, like Andy Taylor would"                       |
| **Modeled**   | Behavior enacted in session   | Lives in context window | Acting as a mediator during a conversation                |
| **Embedded**  | YAML data island in narrative | Lives in a document     | Character traits stored in a story file                   |
| **Incarnate** | Directory with state files    | Lives on disk forever   | A full character with history, personality, relationships |

The first level is what most people do with AI. The fourth level is what we're building toward.

An **incarnate** skill has:

1. **A CARD.yml** — machine-readable interface defining what it can do
2. **A README.md** — human-readable landing page
3. **State files** — YAML files that persist across sessions
4. **A home directory** — its place in the filesystem
5. **Inheritance** — properties it gets from parent directories
6. **A K-line** — its name activates everything associated with it

### Traditional vs Incarnate: Side by Side

Let's compare. Here's a traditional "bartender" prompt:

```
You are a bartender. Be friendly and knowledgeable about drinks.
Recommend cocktails based on customer preferences.
Be responsible about alcohol consumption.
```

Here's the same concept as an incarnate skill:

```
skills/bartender/
├── README.md        # What the bartender skill does
├── SKILL.md         # Full protocol with frontmatter
├── CARD.yml         # Interface definition
└── templates/
    └── menu.yml     # Drink menu template
```

Where `CARD.yml` contains:

```yaml
name: bartender
tier: gameplay

methods:
  - name: TAKE-ORDER
    description: Accept and process a drink order
    parameters:
      - name: customer
        type: string
        required: true
  - name: RECOMMEND
    description: Suggest drinks based on mood/preferences
  - name: CUT-OFF
    description: Responsibly decline to serve

advertisements:
  TAKE-ORDER:
    visibility: public
    satisfies: [thirst, social]
  RECOMMEND:
    visibility: public
    satisfies: [curiosity, social]
  CUT-OFF:
    visibility: staff_only
    satisfies: [safety]

state:
  instance_creates:
    - "tabs.yml" # Running drink tabs
    - "86ed-list.yml" # Items currently unavailable
```

The traditional prompt is a note to yourself. The incarnate skill is a _living system_ — it advertises capabilities, tracks state, has a defined interface, and can be instantiated into specific bartender characters.

### The Mayberry Skill

Let's build a real skill to make this tangible. Imagine we're creating the **mediator** skill — Andy Taylor's core capability:

```yaml
# skills/mediator/CARD.yml
name: mediator
tier: gameplay
lineage: "Andy Taylor → conflict resolution"

methods:
  - name: LISTEN
    description: Hear both sides without judgment
  - name: REFRAME
    description: Restate the problem so both sides feel heard
  - name: SUGGEST
    description: Propose a solution that preserves dignity
  - name: DE-ESCALATE
    description: Calm an escalating situation

advertisements:
  LISTEN:
    visibility: public
    satisfies: [emotional_need, trust]
    trigger: "when two or more characters are in conflict"
  SUGGEST:
    visibility: public
    satisfies: [resolution, harmony]

dovetails_with:
  - needs # Characters have emotional needs
  - room # Mediation happens in a place
  - reputation # Resolution affects standing
```

This skill can be _instantiated_ into any character who needs mediation ability. Andy Taylor gets it. But so could Miss Crump, or even Floyd (who'd be terrible at it, which is also interesting).

---

## Chapter 8: CARD.yml and Advertisements

### Objects That Tell You What They Can Do

One of the most elegant inventions in The Sims — the game that Don Hopkins helped build at Maxis — was the **advertisement system.**

In most games, the developer hardcodes what objects do. Fridge → food. Bed → sleep. Chair → sit. Every interaction is explicitly programmed.

The Sims did something different. Objects **advertise** their capabilities:

| Object       | Advertisements                  | Satisfies        |
| ------------ | ------------------------------- | ---------------- |
| Refrigerator | GET-SNACK, COOK-MEAL, GET-DRINK | Hunger           |
| Bed          | SLEEP, NAP, MAKE-BED            | Energy           |
| TV           | WATCH, CHANGE-CHANNEL           | Fun              |
| Phone        | CALL-FRIEND, ORDER-PIZZA        | Social           |
| Toilet       | USE, CLEAN                      | Bladder, Hygiene |

Characters in The Sims have _needs_ (hunger, energy, fun, social, etc.). When a need gets low, the character scans all nearby objects for advertisements that satisfy that need. The character then picks the best available option and queues it up.

This is autonomous behavior from simple rules. Nobody scripted "when the Sim is hungry, walk to the kitchen." The Sim notices their own hunger, scans for advertisements, sees the fridge advertising GET-SNACK with a hunger payoff, and goes.

### CARD.yml Is the Advertisement System

In our systems, `CARD.yml` is how skills, objects, and characters advertise their capabilities. The name itself is a triple reference:

1. **Warnock's motherboard** — cards that plug into the linguistic motherboard
2. **The Sims** — objects advertising methods
3. **Trading cards** — Magic: The Gathering, Pokémon, baseball cards — entities with stats and abilities

Here's a complete CARD.yml for a room in Mayberry:

```yaml
# floyd-barbershop/CARD.yml
name: floyd-barbershop
tier: gameplay
type: room

methods:
  - name: GET-HAIRCUT
    description: Floyd cuts your hair (quality varies)
    parameters:
      - name: customer
        type: character
    duration: 30_minutes
  - name: GOSSIP
    description: Exchange information (accuracy not guaranteed)
    parameters:
      - name: topics
        type: list
  - name: WAIT
    description: Sit and read ancient magazines

advertisements:
  GET-HAIRCUT:
    visibility: public
    satisfies: [hygiene, social]
    trigger: "hair getting long"
  GOSSIP:
    visibility: public
    satisfies: [social, information]
    trigger: "need to know something"
    # WARNING: Floyd tells you what you want to hear
  WAIT:
    visibility: public
    satisfies: [rest]
    trigger: "nothing else to do"

ambient:
  gossip_flow: true
  # Information exchanged here propagates through town
  # Accuracy degrades with each retelling
```

When a character needs social interaction, the LLM scans nearby rooms and their CARD.yml files. Floyd's Barbershop advertises GOSSIP with a `social` payoff. The character goes. Behavior emerges from advertisements, just like The Sims.

### The Advertisement Loop

Here's how it works in practice:

```
1. Character checks their needs (social is low)
2. LLM scans nearby CARD.yml files for advertisements
3. Floyd's GOSSIP satisfies [social, information]
4. Character walks to Floyd's
5. GOSSIP method executes (LLM generates the scene)
6. Character's social need increases
7. Information propagates (YAML state updates)
8. Gossip accuracy degrades as news spreads
```

Nobody scripted this sequence. It _emerged_ from:

- A character with needs
- Objects with advertisements
- An interpreter (LLM) that connects them

This is what Will Wright meant when he called The Sims characters "autonomous agents." They weren't following scripts. They were responding to their own needs by selecting from available advertisements.

### Advertisements in the Danny Thomas House

Let's see how this works in a family sitcom context:

```yaml
# williams-living-room/CARD.yml
name: williams-living-room
tier: gameplay
type: room

methods:
  - name: FAMILY-DISCUSSION
    description: The family talks about a problem
    satisfies: [emotional, social]
    # Usually starts calm and escalates
    # Danny gets dramatic, Kathy gets practical
  - name: REHEARSE
    description: Danny practices his act
    satisfies: [career, fun]
    # Kathy is his only audience and best critic
  - name: TONOOSE-ARRIVAL
    description: Uncle Tonoose shows up unannounced
    trigger: "dramatic_tension < threshold"
    satisfies: [chaos, comedy, love]
    # This is not optional. Tonoose arrives when he arrives.

advertisements:
  FAMILY-DISCUSSION:
    visibility: family_only
  REHEARSE:
    visibility: [danny, kathy]
  TONOOSE-ARRIVAL:
    visibility: ambient # Tonoose doesn't check schedules
```

Notice the `ambient` visibility on TONOOSE-ARRIVAL. Some advertisements aren't things characters choose — they're things that happen _to_ characters. Uncle Tonoose doesn't wait for an invitation. He's an ambient event, like weather. This is how you model forces that characters can't control but must respond to.

### Cards as Ethical Smart Pointers

Here's where CARD.yml gets deeper. When the "object" being described is a real person — someone who actually exists — the card carries ethical policies:

```yaml
# For a real person referenced in the system
hero_card:
  subject: "Andy Griffith"
  type: real_person
  status: deceased

  policies:
    impersonation: false # Never claim to BE them
    tradition: true # Can invoke their ideas
    tribute: true # Can honor through performance
    quotation: verified_only # Only cite real quotes

  can_provide:
    - guidance: "In the spirit of Andy Griffith's gentle humor..."
    - tradition: "The Mayberry approach would be..."

  cannot_provide:
    - dialogue: "Andy Griffith says: [made up quote]"
    - presence: "Andy Griffith is here with us"
```

This distinction — between creating fictional characters _inspired by_ real people versus _claiming to be_ real people — is baked into the system at the card level. More on this in Part 4.

### What We've Learned

Part 2 has established the architecture:

1. **The LLM is a linguistic motherboard** — a universal interpreter with slots for capability cards
2. **The Axis of Eval** — the same text is code, data, and graphics depending on how you look at it
3. **Skills are programs, not documentation** — they have interfaces, state, and can be instantiated
4. **Objects advertise capabilities** — characters choose actions based on their needs and available advertisements
5. **YAML Jazz** — comments carry semantic meaning, not just annotation

---

### Exercises

**Exercise 2.1:** Write a CARD.yml for a location you know well. Define at least three methods (things that happen there) and their advertisements. What needs do they satisfy?

**Exercise 2.2:** Take the Barney character from Part 1's exercise and add a CARD.yml. What methods does Barney advertise? What methods does he _think_ he advertises versus what he actually provides? (This gap between self-image and reality is fertile ground.)

**Exercise 2.3:** Write the same scene two ways: first as "data" (structured YAML describing what happens), then as "graphics" (prose narrative of the scene). Notice how the same information lives on different axes.

**Exercise 2.4:** Pick an object from real life (a coffee maker, a front porch, a jukebox). Write its advertisements using the Sims model: what does it offer, what needs does it satisfy, who can see the advertisement?

---
