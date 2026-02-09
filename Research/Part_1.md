# Part 1: Welcome to Mayberry

> *"You know what I think? I think you're trying to learn me something."*
> — Opie Taylor

**[← Back to Index](INDEX.md)** | **[Part 2: The Linguistic Motherboard →](Part_2.md)**

---

## Chapter 1: The Fishing Pole

### Why a Game — and Why It's Not Really a Game

Let's get something out of the way: we're going to talk about game development. We'll discuss rooms, characters, objects, inventories, and quests. If you've ever poked around a game engine — even if you just watched a tutorial — some of this will feel familiar.

But the game is the fishing pole.

In *The Andy Griffith Show*, Andy doesn't lecture Opie about ethics. He takes him fishing. Out there on the lake, while they're waiting for a bite, Andy tells a story. Maybe it's about a time he made a mistake when he was young. Opie listens, not because he's being taught, but because they're doing something together. The lesson lands because the context is real, the relationship is genuine, and the activity gives Opie something to do with his hands while his mind works.

That's what we're doing here. The "game" gives you something to do with your hands. The real curriculum is about:

- How to build systems where **meaning emerges** from structure
- How to create **agents that evaluate**, not just simulate
- How to make **hidden assumptions visible** and editable
- How to construct **living worlds** from text files and a language model
- How to design **safety systems** that feel like architecture, not afterthoughts

These are not game design problems. They're systems design problems, AI alignment problems, epistemology problems. But they're a lot easier to learn when you're building a pub where a monkey philosopher plays Fluxx with a family of cats.

### The Mayberry Principle

Andy Griffith understood something deep about governance. Mayberry didn't work because Andy had a gun. It worked because he rarely used it. The social fabric of the town — reputation, relationships, shared meals, gossip at Floyd's barbershop — did most of the heavy lifting.

When Otis Campbell stumbled in drunk on a Saturday night, Andy didn't throw the book at him. He left the cell door unlocked. Otis let himself in, slept it off, and let himself out in the morning. The *system* worked because it understood its participants, respected their dignity, and operated through social consensus rather than rigid enforcement.

That's the kind of system we're building. Not one that forces compliance through hard rules, but one where:

- **Rooms** have constitutions that inhabitants inherit
- **Characters** have inner lives that drive behavior
- **Judgment** is visible, editable, and distributed
- **Safety** comes from architecture, not restrictions

Barney Fife is what happens when you build a system with rigid enforcement and no contextual intelligence. Andy Taylor is what happens when you build a system that understands nuance, evaluates situations, and responds with appropriate force.

We're building Andy Taylor systems.

---

## Chapter 2: The Thread

### 40 Years of Ideas That Led Here

Nothing appears from nowhere. The system we're going to build — let's call it what it is, a living world engine powered by a language model — inherits from a specific lineage of ideas. Understanding where these ideas come from isn't just academic. It tells you *why* the design works.

Here's the short version:

```
1962: Sketchpad (Sutherland)      — Multiple views of the same thing
1968: NLS/Augment (Engelbart)     — Hypertext, augmenting human intellect
1970s: Smalltalk (Kay)            — Everything is an object, all the way down
1980: Society of Mind (Minsky)    — Intelligence as a society of simple agents
1980: Constructionism (Papert)    — You learn by building inspectable things
1984: PostScript (Warnock)        — Text IS graphics IS programs
1986: NeWS (Gosling)              — Send programs, not pixels
1987: Self (Ungar & Smith)        — Prototypes and delegation, no classes needed
1987: HyperCard (Atkinson)        — Everyone is a reader AND a writer
1989: SimCity (Wright)             — Simulation as mental model
1989: TinyMUD / LambdaMOO         — Text-based worlds users can build
2000: The Sims (Wright/Hopkins)   — Objects advertise, characters choose
2025: MOOLLM (Hopkins)            — Skills are programs, LLM is eval()
```

You don't need to memorize this. But notice the pattern: each step made computing more **spatial**, more **linguistic**, more **empowering**. Each step moved from "the computer tells you what to do" toward "you and the computer build something together."

### What We Inherit

From this lineage, we get specific, usable concepts:

**From PostScript and NeWS:** The insight that you can send a *program* to an interpreter rather than sending *data* to a renderer. This is the single most important idea in the entire curriculum, and we'll unpack it in Chapter 3.

**From The Sims:** Objects *advertise* what they can do. A refrigerator says "I can satisfy hunger." A bed says "I can satisfy energy." Characters see these advertisements and choose based on their needs. This is how CARD.yml works — more on this in Part 2.

**From Minsky's Society of Mind:** A name can reactivate an entire mental state. When you say "Mayberry," you don't just recall a town name — you recall warmth, simplicity, gentle humor, front porches, fishing at the lake. That's a K-line. Names are triggers that activate context. We'll use this heavily.

