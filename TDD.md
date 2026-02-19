# Grimoire: The Soulbound Legacy — Technical Design Document

> **Version:** 1.0
> **Last Updated:** 2026-02-18
> **Companion Document:** [GDD.md](GDD.md) (Game Design Document)
> **Engine:** Godot 4.5.1 (stable) | **Language:** GDScript (strict typing)
> **Target Platforms:** Windows, Linux, macOS (desktop-first) | Mobile as stretch goal

---

## Table of Contents

1. [Engine Choice & Justification](#1-engine-choice--justification)
2. [Architecture](#2-architecture)
3. [Folder Structure](#3-folder-structure)
4. [Data Layer](#4-data-layer)
5. [Card Effect System](#5-card-effect-system)
6. [Combat System Architecture](#6-combat-system-architecture)
7. [Procedural Generation Pipeline](#7-procedural-generation-pipeline)
8. [Save System](#8-save-system)
9. [Networking Model (PvP)](#9-networking-model-pvp)
10. [Scene Tree & Node Architecture](#10-scene-tree--node-architecture)
11. [Performance Constraints](#11-performance-constraints)
12. [Platform Targets & Export](#12-platform-targets--export)
13. [Testing Strategy](#13-testing-strategy)
14. [Build & Release Pipeline](#14-build--release-pipeline)
15. [Technical Debt Prevention](#15-technical-debt-prevention)
16. [Phase Implementation Map](#16-phase-implementation-map)
17. [Appendix A: Current Codebase Inventory](#appendix-a-current-codebase-inventory)

---

## 1. Engine Choice & Justification

### 1.1 Why Godot 4.x

| Factor | Godot 4.x | Unity | Unreal |
|--------|-----------|-------|--------|
| **License** | MIT (free forever, no royalties) | Runtime fee at revenue thresholds | 5% royalty above $1M |
| **2D Card Game Fit** | Native 2D engine, first-class support | Bolt-on 2D over 3D renderer | Overkill for 2D |
| **Scripting** | GDScript (Python-like, fast iteration) | C# (heavier, slower compile) | C++/Blueprints (heavy tooling) |
| **Resource System** | Native `.tres` serialization — perfect for card/grimoire data | ScriptableObjects (similar but more boilerplate) | DataAssets (complex setup) |
| **Export Size** | ~30MB base | ~80MB+ base | ~200MB+ base |
| **Community** | Growing rapidly, strong for indie 2D | Massive but trust issues post-pricing | Overkill community for card games |

**Decision:** Godot 4.5.1 stable. The Resource system is a natural fit for card game data. MIT license eliminates revenue risk. GDScript with strict typing provides type safety without C# overhead.

### 1.2 Version Pinning

- **Engine:** Godot 4.5.1 stable (`f62fdbde1`)
- **Minimum:** 4.3 (required for typed `Array[Resource]` exports and `@export_group`)
- **Upgrade Policy:** Only upgrade engine version between development phases, never mid-phase. Test full regression suite before upgrading.

### 1.3 Language: GDScript (Strict Typing)

All scripts use strict typing conventions:

```gdscript
# CORRECT — explicit types everywhere
var damage: int = 0
func calculate_damage(card: CardResource, target: EnemyResource) -> int:
    return card.get_effective_value()

# INCORRECT — no implicit typing
var damage = 0
func calculate_damage(card, target):
    return card.get_effective_value()
```

**Why not C#?** GDScript's tight engine integration means faster iteration, smaller export sizes, and no Mono/.NET dependency. The game's complexity doesn't warrant C#'s performance ceiling — all hot loops are simple integer math on Resource properties.

**Why not GDExtension/C++?** No system in this game requires native performance. Card resolution is O(n) over a max 40-card deck. If profiling reveals a bottleneck (unlikely), individual systems can be ported to GDExtension without refactoring.

---

## 2. Architecture

### 2.1 Architectural Pattern: Resource-Centric MVC

The project uses a **modified MVC (Model-View-Controller)** pattern adapted for Godot's strengths:

```
┌──────────────────────────────────────────────────────────────┐
│                     ARCHITECTURE OVERVIEW                     │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐    │
│  │  MODEL (Resources — scripts/data/)                   │    │
│  │                                                      │    │
│  │  CardResource    GrimoireResource                    │    │
│  │  EnemyResource   InscriptionResource                 │    │
│  │  EffectResource  (Phase 2+)                          │    │
│  │                                                      │    │
│  │  Pure data. No logic beyond self-validation.         │    │
│  │  Serializable via ResourceSaver/ResourceLoader.      │    │
│  └──────────────┬───────────────────────────────────────┘    │
│                 │ passed as arguments                         │
│  ┌──────────────▼───────────────────────────────────────┐    │
│  │  CONTROLLER (Managers — scripts/systems/)            │    │
│  │                                                      │    │
│  │  EvolutionManager     AlignmentManager               │    │
│  │  GrimoireGenerator    MasteryTracker                 │    │
│  │  CombatManager        EffectResolver (Phase 2+)      │    │
│  │                                                      │    │
│  │  Pure logic. RefCounted (no Node dependency).        │    │
│  │  Takes Resources in, returns/mutates Resources out.  │    │
│  │  Stateless where possible.                           │    │
│  └──────────────┬───────────────────────────────────────┘    │
│                 │ signals / method calls                      │
│  ┌──────────────▼───────────────────────────────────────┐    │
│  │  VIEW (Scenes — scenes/ + scripts/ui/)               │    │
│  │                                                      │    │
│  │  GrimoireUI       BattleScene                        │    │
│  │  CardHandUI       MapScene                           │    │
│  │  EvolutionPopup   MoralChoiceUI                      │    │
│  │                                                      │    │
│  │  Nodes and scenes. Reads Resources for display.      │    │
│  │  Sends player actions to Controllers via signals.    │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐    │
│  │  AUTOLOADS (Global Singletons — autoload/)           │    │
│  │                                                      │    │
│  │  GlobalEnums   — Shared enum definitions             │    │
│  │  GameManager   — Session state, save/load, scene     │    │
│  │                  transitions                         │    │
│  │                                                      │    │
│  │  Minimal footprint. Max 2-3 autoloads total.         │    │
│  └──────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

### 2.2 Why Not ECS?

**Entity-Component-System** is popular in performance-critical games (thousands of entities, spatial queries, physics-heavy). This game has:
- Max ~40 cards in a deck
- Max ~5 enemies on screen
- Turn-based (no per-frame entity updates)
- Rich per-entity behavior (cards have evolution trees, mastery, alignment)

**ECS would add complexity without benefit.** Godot's Resource + Node model maps naturally to card game concepts: a `CardResource` IS a card's identity, and a `CardNode` IS its visual representation. Forcing these into ECS components would fight the engine.

### 2.3 Why Not Pure OOP Inheritance Trees?

Deep inheritance hierarchies (e.g., `Card → AttackCard → FireAttackCard → EvolvedFireAttackCard`) create:
- Rigid coupling
- Diamond inheritance problems
- Difficulty adding cross-cutting concerns (e.g., a card that's both Attack and Support)

Instead, we use **composition via Resources:**
- `CardResource` holds data (type, alignment, stats)
- `EffectResource` (Phase 2+) defines what the card *does* as composable effect blocks
- `CardType` enum + effect composition replaces class hierarchies entirely

### 2.4 Dependency Rules

Strict dependency direction prevents circular references and spaghetti:

```
data/Resources  ←  systems/Managers  ←  ui/Views  ←  scenes/Scenes
     ↑                    ↑                              ↑
     │                    │                              │
  GlobalEnums         GlobalEnums                   GameManager
```

| Rule | Enforced By |
|------|-------------|
| Resources NEVER import Managers | Code review. Resources have no `preload()` or `class_name` refs to systems/ |
| Managers NEVER import UI/Scene scripts | Code review. Managers take Resources as args, never Node references |
| UI scripts CAN import Resources and Managers | Natural — UI reads data and calls logic |
| Autoloads are available everywhere | Godot's autoload system. Limited to enums and session state |
| No circular Resource references | Godot enforces this at load time — circular `.tres` refs cause load failure |

### 2.5 Signal Architecture

Signals decouple the View from the Controller:

```gdscript
# UI emits signals when the player acts
signal card_played(card: CardResource, target_index: int)
signal alignment_attuned(alignment: GlobalEnums.Alignment)
signal turn_ended()
signal evolution_chosen(card: CardResource, alignment: GlobalEnums.Alignment)

# GameManager or CombatManager connects to these signals
# and calls the appropriate Manager methods
```

**Signal Naming Convention:**
- Past tense for events that already happened: `card_played`, `turn_ended`
- Present tense for requests: `requesting_evolution`, `requesting_save`

---

## 3. Folder Structure

### 3.1 Current Structure (Phase 1 — Implemented)

```
res://
├── project.godot                          # Engine config, autoload registration
├── GDD.md                                 # Game Design Document
├── TDD.md                                 # This document
│
├── autoload/                              # Global singletons (max 2-3)
│   ├── global_enums.gd                    # All shared enums (7 enums, 29 values)
│   └── game_manager.gd                    # Session state, save/load
│
├── scripts/
│   ├── data/                              # MODELS — Resource subclasses
│   │   ├── card_resource.gd               # CardResource (class_name, @tool)
│   │   ├── grimoire_resource.gd           # GrimoireResource (class_name, @tool)
│   │   ├── inscription_resource.gd        # InscriptionResource (class_name, @tool)
│   │   └── enemy_resource.gd              # EnemyResource (class_name, @tool)
│   │
│   ├── systems/                           # CONTROLLERS — Pure logic (RefCounted)
│   │   ├── evolution_manager.gd           # Card evolution + alignment shift
│   │   ├── alignment_manager.gd           # Alignment shift calculations
│   │   ├── grimoire_generator.gd          # Seed-based procedural generation
│   │   ├── mastery_tracker.gd             # Card XP tracking
│   │   └── combat_manager.gd              # Battle state machine (stub)
│   │
│   ├── ui/                                # VIEW scripts (Phase 2+)
│   └── test_phase1.gd                     # Phase 1 validation test
│
├── resources/                             # Authored data instances (.tres)
│   ├── cards/
│   │   ├── base/                          # 8 base CardResource .tres files
│   │   └── evolved/
│   │       ├── radiant/                   # 1 evolved card
│   │       ├── vile/                      # 1 evolved card
│   │       └── primal/                    # 1 evolved card
│   ├── grimoires/                         # Runtime-generated saves (empty)
│   ├── inscriptions/                      # InscriptionResource .tres (empty)
│   └── enemies/                           # EnemyResource .tres (empty)
│
├── scenes/                                # Scene files (Phase 2+)
│
└── assets/                                # Raw assets (Phase 5+)
    ├── art/
    ├── audio/
    ├── fonts/
    └── shaders/
```

### 3.2 Target Structure (All Phases)

```
res://
├── project.godot
├── GDD.md
├── TDD.md
├── export_presets.cfg                     # Phase 5+
│
├── autoload/
│   ├── global_enums.gd
│   ├── game_manager.gd
│   └── audio_manager.gd                  # Phase 5 — SFX/music bus control
│
├── scripts/
│   ├── data/
│   │   ├── card_resource.gd
│   │   ├── grimoire_resource.gd
│   │   ├── inscription_resource.gd
│   │   ├── enemy_resource.gd
│   │   ├── effect_resource.gd             # Phase 2 — composable card effects
│   │   ├── chapter_resource.gd            # Phase 3 — PvE chapter definition
│   │   ├── encounter_resource.gd          # Phase 3 — encounter node data
│   │   └── moral_choice_resource.gd       # Phase 3 — moral event definition
│   │
│   ├── systems/
│   │   ├── evolution_manager.gd
│   │   ├── alignment_manager.gd
│   │   ├── grimoire_generator.gd
│   │   ├── mastery_tracker.gd
│   │   ├── combat_manager.gd              # Phase 2 — full state machine
│   │   ├── effect_resolver.gd             # Phase 2 — processes EffectResources
│   │   ├── enemy_ai.gd                    # Phase 2 — intent selection logic
│   │   ├── chapter_generator.gd           # Phase 3 — procedural chapter assembly
│   │   ├── seed_validator.gd              # Phase 4 — validates seed viability
│   │   └── pvp_session.gd                 # Phase 6 — WebRTC session wrapper
│   │
│   ├── ui/
│   │   ├── card_hand_ui.gd                # Phase 2 — hand display and interaction
│   │   ├── card_detail_popup.gd           # Phase 2 — card inspection view
│   │   ├── battle_hud.gd                  # Phase 2 — HP, mana, block display
│   │   ├── enemy_display.gd              # Phase 2 — enemy sprite + intent
│   │   ├── evolution_popup.gd             # Phase 2 — evolution choice screen
│   │   ├── grimoire_hub.gd                # Phase 3 — main menu grimoire UI
│   │   ├── chapter_map.gd                 # Phase 3 — node map navigation
│   │   └── moral_choice_ui.gd            # Phase 3 — moral event presentation
│   │
│   ├── components/                        # Phase 2+ — reusable node scripts
│   │   ├── draggable.gd                   # Card drag-and-drop behavior
│   │   ├── hoverable.gd                   # Hover highlight + tooltip trigger
│   │   └── tween_helper.gd               # Shared animation utilities
│   │
│   └── tests/                             # Phase 2+ — organized test scripts
│       ├── test_phase1.gd                 # (moved from scripts/)
│       ├── test_combat.gd                 # Phase 2
│       ├── test_effects.gd                # Phase 2
│       └── test_chapter_gen.gd            # Phase 3
│
├── resources/
│   ├── cards/
│   │   ├── base/                          # 30+ base cards (MVP target)
│   │   └── evolved/
│   │       ├── radiant/                   # 10+ evolved variants
│   │       ├── vile/                      # 10+ evolved variants
│   │       └── primal/                    # 10+ evolved variants
│   ├── effects/                           # Phase 2 — EffectResource .tres
│   ├── enemies/                           # Phase 2 — EnemyResource .tres
│   ├── chapters/                          # Phase 3 — ChapterResource .tres
│   ├── moral_choices/                     # Phase 3 — MoralChoiceResource .tres
│   ├── grimoires/                         # Runtime saves
│   └── inscriptions/                      # Phase 4 — InscriptionResource .tres
│
├── scenes/
│   ├── battle/                            # Phase 2
│   │   ├── battle_scene.tscn
│   │   ├── card_node.tscn                 # Visual card instance
│   │   └── enemy_node.tscn               # Visual enemy instance
│   ├── grimoire/                          # Phase 3
│   │   ├── grimoire_hub.tscn             # Main menu (the grimoire itself)
│   │   └── page_flipper.tscn             # Page turn animation system
│   ├── chapter/                           # Phase 3
│   │   ├── chapter_map.tscn              # Node-based path selection
│   │   └── moral_choice_scene.tscn       # Moral event scene
│   └── shared/                            # Phase 2
│       ├── popup_overlay.tscn            # Reusable modal overlay
│       └── transition.tscn               # Scene transition effect
│
└── assets/
    ├── art/
    │   ├── cards/                          # Card illustrations
    │   ├── grimoire/                       # Grimoire textures (cover, pages)
    │   ├── enemies/                        # Enemy sprites
    │   ├── ui/                            # UI element textures
    │   └── effects/                       # VFX spritesheets
    ├── audio/
    │   ├── sfx/                           # Sound effects
    │   └── music/                         # Background tracks
    ├── fonts/                             # Custom fonts (manuscript style)
    └── shaders/
        ├── grimoire_aura.gdshader         # Pulsing aura effect
        ├── card_glow.gdshader             # Mastery tier glow
        ├── alignment_corruption.gdshader  # Visual corruption overlay
        └── page_turn.gdshader            # Page flip effect
```

### 3.3 Naming Conventions

| Category | Convention | Example |
|----------|-----------|---------|
| Scripts | `snake_case.gd` | `card_resource.gd`, `evolution_manager.gd` |
| Resources (.tres) | `snake_case.tres` | `spark_bolt.tres`, `purifying_bolt.tres` |
| Scenes (.tscn) | `snake_case.tscn` | `battle_scene.tscn`, `card_node.tscn` |
| class_name | `PascalCase` | `CardResource`, `EvolutionManager` |
| Enums | `PascalCase` for type, `SCREAMING_SNAKE` for values | `Alignment.RADIANT` |
| Signals | `snake_case`, past tense | `card_played`, `evolution_chosen` |
| Constants | `SCREAMING_SNAKE_CASE` | `GRIMOIRE_SAVE_DIR`, `MAX_HAND_SIZE` |
| Variables | `snake_case` | `mastery_xp`, `alignment_radiant` |
| Private methods | `_snake_case` (leading underscore) | `_update_mastery_tier()` |
| Export groups | Title Case | `@export_group("Evolution Paths")` |

---

## 4. Data Layer

### 4.1 Resource Class Hierarchy

```
Resource (Godot built-in)
├── CardResource          — Card identity, stats, mastery, evolution refs
├── GrimoireResource      — Player's soulbound grimoire (IS the save file)
├── InscriptionResource   — Passive buff definition
├── EnemyResource         — Enemy stat block
├── EffectResource        — Composable card effect (Phase 2)
├── ChapterResource       — PvE chapter definition (Phase 3)
├── EncounterResource     — Single encounter node data (Phase 3)
└── MoralChoiceResource   — Moral event definition (Phase 3)
```

All Resource subclasses are marked `@tool` so their `@export` fields appear correctly in the Godot editor with enum dropdowns and resource pickers.

### 4.2 Resource Schemas

#### CardResource (Implemented)

```
CardResource
├── card_id: String                                    # Unique identifier
├── card_name: String                                  # Display name
├── description: String (multiline)                    # Flavor/rules text
├── card_type: GlobalEnums.CardType                    # ATTACK | DEFENSE | SUPPORT | SPECIAL
├── alignment: GlobalEnums.Alignment                   # RADIANT | VILE | PRIMAL
├── rarity: GlobalEnums.Rarity                         # COMMON → LEGENDARY
├── mana_cost: int                                     # Mana required to play
├── base_value: int                                    # Primary numeric value (damage/block/heal)
├── target_type: GlobalEnums.TargetType                # Who this card affects
├── [Mastery]
│   ├── mastery_xp: int (0–100)                       # Individual card XP
│   ├── mastery_tier: GlobalEnums.MasteryTier          # Current tier (auto-calculated)
│   └── is_evolved: bool                               # Permanent evolution flag
├── [Evolution Paths]
│   ├── evolution_radiant: CardResource (nullable)     # Radiant evolution result
│   ├── evolution_vile: CardResource (nullable)        # Vile evolution result
│   └── evolution_primal: CardResource (nullable)      # Primal evolution result
├── [Phase 2 — Effects]
│   └── effects: Array[EffectResource]                 # Composable effect chain
│
├── add_xp(amount: int) -> void
├── can_evolve() -> bool
├── get_effective_value() -> int                       # base_value + mastery bonus
├── get_evolution_for_alignment(align) -> CardResource
└── _update_mastery_tier() -> void                     # Private, called by add_xp
```

#### GrimoireResource (Implemented)

```
GrimoireResource
├── [Identity]
│   ├── seed: int                                      # 64-bit master seed
│   ├── true_name: String                              # Pronounceable seed display
│   └── lore_text: String (multiline)                  # Generated lore paragraph
├── [Visuals]
│   ├── cover_type: GlobalEnums.GrimoireCover          # LEATHER → METAL
│   ├── binding_type: GlobalEnums.GrimoireBinding      # CHAIN → RUNE_THREAD
│   ├── sigil_params: Dictionary                       # {sides, rotation, inner_ratio}
│   └── aura_color: Color                              # Alignment-derived color
├── [Alignment] (three independent 0–100 axes)
│   ├── alignment_radiant: int
│   ├── alignment_vile: int
│   └── alignment_primal: int
├── [Progression]
│   ├── grimoire_level: int (1–20)
│   └── grimoire_xp: int
├── [Collections]
│   ├── cards: Array[CardResource]                     # Main deck (20–40 cards)
│   ├── lost_pages: Array[CardResource]                # Dungeon-found rare cards
│   └── inscriptions: Array[Resource]                  # Equipped passive buffs
│
├── get_max_deck_size() -> int                         # Level-based: 20 → 40
├── get_dominant_alignment() -> GlobalEnums.Alignment
├── is_conflicted() -> bool                            # Top two within 5 points
├── get_max_lost_pages() -> int                        # level / 5
└── get_inscription_slot_count() -> int                # 0 → 4 by level
```

#### EffectResource (Phase 2 — Planned)

```
EffectResource
├── effect_type: EffectType                            # DAMAGE | HEAL | BLOCK | STATUS | DRAW | CUSTOM
├── value: int                                         # Primary numeric value
├── target_override: GlobalEnums.TargetType             # Override card's target if set
├── status_type: StatusType                            # POISON | BURN | REGEN | STUN | etc.
├── status_duration: int                               # Turns the status lasts
├── condition: ConditionType                           # ALWAYS | IF_ATTUNED | IF_EVOLVED | etc.
└── custom_script: GDScript (nullable)                 # For Special/Ultimate cards only
```

See [Section 5: Card Effect System](#5-card-effect-system) for full design.

### 4.3 Enum Registry

All enums live in `autoload/global_enums.gd` (single source of truth):

```gdscript
# Current (Phase 1) — 7 enums, 29 values
enum Alignment      { RADIANT, VILE, PRIMAL }
enum Rarity         { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }
enum CardType       { ATTACK, DEFENSE, SUPPORT, SPECIAL }
enum MasteryTier    { UNMASTERED, BRONZE, SILVER, GOLD, EVOLVED }
enum TargetType     { SINGLE_ENEMY, ALL_ENEMIES, SELF, SINGLE_ALLY, ALL_ALLIES }
enum GrimoireCover  { LEATHER, BONE, CRYSTAL, CLOTH, METAL }
enum GrimoireBinding { CHAIN, RIBBON, VINE, CLASP, RUNE_THREAD }

# Phase 2 additions
enum EffectType     { DAMAGE, HEAL, BLOCK, STATUS, DRAW, DISCARD, MANA, CUSTOM }
enum StatusType     { POISON, BURN, REGEN, STUN, WEAKEN, STRENGTHEN, VULNERABLE }
enum ConditionType  { ALWAYS, IF_ATTUNED, IF_EVOLVED, IF_ALIGNMENT_DOMINANT, IF_HP_BELOW_HALF }
enum EnemyIntent    { ATTACK, DEFEND, BUFF, DEBUFF, SUMMON, SPECIAL }
enum BattleState    { SETUP, PLAYER_TURN, ENEMY_TURN, RESOLVING, VICTORY, DEFEAT }

# Phase 3 additions
enum NodeType       { COMBAT, MORAL_CHOICE, TREASURE, REST, BOSS }
enum ChapterTheme   { RADIANT_ARCHIVE, VILE_CRYPT, PRIMAL_GROVE, MIXED }
```

**Why a single enum file?** Godot's `@export` hints require the enum to be accessible at parse time. A centralized autoload ensures every Resource can reference every enum without import chains or circular dependencies.

### 4.4 Data Integrity Rules

| Rule | Enforcement | When |
|------|-------------|------|
| `card_id` must be unique across all `.tres` files | Naming convention (`card_id` = filename without extension) | Authoring time |
| `mastery_xp` must be 0–100 | `clampi()` in `add_xp()` | Runtime |
| Alignment values must be 0–100 | `clampi()` in all shift methods + `@export_range` | Runtime + Editor |
| Evolved cards must have `is_evolved = true` | Set by EvolutionManager, verified in `.tres` | Runtime + Authoring |
| `cards` array size ≤ `get_max_deck_size()` | Checked before adding cards | Runtime |
| `lost_pages` array size ≤ `get_max_lost_pages()` | Checked before binding pages | Runtime |
| Evolution targets must exist if referenced | `.tres` external resource references | Load time (Godot validates) |
| No circular Resource references | Godot's ResourceLoader rejects cycles | Load time |

---

## 5. Card Effect System

### 5.1 Architecture: Hybrid (Data-Driven + Custom Scripts)

The effect system uses a **two-tier approach:**

**Tier 1 — Data-Driven Effects (90% of cards):**
Common effects are composed from reusable `EffectResource` blocks. No code per card.

**Tier 2 — Custom Script Effects (10% of cards):**
Special and Ultimate cards may attach a `GDScript` to an `EffectResource` for unique behavior that can't be expressed as data.

```
┌──────────────────────────────────────────────────────────┐
│  CardResource                                            │
│  └── effects: Array[EffectResource]                      │
│       ├── EffectResource { DAMAGE, value=4, target=SINGLE_ENEMY }  │
│       ├── EffectResource { STATUS, POISON, duration=2 }  │
│       └── EffectResource { CUSTOM, script=my_special.gd }│
└──────────────────────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│  EffectResolver (RefCounted)                             │
│                                                          │
│  func resolve(effects: Array[EffectResource],            │
│               source: CardResource,                      │
│               caster_grimoire: GrimoireResource,         │
│               battle_state: BattleState) -> void         │
│                                                          │
│  Iterates each EffectResource:                           │
│    ├── Check condition (IF_ATTUNED, IF_EVOLVED, etc.)    │
│    ├── If data effect → dispatch to typed handler        │
│    │    ├── _resolve_damage(effect, target)               │
│    │    ├── _resolve_heal(effect, target)                 │
│    │    ├── _resolve_block(effect, target)                │
│    │    ├── _resolve_status(effect, target)               │
│    │    └── _resolve_draw(effect, battle_state)           │
│    └── If custom script → call script.execute(context)   │
└──────────────────────────────────────────────────────────┘
```

### 5.2 Data-Driven Effect Examples

**"Spark Bolt" (Deal 4 Damage):**
```
effects = [
    EffectResource { type=DAMAGE, value=4, target=SINGLE_ENEMY }
]
```

**"Purifying Bolt" (Deal 3 Damage, Remove 1 Debuff):**
```
effects = [
    EffectResource { type=DAMAGE, value=3, target=SINGLE_ENEMY },
    EffectResource { type=STATUS, status=CLEANSE, value=1, target=SELF }
]
```

**"Venomous Bolt" (Deal 3 Damage, Apply 2 Poison):**
```
effects = [
    EffectResource { type=DAMAGE, value=3, target=SINGLE_ENEMY },
    EffectResource { type=STATUS, status=POISON, value=2, duration=2, target=SINGLE_ENEMY }
]
```

**"Chain Bolt" (Deal 2 Damage to Target + Adjacent):**
```
effects = [
    EffectResource { type=DAMAGE, value=2, target=ALL_ENEMIES }
]
# Note: "adjacent" targeting is handled by ALL_ENEMIES with a value reduction.
# If true adjacency is needed, this becomes a Tier 2 custom script.
```

### 5.3 Custom Script Interface (Tier 2)

For Special/Ultimate cards that need unique logic:

```gdscript
# res://scripts/effects/custom/ultimate_radiant_nova.gd
extends RefCounted

## Custom effect for the Radiant Ultimate Spell.
## Heals all allies for damage dealt, then purges all debuffs.
func execute(context: Dictionary) -> void:
    var damage_dealt: int = context.battle_state.deal_damage(
        context.target, context.effect.value
    )
    context.battle_state.heal(context.caster, damage_dealt)
    context.battle_state.cleanse_all(context.caster)
```

**Custom script rules:**
- Must extend `RefCounted`
- Must implement `execute(context: Dictionary) -> void`
- Context dictionary provides: `battle_state`, `caster`, `target`, `effect`, `grimoire`
- Custom scripts are only used for `SPECIAL` and `ULTIMATE` card types
- Estimated count: ~10–15 custom scripts for the full game (not 90)

### 5.4 Mastery Bonus Integration

The `EffectResolver` applies mastery bonuses from `CardResource.get_effective_value()` to the **first effect** in the chain. This means mastery always boosts the card's primary purpose:

```gdscript
func resolve(effects: Array[EffectResource], source: CardResource, ...) -> void:
    var mastery_bonus: int = source.get_effective_value() - source.base_value
    for i in effects.size():
        var effect: EffectResource = effects[i]
        var bonus: int = mastery_bonus if i == 0 else 0
        _dispatch(effect, bonus, ...)
```

---

## 6. Combat System Architecture

### 6.1 State Machine

The `CombatManager` is implemented as an explicit state machine:

```
┌──────────┐     ┌──────────────┐     ┌────────────┐
│  SETUP   │────▶│ PLAYER_TURN  │────▶│ ENEMY_TURN │
│          │     │              │     │            │
│ Load     │     │ Draw hand    │     │ Resolve    │
│ grimoire │     │ Gain mana    │     │ enemy      │
│ Spawn    │     │ Accept input │     │ intents    │
│ enemies  │     │              │     │            │
└──────────┘     └──────┬───────┘     └─────┬──────┘
                        │                    │
                        ▼                    ▼
                 ┌──────────────┐     ┌──────────────┐
                 │  RESOLVING   │     │  RESOLVING   │
                 │              │     │              │
                 │ Process card │     │ Apply damage │
                 │ effects via  │     │ Check deaths │
                 │ EffectResolver│    │              │
                 └──────┬───────┘     └──────┬───────┘
                        │                    │
                        ▼                    ▼
                 ┌────────────┐       ┌────────────┐
                 │  VICTORY   │       │  DEFEAT    │
                 │            │       │            │
                 │ Award XP   │       │ Lose un-   │
                 │ Bind pages │       │ bound pages│
                 │ Alignment  │       │ Keep XP    │
                 │ summary    │       │            │
                 └────────────┘       └────────────┘
```

### 6.2 CombatManager API (Phase 2 Target)

```gdscript
class_name CombatManager
extends RefCounted

signal state_changed(new_state: GlobalEnums.BattleState)
signal card_resolved(card: CardResource, effects_applied: Array)
signal enemy_intent_resolved(enemy: EnemyResource, action: Dictionary)
signal battle_ended(victory: bool)

var battle_state: BattleState        # Current state enum
var grimoire: GrimoireResource       # Player's grimoire
var deck: Array[CardResource]        # Shuffled draw pile
var hand: Array[CardResource]        # Current hand (max 5)
var discard: Array[CardResource]     # Discard pile
var enemies: Array[EnemyInstance]    # Active enemies with runtime HP
var current_mana: int                # Mana available this turn
var max_mana: int                    # Mana cap
var current_block: int               # Damage reduction this turn
var attuned_alignment: GlobalEnums.Alignment  # Declared alignment (-1 = none)

func start_battle(grim: GrimoireResource, enemy_group: Array[EnemyResource]) -> void
func draw_cards(count: int) -> void
func play_card(hand_index: int, target_index: int) -> bool
func attune(alignment: GlobalEnums.Alignment) -> void
func end_player_turn() -> void
func _resolve_enemy_turn() -> void
func _check_battle_end() -> void
```

### 6.3 EnemyInstance (Runtime Wrapper)

Enemies in `.tres` are static data. At battle start, they're wrapped in a runtime object:

```gdscript
class EnemyInstance:
    var resource: EnemyResource       # Source data
    var current_hp: int               # Mutable HP
    var statuses: Dictionary          # {StatusType: {stacks, duration}}
    var current_intent: GlobalEnums.EnemyIntent
    var intent_value: int             # Damage/block/etc. amount for telegraphing
```

This avoids mutating the authored `EnemyResource` `.tres` files.

### 6.4 Turn Flow (Pseudocode)

```
PLAYER_TURN:
    current_block = 0
    current_mana = max_mana
    draw_cards(5)
    tick_player_statuses()           # Poison damage, regen heal, etc.

    WHILE player has not ended turn:
        AWAIT player input:
            play_card(index, target):
                IF card.mana_cost > current_mana → reject
                IF attuned AND card.alignment == attuned → cost -= 1
                current_mana -= adjusted_cost
                effect_resolver.resolve(card.effects, card, grimoire, self)
                mastery_tracker.on_card_used(card)
                move card to discard
            attune(alignment):
                attuned_alignment = alignment (once per turn)
            end_turn():
                break

    discard remaining hand
    transition → ENEMY_TURN

ENEMY_TURN:
    FOR EACH enemy in enemies:
        resolve intent (damage player, gain block, apply debuff, etc.)
        select next intent (telegraphed for next turn)
        tick enemy statuses

    check_battle_end()
    IF all enemies dead → VICTORY
    ELIF player HP <= 0 → DEFEAT
    ELSE → PLAYER_TURN
```

---

## 7. Procedural Generation Pipeline

### 7.1 Seed Architecture

All procedural systems use Godot's `RandomNumberGenerator` initialized with a deterministic seed. This guarantees:
- **Reproducibility:** Same seed → identical Grimoire, always
- **Debuggability:** Bug reports include the seed for exact reproduction
- **Sharability:** Players can share seeds to compare different playstyles on the same starting deck

```
Master Seed (64-bit int)
├── GrimoireGenerator.generate(seed)
│   ├── RNG(seed) → true_name
│   ├── RNG(seed) → cover_type, binding_type
│   ├── RNG(seed) → starting_affinity
│   ├── RNG(seed) → aura_color (derived)
│   ├── RNG(seed) → sigil_params
│   ├── RNG(seed) → lore_text
│   └── RNG(seed) → initial 20 cards (Phase 4 — seed_validator.gd)
│
├── ChapterGenerator.generate(seed + chapter_index)     # Phase 3
│   └── Each chapter uses seed offset for unique but deterministic layout
│
└── UltimateSpellGenerator.generate(seed, alignment)    # Phase 4
    └── Seed + alignment state at level 20 → unique capstone card
```

### 7.2 True Name Generation (Implemented)

```
Name = SYLLABLE_START + SYLLABLE_MID + SYLLABLE_END

Pools:
  START (10): Vex, Thar, Mor, Ael, Kyn, Zor, Ith, Nal, Bre, Fen
  MID   (10): i, a, o, u, e, al, or, en, is, ar
  END   (10): thorn, wick, grim, vale, bone, flux, rend, shade, crest, forge

Total combinations: 10 × 10 × 10 = 1,000 unique names
```

**Phase 4 expansion:** Increase pools to 20+ syllables each for 8,000+ combinations. Add validation to reject unpronounceable or offensive results.

### 7.3 Card Pool Selection (Phase 4 — Planned)

```gdscript
func _select_initial_cards(rng: RandomNumberGenerator) -> Array[CardResource]:
    var all_base_cards: Array[CardResource] = _load_all_base_cards()
    var selected: Array[CardResource] = []
    var type_counts: Dictionary = {}  # Ensure minimum 2 per type

    # Guarantee minimums: 2 ATTACK, 2 DEFENSE, 2 SUPPORT
    for type in [CardType.ATTACK, CardType.DEFENSE, CardType.SUPPORT]:
        var pool: Array = all_base_cards.filter(func(c): return c.card_type == type)
        for i in 2:
            var idx: int = rng.randi_range(0, pool.size() - 1)
            selected.append(pool[idx].duplicate())
            pool.remove_at(idx)

    # Fill remaining 14 slots with rarity-weighted random selection
    var remaining: Array = all_base_cards.filter(func(c): return c not in selected)
    while selected.size() < 20:
        var card: CardResource = _rarity_weighted_pick(rng, remaining)
        selected.append(card.duplicate())
        remaining.erase(card)

    return selected
```

### 7.4 Seed Validation (Phase 4 — Planned)

Before accepting a seed, simulate 1,000 sample hands to verify playability:

```gdscript
func validate_seed(seed: int) -> bool:
    var grimoire: GrimoireResource = generator.generate(seed)
    var rng := RandomNumberGenerator.new()
    rng.seed = seed + 999  # Offset for hand simulation

    var viable_hands: int = 0
    for i in 1000:
        var hand: Array = _draw_random_hand(grimoire.cards, 5, rng)
        if _hand_is_viable(hand):
            viable_hands += 1

    return viable_hands >= 800  # 80% viability threshold
```

---

## 8. Save System

### 8.1 Architecture: Resource-as-Save-File

The `GrimoireResource` IS the save file. No separate save format, no JSON conversion, no database. Godot's built-in `ResourceSaver`/`ResourceLoader` handles serialization natively.

```
Save: ResourceSaver.save(grimoire, "user://grimoires/vexithorn.tres")
Load: ResourceLoader.load("user://grimoires/vexithorn.tres") as GrimoireResource
```

**Why this works:**
- `GrimoireResource` contains ALL player state: cards (with individual mastery XP), alignment, level, inscriptions, lost pages
- `.tres` is human-readable text format — debuggable, diffable, version-controllable
- Nested Resources (CardResource instances inside the Grimoire's `cards` array) are serialized inline automatically
- No schema migration needed — Godot handles missing/extra properties gracefully on load

### 8.2 Save File Location

```
Windows:  %APPDATA%/Godot/app_userdata/Grimoire The Soulbound Legacy/grimoires/
Linux:    ~/.local/share/godot/app_userdata/Grimoire The Soulbound Legacy/grimoires/
macOS:    ~/Library/Application Support/Godot/app_userdata/Grimoire The Soulbound Legacy/grimoires/
```

### 8.3 Save File Structure (Serialized .tres)

```ini
[gd_resource type="Resource" script_class="GrimoireResource" load_steps=N format=3]

[ext_resource type="Script" path="res://scripts/data/grimoire_resource.gd" id="1"]

[sub_resource type="Resource" id="CardResource_1"]
script = ...
card_id = "spark_bolt"
card_name = "Spark Bolt"
mastery_xp = 47
mastery_tier = 1
...

[resource]
script = ExtResource("1")
seed = 12345
true_name = "Vexithorn"
alignment_radiant = 35
alignment_vile = 12
alignment_primal = 28
grimoire_level = 7
cards = [SubResource("CardResource_1"), ...]
...
```

### 8.4 Save Triggers

| Trigger | Action |
|---------|--------|
| End of PvE encounter (victory) | Auto-save |
| Card evolution chosen | Auto-save |
| Grimoire level-up | Auto-save |
| Player closes grimoire / exits game | Auto-save |
| Player explicitly saves | Manual save (same file, overwrite) |

**No manual save slot management.** Each Grimoire has one save file named after its `true_name`. Players can own multiple Grimoires, each with its own file.

### 8.5 Save Integrity

| Risk | Mitigation |
|------|------------|
| Crash during save corrupts file | Write to `.tres.tmp` first, then rename (atomic swap) |
| Player edits `.tres` to cheat | Not a priority for single-player. PvP (post-MVP) will use server-side validation |
| Engine version upgrade breaks format | `.tres` format is stable across Godot 4.x minor versions. Test on upgrade. |
| Save file grows too large | Max 40 cards × ~500 bytes each + grimoire header ≈ ~25KB. Not a concern. |

### 8.6 Atomic Save Implementation

```gdscript
func save_grimoire(grimoire: GrimoireResource, filename: String) -> Error:
    var path: String = GRIMOIRE_SAVE_DIR + filename + ".tres"
    var tmp_path: String = path + ".tmp"

    var err: Error = ResourceSaver.save(grimoire, tmp_path)
    if err != OK:
        return err

    # Atomic swap: delete old, rename tmp
    if FileAccess.file_exists(path):
        DirAccess.remove_absolute(path)
    DirAccess.rename_absolute(tmp_path, path)
    return OK
```

---

## 9. Networking Model (PvP)

### 9.1 Architecture: Peer-to-Peer via WebRTC

**Phase 6 (post-MVP).** PvP uses Godot's WebRTC integration for peer-to-peer connections with no dedicated server.

```
┌──────────────┐         WebRTC          ┌──────────────┐
│   Player A   │◄───────────────────────▶│   Player B   │
│              │    Data Channel          │              │
│ CombatManager│    (reliable,           │ CombatManager│
│ (authoritative│    ordered)            │ (mirror)     │
│  for own turn)│                        │              │
└──────────────┘                         └──────────────┘
         │                                        │
         └────────── Signaling Server ────────────┘
                   (matchmaking only)
```

### 9.2 Why P2P / WebRTC

| Factor | P2P (WebRTC) | Dedicated Server |
|--------|-------------|------------------|
| **Cost** | Free (no hosting) | Monthly server costs |
| **Latency** | Direct connection (lowest possible) | Extra hop through server |
| **Cheat prevention** | Each player authoritative for own turn | Server validates all actions |
| **Complexity** | Medium (signaling server needed) | High (full server logic) |
| **Scalability** | Infinite (no server load) | Limited by server capacity |
| **Offline** | Works for LAN / local play | Requires internet always |

**For a turn-based card game:** Cheat surface is low (each player's actions are deterministic — play card X on target Y). The only cheat vector is lying about hand contents, which can be verified via shared seed + draw order tracking.

### 9.3 Signaling Server (Minimal Backend)

A lightweight WebSocket server for matchmaking only:

```
Player A → SignalingServer: "Looking for match (Level 7, MMR 1200)"
SignalingServer → Player B: "Match found"
SignalingServer: Exchange WebRTC SDP offers/answers
Player A ←→ Player B: Direct WebRTC connection established
SignalingServer: Disconnect (no longer needed)
```

**Technology options:** Cloudflare Workers (free tier), a simple Node.js WebSocket server, or Godot's built-in WebSocket server on a cheap VPS.

### 9.4 PvP Protocol

Turn-based, so network requirements are minimal:

```
Message Types:
├── MATCH_START      { seed, p1_grimoire_hash, p2_grimoire_hash }
├── TURN_ACTION      { action_type, card_index, target_index, attunement }
├── TURN_END         { }
├── RNG_SYNC         { draw_order_seed }      # Ensures identical shuffles
├── STATE_HASH       { hash_of_battle_state }  # Desync detection
├── CONCEDE          { }
└── DISCONNECT       { }
```

**Bandwidth estimate:** ~100 bytes per turn × ~20 turns per match = ~2KB per match. Trivial.

### 9.5 Anti-Cheat for P2P

| Cheat Vector | Prevention |
|-------------|------------|
| Falsified hand contents | Shared deck seed + draw order RNG = both clients know the exact draw sequence. Any discrepancy = desync = match void. |
| Modified card stats | Exchange Grimoire hashes at match start. If hash doesn't match registered Grimoire, reject. |
| Disconnection abuse | Disconnecting player forfeits. Repeated disconnects increase matchmaking penalty timer. |
| Speed hacking | Turn timer (60 seconds). Exceeding timer = auto-end turn with no actions. |

---

## 10. Scene Tree & Node Architecture

### 10.1 Battle Scene Tree (Phase 2 Target)

```
BattleScene (Node2D)
├── Background (TextureRect)
├── EnemyContainer (HBoxContainer)
│   ├── EnemyNode_0 (Control)
│   │   ├── Sprite (TextureRect)           # Enemy artwork
│   │   ├── HPBar (ProgressBar)
│   │   ├── IntentIcon (TextureRect)       # Telegraphed action
│   │   ├── IntentLabel (Label)            # Damage/block amount
│   │   └── StatusContainer (HBoxContainer) # Status effect icons
│   ├── EnemyNode_1
│   └── EnemyNode_2                        # Max 3 enemies
│
├── PlayArea (Control)                      # Cards played this turn (visual only)
│
├── PlayerHUD (HBoxContainer)
│   ├── HPDisplay (HBoxContainer)
│   │   ├── HPBar (ProgressBar)
│   │   └── HPLabel (Label)                # "45 / 60"
│   ├── ManaDisplay (HBoxContainer)
│   │   └── ManaGems (×5–10 TextureRect)   # Filled/empty gems
│   ├── BlockDisplay (Label)               # Shield icon + number
│   └── StatusContainer (HBoxContainer)    # Player status effects
│
├── CardHand (HBoxContainer)
│   ├── CardNode_0 (Control)
│   │   ├── CardBackground (TextureRect)
│   │   ├── CardArt (TextureRect)
│   │   ├── NameLabel (Label)
│   │   ├── CostLabel (Label)              # Mana cost (top-left)
│   │   ├── ValueLabel (Label)             # Damage/block value
│   │   ├── MasteryBar (ProgressBar)       # Tiny XP bar at bottom
│   │   └── TypeIcon (TextureRect)         # Attack/Defense/Support icon
│   ├── CardNode_1 through CardNode_4      # Max 5 cards in hand
│   └── script: card_hand_ui.gd           # Drag, hover, play logic
│
├── AttunementBar (HBoxContainer)
│   ├── RadiantButton (Button)
│   ├── VileButton (Button)
│   └── PrimalButton (Button)
│
├── EndTurnButton (Button)
│
├── EffectLayer (CanvasLayer)              # Particle effects, damage numbers
│   └── DamageNumberSpawner
│
└── UIOverlay (CanvasLayer)                # Popups, card detail, evolution
    ├── CardDetailPopup (PanelContainer)
    └── EvolutionPopup (PanelContainer)
```

### 10.2 Grimoire Hub Scene Tree (Phase 3 Target)

```
GrimoireHub (Control)
├── GrimoireSprite (TextureRect)           # Full-screen grimoire visual
│   ├── CoverMaterial (TextureRect)        # Cover texture based on cover_type
│   ├── BindingOverlay (TextureRect)       # Binding visual based on binding_type
│   ├── SigilRenderer (Node2D)            # Procedural sigil from sigil_params
│   └── AuraEffect (GPUParticles2D)       # Pulsing aura (aura_color)
│
├── PageContainer (Control)                # Active "page" content
│   ├── IdentityPage
│   ├── DeckPage
│   ├── InscriptionPage
│   ├── ArchivesPortalPage
│   └── StatusPage
│
├── PageTurnLeft (Button)                  # Navigate pages
├── PageTurnRight (Button)
│
└── AudioStreamPlayer                      # Page turn SFX, ambient hum
```

### 10.3 Node Ownership Rules

| Layer | Owns | Does NOT Own |
|-------|------|-------------|
| **Scenes (.tscn)** | Node tree structure, visual layout, signal connections | Game logic, data |
| **UI Scripts (scripts/ui/)** | User interaction handling, visual state, animations | Business logic, data mutation |
| **Managers (scripts/systems/)** | Game rules, state transitions, data mutation | Nodes, visuals, UI |
| **Resources (scripts/data/)** | Self-validation, computed properties | Other resources, nodes, logic |

---

## 11. Performance Constraints

### 11.1 Target Hardware (Mid-Range 2020 Laptop)

| Spec | Minimum | Recommended |
|------|---------|-------------|
| **CPU** | Intel i5-1035G1 / Ryzen 5 4500U | Any modern quad-core |
| **GPU** | Intel Iris Plus / MX350 | GTX 1650 / Radeon RX 560 |
| **RAM** | 8 GB | 16 GB |
| **Resolution** | 1280×720 | 1920×1080 |
| **Storage** | 500 MB | 1 GB |
| **OS** | Windows 10 / Ubuntu 20.04 / macOS 11 | Latest |

### 11.2 Performance Budgets

| Metric | Target | Hard Limit |
|--------|--------|------------|
| **Frame rate** | 60 FPS | Never below 30 FPS |
| **Frame time** | 16.6ms | 33.3ms max |
| **Battle scene load** | < 1 second | < 3 seconds |
| **Card play resolution** | < 100ms | < 500ms |
| **Save to disk** | < 200ms | < 1 second |
| **Grimoire generation** | < 50ms | < 500ms |
| **Memory (battle)** | < 200 MB | < 400 MB |
| **Export size** | < 100 MB | < 200 MB |
| **Draw calls (battle)** | < 50 | < 100 |
| **Particles on screen** | < 500 | < 1000 |

### 11.3 Performance-Critical Systems

**Ranked by risk (highest first):**

| System | Risk | Mitigation |
|--------|------|------------|
| **Particle effects** (auras, card glow, alignment corruption) | Medium | Use `GPUParticles2D` with conservative emission rates. LOD: reduce particle count at lower resolutions. Cap at 500 particles. |
| **Card animations** (hand fan, play, discard, draw) | Low | Use `Tween` nodes for interpolation. Avoid physics-based animation. Pre-calculate positions. |
| **Shader effects** (grimoire aura, page turn, corruption overlay) | Medium | Keep fragment shaders simple (< 20 instructions). Profile on Intel integrated. Provide "low effects" option. |
| **Resource loading** (card .tres files) | Low | Max 40 cards × ~500 bytes = trivial. Preload at battle start, not per-turn. |
| **Seed validation** (1,000 hand simulations) | Low | Pure integer math, no allocations. Runs once per Grimoire creation. Profile target: < 200ms. |
| **Save/Load** | Very Low | Single 25KB `.tres` file. Instant on any modern storage. |

### 11.4 Optimization Strategy

**Phase 1–4: Don't optimize.** Profile first, fix bottlenecks if they appear.

**Phase 5 (Visual Polish): Optimize if needed:**
1. Profile with Godot's built-in profiler and monitors
2. Identify hotspots (likely shaders on integrated GPUs)
3. Implement quality settings: Low / Medium / High
4. Low setting: disable particles, use static card borders (no glow shader), reduce page-turn effect quality

**Settings menu (Phase 5):**
```
Graphics Quality: [Low] [Medium] [High]
  Low:    No particles, static borders, no aura effect
  Medium: Reduced particles (50%), simple glow, pulsing aura
  High:   Full particles, animated glow, full aura + corruption
```

---

## 12. Platform Targets & Export

### 12.1 Primary Platforms

| Platform | Priority | Status | Notes |
|----------|----------|--------|-------|
| **Windows (x86_64)** | P0 | Development platform | Primary dev/test target |
| **Linux (x86_64)** | P1 | Export from Phase 5 | Godot has native Linux support |
| **macOS (x86_64 + ARM)** | P1 | Export from Phase 5 | Universal binary. Needs notarization. |

### 12.2 Stretch Goal Platforms

| Platform | Priority | Considerations |
|----------|----------|---------------|
| **Web (HTML5)** | P2 | Godot 4 web export improving. Would enable browser play. Save system needs IndexedDB adapter. |
| **Android** | P3 | Touch input rework needed for card dragging. Screen size constraints. |
| **iOS** | P3 | Same as Android + Apple developer account + App Store review. |
| **Steam Deck** | P2 | Linux export + controller input mapping. Natural fit for the game. |

### 12.3 Export Configuration

```ini
# export_presets.cfg (Phase 5)
[preset.0]
name = "Windows"
platform = "Windows Desktop"
custom_features = ""
export_filter = "all_resources"
include_filter = "*.tres,*.tscn,*.gd"
exclude_filter = "*.md,*.ps1,test_*,scripts/tests/*"

[preset.1]
name = "Linux"
platform = "Linux"
...

[preset.2]
name = "macOS"
platform = "macOS"
codesign/enable = true
notarization/enable = true
...
```

### 12.4 Resolution & Aspect Ratio

```ini
# project.godot display settings
[display]
window/size/viewport_width = 1920
window/size/viewport_height = 1080
window/stretch/mode = "canvas_items"
window/stretch/aspect = "expand"
```

- **Design resolution:** 1920×1080
- **Stretch mode:** `canvas_items` (UI scales cleanly)
- **Aspect handling:** `expand` (extra space filled, no black bars)
- **Minimum supported:** 1280×720 (test all UI at this resolution)

---

## 13. Testing Strategy

### 13.1 Two-Tier Approach

**Tier 1 — Lightweight SceneTree Tests (Now):**
Fast, no framework dependency. Used for rapid iteration during development.

**Tier 2 — GdUnit4 Formal Tests (When Codebase Grows):**
Full unit testing framework with assertions, mocking, parameterized tests, and CI integration. Adopt when the codebase exceeds ~20 system scripts or when multiple contributors join.

### 13.2 Tier 1: SceneTree Test Scripts (Current)

```gdscript
# Run via: godot --headless --script res://scripts/tests/test_phase1.gd
extends SceneTree

func _init() -> void:
    _test_grimoire_generation()
    _test_card_mastery_and_evolution()
    # ... more tests
    quit()
```

**Conventions:**
- Test files live in `scripts/tests/`
- Named `test_<system>.gd`
- Extend `SceneTree` for headless execution
- Use `assert()` for validation
- Print results to stdout
- Return non-zero exit code on failure (via `quit(1)`)

**Current test coverage:**

| Test File | Systems Covered | Status |
|-----------|----------------|--------|
| `test_phase1.gd` | GrimoireGenerator, CardResource (mastery + evolution), AlignmentManager, GrimoireResource (progression), Save/Load | PASSING |
| `test_combat.gd` | CombatManager, EffectResolver, EnemyAI | Phase 2 |
| `test_effects.gd` | EffectResource composition, custom scripts | Phase 2 |
| `test_chapter_gen.gd` | ChapterGenerator, encounter assembly | Phase 3 |

### 13.3 Tier 2: GdUnit4 (Future)

**When to adopt:** When any of these triggers occur:
- More than 1 developer contributing code
- CombatManager exceeds 300 lines
- A bug is found that existing tests should have caught
- Preparing for public release (Phase 5+)

**Setup:**

```
# Install GdUnit4 as Godot addon
res://addons/gdUnit4/

# Test file naming
res://tests/
├── test_card_resource.gd
├── test_grimoire_resource.gd
├── test_evolution_manager.gd
├── test_combat_manager.gd
├── test_effect_resolver.gd
└── test_seed_validator.gd
```

**Test example (GdUnit4 style):**

```gdscript
extends GdUnitTestSuite

func test_card_mastery_bronze_at_25_xp() -> void:
    var card := CardResource.new()
    card.base_value = 4
    card.add_xp(25)
    assert_int(card.mastery_xp).is_equal(25)
    assert_int(card.mastery_tier).is_equal(GlobalEnums.MasteryTier.BRONZE)
    assert_int(card.get_effective_value()).is_equal(5)

func test_evolution_shifts_alignment() -> void:
    var card := _create_evolvable_card()
    var grimoire := GrimoireResource.new()
    grimoire.alignment_radiant = 20
    var mgr := EvolutionManager.new()
    var evolved := mgr.evolve_card(card, GlobalEnums.Alignment.RADIANT, grimoire)
    assert_object(evolved).is_not_null()
    assert_int(grimoire.alignment_radiant).is_equal(30)
```

### 13.4 Testing Coverage Targets

| Phase | Target Coverage | Focus Areas |
|-------|:-:|-------------|
| Phase 1 | Core data validation | Resource creation, mastery math, alignment math, save/load |
| Phase 2 | Combat correctness | Turn flow, mana spending, effect resolution, damage calculation, win/lose conditions |
| Phase 3 | Generation validity | Chapter assembly rules, moral choice wiring, node connectivity |
| Phase 4 | Seed robustness | Seed validation, 30-card pool coverage, evolution tree completeness |
| Phase 5+ | Regression suite | Full system integration, edge cases, performance benchmarks |

### 13.5 CI Pipeline (Phase 5+ / GdUnit4 Adoption)

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: chickensoft-games/setup-godot@v2
        with:
          version: 4.5.1
      - name: Run SceneTree tests
        run: godot --headless --script res://scripts/tests/test_phase1.gd
      - name: Run GdUnit4 tests
        run: godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd --run-all
```

---

## 14. Build & Release Pipeline

### 14.1 Version Numbering

```
MAJOR.MINOR.PATCH

0.1.0 — Phase 1 complete (data architecture)
0.2.0 — Phase 2 complete (battle system)
0.3.0 — Phase 3 complete (PvE campaign)
0.4.0 — Phase 4 complete (full card set, progression)
0.5.0 — Phase 5 complete (visual polish, audio)
1.0.0 — MVP release (single-player complete)
1.1.0 — PvP update (Phase 6)
```

### 14.2 Build Process

```
Development:
  Edit in Godot Editor → Run tests → Playtest in editor

Release Build:
  1. Run full test suite (Tier 1 + Tier 2 if adopted)
  2. Update version string in project.godot
  3. Export via Godot's export system per platform
  4. Test exported builds on target platforms
  5. Package (zip for direct distribution, or upload to Steam/itch.io)
```

### 14.3 Distribution Targets

| Platform | Distribution | Notes |
|----------|-------------|-------|
| **itch.io** | Primary indie platform | Free to upload. Widget embed for web builds. |
| **Steam** | Primary commercial platform | $100 app fee. Steamworks SDK integration for achievements (optional). |
| **Direct download** | Website / GitHub Releases | Zip files per platform. No DRM. |

---

## 15. Technical Debt Prevention

### 15.1 Architecture Rules (Enforced via Code Review)

| Rule | Why |
|------|-----|
| **No game logic in UI scripts** | UI scripts read Resources and emit signals. They never mutate game state directly. If a UI script calls `card.add_xp()`, it's wrong — the Manager should do it. |
| **No Node references in Managers** | Managers are `RefCounted`, not `Node`. They never call `get_node()`, `$`, or use signals as emitter. They take Resources as arguments and return values. |
| **No hardcoded magic numbers** | All game constants live in Resources, GlobalEnums, or named constants. No `if damage > 5` — use `const HEAVY_DAMAGE_THRESHOLD: int = 5`. |
| **No implicit typing** | Every variable, parameter, and return type must be explicitly typed. GDScript's `var x = 5` is banned — use `var x: int = 5`. |
| **No circular dependencies** | If script A imports script B, script B must NOT import script A. Resources never reference Managers. Managers never reference UI. |
| **New enum values go to GlobalEnums** | Never define enums inside Resource or Manager scripts. All enums are centralized. |
| **`.tres` filenames match `card_id`/`enemy_id`** | `spark_bolt.tres` must have `card_id = "spark_bolt"`. Enforced by naming convention. |

### 15.2 Known Technical Debt (Current)

| Debt Item | Location | Risk | Resolution Phase |
|-----------|----------|------|-----------------|
| `CombatManager` is an empty stub | `scripts/systems/combat_manager.gd` | None (placeholder) | Phase 2 |
| `InscriptionResource.effect_key` is a raw string | `scripts/data/inscription_resource.gd` | Typos cause silent failures | Phase 4 — replace with enum |
| `EnemyResource` has no intent system | `scripts/data/enemy_resource.gd` | Incomplete for combat | Phase 2 — add intent patterns |
| No card effect system yet | N/A | Cards can't DO anything | Phase 2 — EffectResource + EffectResolver |
| `GrimoireGenerator` doesn't generate initial cards | `scripts/systems/grimoire_generator.gd` | Grimoire starts empty | Phase 4 — card pool selection |
| Save system lacks atomic writes | `autoload/game_manager.gd` | Crash during save = corruption | Phase 2 — implement tmp+rename |
| `test_phase1.gd` lives in wrong directory | `scripts/test_phase1.gd` | Messy structure | Phase 2 — move to `scripts/tests/` |
| Alignment shift logic duplicated | `EvolutionManager` + `AlignmentManager` both have shift code | DRY violation | Phase 2 — `EvolutionManager` should call `AlignmentManager._shift()` |

### 15.3 Refactoring Triggers

Don't refactor preemptively. Refactor when:

| Trigger | Action |
|---------|--------|
| A method exceeds 50 lines | Extract submethods |
| A script exceeds 300 lines | Split into focused classes |
| Same logic appears in 3+ places | Extract to shared utility |
| A Resource has > 20 `@export` vars | Split into sub-Resources or `@export_group` more aggressively |
| Changing one system breaks another unexpectedly | Introduce interface boundary (signals or method contracts) |

---

## 16. Phase Implementation Map

### Phase-by-Phase Technical Milestones

```
PHASE 1: DATA ARCHITECTURE ✅ (Complete)
├── GlobalEnums (7 enums)
├── CardResource, GrimoireResource, InscriptionResource, EnemyResource
├── EvolutionManager, AlignmentManager, GrimoireGenerator, MasteryTracker
├── 11 sample .tres files
├── test_phase1.gd (all passing)
└── GameManager (save/load)

PHASE 2: BATTLE SYSTEM
├── New Resources: EffectResource
├── New Enums: EffectType, StatusType, ConditionType, EnemyIntent, BattleState
├── New Systems: EffectResolver, EnemyAI, CombatManager (full implementation)
├── New Scenes: battle_scene.tscn, card_node.tscn, enemy_node.tscn
├── New UI: card_hand_ui.gd, battle_hud.gd, enemy_display.gd
├── Components: draggable.gd, hoverable.gd
├── Enemy .tres files (5+ enemies)
├── Refactor: atomic saves, deduplicate alignment shift, move test_phase1.gd
└── Tests: test_combat.gd, test_effects.gd

PHASE 3: PvE CAMPAIGN
├── New Resources: ChapterResource, EncounterResource, MoralChoiceResource
├── New Enums: NodeType, ChapterTheme
├── New Systems: ChapterGenerator
├── New Scenes: grimoire_hub.tscn, chapter_map.tscn, moral_choice_scene.tscn
├── New UI: grimoire_hub.gd, chapter_map.gd, moral_choice_ui.gd
├── 3 handcrafted chapters with bosses
├── 1 moral choice event
└── Tests: test_chapter_gen.gd

PHASE 4: CONTENT & PROGRESSION
├── 30 base cards (full set), 10+ with 3-path evolution trees
├── Seed-based card pool selection in GrimoireGenerator
├── SeedValidator
├── Inscription crafting system
├── Grimoire leveling 1–20
├── Balance pass across all cards
└── Tests: test_seed_validator.gd

PHASE 5: VISUAL & AUDIO POLISH
├── Card art, grimoire textures, enemy sprites
├── Shaders: aura, glow, corruption, page turn
├── SFX + music
├── AudioManager autoload
├── Quality settings (Low/Medium/High)
├── Export presets for Windows/Linux/macOS
├── Performance profiling and optimization pass
└── GdUnit4 adoption + CI pipeline

PHASE 6: PvP & LIVE
├── WebRTC integration (pvp_session.gd)
├── Signaling server (minimal backend)
├── PvP CombatManager variant
├── Matchmaking (level + MMR)
├── Anti-cheat (seed verification, state hashing)
├── Seasonal leaderboard
└── Cosmetic DLC system
```

---

## Appendix A: Current Codebase Inventory

### A.1 File Manifest (Phase 1)

| File | Type | Size | class_name | extends |
|------|------|------|-----------|---------|
| `autoload/global_enums.gd` | Autoload | 428B | — | Node |
| `autoload/game_manager.gd` | Autoload | 549B | — | Node |
| `scripts/data/card_resource.gd` | Resource | 2.1KB | CardResource | Resource |
| `scripts/data/grimoire_resource.gd` | Resource | 1.9KB | GrimoireResource | Resource |
| `scripts/data/inscription_resource.gd` | Resource | 330B | InscriptionResource | Resource |
| `scripts/data/enemy_resource.gd` | Resource | 271B | EnemyResource | Resource |
| `scripts/systems/evolution_manager.gd` | Manager | 1.1KB | EvolutionManager | RefCounted |
| `scripts/systems/alignment_manager.gd` | Manager | 916B | AlignmentManager | RefCounted |
| `scripts/systems/grimoire_generator.gd` | Manager | 2.9KB | GrimoireGenerator | RefCounted |
| `scripts/systems/mastery_tracker.gd` | Manager | 366B | MasteryTracker | RefCounted |
| `scripts/systems/combat_manager.gd` | Manager | 167B | CombatManager | RefCounted |
| `scripts/test_phase1.gd` | Test | 7.0KB | — | SceneTree |

### A.2 Method Inventory

| Class | Method | Signature | Status |
|-------|--------|-----------|--------|
| CardResource | `add_xp` | `(amount: int) -> void` | Implemented |
| CardResource | `can_evolve` | `() -> bool` | Implemented |
| CardResource | `get_effective_value` | `() -> int` | Implemented |
| CardResource | `get_evolution_for_alignment` | `(align: Alignment) -> CardResource` | Implemented |
| GrimoireResource | `get_max_deck_size` | `() -> int` | Implemented |
| GrimoireResource | `get_dominant_alignment` | `() -> Alignment` | Implemented |
| GrimoireResource | `is_conflicted` | `() -> bool` | Implemented |
| GrimoireResource | `get_max_lost_pages` | `() -> int` | Implemented |
| GrimoireResource | `get_inscription_slot_count` | `() -> int` | Implemented |
| EvolutionManager | `evolve_card` | `(card, alignment, grimoire) -> CardResource` | Implemented |
| AlignmentManager | `apply_moral_choice` | `(grimoire, alignment, amount) -> void` | Implemented |
| AlignmentManager | `apply_battle_usage` | `(grimoire, alignment) -> void` | Implemented |
| GrimoireGenerator | `generate` | `(master_seed: int) -> GrimoireResource` | Implemented |
| MasteryTracker | `on_card_used` | `(card: CardResource) -> void` | Implemented |
| MasteryTracker | `on_card_kill_or_combo` | `(card: CardResource) -> void` | Implemented |
| MasteryTracker | `on_perfect_play` | `(card: CardResource) -> void` | Implemented |
| GameManager | `save_grimoire` | `(grimoire, filename) -> Error` | Implemented |
| GameManager | `load_grimoire` | `(filename) -> GrimoireResource` | Implemented |

### A.3 Resource Instance Inventory (.tres Files)

**Base Cards (8):**
| ID | Name | Type | Alignment | Rarity | Mana | Value | Evolutions |
|----|------|------|-----------|--------|:----:|:-----:|:----------:|
| spark_bolt | Spark Bolt | ATTACK | PRIMAL | COMMON | 1 | 4 | 3 paths |
| flame_ward | Flame Ward | DEFENSE | PRIMAL | COMMON | 1 | 5 | — |
| mending_light | Mending Light | SUPPORT | RADIANT | COMMON | 1 | 4 | — |
| holy_shield | Holy Shield | DEFENSE | RADIANT | COMMON | 2 | 7 | — |
| shadow_strike | Shadow Strike | ATTACK | VILE | UNCOMMON | 2 | 6 | — |
| vine_lash | Vine Lash | ATTACK | PRIMAL | UNCOMMON | 2 | 3 | — |
| cursed_drain | Cursed Drain | ATTACK | VILE | UNCOMMON | 2 | 3 | — |
| wild_growth | Wild Growth | SUPPORT | PRIMAL | UNCOMMON | 1 | 3 | — |

**Evolved Cards (3 — all from Spark Bolt):**
| ID | Name | Alignment | Value | Special Effect |
|----|------|-----------|:-----:|---------------|
| spark_bolt_radiant | Purifying Bolt | RADIANT | 3 | Remove 1 debuff |
| spark_bolt_vile | Venomous Bolt | VILE | 3 | Apply 2 poison |
| spark_bolt_primal | Chain Bolt | PRIMAL | 2 | Hit adjacent enemies |
