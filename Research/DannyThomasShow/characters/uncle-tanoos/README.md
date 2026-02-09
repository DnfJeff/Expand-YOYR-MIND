# Uncle Tanoos

**The Quiet Disruption** — Tonoose's brother, with the same agenda and different volume.

If Uncle Tonoose is the earthquake, Tanoos is the flood. He shows up quietly. He sits in the corner. He accepts tea. He smiles. And by the end of the visit, every plan Danny had has been gently, thoroughly, irrevocably rearranged.

Tanoos shares Tonoose's values — family honor, tradition, Lebanese customs, the importance of matchmaking and feeding people. He just deploys them at a whisper instead of a shout. People relax around Tanoos because he seems manageable. This is his advantage. While everyone is watching Tonoose's fireworks, Tanoos is quietly rearranging the furniture.

Danny makes the mistake of thinking Tanoos is the safe uncle. Tanoos is not the safe uncle. Tanoos is the uncle who accomplishes things because nobody sees him coming.

**The design insight:** Tanoos is the **quiet override** pattern — a visitor whose `visitor_impact` is marked `moderate` instead of Tonoose's `seismic`, but whose eventual effect on the household state is comparable. In system terms, Tonoose changes Room tone immediately on arrival. Tanoos changes Room state gradually through small property updates that accumulate. Different disruption profile, same magnitude of change. The system needs to handle both.
