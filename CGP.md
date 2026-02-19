# Grimoire: The Soulbound Legacy — Core Game Pillars

> Every feature, mechanic, asset, and line of code must serve at least one pillar.
> If it serves none — **cut it.** No exceptions.

---

## The Pillars

### I. YOUR BOOK, YOUR SOUL

> *The Grimoire is not a tool. It is you.*

The player's Grimoire is procedurally generated, permanently soulbound, and completely unique. No two players will ever hold the same book. It is not collected, purchased, or traded — it is received, like a birthright. The Grimoire is the protagonist. The player is its vessel.

**This pillar says YES to:**
- Seed-based generation that guarantees uniqueness
- True Names, lore, visual identity tied to the seed
- Cosmetic corruption that tells the Grimoire's history
- The Grimoire-as-menu — the book IS the interface

**This pillar says NO to:**
- Card trading between players
- Deck-building or card shopping
- Resetting or re-rolling a Grimoire
- Any system that makes Grimoires feel interchangeable

**The test:** *"Does this feature make the player's Grimoire feel more personal and irreplaceable?"*

---

### II. CHOICES SCAR

> *Every decision writes in permanent ink.*

Moral choices, card evolutions, and alignment shifts are irreversible. The game does not have an undo button. Choosing the Radiant path for Spark Bolt means Venomous Bolt and Chain Bolt are gone — forever. Sparing an enemy nudges the Grimoire's soul toward light, permanently. The weight of the game comes from consequence, not difficulty.

**This pillar says YES to:**
- Permanent card evolution (3 paths, pick 1, no reversal)
- Three-axis alignment that never resets
- Moral choice events with lasting mechanical impact
- Visual corruption that accumulates and never cleans
- Extraction stakes — die in a chapter, lose unbound pages

**This pillar says NO to:**
- Respec systems or alignment resets
- Undo buttons on evolution choices
- Temporary moral effects that fade over time
- Save-scumming protection bypasses
- Any system that removes the cost of a decision

**The test:** *"Will the player remember making this choice an hour later?"*

---

### III. MASTERY OVER MONEY

> *Power is earned at the table, never at the store.*

A card becomes powerful because the player used it 100 times, not because they bought a rare pack. The Grimoire levels up through play, not through premium currency. A Bronze-mastery common card in the hands of a skilled player outperforms a Legendary card used poorly. Skill and time invested are the only currencies that buy power.

**This pillar says YES to:**
- Individual card XP from battle usage
- Mastery tiers that reward repeated play with stat bonuses
- Grimoire leveling through encounters, not purchases
- The "perfect play" XP bonus for optimal card use
- Inscription slots unlocked by level, not by payment

**This pillar says NO to:**
- Card packs, loot boxes, or gacha mechanics
- Premium currency that accelerates progression
- XP boosters or mastery skip tokens
- Pay-to-unlock card evolutions or inscriptions
- Any monetization that shortcuts the mastery journey

**The test:** *"Can a player with more money have a stronger Grimoire than a player with more hours?"* If yes — kill the feature.

---

### IV. EVERY HAND IS A PUZZLE

> *No turn is autopilot. Every draw demands a decision.*

Combat is a tactical puzzle where the player reads their hand, reads the enemy's telegraphed intent, and makes meaningful choices with limited mana. The Alignment Attunement system forces a commitment each turn. Card synergies emerge from the specific seed, not from a solved meta. The player should feel clever when they win and educated when they lose.

**This pillar says YES to:**
- Visible enemy intent (no hidden information on AI side)
- Mana as a constraining resource (can't play everything)
- Alignment Attunement as a per-turn strategic commitment
- Seed-driven decks that create unique puzzle spaces per player
- Escalating combat tension (enrage timers prevent stalling)

**This pillar says NO to:**
- Auto-play or "skip combat" options
- Optimal solved strategies that work for every hand
- Infinite mana or unlimited card plays per turn
- Enemies with random, untelegraphed behavior
- Combat that can be won by spamming the strongest card

**The test:** *"Did the player make at least 3 meaningful decisions this turn?"*

---

### V. THE BOOK BREATHES

> *Even when nothing is happening, something is alive.*

The Grimoire is not a static data container. It flutters its pages in idle. Its aura pulses with alignment energy. Its cover corrodes or blooms based on the player's history. The candles flicker. The library hums. The sound of a page turn carries a whisper underneath. The game world is never dead — it is always quietly, subtly alive.

**This pillar says YES to:**
- Idle animations on the Grimoire (page flutter, aura pulse, sigil rotation)
- Ambient soundscape (candle crackle, distant rustling, wood creaking)
- Dynamic visual corruption based on alignment state
- The Grimoire's tonal "voice" (hum that shifts with HP and mood)
- Particle effects that persist even outside combat (aura, dust motes)

**This pillar says NO to:**
- Static menu screens with no ambient life
- Silent idle states
- Visual corruption that only updates on load (must be real-time)
- Flat backgrounds with no parallax or atmospheric detail
- Any screen where the world feels paused or dead

**The test:** *"If the player sets the controller down for 30 seconds, does the screen still feel alive?"*

---

## The Razor

When evaluating any proposed feature, mechanic, art asset, sound, or system:

```
┌──────────────────────────────────────────────────┐
│         DOES THIS FEATURE SERVE A PILLAR?         │
│                                                  │
│  I.   Your Book, Your Soul      → Personal?      │
│  II.  Choices Scar              → Permanent?      │
│  III. Mastery Over Money        → Earned?          │
│  IV.  Every Hand Is A Puzzle    → Tactical?        │
│  V.   The Book Breathes         → Alive?           │
│                                                  │
│  Serves 2+ pillars  →  STRONG YES. Build it.     │
│  Serves 1 pillar    →  Probably yes. Justify it.  │
│  Serves 0 pillars   →  CUT IT. No debate.         │
│  Contradicts a pillar → KILL IT. It's poison.      │
└──────────────────────────────────────────────────┘
```

---

## Pillar Validation: Existing Systems

| System | I | II | III | IV | V | Score |
|--------|:-:|:--:|:---:|:--:|:-:|:-----:|
| Seed-based Grimoire generation | **✓** | | | | **✓** | 2 |
| Card mastery XP (0–100) | **✓** | | **✓** | | | 2 |
| Permanent 3-path evolution | **✓** | **✓** | **✓** | | | 3 |
| Three-axis alignment | **✓** | **✓** | | | | 2 |
| Moral choice events | | **✓** | | **✓** | | 2 |
| Alignment Attunement in combat | | | | **✓** | | 1 |
| Visible enemy intent | | | | **✓** | | 1 |
| Mana economy per turn | | | | **✓** | | 1 |
| Lost Pages extraction risk | | **✓** | **✓** | | | 2 |
| Grimoire visual corruption | **✓** | **✓** | | | **✓** | 3 |
| Grimoire idle animations | **✓** | | | | **✓** | 2 |
| Grimoire-as-menu UI | **✓** | | | | **✓** | 2 |
| Dynamic layered music | | | | | **✓** | 1 |
| No-deck-building rule | **✓** | | **✓** | | | 2 |
| Inscription passive buffs | | | **✓** | **✓** | | 2 |
| Ultimate Spell at Level 20 | **✓** | **✓** | **✓** | | | 3 |

**Every existing system serves at least 1 pillar. Three systems score 3/5. Zero systems score 0. The architecture is pillar-aligned.**

---

*Pin this document to the wall. Read it before every sprint. If you can't point to a pillar, you're building the wrong thing.*