**From Papert's Constructionism:** You learn by building things you can inspect. Not by reading about how to build things. Not by watching someone else build things. By getting your hands in and making something, then looking at what you made, then making it better. Play, Learn, Lift.

**From the MUD/MOO tradition:** A world made of rooms connected by exits. Users can build new rooms, create objects, define behaviors. Simple text commands create complex worlds. This is the oldest and most tested model for interactive virtual spaces.

### Danny Thomas and the Performance Boundary

*The Danny Thomas Show* (also called *Make Room for Daddy*) ran from 1953 to 1965. Danny Williams was a nightclub entertainer juggling career and family — show business and home life.

What made the show work was the constant tension between Danny's **public performance** (confident, polished, in control on stage) and his **private reality** (baffled by teenagers, outwitted by his wife, struggling with fatherhood). The show's architecture was built around the boundary between these two worlds.

That boundary — between performance and authenticity, public and private, the role you play and the person you are — is exactly what we'll be building into our systems. In the framework we're learning:

- **The stage** is a room with performance framing. Everything that happens there is understood as enacted, not documentary.
- **The home** is a room with private framing. What happens there is canonical — it's the real state.
- **Characters** can exist in both spaces, and the system tracks which framing applies.

Danny Williams walking off-stage and into his living room is a *framing transition*. The rules change. The audience relationship changes. The evaluation criteria change. Our systems model this explicitly.

---

## Chapter 3: The Key Insight

### Send Programs, Not Data

In 1984, Adobe released PostScript. Most people think of it as a printer language. It was much more than that.

Before PostScript, if you wanted to print a circle, your computer calculated every pixel and sent them to the printer. The computer did the thinking; the printer was a dumb bitmap renderer. Send data. Receive printout.

PostScript flipped this. Instead of sending pixels, your computer sent a *program*:

```
newpath
100 200 50 0 360 arc
fill
showpage
```

That's not data. That's instructions: "Create a path. Draw an arc at position (100,200) with radius 50, from 0 to 360 degrees. Fill it. Show the page." The *printer* ran this program. The printer had intelligence.

John Warnock, Adobe's co-founder, described PostScript as a **"linguistic motherboard"** with **slots for capability cards.** The first card they built was a graphics card. But the architecture could accept any card — because the interpreter was universal.

### Why This Matters for Us

A language model is a linguistic motherboard.

When you interact with a chatbot the old-fashioned way — "answer my question, here's some data" — you're sending data to a renderer. You're doing the pre-PostScript thing. You're calculating the pixels.

When you send the LLM a *skill* — a set of instructions, a description of behavior, a protocol for how to handle situations — you're sending a program to an interpreter. The LLM evaluates it. The LLM has intelligence.

| Old Way | New Way |
|---------|---------|
| Send data to renderer | Send program to interpreter |
| Computer does all the thinking | Interpreter has intelligence |
| Fixed output format | Flexible, contextual responses |
| Every case needs its own code | One interpreter handles everything |

This is the key insight that unlocks everything else in this curriculum:

> **Skills are programs. The LLM is `eval()`. Empathy is the interface.**

Let's break that down:

- **Skills are programs:** A skill isn't documentation about how to do something. It's a program that the LLM *runs*. When you write a skill that says "evaluate the social dynamics of this room," the LLM executes that instruction in context.

- **The LLM is `eval()`:** In programming, `eval()` takes text and executes it as code. The LLM does the same thing with natural language. It takes your skill description — text — and executes it as behavior.

- **Empathy is the interface:** The LLM doesn't need rigid syntax. It understands intent. You can say "make it warmer" or "increase the coziness" or "this room should feel like Floyd's barbershop on a Saturday morning" and it knows what you mean. That empathic understanding IS the interface.

### The Mayberry Connection

Think of Andy Taylor as the interpreter. The townspeople bring him their problems — not as formal legal briefs, but as messy human situations. "Andy, Aunt Bee's feelings are hurt because Clara thinks her pickles are too sweet."

Andy doesn't parse this through rigid rules. He *evaluates* the situation: Who's involved? What are their needs? What's the history? What solution respects everyone's dignity? Then he acts.

That's exactly how a skill-based LLM system works:

1. The situation arrives (in YAML, Markdown, or plain English)
2. The interpreter (LLM) evaluates it against loaded skills
3. The response respects context, history, and relationships
4. The result is written back as state (files) or narrative (prose)

Andy Taylor is `eval()`. Mayberry is the filesystem. The town's customs are the skills.

---

## Chapter 4: The Two Computers

### How Sparse Rules Create Rich Worlds

Will Wright, creator of SimCity and The Sims, had a profound insight about simulation:

> *"He designs games to run on two computers at once: the electronic one on the player's desk, running his shallow tame simulation, and the biological one in the player's head, running their deep wild imagination."*

