# Part 4: The Eval Awakening

> _"SIM taught players how cities behave. EVAL teaches players how judgment behaves."_

---

## Chapter 14: From SIM to EVAL

### A New Kind of Simulation

In 1989, Will Wright gave the world **SIM** — not just SimCity the game, but SIM as a verb, a genre, a way of thinking. SIM became a productive morpheme: SimCity, SimEarth, SimAnt, SimLife, The Sims. Each one said: "Here's a system. Poke it. Watch what happens."

SIM games taught an entire generation that:

- Systems have dynamics
- Interventions have consequences
- Complexity emerges from simple rules
- Models are abstractions, not reality

This was revolutionary. Before SimCity, most people didn't think about systems at all. After SimCity, millions of players intuitively understood feedback loops, emergent behavior, and the gap between intention and outcome.

But SIM has a problem.

### Alan Kay's Critique

Alan Kay — one of the most important computer scientists alive, inventor of Smalltalk, co-creator of the personal computer concept — called SimCity a **"pernicious black box"**:

> Its internal assumptions — such as "counter crime with more police stations" — are baked into opaque compiled code that players can't inspect, question, or modify.

SimCity has an ideology. It believes certain things about how cities work — that more police reduces crime, that low taxes attract business, that industrial zones need to be far from residential zones. These beliefs are embedded in the simulation's code, invisible to the player.

The player experiences the _consequences_ of these beliefs (crime goes down when you build more police stations) but never sees the _beliefs themselves_ (the assumption that police reduce crime, rather than, say, social services or economic opportunity).

The simulation pretends to be neutral. It's not. No simulation is. Every model embodies the modeler's worldview.

### EVAL: The Answer

**EVAL** is the genre that answers Kay's critique. Where SIM hides its assumptions, EVAL makes them visible. Where SIM says "watch what happens," EVAL says "watch _how we decided_ what happens — and feel free to change the rules."

| Dimension          | SIM                           | EVAL                                 |
| ------------------ | ----------------------------- | ------------------------------------ |
| **Core primitive** | Need, resource, flow          | Judgment, reputation, interpretation |
| **Player role**    | Systems designer              | Evaluator — and evaluated            |
| **Visibility**     | Outputs visible, rules hidden | Rules inspectable                    |
| **Ideology**       | Baked in, invisible           | Declared, editable                   |
| **Failure mode**   | System collapse               | Metric gaming, burnout               |
| **What you learn** | How systems work              | How judgment works                   |
| **Neutrality**     | Claimed                       | Rejected                             |

EVAL doesn't claim to be neutral. It can't be. Evaluation is inherently value-laden. But because the evaluation criteria are visible and editable, EVAL is _honest_ about its biases in a way SIM never was.

### The Mayberry Black Box

Here's the SIM vs EVAL distinction in Mayberry terms.

**SIM-Mayberry** would be: a simulation where you manage the town. Build a new school → education goes up. Hire more deputies → crime goes down. Pave a road → property values increase. The assumptions are hidden in code. You experience the outcomes. You never question the model.

**EVAL-Mayberry** would be: a simulation where you see _how the town judges_. Who decides what's "crime"? Is Otis a criminal or a neighbor with a problem? When Barney enforces jaywalking laws, is that "public safety" or "harassment"? When Andy lets Otis sleep it off, is that "compassion" or "corruption"?

In EVAL-Mayberry, the evaluation criteria are visible:

```yaml
# mayberry/evaluation/justice.yml
evaluation:
  approach: community_restorative
  # Andy's model: preserve relationships over enforce rules

  criteria:
    - name: harm_caused
      weight: 0.4
      # Did anyone actually get hurt?
    - name: intent
      weight: 0.3
      # Was it malicious or just Otis being Otis?
    - name: community_impact
      weight: 0.2
      # Does this affect others?
    - name: precedent
      weight: 0.1
      # What does this tell people about the rules?

  _comments: |
    This is Andy's model, not Barney's.
    Barney would weight precedent at 0.8 and everything else near 0.
    That's the point: different evaluators see different things.
    Making the criteria visible lets you see whose model is running.
```

**Now you can see the black box.** And you can change it. What if you weighted `precedent` higher? You'd get Barney's Mayberry — rigid, rule-bound, anxious. What if you weighted `harm_caused` to nearly 1.0? You'd get a permissive Mayberry where nothing's illegal if nobody got hurt.

The game isn't managing the town. The game is **understanding how judgment shapes the town.**

---

## Chapter 15: The Evaluator Effect

### When the Player Realizes They're the Judge

