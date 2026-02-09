# Characters of Mayberry

Every character lives in their own directory with a `CHARACTER.yml` file. Character files **never move** — the `location:` property inside them updates as characters travel through the world.

## Personality System

Each character has a five-axis personality based on The Sims model (0-10 scale):

| Axis         | Low End | High End   | What It Governs           |
| ------------ | ------- | ---------- | ------------------------- |
| **Neat**     | Sloppy  | Tidy       | Organization, cleanliness |
| **Outgoing** | Shy     | Social     | Company-seeking behavior  |
| **Active**   | Lazy    | Energetic  | Initiative, motion        |
| **Playful**  | Serious | Fun-loving | Humor, lightness          |
| **Nice**     | Grouchy | Kind       | Treatment of others       |

## Character Index

| Character                         | Role            | Personality Summary                          |
| --------------------------------- | --------------- | -------------------------------------------- |
| [Andy Taylor](andy-taylor/)       | Sheriff         | Patient, wise, governs through empathy       |
| [Barney Fife](barney-fife/)       | Deputy          | Nervous energy, means well, needs validation |
| [Aunt Bee](aunt-bee/)             | Homemaker       | Nurturing, quietly fierce, competitive       |
| [Opie Taylor](opie-taylor/)       | Andy's son      | Curious, honest, learning right from wrong   |
| [Floyd Lawson](floyd-lawson/)     | Barber          | Anxious, gossip hub, endearingly scattered   |
| [Otis Campbell](otis-campbell/)   | Town drunk      | Self-aware, polite, self-governing           |
| [Gomer Pyle](gomer-pyle/)         | Gas station     | Innocent, literal-minded, genuinely good     |
| [Goober Pyle](goober-pyle/)       | Gas station     | Simple, loyal, mechanical savant             |
| [Helen Crump](helen-crump/)       | Teacher         | Smart, grounded, Andy's equal                |
| [Clara Edwards](clara-edwards/)   | Neighbor        | Competitive, traditional, Bee's frenemy      |
| [Howard Sprague](howard-sprague/) | County clerk    | Proper, lonely, secretly wants adventure     |
| [Ernest T. Bass](ernest-t-bass/)  | Mountain man    | Chaotic, lovesick, window-breaking           |
| [The Darlings](the-darlings/)     | Mountain family | Musical, insular, loyal                      |

## Guest Stars

Visitors to Mayberry — outsiders who bring the wider world into town and leave changed by it. See [guest-stars/](guest-stars/) for full details.

| Character                                   | Role                  | Visitor Impact      |
| ------------------------------------------- | --------------------- | ------------------- |
| [Marvin Jessup](guest-stars/marvin-jessup/) | Young drifter         | Memorable           |
| [Ellen Brown](guest-stars/ellen-brown/)     | Manicurist at Floyd's | Romantic earthquake |
| [Jeff Pruitt](guest-stars/jeff-pruitt/)     | Bachelor farmer       | Endearing           |
| [Ronald Bailey](guest-stars/ronald-bailey/) | Spoiled rich kid      | Transformative      |

## Needs System

Characters have needs that drive autonomous behavior. When a need drops low, the character seeks objects or locations that advertise satisfaction for that need. The LLM scans nearby CARD.yml files and chooses the best match.

```
Need drops → Scan nearby ads → Choose best option → Play scene → Update state
```

This is exactly how The Sims worked, but with semantic richness instead of raw numbers.
