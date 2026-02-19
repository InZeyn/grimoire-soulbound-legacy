# Grimoire: The Soulbound Legacy — Production Roadmap

> **Version:** 1.0
> **Last Updated:** 2026-02-18
> **Companion Documents:** [GDD.md](GDD.md) | [TDD.md](TDD.md) | [ART_BIBLE.md](ART_BIBLE.md) | [ADD.md](ADD.md) | [CGP.md](CGP.md) | [ECONOMY.md](ECONOMY.md)
> **Versioning:** `0.{phase}.{sprint}` — e.g., `0.2.3` = Phase 2, Sprint 3

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Milestone Map](#2-milestone-map)
3. [MVP Definition](#3-mvp-definition)
4. [Phase 1 — Data Architecture (COMPLETE)](#4-phase-1--data-architecture-complete)
5. [Phase 2 — Battle System](#5-phase-2--battle-system)
6. [Phase 3 — PvE Campaign](#6-phase-3--pve-campaign)
7. [Phase 4 — Content & Progression](#7-phase-4--content--progression)
8. [Phase 5 — Visual & Audio Polish](#8-phase-5--visual--audio-polish)
9. [Phase 6 — PvP & Live Service](#9-phase-6--pvp--live-service)
10. [Risk Register](#10-risk-register)
11. [Release Strategy](#11-release-strategy)
12. [Master TODO](#12-master-todo)

---

## 1. Project Overview

| Field | Value |
|-------|-------|
| **Game** | Grimoire: The Soulbound Legacy |
| **Engine** | Godot 4.5.1 stable (GDScript, strict typing) |
| **Genre** | Roguelite Card Game / RPG Hybrid |
| **Target Platforms** | Windows, Linux, macOS (desktop-first) |
| **Revenue Model** | Early Access $9.99 → Premium $14.99–$19.99 |
| **MVP Target** | Single-player playable vertical slice |
| **Current Status** | Phase 1 complete, Phase 2 next |

### Team Roles

> Adapt this table as the team grows. All roles can be held by one person or split across contributors.

| Role | Responsibility | Key Deliverables |
|------|---------------|-----------------|
| **Game Designer** | Mechanics, balance, card data, economy tuning | Card spreadsheets, balance patches, encounter design |
| **Engineer** | GDScript systems, architecture, tooling, CI | All `.gd` scripts, project structure, build pipeline |
| **Artist** | Card art, grimoire textures, UI, VFX, shaders | Sprites, shaders, animations per ART_BIBLE.md |
| **Audio Designer** | Music, SFX, dynamic audio system | Audio assets, AudioManager per ADD.md |
| **Producer** | Scope, schedule, risk, playtesting coordination | This roadmap, sprint planning, milestone reviews |
| **QA** | Manual testing, bug tracking, regression | Test scripts, bug reports, platform verification |

---

## 2. Milestone Map

```
                                                            WE ARE HERE
                                                                 ↓
 ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
 │ PHASE 1  │→ │ PHASE 2  │→ │ PHASE 3  │→ │ PHASE 4  │→ │ PHASE 5  │→ │ PHASE 6  │
 │  Data    │  │  Battle  │  │   PvE    │  │ Content  │  │  Polish  │  │  PvP &   │
 │  Arch    │  │  System  │  │ Campaign │  │ & Prog   │  │  V & A   │  │  Live    │
 │          │  │          │  │          │  │          │  │          │  │          │
 │ ✅ DONE  │  │ ✅ DONE  │  │ ✅ DONE  │  │ 🔲 NEXT  │  │ 🔲 TODO  │  │ 🔲 TODO  │
 │ v0.1.0   │  │ v0.2.0   │  │ v0.3.0   │  │ v0.4.0   │  │ v0.5.0   │  │ v0.6.0   │
 └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘
                              ↑                           ↑
                         INTERNAL ALPHA              EARLY ACCESS
                         (Phases 1–3)                (Phases 1–5)
```

### Milestone Definitions

| Milestone | Trigger | Gate Criteria |
|-----------|---------|---------------|
| **M1: Data Foundation** | Phase 1 complete | All Resources serialize, test_phase1 passes, Godot loads clean |
| **M2: First Playable** | Phase 2 complete | Player can fight 1 enemy with full turn loop, cards deal damage, enemy acts on intent |
| **M3: Internal Alpha** | Phase 3 complete | 3 PvE encounters + 1 boss + 1 moral choice, playable start-to-finish session (15 min) |
| **M4: Content Complete** | Phase 4 complete | 30 base cards, 10+ evolution trees, Grimoire levels 1–5, seed validation, inscriptions |
| **M5: Early Access** | Phase 5 complete | Art, audio, VFX, shaders in place. Exported builds for Win/Linux/Mac. Store-ready |
| **M6: Full Release** | Phase 6 complete | PvP functional, matchmaking, leaderboards, cosmetic DLC pipeline, anti-cheat |

---

## 3. MVP Definition

**MVP = Phases 1–4 (Playable Single-Player Vertical Slice)**

A player can:
1. Generate a unique Grimoire from a seed
2. View their cards, mastery progress, and Grimoire stats
3. Enter a PvE chapter and fight 3 combat encounters + 1 boss
4. Make 1 moral choice that permanently shifts alignment
5. Gain card XP, evolve at least 1 card, see alignment update
6. Level Grimoire from 1 to 5
7. Save progress and resume later

**MVP explicitly excludes:** PvP, leaderboards, Lost Pages binding, procedural chapter generation, art polish, audio, inscriptions beyond basic implementation, mobile.

---

## 4. Phase 1 — Data Architecture (COMPLETE)

> **Version:** `0.1.0` | **Status:** COMPLETE

### Deliverables (All Done)

| # | Task | Status |
|:-:|------|:------:|
| 1 | `project.godot` with autoloads | DONE |
| 2 | `global_enums.gd` — 7 enums | DONE |
| 3 | `card_resource.gd` — card data model with mastery, evolution | DONE |
| 4 | `grimoire_resource.gd` — grimoire data model with alignment, progression | DONE |
| 5 | `inscription_resource.gd` — passive buff data | DONE |
| 6 | `enemy_resource.gd` — enemy stat block | DONE |
| 7 | `evolution_manager.gd` — card evolution + alignment shift | DONE |
| 8 | `alignment_manager.gd` — moral choice + battle usage shifts | DONE |
| 9 | `grimoire_generator.gd` — seed-based procedural generation | DONE |
| 10 | `mastery_tracker.gd` — card XP awards | DONE |
| 11 | `combat_manager.gd` — stub for Phase 2 | DONE |
| 12 | `game_manager.gd` — save/load via ResourceSaver/Loader | DONE |
| 13 | 11 sample `.tres` files (8 base + 3 evolved) | DONE |
| 14 | `test_phase1.gd` — all tests passing | DONE |
| 15 | GDD.md, TDD.md, ART_BIBLE.md, ADD.md, CGP.md, ECONOMY.md | DONE |

### Phase 1 Exit Criteria — ALL MET
- [x] Project loads in Godot 4 with no script errors
- [x] GlobalEnums autoload active
- [x] CardResource `.tres` shows all @export fields with enum dropdowns
- [x] GrimoireResource accepts CardResource arrays
- [x] Test script passes: generation, mastery, evolution, alignment, save/load

---

## 5. Phase 2 — Battle System

> **Version:** `0.2.0` | **Status:** COMPLETE | **Depends on:** Phase 1

### Goal
Implement the full turn-based combat loop. Player draws cards, spends mana, plays cards against enemies with visible intent. Battle ends when HP hits 0.

### 5.1 New Enums (add to `global_enums.gd`)

| Enum | Values |
|------|--------|
| `EffectType` | DAMAGE, HEAL, BLOCK, POISON, BURN, DRAW, MANA_GAIN, BUFF_ATTACK, DEBUFF_ATTACK |
| `StatusType` | POISON, BURN, WEAKNESS, STRENGTH, SHIELD, REGEN |
| `ConditionType` | NONE, IF_ALIGNMENT_MATCH, IF_HP_BELOW_HALF, IF_FIRST_PLAY |
| `EnemyIntent` | ATTACK, DEFEND, BUFF, DEBUFF, SPECIAL |
| `BattleState` | NOT_STARTED, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT |

### 5.2 New Resources

| File | Purpose |
|------|---------|
| `scripts/data/effect_resource.gd` | Data-driven card effect (type, value, target, duration, condition) |
| `scripts/data/status_effect_resource.gd` | Active status on a combatant (type, stacks, remaining turns) |

### 5.3 New Systems

| File | Purpose |
|------|---------|
| `scripts/systems/combat_manager.gd` | Full rewrite — battle state machine (FSM), turn loop, win/loss |
| `scripts/systems/effect_resolver.gd` | Resolves EffectResource against targets, applies damage/heal/status |
| `scripts/systems/enemy_ai.gd` | Selects enemy intent based on HP%, player state, weighted random |
| `scripts/systems/deck_manager.gd` | Draw pile, hand, discard pile, shuffle logic |

### 5.4 New Scenes & UI

| File | Purpose |
|------|---------|
| `scenes/battle/battle_scene.tscn` | Main battle scene — layout for enemy area, play area, hand, HUD |
| `scenes/battle/card_node.tscn` | Visual card in hand — draggable, hoverable, shows stats |
| `scenes/battle/enemy_node.tscn` | Enemy display — HP bar, intent icon, status effects |
| `scripts/ui/card_hand_ui.gd` | Manages fan layout of cards in hand, drag-to-play |
| `scripts/ui/battle_hud.gd` | Player HP, mana pips, block, alignment attunement buttons |
| `scripts/ui/enemy_display.gd` | Enemy HP bar, intent display, status icons |

### 5.5 Enemy Data

Create 5+ enemy `.tres` files with varied intents:
- Ink Wisp (easy, attack-only)
- Page Worm (applies poison)
- Dust Golem (high HP, defend-heavy)
- Rune Sprite (buffs self, then attacks)
- Chapter Guardian (boss — multi-phase)

### 5.6 Refactors

- Deduplicate alignment shift logic (EvolutionManager + AlignmentManager share code)
- Implement atomic save (write to `.tmp`, rename on success)
- Move `test_phase1.gd` to `tests/` folder

### 5.7 Tests

| Test File | Validates |
|-----------|-----------|
| `tests/test_combat.gd` | Full battle loop: start → draw → play card → enemy turn → resolve → end |
| `tests/test_effects.gd` | Each EffectType resolves correctly (damage, heal, poison tick, etc.) |
| `tests/test_deck.gd` | Draw, discard, shuffle, hand limit |

### Phase 2 Exit Criteria
- [x] Battle scene loads with a Grimoire and 1+ enemies
- [x] Player can draw cards, play cards (spend mana), and end turn
- [x] Enemy intent is displayed and resolves correctly
- [x] Alignment Attunement reduces matching card costs by 1
- [x] Card XP is awarded after battle
- [x] Battle ends when either side reaches 0 HP
- [x] All Phase 2 tests pass

### Phase 2 TODO

```
[x] 2.01  Add new enums to global_enums.gd (EffectType, StatusType, ConditionType, EnemyIntent, BattleState)
[x] 2.02  Create effect_resource.gd (extends Resource)
[x] 2.03  Create status_effect_resource.gd (extends Resource)
[x] 2.04  Extend enemy_resource.gd (add combat fields: attack_damage, block_value, buff_value, intent_weights, enrage)
[x] 2.05  Create deck_manager.gd (draw pile, hand, discard, shuffle)
[x] 2.06  Rewrite combat_manager.gd as battle FSM (NOT_STARTED → PLAYER_TURN ↔ ENEMY_TURN → VICTORY/DEFEAT)
[x] 2.07  Create effect_resolver.gd (apply damage, heal, block, status effects, conditional checks)
[x] 2.08  Create enemy_ai.gd (intent selection from weighted patterns based on HP% and battle state)
[x] 2.09  Create battle_scene.tscn (layout: enemy area top, play area mid, hand bottom, HUD overlay)
[x] 2.10  Create card_node.tscn + card_hand_ui.gd (fan layout, hover preview, drag to play area)
[x] 2.11  Create enemy_node.tscn + enemy_display.gd (HP bar, intent icon, status effect icons)
[x] 2.12  Create battle_hud.gd (HP bar, mana pips, block counter, attunement buttons, end turn button)
[x] 2.13  Implement Alignment Attunement (declare alignment → matching cards cost -1 mana this turn)
[x] 2.14  Implement end-of-battle rewards (card XP via MasteryTracker, grimoire XP)
[x] 2.15  Create 5 enemy .tres files (Ink Wisp, Page Worm, Dust Golem, Rune Sprite, Chapter Guardian)
[ ] 2.16  Update existing card .tres files with EffectResource references
[x] 2.17  Deduplicate alignment shift logic between EvolutionManager and AlignmentManager
[x] 2.18  Implement atomic saves in GameManager (write .tmp → rename)
[x] 2.19  Move test_phase1.gd to tests/ folder
[x] 2.20  Write test_combat.gd
[x] 2.21  Write test_effects.gd
[x] 2.22  Write test_deck.gd
[x] 2.23  Run full regression (Phase 1 + Phase 2 tests) — 74/74 passed
[x] 2.24  Milestone review: verify all Phase 2 exit criteria
```

---

## 6. Phase 3 — PvE Campaign

> **Version:** `0.3.0` | **Status:** COMPLETE | **Depends on:** Phase 2

### Goal
Build the PvE chapter structure. Player navigates a node map, fights encounters, faces moral choices, battles a boss. One playable 15-minute session from start to extraction.

### 6.1 New Resources

| File | Purpose |
|------|---------|
| `scripts/data/chapter_resource.gd` | Chapter definition — theme, node sequence, boss, difficulty |
| `scripts/data/encounter_resource.gd` | Single encounter node — enemy list, rewards |
| `scripts/data/moral_choice_resource.gd` | Choice event — prompt text, options, alignment shifts, mechanical rewards |

### 6.2 New Enums

| Enum | Values |
|------|--------|
| `NodeType` | COMBAT, MORAL_CHOICE, TREASURE, REST, BOSS |
| `ChapterTheme` | FORGOTTEN_LIBRARY, BURNING_ARCHIVE, OVERGROWN_SCRIPTORIUM |

### 6.3 New Systems

| File | Purpose |
|------|---------|
| `scripts/systems/chapter_generator.gd` | Builds node map from ChapterResource (handcrafted for MVP) |
| `scripts/systems/encounter_manager.gd` | Transitions between nodes, tracks chapter progress, extraction |

### 6.4 New Scenes & UI

| File | Purpose |
|------|---------|
| `scenes/hub/grimoire_hub.tscn` | Main menu as Grimoire — page-turn navigation |
| `scenes/campaign/chapter_map.tscn` | Node map for chapter progression |
| `scenes/campaign/moral_choice_scene.tscn` | Moral choice event display |
| `scenes/campaign/treasure_scene.tscn` | Lost Page / reward selection |
| `scenes/campaign/rest_scene.tscn` | HP recovery between encounters |

### 6.5 Content

- 3 handcrafted chapters (5–7 nodes each)
- 1 boss per chapter (alignment-themed)
- 3 moral choice events (1 per chapter)
- Treasure node rewards
- Rest node HP recovery

### Phase 3 Exit Criteria
- [x] Player can navigate chapter map from node to node
- [x] Combat nodes launch battle_scene with correct enemies
- [x] Moral choice events display 3 options and apply alignment shifts
- [x] Boss encounter loads at chapter end
- [x] Chapter completion awards Grimoire XP
- [x] Failed chapter = lose unbound Lost Pages (extraction risk)
- [x] Session lasts approximately 15 minutes

### Phase 3 TODO

```
[x] 3.01  Add NodeType, ChapterTheme enums to global_enums.gd
[x] 3.02  Create chapter_resource.gd
[x] 3.03  Create encounter_resource.gd
[x] 3.04  Create moral_choice_resource.gd
[x] 3.05  Create chapter_generator.gd (load handcrafted chapter data → node list)
[x] 3.06  Create encounter_manager.gd (track chapter state, node transitions, extraction)
[x] 3.07  Create grimoire_hub.tscn + grimoire_hub_controller.gd
[x] 3.08  Create chapter_map.tscn + chapter_map_controller.gd
[x] 3.09  Create moral_choice_scene.tscn + moral_choice_controller.gd
[x] 3.10  Create treasure_scene.tscn + treasure_controller.gd
[x] 3.11  Create rest_scene.tscn + rest_controller.gd
[x] 3.12  Design Chapter 1: "The Forgotten Library" (Radiant, 6 nodes)
[x] 3.13  Design Chapter 2: "The Burning Archive" (Vile, 6 nodes)
[x] 3.14  Design Chapter 3: "The Overgrown Scriptorium" (Primal, 7 nodes)
[x] 3.15  Create 3 moral choice .tres files (wounded_scribe, burning_archive, overgrown_spirit)
[x] 3.16  Create 3 boss enemy .tres files (silent_librarian, ember_archivist, root_warden)
[x] 3.17  Implement extraction risk (die in chapter → lose unbound pages)
[x] 3.18  Wire Grimoire Hub → Chapter Select → Chapter Map → Battle → Results flow
[x] 3.19  Write test_chapter_gen.gd — 41/41 passed
[x] 3.20  Run full regression (Phases 1–3) — 115/115 passed
[x] 3.21  Set main scene to grimoire_hub.tscn
[x] 3.22  Milestone review: Internal Alpha gate criteria
```

---

## 7. Phase 4 — Content & Progression

> **Version:** `0.4.0` | **Status:** TODO | **Depends on:** Phase 3

### Goal
Fill out the full card library, implement all progression systems, and validate seed balance. This phase transforms the prototype into a content-complete game.

### 7.1 Card Content

| Task | Details |
|------|---------|
| 30 base cards | Across all types (Attack, Defense, Support, Special) and rarities |
| 10+ evolution trees | Each with 3 alignment paths = 30+ evolved card variants |
| Card balance spreadsheet | DPS-per-mana, heal-per-mana, effect-per-cost ratios |
| Mana curve validation | Ensure 3-mana starting budget allows meaningful turns |

### 7.2 Systems

| File | Purpose |
|------|---------|
| `scripts/systems/seed_validator.gd` | Simulates 1,000 sample hands per seed, rejects unplayable seeds |
| `scripts/systems/inscription_manager.gd` | Inscription crafting, slot management, passive buff application |
| Update `grimoire_generator.gd` | Seed-based card pool selection from full 30-card library |

### 7.3 Progression

- Grimoire leveling 1–20 (XP curve, level-up rewards)
- Deck size scaling (20 → 40 by level 20)
- Inscription slot unlocks (0 at level 1 → 4 at level 16+)
- Ultimate Spell generation at level 20

### Phase 4 Exit Criteria
- [ ] 30 base cards with stats, effects, and `.tres` files
- [ ] 10+ cards have 3-path evolution trees (30+ evolved variants)
- [ ] Seed validator rejects seeds that produce < 2 cards per type
- [ ] Grimoire levels 1–20 with correct deck size / inscription scaling
- [ ] Inscription system: equip/unequip from available slots
- [ ] Balance pass: no single card dominates across all seeds
- [ ] Full card library loads in Godot editor without errors

### Phase 4 TODO

```
[ ] 4.01  Design 30 base cards in spreadsheet (name, type, alignment, rarity, mana, value, effect, description)
[ ] 4.02  Create 30 base card .tres files
[ ] 4.03  Design 10 evolution trees (3 paths each = 30 evolved cards)
[ ] 4.04  Create 30 evolved card .tres files with EffectResource references
[ ] 4.05  Link evolution paths in base card .tres files (evolution_radiant/vile/primal)
[ ] 4.06  Create seed_validator.gd — simulate 1,000 hands, guarantee 2+ cards per type
[ ] 4.07  Update grimoire_generator.gd — select 20 cards from full library using seed
[ ] 4.08  Create inscription_manager.gd — slot management, equip/unequip, passive buff application
[ ] 4.09  Create 6+ inscription .tres files (2 per alignment)
[ ] 4.10  Implement Grimoire XP curve (levels 1–20)
[ ] 4.11  Implement deck size scaling per level
[ ] 4.12  Implement inscription slot unlocks per level
[ ] 4.13  Implement Ultimate Spell generation at level 20 (seed + alignment → unique card)
[ ] 4.14  Balance pass — DPS/mana, heal/mana, effect/cost ratios across all 60+ cards
[ ] 4.15  Write test_seed_validator.gd
[ ] 4.16  Write test_inscriptions.gd
[ ] 4.17  Write test_progression.gd (leveling curve, deck size, slot unlocks)
[ ] 4.18  Run full regression (Phases 1–4)
[ ] 4.19  Milestone review: MVP Content Complete gate criteria
```

---

## 8. Phase 5 — Visual & Audio Polish

> **Version:** `0.5.0` | **Status:** TODO | **Depends on:** Phase 4

### Goal
Transform programmer art into the dark-fantasy illuminated manuscript aesthetic defined in ART_BIBLE.md. Implement the dynamic audio system from ADD.md. Prepare export builds.

### 8.1 Art Pipeline

| Category | Asset Count (Estimate) | Reference |
|----------|:---------------------:|-----------|
| Card illustrations | 60+ (30 base + 30 evolved) | ART_BIBLE.md §4 |
| Grimoire cover textures | 5 (one per cover type) | ART_BIBLE.md §3 |
| Grimoire page backgrounds | 3 (per alignment) | ART_BIBLE.md §3 |
| Enemy sprites | 8+ (5 base + 3 bosses) | ART_BIBLE.md §5 |
| UI elements | ~30 (buttons, bars, icons, frames) | ART_BIBLE.md §7 |
| VFX / particles | ~15 (aura, corruption, damage, heal, status) | ART_BIBLE.md §8 |

### 8.2 Shaders

| Shader | Purpose |
|--------|---------|
| `aura_pulse.gdshader` | Grimoire aura glow pulsing with alignment color |
| `corruption.gdshader` | Visual corruption overlay based on alignment shifts |
| `page_turn.gdshader` | Page flip transition for Grimoire navigation |
| `card_glow.gdshader` | Hover/play glow on cards |
| `damage_flash.gdshader` | Enemy hit feedback |

### 8.3 Audio Pipeline

| Category | Asset Count (Estimate) | Reference |
|----------|:---------------------:|-----------|
| Music tracks | 6–8 (layered stems) | ADD.md §2 |
| UI SFX | ~20 (page turn, button, card play) | ADD.md §3 |
| Combat SFX | ~40 (damage types, shields, heals, status) | ADD.md §3 |
| Ambient loops | ~10 (library hum, fire crackle, wind) | ADD.md §3 |
| Grimoire voice | ~15 (hum, whisper, rumble per state) | ADD.md §3 |

### 8.4 Systems

| File | Purpose |
|------|---------|
| `autoload/audio_manager.gd` | Dynamic audio layer management, bus routing |
| `scripts/ui/transition_manager.gd` | Page-turn scene transitions |
| `scripts/ui/settings_menu.gd` | Quality settings (Low/Medium/High), volume sliders |

### Phase 5 Exit Criteria
- [ ] All cards have final art
- [ ] Grimoire has idle animations (page flutter, aura pulse)
- [ ] Dynamic music responds to battle state (calm → tension → combat → boss)
- [ ] SFX play for all card types, enemy actions, UI interactions
- [ ] Shaders render correctly on all target platforms
- [ ] Quality settings (Low/Medium/High) affect particles and shader complexity
- [ ] Export presets configured for Windows, Linux, macOS
- [ ] Performance profiling: 60fps on target hardware at Medium settings

### Phase 5 TODO

```
[ ] 5.01  Create card illustration pipeline (template, sketches, inking, color)
[ ] 5.02  Produce 30 base card illustrations
[ ] 5.03  Produce 30 evolved card illustrations
[ ] 5.04  Create 5 Grimoire cover textures
[ ] 5.05  Create 3 alignment-themed page backgrounds
[ ] 5.06  Create 8+ enemy sprites (idle + hit + death frames)
[ ] 5.07  Create UI element sprites (HP bar, mana pips, intent icons, card frame, buttons)
[ ] 5.08  Write aura_pulse.gdshader
[ ] 5.09  Write corruption.gdshader
[ ] 5.10  Write page_turn.gdshader
[ ] 5.11  Write card_glow.gdshader
[ ] 5.12  Write damage_flash.gdshader
[ ] 5.13  Create Grimoire idle animations (page flutter, sigil rotation, aura breathing)
[ ] 5.14  Create card play animations (hand → play area → resolve)
[ ] 5.15  Create enemy hit/death animations
[ ] 5.16  Compose 6–8 music tracks with layered stems
[ ] 5.17  Create audio_manager.gd autoload (layer management, crossfades, bus routing)
[ ] 5.18  Implement 5-bus audio architecture (Master, Music, SFX, Ambient, Voice)
[ ] 5.19  Record/source ~20 UI SFX
[ ] 5.20  Record/source ~40 combat SFX
[ ] 5.21  Record/source ~10 ambient loops
[ ] 5.22  Record/source ~15 Grimoire "voice" sounds
[ ] 5.23  Implement dynamic music triggers (calm/tension/combat/boss/victory/defeat)
[ ] 5.24  Create transition_manager.gd (page-turn transitions between scenes)
[ ] 5.25  Create settings_menu.gd (quality presets, volume sliders)
[ ] 5.26  Implement quality scaling (Low: no particles/shaders, Medium: reduced, High: full)
[ ] 5.27  Configure export presets (Windows, Linux, macOS)
[ ] 5.28  Performance profiling on target hardware (i5-1035G1, 8GB RAM, 1080p)
[ ] 5.29  Optimization pass (draw calls, particle count ≤ 500, texture atlas)
[ ] 5.30  Adopt GdUnit4 for automated testing
[ ] 5.31  Set up CI pipeline (build + test on push)
[ ] 5.32  Run full regression (Phases 1–5)
[ ] 5.33  Milestone review: Early Access gate criteria
```

---

## 9. Phase 6 — PvP & Live Service

> **Version:** `0.6.0` | **Status:** TODO | **Depends on:** Phase 5

### Goal
Add multiplayer PvP (1v1), matchmaking, leaderboards, seasonal content rotation, and the cosmetic DLC pipeline. Transition from Early Access to full release.

### 6.1 Networking

| File | Purpose |
|------|---------|
| `scripts/networking/pvp_session.gd` | WebRTC peer connection, state sync |
| `scripts/networking/signaling_client.gd` | WebSocket connection to signaling server |
| `scripts/networking/state_hasher.gd` | Anti-cheat: hash game state for verification |

### 6.2 Backend (Minimal)

| Component | Purpose |
|-----------|---------|
| Signaling server | WebSocket relay for WebRTC handshake (Node.js or Godot server) |
| Leaderboard API | REST endpoint for score submission/retrieval |
| Account system | Basic auth for persistent MMR tracking |

### 6.3 Game Systems

| File | Purpose |
|------|---------|
| `scripts/systems/pvp_combat_manager.gd` | CombatManager variant for networked turns, timeout handling |
| `scripts/systems/matchmaking.gd` | Grimoire Level + MMR-based matching |
| `scripts/systems/leaderboard_manager.gd` | Seasonal ranking, submission, retrieval |

### 6.4 Cosmetic DLC

| File | Purpose |
|------|---------|
| `scripts/systems/cosmetic_manager.gd` | Skin/aura/card-back application, ownership tracking |
| DLC content packs | Grimoire skins, aura effects, card backs (per ECONOMY.md) |

### Phase 6 Exit Criteria
- [ ] 1v1 PvP matches complete without desync
- [ ] Matchmaking pairs by Grimoire Level + MMR
- [ ] Anti-cheat detects modified seeds and invalid state transitions
- [ ] Leaderboard displays global ranking with seasonal resets
- [ ] Cosmetic DLC can be purchased and applied without affecting gameplay
- [ ] Full game runs stable for 2-hour sessions without crashes

### Phase 6 TODO

```
[ ] 6.01  Research and prototype WebRTC in Godot 4.x
[ ] 6.02  Create pvp_session.gd (WebRTC connection, offer/answer exchange)
[ ] 6.03  Create signaling_client.gd (WebSocket to signaling server)
[ ] 6.04  Build minimal signaling server (WebSocket relay)
[ ] 6.05  Create pvp_combat_manager.gd (networked turn loop, timeout, disconnect handling)
[ ] 6.06  Create state_hasher.gd (hash grimoire seed + game state for anti-cheat)
[ ] 6.07  Create matchmaking.gd (queue, level + MMR matching, wager setup)
[ ] 6.08  Create leaderboard_manager.gd (submit score, fetch rankings, seasonal reset)
[ ] 6.09  Build leaderboard REST API
[ ] 6.10  Implement basic account system (authentication for MMR persistence)
[ ] 6.11  Create PvP battle UI variant (opponent grimoire info, connection status, timer)
[ ] 6.12  Implement wager matches (bet Gold/XP, XP floor protection)
[ ] 6.13  Implement Alignment Clash PvP bonus (opposing alignments → mana regen boost)
[ ] 6.14  Create cosmetic_manager.gd (skin ownership, application, preview)
[ ] 6.15  Create first cosmetic DLC pack (3 grimoire skins, 3 aura effects, 3 card backs)
[ ] 6.16  Implement DLC purchase flow (platform store integration)
[ ] 6.17  Stress test: 100 concurrent PvP matches
[ ] 6.18  Security audit: anti-cheat, state validation, seed verification
[ ] 6.19  2-hour stability test (no crashes, no memory leaks)
[ ] 6.20  Run full regression (Phases 1–6)
[ ] 6.21  Milestone review: Full Release gate criteria
```

---

## 10. Risk Register

| # | Risk | Impact | Likelihood | Phase | Mitigation |
|:-:|------|:------:|:----------:|:-----:|------------|
| R1 | Seed produces unplayable combos | High | Medium | 4 | Seed validator simulates 1,000 hands, rejects bad seeds |
| R2 | Battle system feels like Slay the Spire clone | Medium | Medium | 2 | Alignment Attunement + soulbound deck = differentiation. Playtest early |
| R3 | 90 evolved cards impossible to balance | High | High | 4 | Stat-shift templates. Shared effect system with standardized values |
| R4 | Scope creep from PvP ideas leaking into MVP | High | High | 2–4 | PvP is Phase 6 only. MVP is strictly single-player. Enforce via this roadmap |
| R5 | Art pipeline bottleneck (60+ illustrations) | High | High | 5 | Start art for Phase 2 enemies early. Use placeholder art until Phase 5 |
| R6 | WebRTC complexity in Godot | Medium | Medium | 6 | Prototype in Phase 5 spare time. Fallback: polling-based async PvP |
| R7 | GDScript performance in large battles | Low | Low | 2 | Max 40-card deck, max 3 enemies. Profile in Phase 2. GDExtension as escape hatch |
| R8 | "Best alignment" meta emerges | Medium | Medium | 4 | Equal power budgets. Conflicted state offers unique hybrid cards |
| R9 | Player fatigue (same 20 cards) | Medium | Medium | 4 | Evolution branching, Lost Pages, deck size growth to 40 |
| R10 | Early Access negative reception | High | Medium | 5 | Gate EA on polished vertical slice. Content-complete before store page |

---

## 11. Release Strategy

### 11.1 Release Timeline

| Stage | Phase Gate | Audience | Distribution |
|-------|-----------|----------|-------------|
| **Internal Alpha** | Phase 3 complete | Dev team + trusted testers (5–10) | Direct builds |
| **Closed Beta** | Phase 4 complete | Community applicants (50–100) | Itch.io keys |
| **Early Access** | Phase 5 complete | Public | Steam EA ($9.99) |
| **Full Release** | Phase 6 complete | Public | Steam/GOG ($14.99–$19.99) |

### 11.2 Version Numbering

| Version | Meaning |
|---------|---------|
| `0.1.x` | Phase 1 — Data only, no playable game |
| `0.2.x` | Phase 2 — Battle system playable |
| `0.3.x` | Phase 3 — PvE sessions playable |
| `0.4.x` | Phase 4 — Content complete, balance in progress |
| `0.5.x` | Phase 5 — Early Access candidate |
| `0.6.x` | Phase 6 — PvP + Live features |
| `1.0.0` | Full Release |

### 11.3 Store Page Timing

- **Steam page live:** During Phase 4 (wishlists build during content phase)
- **Trailer:** Phase 5 (requires final art/audio)
- **Press kit:** Phase 5
- **EA launch:** End of Phase 5

---

## 12. Master TODO

> The single source of truth for task tracking. Update status as work progresses.
> Status key: `[x]` = done, `[ ]` = pending, `[~]` = in progress

### Phase 1 — Data Architecture ✅

```
[x] 1.01  Create project.godot with autoloads
[x] 1.02  Create global_enums.gd (7 enums)
[x] 1.03  Create card_resource.gd
[x] 1.04  Create grimoire_resource.gd
[x] 1.05  Create inscription_resource.gd
[x] 1.06  Create enemy_resource.gd
[x] 1.07  Create evolution_manager.gd
[x] 1.08  Create alignment_manager.gd
[x] 1.09  Create grimoire_generator.gd
[x] 1.10  Create mastery_tracker.gd
[x] 1.11  Create combat_manager.gd (stub)
[x] 1.12  Create game_manager.gd
[x] 1.13  Create 11 sample .tres files
[x] 1.14  Create test_phase1.gd — all tests passing
[x] 1.15  Create GDD.md
[x] 1.16  Create TDD.md
[x] 1.17  Create ART_BIBLE.md
[x] 1.18  Create ADD.md
[x] 1.19  Create CGP.md
[x] 1.20  Create ECONOMY.md
[x] 1.21  Create ROADMAP.md
```

### Phase 2 — Battle System ✅

```
[x] 2.01  Add new enums to global_enums.gd
[x] 2.02  Create effect_resource.gd
[x] 2.03  Create status_effect_resource.gd
[x] 2.04  Extend enemy_resource.gd with combat fields
[x] 2.05  Create deck_manager.gd
[x] 2.06  Rewrite combat_manager.gd (battle FSM)
[x] 2.07  Create effect_resolver.gd
[x] 2.08  Create enemy_ai.gd
[x] 2.09  Create battle_scene.tscn
[x] 2.10  Create card_node.tscn + card_hand_ui.gd
[x] 2.11  Create enemy_node.tscn + enemy_display.gd
[x] 2.12  Create battle_hud.gd
[x] 2.13  Implement Alignment Attunement
[x] 2.14  Implement end-of-battle rewards
[x] 2.15  Create 5 enemy .tres files
[ ] 2.16  Update card .tres files with EffectResource references
[x] 2.17  Deduplicate alignment shift logic
[x] 2.18  Implement atomic saves
[x] 2.19  Move test_phase1.gd to tests/
[x] 2.20  Write test_combat.gd
[x] 2.21  Write test_effects.gd
[x] 2.22  Write test_deck.gd
[x] 2.23  Run full regression — 74/74 passed
[x] 2.24  Milestone review: First Playable
```

### Phase 3 — PvE Campaign ✅

```
[x] 3.01  Add NodeType, ChapterTheme enums
[x] 3.02  Create chapter_resource.gd
[x] 3.03  Create encounter_resource.gd
[x] 3.04  Create moral_choice_resource.gd
[x] 3.05  Create chapter_generator.gd
[x] 3.06  Create encounter_manager.gd
[x] 3.07  Create grimoire_hub.tscn + controller
[x] 3.08  Create chapter_map.tscn + controller
[x] 3.09  Create moral_choice_scene.tscn + controller
[x] 3.10  Create treasure_scene.tscn + controller
[x] 3.11  Create rest_scene.tscn + controller
[x] 3.12  Design Chapter 1: The Forgotten Library
[x] 3.13  Design Chapter 2: The Burning Archive
[x] 3.14  Design Chapter 3: The Overgrown Scriptorium
[x] 3.15  Create 3 moral choice .tres files
[x] 3.16  Create 3 boss enemy .tres files
[x] 3.17  Implement extraction risk
[x] 3.18  Wire full session flow (Hub → Map → Battle → Results)
[x] 3.19  Write test_chapter_gen.gd — 41/41 passed
[x] 3.20  Run full regression — 115/115 passed
[x] 3.21  Set main scene to grimoire_hub.tscn
[x] 3.22  Milestone review: Internal Alpha
```

### Phase 4 — Content & Progression

```
[ ] 4.01  Design 30 base cards in spreadsheet
[ ] 4.02  Create 30 base card .tres files
[ ] 4.03  Design 10 evolution trees (30 evolved cards)
[ ] 4.04  Create 30 evolved card .tres files
[ ] 4.05  Link evolution paths in base card .tres
[ ] 4.06  Create seed_validator.gd
[ ] 4.07  Update grimoire_generator.gd for full library
[ ] 4.08  Create inscription_manager.gd
[ ] 4.09  Create 6+ inscription .tres files
[ ] 4.10  Implement Grimoire XP curve (1–20)
[ ] 4.11  Implement deck size scaling
[ ] 4.12  Implement inscription slot unlocks
[ ] 4.13  Implement Ultimate Spell generation
[ ] 4.14  Balance pass across all cards
[ ] 4.15  Write test_seed_validator.gd
[ ] 4.16  Write test_inscriptions.gd
[ ] 4.17  Write test_progression.gd
[ ] 4.18  Run full regression
[ ] 4.19  Milestone review: Content Complete / MVP
```

### Phase 5 — Visual & Audio Polish

```
[ ] 5.01  Card illustration pipeline setup
[ ] 5.02  30 base card illustrations
[ ] 5.03  30 evolved card illustrations
[ ] 5.04  5 Grimoire cover textures
[ ] 5.05  3 alignment page backgrounds
[ ] 5.06  8+ enemy sprites
[ ] 5.07  UI element sprites
[ ] 5.08  Shader: aura_pulse.gdshader
[ ] 5.09  Shader: corruption.gdshader
[ ] 5.10  Shader: page_turn.gdshader
[ ] 5.11  Shader: card_glow.gdshader
[ ] 5.12  Shader: damage_flash.gdshader
[ ] 5.13  Grimoire idle animations
[ ] 5.14  Card play animations
[ ] 5.15  Enemy hit/death animations
[ ] 5.16  Compose 6–8 music tracks
[ ] 5.17  Create audio_manager.gd
[ ] 5.18  5-bus audio architecture
[ ] 5.19  ~20 UI SFX
[ ] 5.20  ~40 combat SFX
[ ] 5.21  ~10 ambient loops
[ ] 5.22  ~15 Grimoire voice sounds
[ ] 5.23  Dynamic music triggers
[ ] 5.24  Create transition_manager.gd
[ ] 5.25  Create settings_menu.gd
[ ] 5.26  Quality scaling implementation
[ ] 5.27  Export presets (Win/Linux/Mac)
[ ] 5.28  Performance profiling
[ ] 5.29  Optimization pass
[ ] 5.30  Adopt GdUnit4
[ ] 5.31  CI pipeline
[ ] 5.32  Run full regression
[ ] 5.33  Milestone review: Early Access
```

### Phase 6 — PvP & Live Service

```
[ ] 6.01  WebRTC prototype
[ ] 6.02  pvp_session.gd
[ ] 6.03  signaling_client.gd
[ ] 6.04  Signaling server
[ ] 6.05  pvp_combat_manager.gd
[ ] 6.06  state_hasher.gd
[ ] 6.07  matchmaking.gd
[ ] 6.08  leaderboard_manager.gd
[ ] 6.09  Leaderboard REST API
[ ] 6.10  Account system
[ ] 6.11  PvP battle UI
[ ] 6.12  Wager matches
[ ] 6.13  Alignment Clash PvP bonus
[ ] 6.14  cosmetic_manager.gd
[ ] 6.15  First cosmetic DLC pack
[ ] 6.16  DLC purchase flow
[ ] 6.17  Stress test (100 concurrent matches)
[ ] 6.18  Security audit
[ ] 6.19  2-hour stability test
[ ] 6.20  Run full regression
[ ] 6.21  Milestone review: Full Release (v1.0.0)
```

---

### Task Summary

| Phase | Tasks | Status |
|:-----:|:-----:|:------:|
| 1 | 21 | 21/21 COMPLETE |
| 2 | 24 | 23/24 COMPLETE |
| 3 | 22 | 22/22 COMPLETE |
| 4 | 19 | 0/19 |
| 5 | 33 | 0/33 |
| 6 | 21 | 0/21 |
| **Total** | **140** | **66/140 (47%)** |

---

*This roadmap is a living document. Update task statuses after each work session. Review milestone gates before advancing phases. When in doubt, check the [Core Game Pillars](CGP.md) — if a task doesn't serve a pillar, cut it.*