SimCity doesn't actually simulate a real city. It simulates *just enough* — some traffic patterns, some land values, some crime rates — and your brain fills in the entire rest of the city. You imagine the people, the smells, the politics, the Saturday farmers' market. The game gives you scaffolding. Your imagination builds the cathedral.

This is the **Simulator Effect**: players imagine simulations are vastly more detailed than they actually are.

### The Two Computers in Practice

Here's what this looks like in our systems. Consider a character defined in YAML:

```yaml
character:
  name: "Barney"
  role: deputy
  personality: [nervous, eager, loyal, officious]
  carrying: one_bullet
  # Means well but overcomplicates everything
  # Quotes regulations nobody's heard of
  # Andy is his best friend and he'd do anything for him
```

That's Computer 1: the electronic one. Sparse data. A name, some traits, a few comments.

Now here's what happens when the LLM reads this and generates a scene:

> Barney straightened his holster for the third time, even though the single bullet was safe in his shirt pocket where Andy made him keep it. "Section 4, paragraph 2, subsection B of the Mayberry Municipal Code clearly states—"
>
> "Barney," Andy said, not looking up from the newspaper.
>
> "Right, right." Barney deflated slightly, then puffed back up. "But I'm just saying, Andy, if we don't enforce the jaywalking ordinance on a Tuesday, what's next? Anarchy?"
>
> Andy folded the paper. "Why don't we go get some lunch."
>
> Barney's face lit up like he'd been deputized all over again. "The diner? Your treat?"

That's Computer 2: the biological one (well, the neural one — the LLM serving as an imagination engine). From six lines of YAML, we get a scene that *feels* like those characters. The sparse data anchored it; the interpreter filled it in.

### Scott McCloud's Masking

This connects to a principle from comics theory by Scott McCloud (*Understanding Comics*, 1993). McCloud observed that the most effective comics use **detailed, realistic backgrounds** but **simple, abstract characters:**

| Element | Style | Effect |
|---------|-------|--------|
| **Environment** | Detailed, specific | Immersive — you feel *there* |
| **Characters** | Abstract, simple | Projective — you see *yourself* |

The Sims did this deliberately. The world was rendered in detail — furniture, textures, lighting. But the characters were simplified, spoke gibberish (Simlish), and were visually stylized. Players projected their own families, friends, and emotions onto those simple figures.

Our systems do the same thing with prose:

| Component | Detail Level | Why |
|-----------|-------------|-----|
| **Rooms** (ROOM.yml) | Rich — atmosphere, objects, exits, rules | You need to feel the space |
| **Characters** (CHARACTER.yml) | Sparse — traits, a few comments | The LLM projects personality |

The LLM is the player's imagination, running on Computer 2.

### The Danny Thomas Application

*The Danny Thomas Show's* apartment in New York is detailed: the specific furniture, the layout, the kitchen where Danny spills things. But the characters — Danny, Kathy, Rusty, Linda, Uncle Tonoose — are drawn with broad, memorable strokes. Danny is the blustering entertainer with a heart of gold. Uncle Tonoose is the impossible Lebanese relative. You don't need 50 pages of backstory. You need three traits and a catch phrase, and the audience's imagination does the rest.

When we build characters for our systems, we follow the same principle:

```yaml
character:
  name: "Uncle Tonoose"
  traits: [dramatic, opinionated, generous, impossible]
  catchphrase: "I am MORTIFIED!"
  # Shows up unannounced
  # Gives terrible advice with total confidence
  # Would take a bullet for family
  # His stories about Lebanon get longer every time
```

That's enough. The LLM — or better yet, the reader's imagination working with the LLM — fills in the rest. The Simulator Effect makes Uncle Tonoose feel like a real person from a few lines of YAML.

### What We've Learned So Far

Let's take stock before moving on:

1. **The game is the fishing pole** — a familiar context for learning deeper mechanisms
2. **40 years of ideas converge** — PostScript, The Sims, Society of Mind, MOOs, and constructionism
3. **Send programs, not data** — the LLM is an interpreter, not a renderer
4. **Sparse rules, rich worlds** — the Simulator Effect lets minimal state create immersive experiences

In Part 2, we'll build the actual architecture — how the interpreter works, what skills look like, and how objects announce their capabilities.

---

### Exercises

**Exercise 1.1:** Think of a location you know well — a barbershop, a diner, a porch, a living room. Write 5-7 lines of YAML describing it. Include an `atmosphere:` field and a few comments hinting at its history. Don't over-describe. Leave room for imagination.

**Exercise 1.2:** Pick a character from a show you love. Write a sparse CHARACTER.yml for them: name, 3-4 traits, one or two comments about their behavior. See how much personality you can convey in under 10 lines.

**Exercise 1.3:** Describe the difference between "sending data" and "sending a program" in your own words. Use a non-computing analogy — like the difference between giving someone a fish and teaching them to fish.

---

**[← Back to Index](INDEX.md)** | **[Part 2: The Linguistic Motherboard →](Part_2.md)**