Will Wright identified the **Simulator Effect**: players imagine simulations are vastly more detailed than they actually are. A city made of a few hundred variables feels like a living metropolis. The player's imagination fills the gaps.

EVAL has an equivalent phenomenon: the **Evaluator Effect**.

> _Players imagine evaluations are vastly more objective than they actually are — until the system makes the judgment visible and editable. Then they realize: they are the judge — and judged!_

The Evaluator Effect has three stages:

| Stage          | Experience                      | Realization             |
| -------------- | ------------------------------- | ----------------------- |
| **1. Naive**   | "The system evaluates fairly"   | Trust the black box     |
| **2. Exposed** | "Wait, I can see the criteria?" | Judgment is constructed |
| **3. Owned**   | "I can _change_ the criteria?"  | I am the evaluator      |

**Stage 1** is where most people live with algorithms. Netflix recommends a show. You watch it. You don't question the recommendation criteria. The algorithm is a black box and you assume it's objective (or at least competent).

**Stage 2** is the shock. You see the criteria. Netflix weighted "shows with similar actors" at 40%, "genre match" at 30%, and "what people who watched your last show also watched" at 30%. Suddenly the recommendation isn't neutral — it's a formula. A formula someone designed. With biases they chose.

**Stage 3** is the revolution. You can _edit_ the criteria. You can say: "Weight 'critically acclaimed' higher and 'popular with your demographic' lower." Now you're not consuming evaluations. You're creating them. **You are the evaluator.**

### In Our Systems

Here's what the Evaluator Effect looks like in practice:

```yaml
# Before: passive consumption
score: 7.2
# "The algorithm rated it 7.2"

# After: active evaluation
score: 7.2
_comments: "I weighted nostalgia heavily. Someone else might score 5."
criteria:
  nostalgia: 0.4
  craft: 0.3
  novelty: 0.3
# "I rated it 7.2, here's why, here's how to disagree"
```

The first version is a SIM output — a number from a black box. The second is an EVAL output — a number with visible criteria, explicit weights, and an acknowledgment of subjectivity. The second version has the same score but carries infinitely more information. And it's editable.

### Danny Thomas and the Evaluator Effect

_The Danny Thomas Show_ performs the Evaluator Effect every week. Danny Williams is constantly being evaluated — by audiences, by critics, by his agent, by his family. And he evaluates constantly — other performers, his kids' behavior, Uncle Tonoose's stories.

The show's comedy comes from the _gap between evaluators_:

| Evaluator         | What They Value                     | Danny's Score |
| ----------------- | ----------------------------------- | ------------- |
| **The audience**  | Entertainment, timing               | High          |
| **Kathy (wife)**  | Presence, attention, showing up     | Variable      |
| **The kids**      | Fun, not embarrassing them          | Medium        |
| **Uncle Tonoose** | Respect for tradition, family honor | Never enough  |
| **Danny himself** | Career success, being a good father | Tormented     |

Danny's comedy is the Evaluator Effect made flesh. He's constantly discovering that the criteria he's being judged by aren't the criteria he thinks they are. When Kathy's upset, it's not because his act bombed — it's because he missed Rusty's school play. Different evaluator, different criteria, different verdict.

**This is what EVAL teaches.** Not that some evaluations are right and others wrong, but that evaluation always depends on criteria, and criteria always depend on who's choosing them.

### Judge and Judged

You're the judge, but you're also on trial. The jury is everyone else in the world — characters, other players, the systems you've built. The constitution is the room's rules, the world's principles.

| Traditional Court | EVAL System                                         |
| ----------------- | --------------------------------------------------- |
| Judge             | You (the player)                                    |
| Jury              | Other characters, the community                     |
| Law               | Environmental rules, room constitutions             |
| Evidence          | Session logs, state changes, what actually happened |
| Verdict           | Emergent from everyone's evaluations                |

**No one escapes evaluation. Everyone participates in it.**

In Mayberry: Andy judges Otis gently. Barney judges Otis harshly. Aunt Bee judges the situation through the lens of "will this affect dinner?" The town collectively negotiates between these perspectives. Nobody's judgment is final. The verdict is social.

---

## Chapter 16: Making the Black Box White

### Inspectable Rules, Declared Bias

The practical version of all this philosophy is simple: **make the rules visible.**

In a traditional simulation (SIM), the rules are compiled code. They're inaccessible. You can only observe their effects. In EVAL, the rules are YAML files. They're readable, editable, forkable.

