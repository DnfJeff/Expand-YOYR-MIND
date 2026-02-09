# Mayberry, North Carolina

> *"You know what I like about Mayberry? Everything."*

**Population:** ~5,000 (give or take, depending on who's visiting)
**Era:** Early 1960s
**Governance:** Sheriff Andy Taylor (through relationship, never force)

---

## What This Is

This directory IS Mayberry. Every subfolder is a place you can visit. Every YAML file is something — or someone — you can interact with. The folder tree mirrors the town's geography, and properties cascade downward through the hierarchy like CSS inheritance.

This is Don Hopkins' core insight applied: **the filesystem is the world.**

```
Mayberry/
├── WORLD.yml                    # Town-wide defaults (era, tone, rules)
├── characters/                  # Everyone who lives here
│   ├── andy-taylor/
│   ├── barney-fife/
│   ├── aunt-bee/
│   ├── opie-taylor/
│   ├── floyd-lawson/
│   ├── otis-campbell/
│   ├── gomer-pyle/
│   ├── goober-pyle/
│   ├── helen-crump/
│   ├── clara-edwards/
│   ├── howard-sprague/
│   ├── ernest-t-bass/
│   ├── the-darlings/
│   ├── thelma-lou/              #   Barney's steady girl
│   ├── juanita/                 #   The voice on the phone (never seen)
│   └── mayor-stoner/            #   Title without authority
├── main-street/                 # The town's social spine
│   ├── courthouse/              #   Sheriff's office + jail
│   ├── floyds-barbershop/       #   The real nerve center
│   ├── wally-filling-station/   #   Gas and gossip
│   ├── walkers-drugstore/       #   Soda fountain
│   ├── weavers-dept-store/      #   Dry goods
│   ├── bluebird-diner/          #   Where everyone eats
│   └── mayberry-bank/           #   Where everyone worries
├── taylor-house/                # Home base
│   ├── front-porch/             #   Where the real life happens
│   ├── living-room/
│   ├── kitchen/
│   └── opies-room/
├── myers-lake/                  # Escape and reflection
│   └── fishing-hole/            #   Andy and Opie's spot
├── church/                      # Community anchor
├── schoolhouse/                 # Helen Crump's domain
└── mt-pilot/                   # The "big city" next door
```

## How Delegation Works Here

Every room inherits from its parent directory. `WORLD.yml` sets the defaults for all of Mayberry:

- **Era:** 1960s
- **Tone:** Gentle humor
- **Language:** Clean ("Gol-ly" is as strong as it gets)
- **Governance:** Community consensus, Andy as steward

A room deep in the tree — say `main-street/courthouse/jail-cell/` — inherits all of these unless it explicitly overrides them. The delegation chain:

```
jail-cell → courthouse → main-street → Mayberry (WORLD.yml)
```

This is prototype-based inheritance from the Self language, applied to a filesystem. David Ungar and Randy Smith (1987) would recognize it immediately.

## Key Dynamics

| Dynamic | How It Works | Where It Lives |
|---------|-------------|----------------|
| **Town gossip** | Information spoken at Floyd's propagates outward | `floyds-barbershop/ROOM.yml` → `ambient.gossip_flow` |
| **Andy's governance** | Conflicts resolve through empathy, not authority | `characters/andy-taylor/CHARACTER.yml` |
| **Otis's routine** | Self-check-in/check-out from the jail cell | `courthouse/jail-cell/ROOM.yml` |
| **Front porch life** | Evening conversations drive the show's heart | `taylor-house/front-porch/ROOM.yml` |
| **The lake escape** | When Andy needs to think, he goes fishing | `myers-lake/fishing-hole/ROOM.yml` |

## Characters Home vs. Location

Character files live permanently in `characters/`. They never move. Instead, each CHARACTER.yml has a `location:` property that updates as they move through the world:

```yaml
# The file stays at characters/barney-fife/CHARACTER.yml
# But the location property changes:
location: main-street/courthouse    # Morning
location: main-street/floyds-barbershop  # Midday gossip
location: taylor-house/front-porch  # Evening
```

This keeps version control clean — you see property changes, not confusing file moves.
