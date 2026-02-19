# Grimoire: The Soulbound Legacy — Game Design Document

> **Version:** 1.0
> **Last Updated:** 2026-02-18
> **Engine:** Godot 4.x (4.3+) | **Language:** GDScript (strict typing)
> **Platform:** Desktop (Windows / Linux / Mac) — Mobile as stretch goal
> **Genre:** Roguelite Card Game / RPG Hybrid
> **Inspirations:** *Black Clover* (anime), *KeyForge* (card game), *Slay the Spire*, *Inscryption*

---

## Table of Contents

1. [Core Concept](#1-core-concept)
2. [Gameplay Mechanics](#2-gameplay-mechanics)
3. [Game Loop](#3-game-loop)
4. [Progression System](#4-progression-system)
5. [Economy](#5-economy)
6. [Characters](#6-characters)
7. [Level Design Philosophy](#7-level-design-philosophy)
8. [UI Flow](#8-ui-flow)
9. [Monetization](#9-monetization)
10. [Art Direction](#10-art-direction)
11. [Technical Architecture](#11-technical-architecture)
12. [Scope & Risk Management](#12-scope--risk-management)
13. [Verification Plan](#13-verification-plan)
14. [Inspiration Sources](#14-inspiration-sources)

---

## 1. Core Concept

### 1.1 Elevator Pitch

A card-game RPG where **the deck chooses YOU**. Players receive a procedurally generated **Grimoire** — a soulbound, living spellbook — that evolves based on moral choices, card mastery, and combat style. No two players will ever have the same book.

### 1.2 Core Fantasy

You are not collecting cards. You are nurturing a living artifact. **The Grimoire is the protagonist; the player is its vessel.**

In *Black Clover*, every mage receives a grimoire at age 15 — a book bonded to their soul that grows as they grow. In *KeyForge*, every deck is algorithmically unique and cannot be modified — you discover its strengths rather than engineering them. **Grimoire: The Soulbound Legacy** fuses both ideas: your Grimoire is generated once, bonded permanently, and evolves through the way you play — not through a store.

### 1.3 The Hook — Why Is This Fun?

| Pillar | Why It's Fun |
|--------|-------------|
| **Discovery** | Your Grimoire is a mystery box. You discover its personality by playing it, not by reading a wiki. Every card interaction teaches you something new about what your book *wants to be*. |
| **Ownership** | No one else in the world has your Grimoire. Your "Vexithorn" is yours alone — its name, its look, its evolved spells, its alignment scars. This is *your* story. |
| **Moral Weight** | Choices matter permanently. Spare an enemy and your healing spells grow. Sacrifice allies and your curses deepen. The Grimoire *remembers*. |
| **Mastery Curve** | Cards reward repeated use. A common "Spark Bolt" you've used 100 times becomes a devastating "Chain Bolt" that no store-bought card could replicate. Skill is rewarded, not spending. |

### 1.4 Unique Selling Points

- **No deck-building** — the Grimoire IS the deck, generated once from a seed, soulbound permanently (inspired by KeyForge's Unique Deck Game philosophy)
- **Cards evolve** along three moral alignment branches (Radiant / Vile / Primal) — the same base card becomes entirely different spells for different players
- **The Grimoire levels up** as an RPG character — gaining deck slots, passive inscriptions, and a unique ultimate spell (inspired by Black Clover's growing grimoires)
- **PvE moral choices** permanently shift alignment, altering available card evolutions
- **No pay-to-win** — power comes from mastery hours, not purchases

### 1.5 Target Audience

Players who enjoy roguelike deckbuilders (*Slay the Spire*, *Inscryption*) and RPG progression (*Black Clover*, *Persona*) but want a more personal, permanent relationship with their deck. Secondary audience: competitive card game players tired of the pay-to-win meta who want skill-based differentiation.

---

## 2. Gameplay Mechanics

### 2.1 Grimoire Generation (The "Unique Deck" System)

Generated **once per account** from a **master seed** (64-bit integer). The seed drives ALL procedural aspects — just as every KeyForge Archon deck is algorithmically unique and unmodifiable, every Grimoire is one-of-a-kind.

| Attribute | Seed-Driven? | Details |
|-----------|:---:|---------|
| Cover material | Yes | Leather, Bone, Crystal, Cloth, Metal |
| Binding style | Yes | Chain, Ribbon, Vine, Clasp, Rune Thread |
| Central sigil | Yes | Parameterized geometric generator (sides, rotation, inner ratio) |
| Aura color | Yes | Derived from starting affinity |
| Starting affinity | Yes | +10 nudge on one alignment axis (not a hard lock) |
| Initial 20 cards | Yes | Rarity-weighted shuffle from master card DB, guaranteeing minimum 2 cards per type |
| Lore paragraph | Yes | Templated text fragments keyed to affinity/rarity |

**True Name:** The seed is displayed to the player as a pronounceable word (e.g., "Vexithorn", "Ithenwick") — echoing how grimoires in *Black Clover* are deeply personal artifacts tied to the mage's soul.

**Soulbound Rule:** A Grimoire cannot be dismantled. Cards from different Grimoires never mix. Players may own multiple Grimoires (but each is a separate progression track). Like in *Black Clover*, a grimoire dies with its owner — if a save is deleted, the Grimoire is gone forever.

**Seed Validation:** Before a seed is accepted, the system simulates 1,000 sample hands to ensure no seed produces an unplayable deck. Seeds must guarantee at least 2 cards of each type (Attack, Defense, Support).

### 2.2 Combat System (Turn-Based Card Battles)

Inspired by the mana-driven magic of *Black Clover* and the House-selection mechanic of *KeyForge*:

**Core Rules:**
- Draw **5 cards** per turn from your Grimoire
- Start with **3 mana** per turn (cap grows to 10 with progression)
- Each card has a **mana cost** — play as many cards as your mana allows
- Enemies display **visible intent** (attack, defend, buff) so the player can strategize — no hidden information on the AI side

**Alignment Attunement (Inspired by KeyForge Houses):**
At the start of each turn, the player may declare an **Alignment Attunement** (Radiant, Vile, or Primal). Cards matching the declared alignment cost **1 less mana** that turn. This forces the player to read their hand and commit to a strategy each turn, similar to how KeyForge players declare a House and can only use cards of that House.

Unlike KeyForge, non-attuned cards are still playable at full cost — the system rewards focus without punishing flexibility.

**Card Types:**

| Type | Role | Examples |
|------|------|---------|
| **Attack** | Deal damage to enemies | Spark Bolt (4 dmg), Shadow Strike (6 dmg, costs 1 HP) |
| **Defense** | Block incoming damage, generate shields | Holy Shield (7 block), Flame Ward (5 block + retaliation) |
| **Support** | Heal, buff, draw, manipulate | Mending Light (4 HP restore), Wild Growth (3 block + draw 1) |
| **Special** | Unique effects, alignment-locked | Ultimate Spells, Lost Page abilities |

**Damage Resolution:**
1. Player plays cards during their turn
2. Enemy intent resolves at end of enemy turn
3. Block is consumed before HP damage
4. Status effects (poison, burn, regen) tick at turn start
5. Battle ends when either side reaches 0 HP

**Alignment Clash Bonus:** When facing an enemy of the opposing alignment (e.g., Radiant player vs. Vile enemy), both sides deal **+10% damage** — reflecting the narrative tension of opposing magical philosophies clashing, much like how in *Black Clover*, opposing magic attributes create explosive confrontations.

### 2.3 Alignment System (The Three-Axis Moral Compass)

**Three independent axes (0–100 each), not a single slider.** This is critical — players are never "losing" one alignment when they gain another. They're building a unique identity.

| Alignment | Theme | Spell Philosophy | Visual Language |
|-----------|-------|-------------------|-----------------|
| **Radiant** (Order) | Light, Duty, Protection | Healing, shielding, purification, group buffs | Gold, white, clean geometric sigils, soft glow |
| **Vile** (Chaos) | Darkness, Ambition, Sacrifice | DOT, debuffs, life-steal, self-harm for power | Purple, green, jagged edges, thorny sigils, dripping effects |
| **Primal** (Balance) | Nature, Instinct, Adaptation | Multi-hit, chain effects, transformation, tempo | Brown, teal, natural curves, leaf/root sigils, earthy particles |

**Dominant alignment** = highest score. Determines visual theme and available inscription bonuses.

**Alignment Shift Sources:**

| Source | Shift Amount | Frequency |
|--------|:---:|-----------|
| PvE moral choices | +3 to +5 | 1–2 per Chapter |
| Card usage in battle (alignment-matching) | +1 | Per battle |
| Evolution choices | +10 | Per card evolution |

**Conflicted State:** If the top two alignment scores are within 5 of each other, the Grimoire enters a **Conflicted State** — unlocking hybrid cards but weakening pure-alignment bonuses. This creates a genuine strategic choice: commit to a path for power, or stay balanced for versatility.

**Visual Corruption:** Alignment shifts alter the Grimoire's appearance dynamically. A Radiant book played aggressively will show gold leaf peeling, pages darkening, spell text twisting. A Vile book used for healing will sprout white flowers through the thorns. The Grimoire *shows its history*.

### 2.4 Card Mastery & Evolution

Every card tracks **individual XP** (0–100). This is the core "relationship" mechanic — you grow with your cards through repeated use, just as Black Clover mages unlock new spell pages through experience and emotional growth.

| Milestone | XP | Effect |
|-----------|:--:|--------|
| Unmastered | 0 | Base stats |
| Bronze | 25 | +1 to base value |
| Silver | 50 | +2 to base value |
| Gold | 75 | +3 to base value |
| **Evolved** | **100** | **Choose 1 of 3 alignment evolutions (permanent)** |

**XP Gain:**

| Action | XP Gained |
|--------|:---------:|
| Standard use in battle | +1 |
| Card scores a kill or triggers a combo | +2 |
| "Perfect play" (optimal use, e.g., exact lethal, full block absorption) | +5 |

**Evolution is Permanent.** At 100 XP, the player chooses one of three alignment-themed evolutions. The original card is gone forever. This mirrors *Black Clover*'s grimoire growth — spells evolve, they don't revert.

**Evolution Example — "Spark Bolt" (Deal 4 Damage):**
- **Radiant → "Purifying Bolt":** Deal 3 damage, remove 1 debuff from self
- **Vile → "Venomous Bolt":** Deal 3 damage, apply 2 poison
- **Primal → "Chain Bolt":** Deal 2 damage to target + 2 to adjacent enemies

Evolution shifts the Grimoire's alignment **+10** toward the chosen path, creating a feedback loop: the more you evolve toward one alignment, the more naturally your future evolutions lean that way.

---

## 3. Game Loop

### 3.1 Macro Loop (Session-to-Session Progression)

```
┌─────────────────────────────────────────────────────┐
│  OPEN GRIMOIRE (Main Menu IS the Grimoire)          │
│    ↓                                                │
│  CHOOSE MODE                                        │
│    ├── PvE: The Archives (Campaign / Roguelike)     │
│    └── PvP: Clash of Tomes (Post-MVP)               │
│    ↓                                                │
│  PLAY 1–3 ENCOUNTERS (15–30 min session)            │
│    ↓                                                │
│  POST-SESSION REVIEW                                │
│    ├── Card XP gains → evolve ready cards            │
│    ├── Grimoire level-up → select inscriptions       │
│    ├── Alignment shift summary                       │
│    └── New Lost Pages acquired?                      │
│    ↓                                                │
│  CLOSE GRIMOIRE                                     │
└─────────────────────────────────────────────────────┘
```

**Target Session Length:** 15–30 minutes. Designed for "one more run" engagement without requiring multi-hour commitments.

### 3.2 Micro Loop (Single PvE Chapter — "The Archives")

Roguelike-structured campaign with procedurally generated **Chapters** (5–7 encounters each):

```
Chapter Start
  ├── Combat Encounter (×3–4)
  │     └── Turn-based card battles, enemy intent visible
  ├── Moral Choice Event (×1–2)
  │     └── "A wounded enemy begs for mercy."
  │           → Spare (Radiant +3)
  │           → Execute (Vile +3)
  │           → Absorb their power (Primal +3)
  ├── Treasure / Rest Node (×1)
  │     └── Find Lost Pages (pick 1 of 3 if slot available)
  │     └── OR rest to heal and gain small XP boost
  └── Chapter Boss
        └── Alignment-themed boss
        └── Opposing alignment = Alignment Clash (+10% damage)
```

**Extraction Rule:** Found Lost Pages are only permanently bound to your Grimoire if you **survive the entire Chapter**. Dying means you keep XP gained but lose unbound pages — creating genuine tension in the final encounters. This mirrors roguelike extraction mechanics: the reward is only real if you can carry it home.

### 3.3 Combat Loop (Single Battle — 3–8 Turns)

```
TURN START
  ├── Status effects tick (poison, regen, burn)
  ├── Draw 5 cards from Grimoire
  ├── Gain mana (3 base, scaling with progression)
  └── Enemy telegraphs intent
       ↓
PLAYER ACTION PHASE
  ├── [Optional] Declare Alignment Attunement (-1 mana to matching cards)
  ├── Play cards (spend mana, resolve effects)
  └── End turn when satisfied or out of mana
       ↓
ENEMY ACTION PHASE
  ├── Enemy resolves telegraphed intent
  ├── Block absorbs damage first
  └── Check for defeat (either side)
       ↓
TURN END
  ├── Discard remaining hand
  ├── Card XP awarded for cards played
  └── Next turn or battle end
```

### 3.4 PvP Loop: Clash of Tomes (Post-MVP)

1v1 card battles (async or real-time):
- **Matchmaking:** Grimoire Level + hidden MMR
- **Wager Matches:** Bet Gold or XP. Losing does NOT lose levels (XP floor at current level minimum)
- **Alignment Clash:** Opposing alignments = both get increased mana regen + stronger alignment effects. Mirror matches get no bonus.
- **The Archive (Leaderboard):** Global ranking, seasonal resets. Top Grimoires are immortalized; other players can "rent" copies (giving royalties to the original owner)

---

## 4. Progression System

### 4.1 Grimoire Leveling (The RPG Layer)

The Grimoire levels up independently of individual cards (Level 1–20). This is the macro progression — your Grimoire growing in power and capacity, just as *Black Clover* mages unlock new pages and abilities as their grimoire grows thicker.

| Level Range | Deck Size | Inscription Slots | Unlocks |
|:-----------:|:---------:|:-----------------:|---------|
| 1–2 | 20 | 0 | Starting experience |
| 3–5 | 20 | 1–2 | Inscription system unlocked |
| 6–10 | 25 | 2 | Lost Pages can be bound to Grimoire |
| 11–15 | 30 | 3 | Visual upgrades (Grimoire appearance evolves) |
| 16–19 | 35 | 4 | — |
| 20 | 40 | 4 | **Ultimate Spell generated** |

**XP Sources for Grimoire Level:**
- Completing PvE encounters
- Winning PvP matches (post-MVP)
- Completing full Chapters without dying (bonus XP)
- First evolution of each card (one-time bonus)

### 4.2 Inscriptions (Passive Buff System)

Inscriptions are **permanent passive buffs** slotted into the Grimoire. They are filtered by alignment — you can only equip inscriptions matching or close to your dominant alignment. This rewards commitment to a playstyle.

| Inscription | Alignment | Effect |
|-------------|-----------|--------|
| Radiant Ink | Radiant | Healing cards restore +1 HP |
| Blessed Binding | Radiant | Shield cards grant +1 block |
| Vile Script | Vile | Poison duration +1 turn |
| Shadow Weave | Vile | Life-steal effects increased by +1 |
| Primal Glyph | Primal | Multi-hit cards gain +1 hit |
| Wild Thread | Primal | Draw +1 card on first turn |

### 4.3 Lost Pages (Rare External Cards)

Lost Pages are rare cards found **only** in PvE dungeons — they are NOT part of the original seed generation. They represent forbidden knowledge, lost spells, and ancient magic bound into your Grimoire from external sources.

- Limited to `grimoire_level / 5` lost pages (max 4 at level 20)
- Must survive the Chapter to bind them permanently
- Often more powerful than seed cards but with higher mana costs or drawbacks
- Cannot be evolved — they are already in their final form

This mirrors *Black Clover*'s concept of forbidden or ancient magic that mages can discover in ruins and dungeons.

### 4.4 The Ultimate Spell (Level 20 Capstone)

At Level 20, the game generates a **completely unique card** based on:
- The Grimoire's original seed
- Current alignment state at the moment of reaching max level
- Most-used card types throughout the Grimoire's history

This card is the Grimoire's "signature move" — its identity crystallized into a single devastating spell. No two Ultimate Spells are the same. In *Black Clover* terms, this is the equivalent of a mage's most powerful, deeply personal spell — like Yami's "Death Thrust" or Asta's "Black Divider."

### 4.5 Progression Feel

```
Early Game (Lv 1–5):    "Learning my book"    — Discover card synergies, first evolutions
Mid Game (Lv 6–10):     "Growing together"    — Lost Pages add depth, alignment identity solidifies
Late Game (Lv 11–19):   "Mastering my path"   — Most cards evolved, inscriptions stacked, build is defined
Endgame (Lv 20):        "The Grimoire awakens" — Ultimate Spell, optimized deck, PvP-ready
```

---

## 5. Economy

### 5.1 Design Philosophy

**No premium currency. No card packs. No pay-to-win.**

The economy exists to provide meaningful resource management within runs, not to extract money. Power comes from **time invested and skill demonstrated**, not from purchases.

### 5.2 Currencies

| Currency | Earned By | Spent On |
|----------|-----------|----------|
| **Ink** (Primary) | PvE combat victories, Chapter completion | Inscription crafting, Grimoire cosmetics, rest node healing |
| **Aether** (Rare) | Chapter Boss kills, perfect Chapter runs, PvP wins | Re-rolling Lost Page offerings, unlocking new Chapter tiers, cosmetic Grimoire effects |
| **Star Marks** (Rank) | PvP seasonal performance (post-MVP) | Seasonal cosmetics, leaderboard entry, Grimoire title unlocks |

### 5.3 Resource Sinks

- **Inscription Crafting:** Spend Ink + alignment-specific materials dropped by enemies to create new inscriptions
- **Grimoire Cosmetics:** Alternate cover textures, aura effects, page edge gilding — purely visual
- **Chapter Tier Unlocks:** Higher-difficulty PvE chapters cost Aether to unlock but yield better Lost Pages and more XP
- **Rest Node Healing:** Spend Ink at rest nodes to restore HP between encounters (cheaper than potions, more expensive than nothing)

### 5.4 Economy Balance Goals

- A player should never feel *forced* to grind currency
- Ink income should always exceed Ink spending in a typical session (net positive)
- Aether is a "luxury" currency — nice to have, never required for progression
- No currency can buy power — only time, cosmetics, or convenience

---

## 6. Characters

### 6.1 The Player Character

The player is a **nameless Vessel** — a young mage who has received their Grimoire at the Grimoire Acceptance Ceremony (a direct reference to *Black Clover*'s ceremony at age 15). The Vessel has no preset personality; their character is defined entirely by their alignment choices and combat style.

**The Grimoire IS the character.** Its True Name, its appearance, its evolved spells — these are the player's identity. The Vessel is a lens through which the Grimoire acts.

### 6.2 Enemy Design Philosophy

Enemies are organized by alignment, creating natural "Alignment Clash" dynamics:

**Regular Enemies (per alignment):**

| Alignment | Enemy Archetype | Behavior |
|-----------|----------------|----------|
| Radiant | Paladins, Clerics, Light Constructs | Shield-heavy, heal allies, punish debuffs |
| Vile | Demons, Cursed Knights, Shadow Beasts | Apply poison/bleed, life-steal, sacrifice minions for power |
| Primal | Forest Spirits, Elementals, Shapeshifters | Multi-hit attacks, adapt to player strategy, transform mid-fight |

**Chapter Bosses:**
Each Chapter culminates in an alignment-themed boss. Bosses have unique mechanics that test the player's mastery:

- **Radiant Boss — "The Arbiter":** Massive shields that must be broken with sustained damage. Punishes defensive play by buffing its own attack when not damaged.
- **Vile Boss — "The Hollow Priest":** Drains player HP to heal itself. Rewards aggressive play but punishes recklessness with stacking debuffs.
- **Primal Boss — "The Rootmother":** Splits into copies. Rewards area damage and chain effects. Punishes single-target focus.

### 6.3 NPCs (Narrative Encounters)

Moral choice events feature recurring NPC archetypes:

| NPC | Role | Alignment Test |
|-----|------|---------------|
| **The Wounded Enemy** | Defeated foe begging for mercy | Spare (Radiant), Execute (Vile), Absorb power (Primal) |
| **The Merchant of Whispers** | Offers powerful cards at a cost | Pay fair price (Radiant), Steal (Vile), Barter with nature (Primal) |
| **The Sealed Door** | Ancient vault requiring sacrifice | Sacrifice HP (Vile), Sacrifice a card (Primal), Pray for opening (Radiant) |
| **The Lost Child** | Spirit trapped between worlds | Guide to light (Radiant), Bind as servant (Vile), Return to nature (Primal) |

### 6.4 Magic Knight Orders (Post-MVP Guild System)

Inspired by *Black Clover*'s Magic Knight Squads, players can join one of three Orders:

| Order | Alignment | Bonus |
|-------|-----------|-------|
| **The Golden Quill** | Radiant | Healing inscriptions are 20% more effective |
| **The Black Ink** | Vile | Poison and debuff cards gain +1 duration |
| **The Green Binding** | Primal | Multi-hit cards gain +1 hit in PvP |

Orders compete for seasonal rankings, mirroring the Star Festival ranking system from *Black Clover*.

---

## 7. Level Design Philosophy

### 7.1 The Archives (PvE World Structure)

The game world is a **magical archive** — an infinite library of grimoires, memories, and forgotten magic. Each "Chapter" is a wing of this archive, procedurally assembled from handcrafted encounter templates.

**Design Principles:**
1. **No backtracking.** Every Chapter is a forward path — the player never revisits completed nodes
2. **Visible branching.** The player can see upcoming nodes (combat / moral choice / treasure / boss) and choose their path
3. **Risk vs. reward.** Harder paths (more combats) yield more XP and better Lost Page offerings
4. **Alignment theming.** Each Chapter has a dominant alignment that affects enemy composition and moral choice themes

### 7.2 Chapter Structure (Node Map)

```
[START]
   ├── [COMBAT] ─── [COMBAT] ─── [MORAL CHOICE] ─── [COMBAT] ─── [BOSS]
   │
   └── [COMBAT] ─── [MORAL CHOICE] ─── [TREASURE/REST] ─── [COMBAT] ─── [BOSS]
```

- 5–7 nodes per Chapter
- Player chooses path at branching points
- Harder path = more encounters but better rewards
- Chapter boss is always the final node

### 7.3 Encounter Design Rules

1. **No encounter should last more than 8 turns.** If a battle drags, the enemy should become more aggressive (enrage mechanic)
2. **Every enemy must telegraph.** No hidden damage — the player always has information to make informed decisions
3. **Alignment variety per Chapter.** Each Chapter features enemies of at least 2 different alignments, ensuring the player faces both favorable and unfavorable matchups
4. **Escalating difficulty.** Combat encounters within a Chapter increase in difficulty. The first combat is always manageable; the pre-boss combat should test the player's limits

### 7.4 Difficulty Tiers

| Tier | Unlock Requirement | Enemy Scaling | Rewards |
|------|-------------------|---------------|---------|
| **Apprentice** | Default | Base stats | Standard Ink, common Lost Pages |
| **Knight** | Grimoire Level 5 | +25% HP/ATK | 1.5x Ink, uncommon Lost Pages |
| **Captain** | Grimoire Level 10 | +50% HP/ATK, new mechanics | 2x Ink, rare Lost Pages, Aether drops |
| **Wizard King** | Grimoire Level 15 | +100% HP/ATK, elite modifiers | 3x Ink, epic Lost Pages, cosmetic drops |

---

## 8. UI Flow

### 8.1 Design Philosophy

**The UI IS the Grimoire.** The main menu is not a traditional menu — it's the player's open Grimoire. Navigation happens by turning pages, tapping sigils, and interacting with the book itself. Every screen transition is a page turn.

### 8.2 Screen Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    GRIMOIRE (Main Hub)                       │
│                                                             │
│  [Cover Page]         → Tap to open                         │
│    ↓                                                        │
│  [Identity Page]      → True Name, Seed, Lore, Alignment    │
│    ↓ (turn page)                                            │
│  [Deck Pages]         → Browse cards, view mastery, evolve  │
│    ↓ (turn page)                                            │
│  [Inscription Page]   → Manage passive buffs                │
│    ↓ (turn page)                                            │
│  [Archives Portal]    → Enter PvE (choose Chapter)          │
│    ↓ (turn page)                                            │
│  [Clash Arena]        → Enter PvP (post-MVP)                │
│    ↓ (turn page)                                            │
│  [Grimoire Status]    → Level, XP bar, stats summary        │
└─────────────────────────────────────────────────────────────┘
```

### 8.3 Battle UI Layout

```
┌──────────────────────────────────────────────┐
│  ENEMY AREA                                  │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐      │
│  │ Enemy 1 │  │ Enemy 2 │  │ Enemy 3 │      │
│  │ HP: ██░ │  │ HP: ███ │  │ HP: █░░ │      │
│  │ Intent: │  │ Intent: │  │ Intent: │      │
│  │ 🗡 ATK 6│  │ 🛡 DEF  │  │ 💀 DBUF │      │
│  └─────────┘  └─────────┘  └─────────┘      │
│                                              │
│──────────────── PLAY AREA ───────────────────│
│  [Cards played this turn appear here]        │
│                                              │
│──────────────── PLAYER HUD ──────────────────│
│  HP: ████████░░  │  Mana: ◆◆◆◇◇  │ Block: 5│
│                                              │
│──────────────── HAND ────────────────────────│
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌────┐ │
│  │Spark │ │Holy  │ │Vine  │ │Mend  │ │Wild│ │
│  │Bolt  │ │Shield│ │Lash  │ │Light │ │Grwt│ │
│  │⚡ 1  │ │🛡 2  │ │⚡ 2  │ │💚 1  │ │💚 1│ │
│  └──────┘ └──────┘ └──────┘ └──────┘ └────┘ │
│                                              │
│  [ATTUNE: Radiant | Vile | Primal]  [END]    │
└──────────────────────────────────────────────┘
```

### 8.4 Card Detail View

When a card is long-pressed / right-clicked:

```
┌──────────────────────────────┐
│  ★★☆☆☆  UNCOMMON             │
│                              │
│  SPARK BOLT                  │
│  ───────────────             │
│  [Card Illustration]         │
│                              │
│  "A crackling bolt of        │
│   raw mana."                 │
│                              │
│  Type: ATTACK                │
│  Alignment: PRIMAL           │
│  Mana Cost: 1                │
│  Damage: 4 (+2 mastery)      │
│  Target: Single Enemy        │
│                              │
│  MASTERY: ██████████░░ 75/100│
│  Tier: GOLD (+3)             │
│                              │
│  EVOLUTION PATHS:            │
│  [Radiant] Purifying Bolt    │
│  [Vile] Venomous Bolt        │
│  [Primal] Chain Bolt         │
└──────────────────────────────┘
```

### 8.5 Evolution Choice Screen

```
┌──────────────────────────────────────────────────────┐
│  YOUR CARD HAS REACHED MASTERY                       │
│  Choose an evolution path. This choice is PERMANENT.  │
│                                                      │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐  │
│  │  PURIFYING   │ │  VENOMOUS    │ │  CHAIN       │  │
│  │  BOLT        │ │  BOLT        │ │  BOLT        │  │
│  │              │ │              │ │              │  │
│  │  3 dmg       │ │  3 dmg       │ │  2 dmg ×2    │  │
│  │  Remove 1    │ │  Apply 2     │ │  (target +   │  │
│  │  debuff      │ │  poison      │ │   adjacent)  │  │
│  │              │ │              │ │              │  │
│  │  Radiant +10 │ │  Vile +10    │ │  Primal +10  │  │
│  │  [CHOOSE]    │ │  [CHOOSE]    │ │  [CHOOSE]    │  │
│  └──────────────┘ └──────────────┘ └──────────────┘  │
└──────────────────────────────────────────────────────┘
```

---

## 9. Monetization

### 9.1 Model: Premium Game + Cosmetic DLC

**Base Game:** One-time purchase (target: $14.99–$19.99). Includes full PvE campaign, all card content, unlimited Grimoire generation, and all gameplay systems.

**No loot boxes. No card packs. No gacha. No pay-to-win.**

### 9.2 Revenue Streams

| Stream | Type | Examples |
|--------|------|---------|
| **Base Game** | One-time purchase | Full game access |
| **Cosmetic Grimoire Skins** | Optional DLC packs | Alternate cover materials (Obsidian, Dragonscale, Starweave), animated auras, custom sigil sets |
| **Chapter Packs** | Content DLC | New PvE Chapter tiers with unique themes, enemies, and Lost Pages (gameplay content, not power) |
| **Seasonal Battle Pass** (Post-MVP) | Time-limited cosmetic track | PvP seasons with cosmetic rewards — frames, titles, Grimoire effects. Free track included. |

### 9.3 What Money Can NEVER Buy

- Cards or card upgrades
- XP boosts or mastery acceleration
- Alignment shifts or resets
- Inscriptions or inscription materials
- Any gameplay advantage in PvP
- Additional deck slots beyond what leveling provides

### 9.4 Monetization Philosophy

The Grimoire's value comes from the time spent with it. If a player could buy power, the soulbound fantasy is broken — the book would just be a wallet, not a companion. Every purchased item must be **purely cosmetic** or **content-additive** (new things to do, not better ways to win).

---

## 10. Art Direction

### 10.1 Visual Style

**Dark fantasy with illuminated manuscript influences.** Think medieval codices crossed with anime energy effects — parchment and gold leaf meeting crackling magical auras.

### 10.2 Card Visuals

Cards look like **pages torn from an ancient book:**
- Parchment texture background
- Ink-style illustrations (not photorealistic)
- Gilded borders that change color based on alignment
- Mastery tier indicated by border complexity (Unmastered = plain, Gold = ornate)

### 10.3 Grimoire Visuals

The Grimoire is the primary visual identity and must feel **handcrafted and alive:**
- Idle animations: pages fluttering, aura pulsing, sigil slowly rotating
- Alignment corruption: visual wear-and-tear that tells the Grimoire's story
- Cover material has distinct texture and lighting response
- Binding style affects how the book opens/closes

### 10.4 Alignment Visual Language

| Element | Radiant | Vile | Primal |
|---------|---------|------|--------|
| Colors | Gold, white, warm ivory | Purple, sickly green, deep crimson | Brown, teal, amber |
| Sigil style | Clean geometry, circles, stars | Jagged, organic, thorny, asymmetric | Natural curves, spirals, leaf patterns |
| Particle effects | Soft glow, light motes, halos | Dripping shadow, green fire, smoke | Falling leaves, root tendrils, fireflies |
| Card borders | Polished gold, smooth | Corroded iron, barbed wire | Woven vines, bark texture |
| Audio tone | Choral hums, bells | Dissonant whispers, deep rumbles | Wind, running water, animal calls |

---

## 11. Technical Architecture

### 11.1 Project Folder Structure

```
res://
  project.godot
  GDD.md                          # This document
  autoload/
    global_enums.gd               # All shared enums
    game_manager.gd               # Session state, save/load
  scripts/
    data/
      card_resource.gd            # extends Resource
      grimoire_resource.gd        # extends Resource
      inscription_resource.gd     # extends Resource
      enemy_resource.gd           # extends Resource
    systems/
      evolution_manager.gd        # Card evolution logic
      alignment_manager.gd        # Alignment shift calculations
      grimoire_generator.gd       # Seed-based generation
      mastery_tracker.gd          # Card XP tracking
      combat_manager.gd           # Battle state machine
    ui/                           # UI scripts (Phase 2+)
  resources/
    cards/
      base/                       # Base CardResource .tres files
      evolved/
        radiant/
        vile/
        primal/
    grimoires/                    # Saved GrimoireResource .tres files
    inscriptions/                 # InscriptionResource .tres files
    enemies/                      # EnemyResource .tres files
  scenes/                         # Scene files (Phase 2+)
  assets/
    art/
    audio/
    fonts/
    shaders/
```

### 11.2 Data Layer Principles

- All game data lives in `Resource` subclasses, not in nodes
- Enums centralized in a single autoload (`global_enums.gd`) for `@export` hints across all resources
- Managers (`EvolutionManager`, `AlignmentManager`, etc.) are pure-logic `RefCounted` scripts — no Node dependencies. They take Resources as input and return modified Resources
- **Save/Load:** `GrimoireResource` IS the save file. `ResourceSaver.save()` to save, `ResourceLoader.load()` to load
- Minimal autoloads: only `GlobalEnums` and `GameManager`

### 11.3 Key Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Resource-based data | Godot's native serialization; `.tres` files are human-readable, editor-inspectable, and version-control friendly |
| `RefCounted` managers | No scene tree dependency means systems are testable in isolation |
| Seed-based generation | Deterministic — same seed always produces same Grimoire. Enables sharing seeds, bug reproduction, and fair PvP |
| Three separate alignment ints | Simpler than a vector, easier to serialize, clearer in the inspector |
| `@tool` on Resources | Allows editor preview of enum dropdowns and resource references |

---

## 12. Scope & Risk Management

### 12.1 MVP Definition (Single Player Only)

- Grimoire generation from seed (visual placeholders OK)
- 30 base cards, at least 10 with full 3-path evolution trees
- Card mastery XP tracking and evolution
- Alignment tracking responding to evolution choices and moral events
- 3 handcrafted PvE combat encounters
- 1 moral choice event
- Grimoire leveling from 1–5
- Basic battle UI (hand, play area, enemy)

### 12.2 Explicitly Post-MVP

- PvP (Clash of Tomes)
- Leaderboards and seasonal rankings
- Lost Pages system
- Inscription crafting
- Procedural PvE generation
- Magic Knight Orders (guild system)
- Cosmetic DLC and Battle Pass
- Mobile port

### 12.3 Development Phases

| Phase | Focus | Deliverables |
|-------|-------|-------------|
| **Phase 1** (COMPLETE) | Data Architecture | Resource scripts, enums, managers, sample `.tres` files, test validation |
| **Phase 2** | Battle System | Combat scene, turn loop, card play, enemy AI, basic UI |
| **Phase 3** | PvE Campaign | Chapter structure, node map, moral choices, boss encounters |
| **Phase 4** | Progression Polish | Full card set (30+), evolution trees, Grimoire leveling, inscriptions |
| **Phase 5** | Visual & Audio | Card art, Grimoire animations, effects, sound design |
| **Phase 6** | PvP & Live | Multiplayer, leaderboards, seasonal content, cosmetics |

### 12.4 Risk Register

| Risk | Impact | Mitigation |
|------|--------|------------|
| Seed produces unplayable card combos | High | Seed validation: simulate 1,000 hands, reject seeds with no viable plays. Guarantee 2+ cards per type |
| Alignment punishes experimentation | Medium | Three-axis model — shifting one axis does NOT reduce others. Rewards commitment without exclusivity |
| 90 evolved cards impossible to balance | High | Evolved cards follow stat-shift templates. Secondary effects use shared effect system with standardized values |
| Scope creep from PvP/multiplayer | High | PvP is explicitly post-MVP. MVP is single-player only |
| "Best alignment" meta emerges | Medium | All three alignments have equal power budgets. Conflicted state offers unique hybrid cards as incentive for balance |
| Card fatigue (same 20 cards every run) | Medium | Lost Pages, evolution branching, and Grimoire leveling increase deck size to 40. Different seeds produce different starting decks |

---

## 13. Verification Plan

### Phase 1 Verification (COMPLETE)

1. ~~Open project in Godot 4 — confirm no script errors~~ ✅
2. ~~Inspect `GlobalEnums` in autoload settings~~ ✅
3. ~~Create a `CardResource` `.tres` in the editor — verify all `@export` fields appear with correct enum dropdowns~~ ✅
4. ~~Create a `GrimoireResource` `.tres` — verify card array accepts `CardResource` entries~~ ✅
5. ~~Run test script: create Grimoire → add cards → simulate 100 XP → trigger evolution → print alignment shift → confirm output matches expected values~~ ✅
6. ~~Save/load a `GrimoireResource` via `ResourceSaver`/`ResourceLoader` — verify persistence~~ ✅

### Phase 2 Verification (Upcoming)

1. Battle scene loads with a Grimoire and at least 1 enemy
2. Player can draw cards, play cards, spend mana, and end turn
3. Enemy intent is displayed and resolves correctly
4. Card XP is awarded after battle
5. Battle ends when either side reaches 0 HP

---

## 14. Inspiration Sources

### KeyForge (Card Game by Richard Garfield)
- **Unique Deck Game philosophy:** Every deck is algorithmically generated, unique, and unmodifiable — you discover its strengths rather than engineering them
- **House system:** Declaring a House each turn and only using those cards — adapted as our Alignment Attunement system
- **No deck-building economy:** Power cannot be purchased — adapted as our core monetization philosophy
- **Archon identity:** Each deck has a unique name and visual identity — adapted as our True Name and Grimoire appearance system
- Source: [KeyForge Wikipedia](https://en.wikipedia.org/wiki/KeyForge) | [Nerdlab Game Design Review](https://nerdlab-games.com/keyforge-a-game-design-review-of-the-unique-deck-idea/)

### Black Clover (Anime/Manga)
- **Grimoire Acceptance Ceremony:** Receiving your grimoire at age 15 — the core fantasy of our game's opening
- **Soulbound grimoires:** A grimoire is connected to its owner's soul, cannot be used by others, and disintegrates when the owner dies — our Soulbound Rule
- **Growing grimoires:** Grimoires grow new pages and unlock new spells as the mage grows — our Grimoire Leveling and Card Evolution systems
- **Magic Knight Squads and Star Rankings:** Competitive squad-based ranking — our Magic Knight Orders and seasonal leaderboards
- **Clover rarity system:** Three-leaf (common), four-leaf (rare), five-leaf (legendary/cursed) — inspiration for our rarity tiers
- Source: [Black Clover Grimoire Wiki](https://blackclover.fandom.com/wiki/Grimoire) | [CBR Grimoire System Explained](https://www.cbr.com/grimoires-black-clover-explained/)

### Additional Influences
- **Slay the Spire:** Roguelike deckbuilder structure, visible enemy intent, encounter node maps
- **Inscryption:** Cards as living entities with personality and evolution, the "deck as character" fantasy
- **Persona:** Social/moral choices affecting combat capabilities, deep personal progression systems
