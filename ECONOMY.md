# Grimoire: The Soulbound Legacy — Monetization & Economy Document

> **Version:** 1.0
> **Last Updated:** 2026-02-18
> **Companion Documents:** [GDD.md](GDD.md) | [TDD.md](TDD.md) | [CGP.md](CGP.md)
> **Revenue Model:** Early Access → Premium (no F2P, no gacha, no battle pass)
> **Core Pillar Check:** Pillar III — *Mastery Over Money. Power is earned, never purchased.*

---

## Table of Contents

1. [Monetization Philosophy](#1-monetization-philosophy)
2. [Revenue Model & Pricing](#2-revenue-model--pricing)
3. [Real-Money Products](#3-real-money-products)
4. [In-Game Currency Design](#4-in-game-currency-design)
5. [Source & Sink Balance](#5-source--sink-balance)
6. [Reward Pacing](#6-reward-pacing)
7. [Retention Hooks](#7-retention-hooks)
8. [Grimoire Slot Economy](#8-grimoire-slot-economy)
9. [Mobile Rewarded Ads (Stretch Goal)](#9-mobile-rewarded-ads-stretch-goal)
10. [What Money Can Never Buy](#10-what-money-can-never-buy)
11. [Economy Health Metrics](#11-economy-health-metrics)
12. [Anti-Patterns & Red Lines](#12-anti-patterns--red-lines)
13. [Pricing Research & Comps](#13-pricing-research--comps)

---

## 1. Monetization Philosophy

### 1.1 The Iron Rule

> **The Grimoire's value comes from the time spent with it. If power can be purchased, the soulbound fantasy is dead.**

Every monetization decision is filtered through one question:

```
"Does this purchase give the buyer a gameplay advantage
 over someone who didn't buy it?"

YES → Kill it. Non-negotiable.
NO  → Evaluate further.
```

### 1.2 What We Sell

We sell **cosmetics, content, and convenience.** We never sell **power, progression, or advantage.**

| Category | Examples | Acceptable? |
|----------|---------|:-----------:|
| **Cosmetics** | Grimoire skins, aura effects, card backs | ✅ Yes |
| **Content** | New PvE chapter packs, enemy sets, lore expansions | ✅ Yes |
| **Convenience** | Additional Grimoire save slots | ✅ Yes |
| **Power** | Stronger cards, better stats, exclusive evolutions | ❌ Never |
| **Progression** | XP boosters, mastery accelerators, level skips | ❌ Never |
| **Advantage** | Extra mana, bonus card draws, easier enemies | ❌ Never |
| **Gambling** | Loot boxes, gacha, random reward purchases | ❌ Never |

### 1.3 Player Trust Contract

This is the implicit promise to the player:

> *"Your Grimoire is yours. Your progress is real. Your mastery is earned. No one can buy what you've built. The only wallet that matters is the hours you've invested."*

Breaking this contract — even once — destroys the game's core identity. A single pay-to-win feature poisons the well permanently. The community will never trust us again.

---

## 2. Revenue Model & Pricing

### 2.1 Lifecycle Pricing

```
EARLY ACCESS                           FULL RELEASE
────────────────────────────           ────────────────────────
│ Base Game: $9.99         │           │ Base Game: $14.99–    │
│                          │  Launch   │            $19.99     │
│ "Thank you" price for    │ ───────▶  │                      │
│ early supporters.        │  1.0      │ Full game, all MVP   │
│ All EA content carries   │           │ content included.    │
│ to full release.         │           │                      │
────────────────────────────           ────────────────────────
                                                │
                                                ▼
                                       POST-LAUNCH DLC
                                       ────────────────────────
                                       │ Chapter Packs: $3.99  │
                                       │ Cosmetic Packs: $1.99 │
                                       │ Grimoire Slots: $2.99 │
                                       ────────────────────────
```

### 2.2 Pricing Tiers

| Product | Price (USD) | Contents | When Available |
|---------|:---:|---------|:-:|
| **Base Game (Early Access)** | $9.99 | Full PvE campaign (in development), all base cards, all systems | EA Launch |
| **Base Game (1.0 Release)** | $14.99 | Complete PvE campaign, 30+ cards, full evolution trees, Grimoire leveling 1–20 | 1.0 |
| **Base Game (Mature)** | $19.99 | All above + post-launch content updates included to date | 6+ months post-1.0 |
| **Grimoire Slot** | $2.99 | 1 additional Grimoire save slot | 1.0 |
| **Cosmetic Pack (Small)** | $1.99 | 1 Grimoire cover skin + 1 aura effect | Post-1.0 |
| **Cosmetic Pack (Large)** | $4.99 | 3 cover skins + 3 aura effects + 1 card back set | Post-1.0 |
| **Chapter Pack DLC** | $3.99 | 1 new PvE chapter tier (new enemies, environments, Lost Pages) | Post-1.0 |
| **Collector's Bundle** | $7.99 | 1 Chapter Pack + 1 Large Cosmetic Pack (saves $1) | Post-1.0 |

### 2.3 Regional Pricing

Use Steam's recommended regional pricing matrix. Key adjustments:

| Region | Multiplier | Base Game (1.0) |
|--------|:---:|:---:|
| US / EU / UK | 1.0× | $14.99 / €14.99 / £12.99 |
| Brazil | 0.45× | R$34.99 |
| Turkey | 0.30× | ₺149.99 |
| India | 0.35× | ₹499 |
| Russia/CIS | 0.40× | Evaluate per platform |
| China | 0.50× | ¥49 |
| Japan | 1.1× | ¥1,980 |

**Rule:** Never price below the floor where chargebacks exceed revenue. Use Steam/itch.io's built-in regional pricing tools.

### 2.4 Sale Strategy

| Timing | Discount | Rationale |
|--------|:---:|---------|
| EA Launch week | 10% | Early adopter bonus, drives initial visibility |
| Major EA update milestones | 15% | Re-engagement, reminds wishlisted players |
| 1.0 Launch week | 10% | Transition incentive for new players |
| Steam seasonal sales | 20–30% | Standard, expected by the market |
| 1-year anniversary | 33% | Celebration milestone |
| **Never:** >50% within first year | — | Protects early buyers, maintains perceived value |

---

## 3. Real-Money Products

### 3.1 Cosmetic Grimoire Skins

Alternate visual appearances for the Grimoire cover. **Purely visual — zero gameplay effect.**

| Skin | Cover Style | Aura | Price | Rarity Feel |
|------|-----------|------|:---:|:---:|
| **Obsidian Tome** | Glossy black volcanic glass, red vein cracks | Deep red ember particles | $1.99 (small pack) | Dark, powerful |
| **Dragonscale Codex** | Iridescent green-blue scales, fang clasps | Emerald fire wisps | $1.99 (small pack) | Exotic, ancient |
| **Starweave Grimoire** | Deep navy cloth with silver thread constellations | Twinkling starfield | $1.99 (small pack) | Celestial, mystical |
| **Ironbound Ledger** | Riveted black iron plates, gear-mechanism clasp | Copper spark trails | $4.99 (large pack) | Industrial, imposing |
| **Frostwood Manuscript** | Pale birch wood, ice crystal inlays | Snowflake drift | $4.99 (large pack) | Cold, pristine |
| **Bloodvine Journal** | Crimson leather, living thorny vines | Red petal scatter | $4.99 (large pack) | Organic, dangerous |

**Production rule:** Every cosmetic skin must satisfy Art Bible Pillar I (Handcrafted) and Pillar V (Living — idle animations required). No flat texture swaps.

### 3.2 Aura Effects

Alternative particle systems for the Grimoire's idle aura.

| Aura | Visual | Price |
|------|--------|:---:|
| **Ember Storm** | Slow-falling ember particles, warm orange glow | Included in packs |
| **Ink Rain** | Tiny ink droplets falling upward, dissolving | Included in packs |
| **Moth Swarm** | Small moths orbiting the book, drawn to its light | Included in packs |
| **Frozen Mist** | Cold fog rolling off the book's edges | Included in packs |
| **Golden Dust** | Gilded particles drifting like disturbed gold leaf | Included in packs |

**Rule:** Auras never override alignment corruption visuals. They layer beneath corruption, so the Grimoire's history is always visible.

### 3.3 Card Back Sets

Alternative visual for the reverse side of cards in hand.

| Card Back | Visual | Price |
|-----------|--------|:---:|
| **Classic Manuscript** | Default — aged parchment with simple sigil | Free (default) |
| **Gilded Codex** | Gold-leaf border on dark leather | Included in large pack |
| **Shadow Script** | Dark parchment with faintly glowing runes | Included in large pack |
| **Nature Weave** | Woven leaf pattern with bark border | Included in large pack |

### 3.4 Chapter Pack DLC

New PvE content that adds **things to do**, not **power to have.**

| Chapter Pack | Theme | Contents | Price |
|-------------|-------|---------|:---:|
| **The Sunken Scriptorium** | Underwater archive, water magic enemies | 1 chapter (6 encounters), 3 enemies, 2 Lost Pages, 1 boss | $3.99 |
| **The Burning Index** | Fire-ravaged wing of the Archives | 1 chapter, 3 enemies, 2 Lost Pages, 1 boss | $3.99 |
| **The Whispering Annex** | Mind magic, puzzle-combat hybrid encounters | 1 chapter, 3 enemies, 2 Lost Pages, 1 boss | $3.99 |

**DLC content rules:**
- New Lost Pages in DLC chapters are **not stronger** than base game Lost Pages — they are **different** (lateral power, not vertical)
- DLC enemies follow the same stat templates as base enemies (scaling by chapter difficulty tier, not by DLC)
- DLC chapters are accessible at any Grimoire level — difficulty scales to the player
- Players who don't buy DLC are never at a disadvantage in PvP

---

## 4. In-Game Currency Design

### 4.1 Currency Overview

Two in-game currencies. Both are earned through play only. Neither can be purchased with real money.

```
┌─────────────────────────────────────────────────────────┐
│  INK (Primary / Soft Currency)                          │
│                                                         │
│  Earned:  Every combat encounter, every chapter         │
│  Spent:   Inscription crafting, rest node healing,      │
│           Grimoire cosmetic unlocks (in-game only)      │
│  Feel:    "Working money." Flows freely, spent often.   │
│  Icon:    Ink pot with quill                             │
│  Color:   Ink Black (#1A1410) with slight blue tint     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  AETHER (Premium / Hard Currency — NOT purchasable)     │
│                                                         │
│  Earned:  Boss kills, perfect chapter runs, PvP wins    │
│  Spent:   Re-rolling Lost Page offerings, unlocking     │
│           higher chapter difficulty tiers, rare          │
│           in-game cosmetics                             │
│  Feel:    "Special occasion money." Earned slowly,      │
│           spent deliberately.                           │
│  Icon:    Glowing crystal shard                          │
│  Color:   Mana Blue (#3D6B99) with shimmer              │
└─────────────────────────────────────────────────────────┘
```

**Critical design decision:** Aether CANNOT be purchased with real money. It is an in-game prestige currency only. This prevents any path from "wallet → Aether → gameplay advantage." If Aether were purchasable, re-rolling Lost Page offerings would become pay-to-win.

### 4.2 Why Only Two Currencies?

| Temptation | Why We Resist |
|-----------|--------------|
| "Add a premium gem currency for real-money purchases" | Violates Pillar III. Creates a pay-to-advantage path. Erodes player trust. |
| "Add PvP tokens as a third currency" | Complexity without benefit. PvP rewards can use Aether + unique cosmetic drops. |
| "Add crafting materials as separate currencies" | Materials are not currencies — they're inventory items. Inscription materials drop from enemies, not from a wallet. |

Two currencies keep the economy legible. The player always knows: Ink for daily needs, Aether for special occasions.

---

## 5. Source & Sink Balance

### 5.1 Ink Economy (Soft Currency)

#### Sources (How Players Earn Ink)

| Source | Ink per Event | Frequency per Session | Session Total |
|--------|:---:|:---:|:---:|
| Combat encounter victory (standard) | 15–25 | 3–4 | 60–100 |
| Combat encounter victory (hard) | 25–40 | 1–2 | 25–80 |
| Chapter completion bonus | 30–50 | 0–1 | 0–50 |
| Moral choice event (any option) | 10 | 1 | 10 |
| First evolution of a card (one-time) | 50 | Rare | 0–50 |
| **Session Ink income (typical)** | | | **~120–200** |

#### Sinks (How Players Spend Ink)

| Sink | Ink Cost | Frequency | Notes |
|------|:---:|---------|-------|
| Rest node healing (partial) | 15–25 | 0–1 per chapter | Optional — skip if healthy |
| Rest node healing (full) | 40–60 | Rare | Emergency option |
| Inscription crafting (common) | 50–80 | Every few sessions | Requires materials + Ink |
| Inscription crafting (rare) | 120–180 | Rare | Significant investment |
| In-game Grimoire cosmetics | 100–500 | One-time purchases | Titles, page edge styles, sigil variants |

#### Ink Balance Target

```
Average session income:  ~160 Ink
Average session spending: ~40 Ink  (one rest heal + incidentals)
Net session surplus:     ~120 Ink

Time to craft a common inscription:  ~3 sessions of saving
Time to craft a rare inscription:    ~8 sessions of saving
Time to buy cheapest in-game cosmetic: ~5 sessions of saving
```

**Design intent:** Players should ALWAYS end a session with more Ink than they started. The surplus accumulates toward meaningful purchases (inscriptions, cosmetics). Players should never feel Ink-starved during normal play. The occasional "big purchase" (rare inscription) creates a satisfying saving goal.

**Inflation control:** In-game cosmetics are one-time purchases. Inscription crafting is limited by material drops (bottleneck is materials, not Ink). No infinitely repeatable Ink sinks exist — this prevents runaway deflation or inflation.

### 5.2 Aether Economy (Hard Currency)

#### Sources

| Source | Aether per Event | Frequency |
|--------|:---:|---------|
| Chapter boss kill (first time per boss) | 10 | Limited (one-time per boss) |
| Chapter boss kill (repeat) | 3 | Once per chapter run |
| Perfect chapter run (no damage taken in any encounter) | 15 | Rare — skill-gated |
| PvP victory (post-MVP) | 2–5 | Per match |
| Grimoire level milestone (5, 10, 15, 20) | 20 | 4 times per Grimoire, ever |

#### Sinks

| Sink | Aether Cost | Notes |
|------|:---:|-------|
| Re-roll Lost Page offering (pick 1 of 3 → shuffle for new 3) | 5 | Only at treasure nodes. Max 2 re-rolls per node. |
| Unlock chapter difficulty tier (Knight) | 15 | One-time unlock |
| Unlock chapter difficulty tier (Captain) | 25 | One-time unlock |
| Unlock chapter difficulty tier (Wizard King) | 40 | One-time unlock |
| Rare in-game cosmetics (earned, not bought) | 30–100 | Prestige cosmetics that signal dedicated play |

#### Aether Balance Target

```
First 10 hours of play:  ~60–80 Aether earned
  Spent on: Knight tier unlock (15) + a few re-rolls (10–15)
  Surplus: ~30–50 Aether

Hours 10–30:  ~80–120 more Aether earned
  Spent on: Captain tier unlock (25) + re-rolls + cosmetic
  Surplus: ~30–60 Aether

Hours 30+:  Steady income from repeating bosses + PvP
  Spent on: Wizard King unlock (40) + prestige cosmetics
```

**Design intent:** Aether income is front-loaded via one-time boss kills and milestones. This gives new players the exciting feeling of accumulating a special resource. Long-term, Aether income slows to a trickle (repeat bosses only give 3), making prestige cosmetics a genuine time investment.

### 5.3 Visual Economy Flow

```
     PLAYER TIME & SKILL
            │
            ▼
    ┌───────────────┐        ┌──────────────┐
    │   COMBAT      │───────▶│     INK      │
    │   ENCOUNTERS  │        │  (soft)      │
    └───────────────┘        └──────┬───────┘
            │                       │
            │                       ├──▶ Rest Healing
            │                       ├──▶ Inscription Crafting
            │                       └──▶ In-Game Cosmetics
            │
    ┌───────────────┐        ┌──────────────┐
    │   BOSSES      │───────▶│   AETHER     │
    │   PVP WINS    │        │  (hard)      │
    │   MILESTONES  │        └──────┬───────┘
    └───────────────┘               │
                                    ├──▶ Difficulty Tier Unlocks
                                    ├──▶ Lost Page Re-rolls
                                    └──▶ Prestige Cosmetics

     REAL MONEY (completely separate track)
            │
            ▼
    ┌───────────────┐
    │  STORE        │───────▶ Grimoire Skins (cosmetic)
    │  (optional)   │───────▶ Aura Effects (cosmetic)
    │               │───────▶ Card Backs (cosmetic)
    │               │───────▶ Chapter Pack DLC (content)
    │               │───────▶ Grimoire Slots (convenience)
    └───────────────┘
            │
            ✕ NO CONNECTION to Ink, Aether, or gameplay power
```

---

## 6. Reward Pacing

### 6.1 Reward Schedule Philosophy

> **Frequent small rewards. Occasional medium rewards. Rare large rewards. Every session delivers something.**

The player should never finish a session feeling like nothing happened. At minimum, they earned card XP. At best, they evolved a card, leveled up, or found a Lost Page.

### 6.2 Reward Frequency Table

| Reward Type | Avg. Frequency | Emotional Weight | Sound/Visual |
|-------------|:-:|:-:|---------|
| **Card XP gained** | Every battle (guaranteed) | Low — expected, background progress | Tiny quill scratch, XP bar fills |
| **Ink earned** | Every battle (guaranteed) | Low — expected, working currency | Soft coin clink |
| **Card mastery tier-up** (Bronze/Silver/Gold) | Every 3–5 battles (for active cards) | Medium — noticeable power bump | Metallic shimmer + border upgrade |
| **Moral choice** | 1–2 per chapter | Medium-high — narrative weight | Bell toll, alignment shift visual |
| **Lost Page found** | ~1 per chapter (not guaranteed) | High — rare, exciting | Page flutter + golden glow |
| **Card evolution** | Every 15–25 battles (per card) | Very high — permanent transformation | Shatter → silence → reform |
| **Grimoire level-up** | Every 5–10 sessions | Very high — macro progression | Gong + page eruption + stat unlocks |
| **Inscription unlock** | Tied to Grimoire level (4 total) | High — new system engagement | Stone-slot sound, new passive |
| **Ultimate Spell** | Once per Grimoire (at level 20) | **Maximum** — unique capstone | Unique cinematic moment |

### 6.3 Session Reward Guarantee

Every single play session (15–30 min) must deliver at minimum:

```
GUARANTEED PER SESSION:
├── Card XP on multiple cards (visible progress)
├── Ink income exceeding expenses (net positive)
├── At least 1 encounter victory (competence feeling)
└── At least 1 card moving toward next mastery tier

LIKELY PER SESSION (70%+):
├── 1 mastery tier-up on at least 1 card
├── 1 moral choice event
└── Meaningful alignment score change

POSSIBLE PER SESSION (20–40%):
├── Lost Page discovery
├── Card reaching evolution threshold
├── Grimoire level-up

RARE PER SESSION (5–10%):
├── Multiple cards evolving in same session
├── Perfect chapter run (Aether bonus)
└── Finding a Legendary Lost Page
```

### 6.4 The "Just One More" Curve

Reward pacing follows variable ratio reinforcement — the most engaging reward schedule in behavioral psychology:

```
REWARD DENSITY
  ▲
  │  ██                                         ██
  │  ██ █                                     █ ██
  │  ██ ██  █                             █  ██ ██
  │  ██ ██ ███ █                       █ ███ ██ ██
  │  ██ ██ ██████ █   █         █   █ ██████ ██ ██
  │  ██ ██ ████████ ███ █   █ ███ ████████ ██ ██
  └──────────────────────────────────────────────── TIME
     ↑ Session start        Mid-session        Session end ↑
     High early rewards     Spacing grows       Cluster before
     (hook you in)          (builds tension)    natural stop point
```

**Implementation:**
- First encounter of a session always drops slightly higher Ink (1.2× multiplier) — the "welcome back" bonus
- Mastery tier-ups are celebrated with a pause + sound + visual — the game makes you FEEL the reward
- Lost Pages appear at the treasure node AFTER the hardest combat in the chapter — reward follows effort
- The Chapter boss always drops guaranteed Aether — the session always ends on a high note

### 6.5 Anti-Grind Principle

> **If it feels like grinding, the pacing is broken.**

| Symptom | Cause | Fix |
|---------|-------|-----|
| "I've played 5 battles and nothing changed" | Card XP gains too small or invisible | Make XP bar animations more prominent. Consider +1 XP → +2 for standard use. |
| "I need 200 more Ink and it's taking forever" | Ink income too low relative to target | Reduce inscription costs or increase per-battle Ink by 20%. |
| "I keep seeing the same encounters" | Content variety too low | Add procedural modifiers to existing encounters (enemy buff variants). |
| "My cards are all maxed but Grimoire is only level 8" | Card mastery outpaces Grimoire leveling | Increase Grimoire XP from evolutions. Add XP bonus for using evolved cards. |

---

## 7. Retention Hooks

### 7.1 What Brings Players Back?

Retention in a premium game (no daily login rewards, no FOMO) comes from **intrinsic motivation** — the player WANTS to return, not feels OBLIGATED to.

| Hook | Mechanic | Psychology |
|------|---------|-----------|
| **Unfinished evolution** | A card at 85/100 XP begging to be evolved | Zeigarnik effect — incomplete tasks nag at us |
| **Unexplored evolution path** | "What does the Vile evolution of Flame Ward do?" | Curiosity — the unknown pulls us back |
| **Alignment identity** | "I'm building a Radiant Grimoire" | Identity investment — we protect what we've built |
| **The next level** | Grimoire XP bar sitting at 80% | Progress — visible proximity to the next milestone |
| **Lost Page slot opening** | "At level 10 I can bind 2 Lost Pages" | Anticipation — a locked reward creates desire |
| **Grimoire visual evolution** | "My book is starting to glow gold" | Ownership — watching your artifact transform |
| **New chapter difficulty** | "I wonder if I can beat Captain tier" | Challenge — testing mastery against harder content |
| **Seed sharing** | "My friend got seed 'Tharvale' — what's mine like?" | Social comparison — not competitive, but curious |

### 7.2 Session Ending Hooks

When the player finishes a session, the game surfaces a **single hook** to plant the seed for return:

```
SESSION END SCREEN
──────────────────────────────────────────
  Session Summary

  Cards Used: 12     Ink Earned: 145
  XP Gained: +24     Alignment: Radiant ▲3

  ┌─────────────────────────────────────┐
  │  ⚡ Spark Bolt is 8 XP from         │ ← The Hook
  │     EVOLUTION. One more battle...   │
  └─────────────────────────────────────┘

  [Continue Playing]    [Close Grimoire]
──────────────────────────────────────────
```

**Hook selection priority:**
1. Card closest to evolution threshold (most compelling)
2. Grimoire XP close to level-up (if >75%)
3. New chapter difficulty unlockable (if Aether is sufficient)
4. Unused Lost Page slot available
5. New inscription craftable (if materials + Ink sufficient)
6. Generic "Your Grimoire grows stronger" (fallback)

### 7.3 Long-Term Retention (Month 1+)

| Timeframe | Retention Driver | Content |
|-----------|-----------------|---------|
| **Week 1** | Discovery | Learning the Grimoire, first evolutions, finding playstyle |
| **Week 2–3** | Identity formation | Alignment solidifying, visual corruption visible, mastery tier-ups |
| **Month 1** | Mastery depth | Harder difficulty tiers, optimizing card usage, inscription builds |
| **Month 2–3** | Completion drive | Evolving all cards, reaching Grimoire level 20, Ultimate Spell |
| **Month 3+** | New Grimoire / DLC / PvP | Starting a new Grimoire with different seed, DLC chapters, PvP competition |

### 7.4 What We Do NOT Use for Retention

| Dark Pattern | Why We Reject It |
|-------------|-----------------|
| **Daily login rewards** | Creates obligation, not desire. Players resent "missing" a day. |
| **FOMO limited-time offers** | Anxiety-driven spending. Violates trust. |
| **Energy / stamina systems** | "Play 3 battles, wait 4 hours" is hostile to the player. |
| **Loss aversion mechanics** | "Play today or lose your streak" punishes real life. |
| **Notification spam** | "Your Grimoire misses you!" is manipulative. |
| **Social pressure** | "Your friend is ahead of you!" breeds resentment, not fun. |

---

## 8. Grimoire Slot Economy

### 8.1 Slot Structure

| Slot | How Acquired | Cost |
|------|-------------|:---:|
| **Slot 1** | Free with game purchase | $0 |
| **Slot 2** | Purchased | $2.99 |
| **Slot 3** | Purchased | $2.99 |
| **Slot 4** | Purchased (max) | $2.99 |

**Maximum 4 Grimoires per account.** Hard cap — even with purchases. This isn't a whale trap, it's a convenience option for players who want to explore different playstyles.

### 8.2 Why Charge for Slots?

| Reason | Explanation |
|--------|------------|
| **Pillar I reinforcement** | Limiting Grimoire count makes each one feel MORE precious. "I only have 2 — each matters." |
| **Revenue without power** | Slots are pure convenience. Player 1 with 4 Grimoires has zero advantage over Player 2 with 1. |
| **Exploration incentive** | A second slot lets the player try a different seed, different alignment, different playstyle — without losing their first Grimoire. |
| **Low price, high perceived value** | $2.99 is an impulse purchase that delivers significant value (an entire new progression track). |

### 8.3 Slot Revenue Projection

Conservative estimate:
- 30% of buyers purchase Slot 2 (most common second purchase)
- 10% of buyers purchase Slot 3
- 5% of buyers purchase Slot 4

```
Per 1,000 copies sold at $14.99:
  Base revenue:    $14,990
  Slot 2 (30%):    $897   (300 × $2.99)
  Slot 3 (10%):    $299   (100 × $2.99)
  Slot 4 (5%):     $150   (50 × $2.99)
  Slot revenue:    $1,346  (+9% over base)
```

### 8.4 Slot UX

- Slot purchase is surfaced ONLY when the player tries to create a second Grimoire
- No upsell on the main menu, no persistent "buy more slots" badge
- Purchase flow: "Create New Grimoire" → "This requires an additional Grimoire Slot ($2.99)" → Platform purchase dialog
- Purchased slots persist across reinstalls (tied to platform account)

---

## 9. Mobile Rewarded Ads (Stretch Goal)

### 9.1 Mobile-Only, Desktop-Zero

If a mobile port is developed (stretch goal, post-MVP), optional rewarded video ads may be offered. **Desktop builds will never contain ads of any kind.**

### 9.2 Ad Rules

| Rule | Rationale |
|------|-----------|
| **100% optional.** No forced ads, ever. | Player respect. |
| **Player-initiated only.** Ads are triggered by the player pressing a clearly labeled button. | No surprise interruptions. |
| **Limited to 3 per day.** | Prevents ad fatigue and devaluing the currency. |
| **Reward: 15–25 Ink per ad.** | Equivalent to one combat encounter. Helpful, not game-changing. |
| **No ad between encounters.** Ads are only available at rest nodes or the hub menu. | Never interrupt gameplay flow. |
| **No ads in combat or moral choices.** | Sacred moments are never interrupted. |
| **Clear labeling: "Watch Ad for 20 Ink"** | Transparency. The player knows the exact exchange. |

### 9.3 Ad Revenue Projection

Conservative estimate for mobile:
```
DAU: 5,000 (modest)
Ad engagement rate: 15% (industry avg for opt-in rewarded)
Avg ads per engaged user: 1.5/day
Ad impressions/day: 1,125
eCPM: $8–12 (rewarded video, gaming vertical)
Daily ad revenue: $9–13.50
Monthly ad revenue: $270–405
```

This is supplementary income only. It will never be the primary revenue driver.

---

## 10. What Money Can Never Buy

This is the most important section. Tape it to the monitor.

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║  THE FOLLOWING CANNOT BE PURCHASED WITH REAL MONEY.       ║
║  NOT NOW. NOT EVER. NOT UNDER ANY CIRCUMSTANCE.           ║
║                                                           ║
║  ✕  Cards or card upgrades                                ║
║  ✕  Card mastery XP or mastery accelerators               ║
║  ✕  Card evolution unlocks or evolution resets             ║
║  ✕  Grimoire XP or level boosts                           ║
║  ✕  Alignment points or alignment resets                  ║
║  ✕  Inscriptions or inscription materials                 ║
║  ✕  Lost Pages or Lost Page selection                     ║
║  ✕  Ink currency                                          ║
║  ✕  Aether currency                                       ║
║  ✕  Mana boosts, extra card draws, or combat advantages   ║
║  ✕  Easier enemies or difficulty reduction                ║
║  ✕  PvP matchmaking advantages                            ║
║  ✕  Extra turns, time extensions, or retry tokens         ║
║  ✕  Any item, stat, or system that affects win/loss odds  ║
║                                                           ║
║  IF A PROPOSED FEATURE CONFLICTS WITH THIS LIST,          ║
║  THE FEATURE IS WRONG, NOT THE LIST.                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 11. Economy Health Metrics

### 11.1 Key Metrics to Track

Once the game is live, monitor these metrics to detect economy imbalances:

| Metric | Healthy Range | Warning Sign | Action |
|--------|:---:|:---:|---------|
| **Ink per session (avg)** | 120–200 | <100 (too stingy) or >300 (too generous) | Adjust combat rewards |
| **Ink balance (median player)** | 200–800 | >2000 (nothing to spend on) or <50 (too broke) | Add/adjust sinks or sources |
| **Aether balance (median player at hour 20)** | 40–80 | <20 (starved) or >150 (flooded) | Adjust boss/milestone rewards |
| **Cards at max mastery (avg per Grimoire)** | 5–10 by hour 15 | <3 (too slow) or all 20 (too fast) | Adjust XP per battle |
| **Evolutions chosen by hour 10** | 2–4 | 0 (XP too slow) or 8+ (too fast) | Adjust XP gains or mastery threshold |
| **Session length (avg)** | 15–30 min | <10 (not engaged) or >60 (no stopping point) | Adjust chapter length |
| **Sessions before first evolution** | 3–5 | >8 (too far away) or 1 (too easy) | Adjust XP rates |
| **Grimoire level at hour 20** | 6–10 | <4 (grind) or >15 (trivial) | Adjust Grimoire XP curve |
| **Cosmetic purchase rate (of buyers)** | 5–15% | <3% (too expensive or unappealing) | Adjust pricing or improve skins |
| **Slot purchase rate (of buyers)** | 20–35% | <10% (too expensive or not surfaced) | Adjust price or purchase UX |
| **Refund rate** | <5% | >8% | Investigate — content expectations not met |
| **D7 retention** | 30–40% | <20% | Reward pacing too slow, investigate session 2 hook |
| **D30 retention** | 15–25% | <10% | Content exhaustion, need DLC pipeline or PvP |

### 11.2 Economy Tuning Levers

When metrics are unhealthy, these are the levers to pull:

| Problem | Lever | Direction |
|---------|-------|:---------:|
| Players feel Ink-starved | Per-combat Ink reward | ▲ Increase 10–20% |
| Players hoard Ink with nothing to spend on | Add new Ink sinks (cosmetics, inscription variety) | ▲ Add options |
| Card mastery feels too slow | XP per standard use (currently +1) | ▲ Increase to +2 |
| Card mastery feels too fast (no anticipation) | XP per standard use | ▼ Keep at +1, increase threshold to 125 |
| Aether feels meaningless | Aether sink variety | ▲ Add prestige cosmetics, special re-roll options |
| Aether feels too rare | Boss repeat Aether reward (currently 3) | ▲ Increase to 5 |
| Sessions feel unrewarding | Session-end hook visibility | ▲ Improve summary screen, surface progress |
| Sessions feel too long | Chapter encounter count | ▼ Reduce from 5–7 to 4–6 |

---

## 12. Anti-Patterns & Red Lines

### 12.1 Monetization Red Lines

Lines we will never cross, regardless of revenue pressure:

| Red Line | Why It's Absolute |
|----------|------------------|
| **No loot boxes or randomized purchases** | Gambling mechanics. Illegal in some jurisdictions. Ethically wrong for our audience. |
| **No pay-to-win** | Destroys Pillar III entirely. The game's identity dies. |
| **No artificial scarcity on gameplay items** | "Limited edition" cards that are mechanically superior create FOMO and inequality. |
| **No pay-to-skip-grind** | If the grind needs skipping, the grind is the bug — fix the pacing, don't sell the bypass. |
| **No subscription required for core gameplay** | The $14.99 buys the full game. No monthly fee to keep playing. |
| **No blockchain, NFT, or crypto integration** | Not this game. Not any game we make. |
| **No selling player data** | We collect anonymous analytics for economy tuning. We never sell identifying data. |

### 12.2 Feature Creep Warning Signs

Economy features that sound reasonable but violate pillars:

| Proposal | Sounds Like | Actually Is | Verdict |
|----------|-----------|------------|:---:|
| "Let players buy Ink with real money" | "Convenience — skip a few battles" | Pay-to-advance. Ink buys inscriptions which are gameplay power. | ❌ |
| "Sell a 'Double XP Weekend' event" | "Fun event, everyone benefits" | Pay-to-accelerate mastery. Violates Pillar III. | ❌ |
| "Offer a $0.99 Grimoire respec" | "Letting players fix mistakes" | Destroys Pillar II (Choices Scar). Mistakes ARE the game. | ❌ |
| "Sell exclusive cards in the store" | "Just a few fun extras" | Pay-to-win. Even 1 store-exclusive card poisons the well. | ❌ |
| "Let players buy Lost Page selection" | "They still have to find the page in a dungeon" | Pay-to-choose removes the constraint. Aether re-rolls already exist for free. | ❌ |
| "Add a premium battle pass for PvP seasons" | "It's just cosmetics" | FOMO + time pressure + paid track. Violates no-battle-pass decision. | ❌ |
| "Sell difficulty reduction items" | "Accessibility option" | Difficulty tiers already serve accessibility. Selling easy mode signals that default is unfair. | ❌ |

### 12.3 The Pub Test

Before shipping any monetization feature, apply the Pub Test:

> *Imagine explaining this feature to a player at a pub. If you feel embarrassed saying it out loud, don't ship it.*

- "You buy the game once and own everything" → ✅ Proud to say
- "Cosmetic skins for your Grimoire if you want them" → ✅ Reasonable
- "Extra save slots for $2.99 if you want more Grimoires" → ✅ Fair
- "New chapters with new enemies for $3.99" → ✅ Content worth paying for
- "Buy gems to speed up your card XP" → ❌ Embarrassing. Don't ship it.

---

## 13. Pricing Research & Comps

### 13.1 Comparable Games & Their Models

| Game | Price | Model | DLC Strategy | What We Learn |
|------|:---:|-------|-------------|--------------|
| **Slay the Spire** | $24.99 | Premium | None (complete game) | Proof that a $25 card roguelike can sell 10M+ copies with zero DLC or MTX |
| **Inscryption** | $19.99 | Premium | None | Single-player narrative card games at $20 are well-accepted |
| **Balatro** | $14.99 | Premium | Minor DLC ($4.99) | $15 is the sweet spot for indie card games. Massive sales at this price. |
| **Monster Train** | $24.99 | Premium | Major DLC ($12.99) | DLC chapters at $10+ are accepted if substantial content |
| **Hades** | $24.99 | Premium (was EA at $19.99) | None | EA → Premium at +$5 works. No MTX needed for retention. |
| **Darkest Dungeon** | $24.99 | Premium | Major DLC ($4.99–14.99) | DLC chapters with new mechanics are well-received |
| **Hearthstone** | Free | F2P + Packs | $80+ per expansion meta | What we are NOT. Pay-to-win drives players away long-term. |

### 13.2 Price Sensitivity Analysis

```
$9.99  (EA)     → Impulse buy. Low barrier. High volume potential.
                   Risk: perceived as "cheap/incomplete."
                   Mitigated by: EA label sets expectations.

$14.99 (1.0)    → Sweet spot for indie. Balatro proved this tier.
                   High enough to signal quality, low enough for
                   Steam sale impulse purchases at 20–30% off.

$19.99 (Mature) → Justified after content additions and reviews.
                   Inscryption/Hades tier. Requires proven quality.

$24.99+         → Only if PvP + multiple DLC chapters justify it.
                   Slay the Spire tier. Need 50+ hour content to
                   justify this price for a card game.
```

### 13.3 Revenue Projection (Conservative)

```
Year 1 Scenario: 10,000 copies sold (indie baseline)

Base game revenue (blended $12 avg after sales/regional):
  10,000 × $12 = $120,000

Grimoire slots (30% attach rate):
  3,000 × $2.99 = $8,970

Cosmetic packs (10% attach, avg $3):
  1,000 × $3.00 = $3,000

Chapter DLC (15% attach):
  1,500 × $3.99 = $5,985

Year 1 Gross Revenue: ~$138,000
Platform cut (30%): -$41,400
Net Revenue: ~$96,600
```

```
Year 1 Scenario: 50,000 copies (breakout indie)

Base: 50,000 × $12 = $600,000
Slots: 15,000 × $2.99 = $44,850
Cosmetics: 5,000 × $3 = $15,000
DLC: 7,500 × $3.99 = $29,925

Year 1 Gross: ~$690,000
Net (after 30% cut): ~$483,000
```

---

*The economy exists to serve the game, not the other way around. If a monetization feature makes the game worse for players who don't pay — even slightly — it fails. We build a game worth paying for, and then we let people pay for it. That's the whole strategy.*