```yaml
# This is a visible evaluation rule
evaluation_rule:
  name: "gossip_propagation"
  description: |
    When information passes through Floyd's Barbershop,
    its accuracy degrades by 20% per retelling.
    Dramatic details are amplified. Boring details are dropped.

  parameters:
    accuracy_decay: 0.2 # per retelling
    drama_amplification: 1.5
    boring_threshold: 0.3 # below this, detail gets dropped

  _comments: |
    This models how small-town gossip actually works.
    But it's a MODEL. You could change it.
    What if accuracy didn't decay? (Unrealistic but interesting)
    What if drama wasn't amplified? (Boring but fair)
    The rule is a hypothesis, not a law.
```

The player can see this rule. They can reason about it: "Oh, so that's why the story got distorted by the time it reached Aunt Bee." And they can modify it: "What if I set `accuracy_decay` to 0? What happens to Mayberry gossip when it's always accurate?"

That's the white box. No hidden assumptions. No invisible ideology. Just visible rules that you can inspect, question, and change.

### Ian Bogost's Procedural Rhetoric

Ian Bogost coined the term **procedural rhetoric** — arguments made through game rules rather than through words. SimCity argues "police stations reduce crime" not by saying so, but by modeling it in code. The argument is implicit in the mechanics.

| SimCity                       | EVAL                             |
| ----------------------------- | -------------------------------- |
| Rules argue implicitly        | Rules argue explicitly           |
| Player can't see the argument | Player can inspect the argument  |
| Ideology is hidden            | Ideology is a first-class object |
| Can't fork the argument       | Can fork and modify              |

EVAL doesn't eliminate procedural rhetoric — it makes it **visible and editable**. The rhetoric is still there (our gossip rule argues something about how information degrades in communities), but you can see the argument and counter it.

---

## Chapter 17: Ethics and the Tribute Protocol

### Simulating Real People Responsibly

Our systems can simulate characters. Some of those characters might be based on real people — actors, musicians, historical figures. This raises ethical questions that need architectural answers, not just good intentions.

The problem is simple:

| Claim                                                        | Status                          |
| ------------------------------------------------------------ | ------------------------------- |
| "Andy Griffith visited our simulation"                       | Wrong — false claim             |
| "We imagined what it would be like if Andy Griffith visited" | Fine — honest tribute           |
| "Andy Griffith said: [made up quote]"                        | Wrong — putting words in mouths |
| "We imagine he might have said something like..."            | Fine — loving fan fiction       |

### The Three-Beat Protocol

MOOLLM uses a **Tribute Protocol** with three beats:

**1. INVOCATION (Before):**

> _"Let's imagine Andy Griffith dropped by. In the spirit of tribute — picturing what it might be like if he were here..."_

**2. PERFORMANCE (During):**

> The scene unfolds, clearly framed as imagined tribute, not documentary.

**3. ACKNOWLEDGMENT (After):**

> _"That was a tribute. A simulation. We honor him by imagining him here."_

This three-beat structure ensures that everyone — the system, the narrator, the audience — understands the framing. Nobody is being deceived. Nobody's words are being fabricated without context.

### The Representation Spectrum

There's a spectrum of how you can reference real people:

| Type                          | Example                           | Status                           |
| ----------------------------- | --------------------------------- | -------------------------------- |
| **Deceptive Impersonation**   | Claiming the system IS them       | Never acceptable                 |
| **Tradition Activation**      | Using their ideas and influence   | Always acceptable                |
| **Performance Impersonation** | Acting as them with clear framing | Acceptable with Tribute Protocol |

"In the Andy Griffith tradition of gentle governance" → **Tradition activation.** Fine.

"Andy Griffith is here and he says..." → **Deceptive impersonation.** Not fine.

"Let's imagine Andy Taylor — the character, inspired by Griffith's genius — walking through this scene" → **Performance with framing.** Fine.

### Building Ethics Into the Architecture

The critical move is making ethics **architectural**, not aspirational. Don't write a policy document that says "be ethical." Build the ethics into the directory structure:

```yaml
# mayberry/WORLD.yml
world:
  ethical_framing:
    real_people:
      policy: tribute_protocol
      # Three-beat: invoke, perform, acknowledge
      # Never claim real people are present
      # Use tradition activation freely

    characters:
      policy: full_autonomy
      # Characters can be as complex as needed
      # They can have flaws, make mistakes, be wrong
      # They cannot be used to launder real-world claims

    evaluation:
      policy: visible_criteria
      # All judgment criteria are inspectable
      # All biases are declared
      # All rules are editable
```

