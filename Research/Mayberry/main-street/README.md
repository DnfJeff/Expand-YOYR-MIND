# Main Street

The spine of Mayberry. Everything happens here or connects through here.

Main Street is walkable — you can stroll from the courthouse to Floyd's to Wally's to the drugstore in ten minutes. Everyone does, multiple times a day. This isn't a street; it's a social circulatory system.

## Locations

| Place | Function | Social Role |
|-------|----------|-------------|
| [Courthouse](courthouse/) | Law enforcement, county records | Andy's base, Otis's hotel |
| [Floyd's Barbershop](floyds-barbershop/) | Haircuts | Town nerve center, gossip hub |
| [Wally's Filling Station](wally-filling-station/) | Gas, auto repair | Gomer & Goober's domain |
| [Walker's Drugstore](walkers-drugstore/) | Pharmacy, soda fountain | Teen hangout, casual social |
| [Weaver's Department Store](weavers-dept-store/) | Dry goods, clothing | Commercial backbone |
| [Bluebird Diner](bluebird-diner/) | Food, coffee | Communal table |
| [Mayberry Bank](mayberry-bank/) | Banking | Anxiety generator |

## Information Flow

Gossip enters the system at Floyd's and propagates outward:

```
Floyd's (origin) → Drugstore (15 min) → Diner (30 min) → Porches (evening)
                                                            ↓
                                                    Accuracy: ~40% → ~25% → ~15%
```

By the time a rumor reaches the front porches, it has mutated beyond recognition. This is built into the room properties — `gossip_flow`, `gossip_delay`, and `gossip_accuracy` values cascade and degrade.
