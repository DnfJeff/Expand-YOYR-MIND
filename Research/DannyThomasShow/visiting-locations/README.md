# Visiting Locations

**The dynamic expansion zone.**

The Danny Thomas Show's secret weapon is visitors who bring their own worlds with them. When Uncle Tonoose arrives from Lebanon, he carries an entire culture. When an old friend calls from Chicago, that city briefly enters the universe. When Danny travels for a gig in Miami, a new location spawns.

This directory exists for those **ephemeral locations** — places that matter for one episode or one story arc and then fade back to potential.

## How This Works in Practice

In MOOLLM terms, `visiting-locations/` is a **Tardis directory**. It starts nearly empty and grows organically:

```
visiting-locations/
├── README.md           # This file (permanent)
├── miami-gig/          # Created when Danny books a show
│   ├── ROOM.yml
│   └── CARD.yml
├── tonoose-village/    # Created when storyline visits Lebanon  
│   ├── ROOM.yml
│   └── CARD.yml
└── chicago-friend/     # Created for a visiting friend's home
    └── ROOM.yml
```

Each directory is created on demand, used for its story, and remains in the tree as narrative history. The folder structure becomes a **record of everywhere the story has been**.

## Contrast with Mayberry

Mayberry doesn't need this. Mayberry's locations are fixed because the town is fixed. The drama comes from the same people in the same places having new interactions.

Danny's world needs this because the drama comes from *new elements* entering a fixed space. The apartment is the constant. The visitors are the variables. And sometimes the visitors bring their own rooms.

## The Visitor Pattern

```
New visitor arrives →
  Do they bring a location? →
    Yes: Create directory in visiting-locations/
    No: They operate within existing spaces
  Story plays out →
  Visitor departs →
  Directory remains as history
```

This is how a world grows without being pre-planned. The structure itself records the narrative.