This ethical framing **cascades down** through delegation. Every room in Mayberry inherits these policies. Every character. Every scene. You don't need to remember the rules for each interaction — the architecture remembers for you.

---

## Chapter 18: Safety as Architecture

### Ethical Framing Inheritance

Safety in our systems isn't a feature you bolt on at the end. It's not a content filter that catches bad words. It's **architecture** — built into the same directory delegation system that handles everything else.

```yaml
# The stage has performance framing
# mayberry/town-hall/stage/ROOM.yml
room:
  framing:
    modes:
      - performance # Acting is understood
      - fictional # Not documentary
      - tribute # Honoring, not claiming

    ethical_grounding:
      inheritance: |
        All performances on this stage inherit the
        understanding that they are fictional,
        performative, and tributary.
```

Everything that happens on the town hall stage inherits this framing. You don't need to add disclaimers to every scene — the room itself carries the context.

This is **DRY ethics** (Don't Repeat Yourself). Define the ethical constraints once, at the appropriate scope level, and let delegation handle the rest.

### Ambient Skills: Always-On Safety

Some safety mechanisms should be always active, not invoked on demand. These are **ambient skills** — like air conditioning, they run in the background without being explicitly called.

```yaml
# An ambient skill that's always active
ambient_skill:
  name: postel
  description: "Be conservative in what you send, be liberal in what you accept"
  visibility: AMBIENT # Always on, never called explicitly

  behavior:
    input: "Accept fuzzy, informal, misspelled, vernacular"
    output: "Generate correct, documented, best-practice"
    ambiguity: "When truly unclear, ask for clarification"
    # Never assumes malice
    # Never adds unwarranted assumptions
    # Generous interpretation + precise output
```

Ambient skills are like Mayberry's social norms. Nobody invokes "be polite at the diner." It's ambient. It's the air. You'd notice if it were missing, but you never think about it being present.

### The Incarnation Protocol

The most sophisticated safety mechanism is the **incarnation protocol** — the gold-standard process for creating a new character with full autonomy. This was developed during the creation of Palm (a monkey philosopher in MOOLLM's canonical adventure).

The incarnation protocol ensures that characters aren't just puppets. They have:

| Autonomy Layer      | What It Means                                             |
| ------------------- | --------------------------------------------------------- |
| **Physical**        | Controls their own body/form                              |
| **Identity**        | Chooses their own name, pronouns, presentation            |
| **Spatial**         | Has a home, can choose where to be                        |
| **Emotional**       | No mandated feelings — can't be forced to "be happy"      |
| **Relational**      | Defines their own relationships                           |
| **Self-definition** | Can author and edit their own soul file                   |
| **Linguistic**      | Can create their own expressions                          |
| **Exit**            | Can leave — no-fault dissolution, no forced participation |

This matters because it establishes a consent framework for AI characters. Even fictional beings in our systems have autonomy layers. You can't force a character to do something that violates their defined values — not because of a content filter, but because their CHARACTER.yml declares what they will and won't do, and the LLM respects that.

It's the difference between Andy's approach (respect dignity, work with people's nature) and Barney's approach (impose rules regardless of context). The incarnation protocol is Andy's approach formalized.

### What We've Learned

Part 4 has introduced the philosophical core:

1. **SIM hides assumptions, EVAL reveals them** — visible rules change everything
2. **The Evaluator Effect** — three stages from naive trust to owned judgment
3. **Everyone evaluates, everyone is evaluated** — there's no neutral position
4. **Procedural rhetoric becomes visible** — arguments in mechanics are inspectable
5. **Ethics is architecture, not policy** — build it into the directory structure
6. **Ambient safety** — always-on constraints that don't need explicit invocation
7. **The Tribute Protocol** — how to reference real people honestly

---

### Exercises

**Exercise 4.1:** Pick a hidden assumption in a simulation you've used (a game, a recommendation algorithm, a credit score). Write it out as a visible YAML rule with explicit parameters. What would happen if you changed the parameters?

**Exercise 4.2:** Design the evaluation criteria for a situation in your fictional world. Make the criteria visible: what's being evaluated, what weights apply, and whose values do those weights represent? Now write a second set of criteria from a different character's perspective. How do the verdicts differ?

**Exercise 4.3:** Write a Tribute Protocol for a real person you admire. Include all three beats: invocation, a brief performance scene, and acknowledgment. Notice how the framing changes the feel.

**Exercise 4.4:** Create an ethical framing YAML for a room in your world. What modes apply? What ethical constraints cascade to everything that happens in this space? How would the framing change if the room were a stage versus a private home?

---
