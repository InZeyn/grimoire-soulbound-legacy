# Grimoire: The Soulbound Legacy — Audio Design Document

> **Version:** 1.0
> **Last Updated:** 2026-02-18
> **Companion Documents:** [GDD.md](GDD.md) | [TDD.md](TDD.md) | [ART_BIBLE.md](ART_BIBLE.md)
> **Audio Engine:** Godot 4.5.1 native audio (AudioStreamPlayer, Audio Bus system, AudioStreamInteractive)
> **No middleware.** No FMOD, no Wwise. Godot's built-in audio is sufficient for this scope.

---

## Table of Contents

1. [Audio Philosophy](#1-audio-philosophy)
2. [Emotional Architecture](#2-emotional-architecture)
3. [Music Direction](#3-music-direction)
4. [Dynamic Music System](#4-dynamic-music-system)
5. [Sound Effect Categories](#5-sound-effect-categories)
6. [Audio Mood by Scene](#6-audio-mood-by-scene)
7. [Voice & Vocalization](#7-voice--vocalization)
8. [Alignment Audio Identity](#8-alignment-audio-identity)
9. [Dynamic Audio Triggers](#9-dynamic-audio-triggers)
10. [Audio Bus Architecture](#10-audio-bus-architecture)
11. [Technical Specs & Performance](#11-technical-specs--performance)
12. [Asset Production Pipeline](#12-asset-production-pipeline)
13. [Audio Anti-Patterns](#13-audio-anti-patterns)
14. [Implementation Phases](#14-implementation-phases)
15. [Reference Listening](#15-reference-listening)

---

## 1. Audio Philosophy

### 1.1 Core Audio Identity

> **"Foley for a magical library."**

Every sound in this game is born from a real, physical action — pages turning, ink scratching on parchment, a metal clasp clicking, leather creaking, wax dripping from a candle — and then subtly haunted by a magical undertone. A whisper beneath the page turn. A harmonic resonance inside the clasp click. A faint choir chord that breathes under the candle drip.

The player should feel like they're sitting alone in an ancient library at midnight, holding a book that hums with its own heartbeat.

### 1.2 The Three Audio Layers

Every moment in the game is built from three simultaneous audio layers:

```
Layer 1: THE ROOM (Ambient)
  └── Where you are. Always present. Library air, distant echoes,
      candle crackle, wind against stone walls.
      Volume: -18 to -12 dB (background, never foreground)

Layer 2: THE ACTION (SFX)
  └── What you do. Pages, cards, impacts, UI clicks.
      Triggered by player interaction or game events.
      Volume: -6 to 0 dB (clear, immediate, tactile)

Layer 3: THE SOUL (Music)
  └── What you feel. Adaptive music that responds to game state.
      Volume: -12 to -6 dB (present but never overpowering SFX)
```

**The golden ratio:** At any moment, the player should be able to hear all three layers distinctly. If music drowns out a page turn, the mix is wrong. If ambient kills the card play sound, the mix is wrong. SFX is king — it is the player's direct feedback. Music and ambient serve it.

### 1.3 Emotional Design Goals

| Moment | The Player Should Feel | Audio Creates This Through |
|--------|----------------------|---------------------------|
| Opening the Grimoire | Reverence. Like opening a sacred text. | Heavy book creak, clasp release, faint harmonic swell, silence that lets the moment breathe |
| Drawing cards | Anticipation. A hand of possibilities. | Quick paper slides in sequence, each slightly different pitch, subtle ascending tone |
| Playing a card | Commitment. This action matters. | Satisfying paper-on-surface impact, ink splash, effect-specific accent that confirms the choice |
| Taking damage | Consequence. Not punishment. | Muted impact (not sharp), page tear undertone, brief musical dissonance that resolves |
| Evolving a card | Transformation. A moment of power. | Glass shatter → silence → crystalline reform. Musical key change. This should feel like the biggest audio moment in regular gameplay |
| Moral choice | Weight. No rush. | Music drops to near-silence. Reverb-heavy bell toll. The room gets quiet. The choice is loud. |
| Victory | Earned satisfaction. Not celebration. | Warm chord resolution, page-flutter burst, gold shimmer. Brief — 3 seconds. The Grimoire sighs with contentment. |
| Defeat | Somber acceptance. Not frustration. | Descending low strings, candle snuff, book closing slowly. Also brief — 3 seconds. The Grimoire rests. |

---

## 2. Emotional Architecture

### 2.1 The Emotional Arc of a Session

A typical 15–30 minute session follows this emotional trajectory. Audio drives each phase:

```
EMOTION
  ▲
  │                              ╱╲ Boss
  │                    ╱╲ Combat╱  ╲
  │           ╱╲ Combat╱  ╲───╱    ╲
  │     ╱────╱  ╲───╱      Moral    ╲ Victory
  │    ╱              Choice         ╲  ╱
  │───╱ Open                     Rest ╲╱
  │  Grimoire                         Defeat
  └──────────────────────────────────────────── TIME
    Calm   Rising   Tension  Weight  Peak  Release
```

| Phase | Music Energy | Ambient Presence | SFX Density |
|-------|:---:|:---:|:---:|
| **Open Grimoire** | Low (solo instrument) | High (room tone dominant) | Sparse (single book open) |
| **Chapter Map** | Low-medium (adds rhythm) | Medium | Low (map interactions) |
| **Combat (early)** | Medium (percussion enters) | Low (fades under music) | Medium (card plays) |
| **Combat (late/boss)** | High (full arrangement) | Very low | High (rapid card plays, effects) |
| **Moral Choice** | Near-zero (drone only) | Medium-high (room returns) | Single heavy impact per choice |
| **Rest Node** | Low (gentle, warm) | High (crackling fire, birds) | Sparse |
| **Victory** | Brief peak → rapid descent | Returns immediately | Celebratory burst → silence |
| **Defeat** | Brief low → silence | Returns with heavier tone | Single muted close |

### 2.2 Tension Curve in Combat

Combat has its own internal emotional arc across turns:

```
Turn 1: "Assessment"     → Music: Percussion only. Sizing up the enemy.
Turn 2-3: "Engagement"   → Music: Strings enter. Commitment to a strategy.
Turn 4-5: "Escalation"   → Music: Full arrangement. Stakes are clear.
Turn 6+: "Urgency"       → Music: Tempo increase. Enemy enrage approaching.
Final blow: "Resolution" → Music: Hit accent → brief silence → result stinger.
```

This is implemented via the Dynamic Music System (Section 4).

---

## 3. Music Direction

### 3.1 Compositional Style

**Dark chamber music meets medieval folk.**

The soundtrack is built on small, intimate ensembles — not full Hollywood orchestras. Every instrument should feel like it could be played in a candlelit room. The music is atmospheric first, melodic second. Melodies emerge from texture, not the other way around.

**Modal, not tonal.** Compositions use medieval modes (Dorian, Phrygian, Aeolian) rather than standard major/minor keys. This creates an ancient, pre-classical sound that matches the manuscript aesthetic.

### 3.2 Instrument Palette

#### Core Instruments (Always Available)

| Instrument | Role | Emotional Register |
|-----------|------|-------------------|
| **Solo cello** | Lead voice, melodic lines | Melancholy, gravitas, warmth. The "voice" of the Grimoire. |
| **Lute / Classical guitar** | Harmonic foundation, arpeggios | Intimacy, the medieval world, grounding. The "room" instrument. |
| **Frame drum / Bodhrán** | Rhythmic pulse in combat | Heartbeat, tension, momentum. Gentle pulse in exploration, driving in combat. |
| **Finger cymbals / Crotales** | High-frequency accents, UI feedback | Sparkle, attention, punctuation. Used for card draws, gold, mana. |
| **Sustained strings (ensemble)** | Pads, drones, harmonic bed | Atmosphere, unease, beauty. The emotional undercurrent. |

#### Accent Instruments (Context-Specific)

| Instrument | Used In | Why |
|-----------|---------|-----|
| **Choir (wordless, "ah" / "oh")** | Radiant alignment, sacred moments, level-up | Spiritual weight, holiness, transcendence |
| **Low brass (French horn, trombone)** | Boss encounters, Vile alignment | Power, menace, authority |
| **Wooden flute / Recorder** | Primal alignment, rest nodes, nature chapters | Organic warmth, folk quality, breath |
| **Hammered dulcimer** | Grimoire hub, progression screens | Delicate, crystalline, scholarly |
| **Bowed psaltery** | Moral choices, evolution screen | Ethereal, suspended, otherworldly |
| **Taiko / Large frame drum** | Boss encounter peak moments | Impact, earthquake, climax |
| **Music box** | Defeat screen, loss moments | Fragility, fading, nostalgia |

#### Instruments We Do NOT Use

| Instrument | Why Not |
|-----------|---------|
| Electric guitar | Too modern, breaks the medieval atmosphere |
| Synthesizers (obvious) | We use organic sounds only. Synth pads disguised as strings are acceptable if indistinguishable. |
| Drum kit (kick, snare, hi-hat) | Too contemporary. Frame drums and hand percussion only. |
| Piano | Too classical-era. Lute and dulcimer fill this harmonic role instead. |
| Brass fanfares (trumpet) | Too triumphant, too military. Horn and trombone are darker, more atmospheric. |
| EDM / electronic elements | Not this game. Not this world. |

### 3.3 Key & Mode Guide

| Context | Mode | Tonal Center | Character |
|---------|------|:---:|-----------|
| **Grimoire Hub** | D Dorian | D | Warm, ancient, slightly mysterious. Home base. |
| **Combat (standard)** | A Aeolian (natural minor) | A | Tense but not dark. Workmanlike danger. |
| **Combat (boss)** | E Phrygian | E | Dark, exotic, powerful. The half-step from E to F creates menace. |
| **Radiant Chapter** | F Lydian | F | Bright but strange. The raised 4th feels sacred, not happy. |
| **Vile Chapter** | B Locrian | B | Unstable, dissonant. The diminished fifth creates constant unease. |
| **Primal Chapter** | G Mixolydian | G | Open, earthy, folk-like. The flat 7th keeps it from sounding classical. |
| **Moral Choice** | No key center (drone) | — | Suspended. No resolution until the player chooses. |
| **Evolution** | Modulates from base key → alignment key | — | The key change IS the evolution. Radiant shifts up, Vile shifts down, Primal stays and adds complexity. |

### 3.4 Tempo Guide

| Context | BPM | Feel |
|---------|:---:|------|
| **Grimoire Hub** | 60–70 | Resting heartbeat. Contemplative. Free tempo (rubato). |
| **Chapter Map** | 70–80 | Slightly purposeful. Steady but unhurried. |
| **Combat (early turns)** | 90–100 | Walking pace. Measuring. |
| **Combat (mid turns)** | 100–115 | Jogging pace. Engaged. |
| **Combat (late / boss)** | 115–130 | Running pace. Urgent. |
| **Combat (enrage)** | 130–145 | Sprinting. Out of time. |
| **Moral Choice** | Free tempo | Rubato. Time stops. |
| **Rest Node** | 55–65 | Below heartbeat. Deep relaxation. |

---

## 4. Dynamic Music System

### 4.1 Architecture: Vertical Layering + Horizontal Transitions

The music system uses **two complementary techniques:**

**Vertical Layering (Within a Scene):**
Multiple synchronized stems play simultaneously. Individual layers are faded in/out based on game state. The base layer always plays; intensity layers add on top.

**Horizontal Transitions (Between Scenes):**
Transitioning between different musical pieces (hub → combat, combat → boss phase) uses beat-synced crossfades via Godot's `AudioStreamInteractive`.

```
┌─────────────────────────────────────────────────────────┐
│  VERTICAL LAYERS (Combat Example)                       │
│                                                         │
│  Layer 0: AMBIENT DRONE ──────────────────── Always on  │
│  Layer 1: PERCUSSION (frame drum) ─── Turn 1+           │
│  Layer 2: STRINGS (sustained) ──────── Turn 2+          │
│  Layer 3: LEAD (cello melody) ──────── Turn 4+ / Boss   │
│  Layer 4: INTENSITY (brass, choir) ── Boss / Low HP     │
│  Layer 5: URGENCY (fast percussion) ── Enrage / Final   │
│                                                         │
│  Each layer = separate AudioStreamPlayer on Music bus    │
│  Fade time: 2 beats (at current tempo)                  │
│  All layers are pre-synchronized to the same tempo/bar  │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  HORIZONTAL TRANSITIONS (Scene Changes)                  │
│                                                         │
│  Hub Theme ──┤crossfade 2s├──▶ Map Theme                │
│  Map Theme ──┤beat-sync├─────▶ Combat Theme             │
│  Combat ─────┤hit accent├───▶ Boss Phase                │
│  Combat ─────┤quick fade├───▶ Victory Stinger           │
│  Combat ─────┤slow fade├────▶ Defeat Stinger            │
│  Any ────────┤fade to silence├▶ Moral Choice Drone      │
│                                                         │
│  Implemented via AudioStreamInteractive transition table │
└─────────────────────────────────────────────────────────┘
```

### 4.2 Implementation in Godot

```gdscript
# autoload/audio_manager.gd (Phase 5)
extends Node

# Music Bus Layers
var music_layers: Array[AudioStreamPlayer] = []
var layer_targets: Array[float] = []  # Target volume for each layer (-80 to 0)

const FADE_SPEED: float = 2.0  # dB per second
const LAYER_COUNT: int = 6

func _ready() -> void:
    for i in LAYER_COUNT:
        var player := AudioStreamPlayer.new()
        player.bus = "Music"
        player.volume_db = -80.0  # Start silent
        add_child(player)
        music_layers.append(player)
        layer_targets.append(-80.0)

func set_layer_active(layer_index: int, active: bool) -> void:
    layer_targets[layer_index] = 0.0 if active else -80.0

func _process(delta: float) -> void:
    for i in LAYER_COUNT:
        var current: float = music_layers[i].volume_db
        var target: float = layer_targets[i]
        if not is_equal_approx(current, target):
            music_layers[i].volume_db = move_toward(current, target, FADE_SPEED * delta)
```

### 4.3 Layer Activation Rules

| Game State | L0 Drone | L1 Perc | L2 Strings | L3 Lead | L4 Intensity | L5 Urgency |
|-----------|:---:|:---:|:---:|:---:|:---:|:---:|
| **Hub idle** | ON | — | — | — | — | — |
| **Map browsing** | ON | soft | — | — | — | — |
| **Combat turn 1** | ON | ON | — | — | — | — |
| **Combat turns 2–3** | ON | ON | ON | — | — | — |
| **Combat turns 4+** | ON | ON | ON | ON | — | — |
| **Boss encounter** | ON | ON | ON | ON | ON | — |
| **Player HP < 30%** | ON | ON | ON | ON | ON | — |
| **Enemy enrage / turn 7+** | ON | ON | ON | ON | ON | ON |
| **Moral choice** | ON | — | — | — | — | — |
| **Rest node** | ON | — | soft | — | — | — |

### 4.4 Beat-Synchronized Transitions

All layer changes snap to the nearest beat boundary (not immediate) to prevent musical jarring:

```gdscript
# Calculate time to next beat
var seconds_per_beat: float = 60.0 / current_bpm
var time_in_bar: float = fmod(playback_position, seconds_per_beat * 4)
var time_to_next_beat: float = seconds_per_beat - fmod(time_in_bar, seconds_per_beat)

# Schedule layer change at next beat
await get_tree().create_timer(time_to_next_beat).timeout
set_layer_active(layer_index, true)
```

### 4.5 Music Track List (MVP)

| Track ID | Context | Duration | Layers | Loop? |
|----------|---------|:--------:|:------:|:-----:|
| `hub_theme` | Grimoire Hub | 3:00 | 2 (drone + dulcimer) | Yes |
| `map_theme` | Chapter Map | 2:00 | 2 (drone + light percussion) | Yes |
| `combat_standard` | Standard encounters | 2:30 | 6 (full layer stack) | Yes |
| `combat_boss` | Boss encounters | 3:00 | 6 (higher intensity stems) | Yes |
| `moral_drone` | Moral choice events | 1:30 | 1 (sustained drone) | Yes |
| `rest_theme` | Rest / treasure nodes | 2:00 | 2 (drone + flute) | Yes |
| `stinger_victory` | Victory | 0:04 | 1 (chord + shimmer) | No |
| `stinger_defeat` | Defeat | 0:04 | 1 (descending + close) | No |
| `stinger_evolution` | Card evolution | 0:05 | 1 (shatter + key change + resolve) | No |
| `stinger_levelup` | Grimoire level-up | 0:06 | 1 (gong + pages + ascension) | No |

**Total music needed for MVP: ~20 minutes of composed audio (10 tracks).**

---

## 5. Sound Effect Categories

### 5.1 Category Taxonomy

All sound effects fall into one of six categories. Each category has distinct production rules and bus routing.

```
SFX Categories
├── 1. GRIMOIRE FOLEY    — Physical book interactions
├── 2. CARD ACTIONS       — Card game mechanical sounds
├── 3. COMBAT IMPACTS     — Damage, healing, status effects
├── 4. UI FEEDBACK        — Button clicks, navigation, menus
├── 5. AMBIENT FOLEY      — Room tone, environmental detail
└── 6. MAGIC ACCENTS      — Supernatural layer on top of physical sounds
```

### 5.2 Category 1: Grimoire Foley

Sounds of interacting with a physical book. These are the most important SFX in the game — they sell the fantasy that you're holding a real, ancient artifact.

| Sound | Description | Layers | Duration | Variations |
|-------|------------|:------:|:--------:|:----------:|
| `grimoire_open` | Heavy book creak + clasp release + pages settling | 3 | 1.2s | 2 |
| `grimoire_close` | Pages compress + clasp lock + leather thud | 3 | 0.8s | 2 |
| `page_turn` | Paper slide + fabric whoosh + subtle air | 2 | 0.4s | 4 |
| `page_flutter` | Quick multi-page riffle (idle animation) | 1 | 0.6s | 3 |
| `clasp_click` | Metal on metal, small and precise | 1 | 0.1s | 2 |
| `ink_write` | Quill scratching on parchment (lore text reveal) | 1 | 0.3s | 4 |
| `book_hum` | Low tonal drone (Grimoire's "heartbeat") | 1 | Loop | 1 per alignment |

**Production notes:**
- Record real book foley. Do not synthesize. The tactile quality of real paper, leather, and metal is irreplaceable.
- Layer a subtle harmonic undertone (sine wave, +2 octaves above fundamental) beneath every Grimoire foley sound at -18 dB. This is the Grimoire's "soul" — barely audible but subconsciously felt.

### 5.3 Category 2: Card Actions

The mechanical sounds of card game interactions. These provide **tactile feedback** — the player must feel like they're physically handling cards.

| Sound | Description | Duration | Variations |
|-------|------------|:--------:|:----------:|
| `card_draw` | Single card slides from deck (paper on paper) | 0.15s | 3 |
| `card_draw_multi` | Rapid sequence of draws (hand fill at turn start) | 0.5s | 2 |
| `card_hover` | Soft paper lift + tiny air puff | 0.1s | 2 |
| `card_play` | Paper slaps on surface + ink splash | 0.25s | 3 |
| `card_discard` | Soft paper slide to discard pile | 0.15s | 2 |
| `card_shuffle` | Deck riffle (at battle start) | 0.6s | 2 |
| `card_unplayable` | Dull thud + muted buzz (insufficient mana) | 0.2s | 1 |
| `card_evolve_shatter` | Glass/crystal breaking into fragments | 0.4s | 1 |
| `card_evolve_reform` | Crystalline reassembly + harmonic ascension | 0.6s | 3 (one per alignment) |

**Production notes:**
- Card sounds should be dry (minimal reverb). They happen in the player's hands, not in a cathedral.
- Each card draw in a multi-draw sequence is pitched up slightly (+20 cents per card) to create an ascending "dealing" feel.
- Evolution reform sounds are alignment-specific: Radiant = chime ascending, Vile = low grind ascending, Primal = organic growth.

### 5.4 Category 3: Combat Impacts

Damage, healing, blocking, and status effects. These communicate game state changes and must be **instantly readable**.

| Sound | Description | Duration | Variations |
|-------|------------|:--------:|:----------:|
| `damage_dealt` | Ink slash (whip crack) + impact thud | 0.3s | 3 |
| `damage_heavy` | Deeper slash + heavier thud + brief bass rumble | 0.4s | 2 |
| `damage_received` | Muted impact + page tear undertone | 0.3s | 2 |
| `heal_apply` | Warm shimmer + liquid tone + soft exhale | 0.4s | 2 |
| `block_gain` | Stone/metal impact + shield tone (ring) | 0.25s | 2 |
| `block_absorb` | Muted stone impact (block absorbs incoming hit) | 0.2s | 2 |
| `block_break` | Shield crack + glass scatter (block fully consumed) | 0.3s | 1 |
| `poison_apply` | Wet drip + sizzle | 0.3s | 2 |
| `poison_tick` | Bubble + quiet sizzle | 0.2s | 2 |
| `burn_apply` | Fire ignite + crackle | 0.3s | 2 |
| `burn_tick` | Ember crackle | 0.2s | 2 |
| `stun_apply` | Bell ring + echo decay | 0.4s | 1 |
| `regen_tick` | Soft chime + organic growth | 0.2s | 2 |
| `enemy_death` | Ink dissolve (wet fade) + low bass drop | 0.5s | 2 |
| `enemy_spawn` | Ink splash (wet impact) + brief snarl/growl | 0.4s | 2 |
| `boss_intro` | Deep horn blast + rumbling earthquake + choir hit | 1.5s | 1 per boss |

**Production notes:**
- Status tick sounds (poison, burn, regen) play at -6 dB relative to apply sounds. Ticks are background information, not events.
- Enemy death has a 0.2s silence after the bass drop before the next sound plays. Let the death breathe.
- Boss intro is the loudest non-music sound in the game. It should command attention.

### 5.5 Category 4: UI Feedback

Interface interaction sounds. These must be **subtle, consistent, and never annoying.** The player will hear these thousands of times — they must be pleasant on repetition.

| Sound | Description | Duration | Notes |
|-------|------------|:--------:|-------|
| `ui_button_hover` | Soft parchment rustle | 0.05s | Very quiet. -12 dB relative to button click. |
| `ui_button_click` | Crisp tap on parchment (fingertip on paper) | 0.08s | The most-heard sound in the game. Must be perfect. |
| `ui_button_back` | Slightly lower-pitched tap | 0.08s | Distinct from click — navigating backward. |
| `ui_tab_switch` | Page corner fold | 0.1s | Tab navigation within a screen. |
| `ui_scroll` | Paper sliding on paper | 0.1s | Scrolling through card list or lore. |
| `ui_popup_open` | Parchment unfurl + light tap | 0.2s | Tooltip, detail view, popup overlay. |
| `ui_popup_close` | Parchment curl + muted tap | 0.15s | Closing any popup. |
| `ui_error` | Dull wooden knock | 0.15s | Invalid action. Not harsh — just a "no." |
| `ui_confirm` | Satisfying clasp click + tiny chime | 0.15s | Confirming an important choice. |
| `ui_inscription_slot` | Stone sliding into stone | 0.25s | Slotting an inscription into the Grimoire. |
| `ui_mana_gem_fill` | Crystal ping (ascending pitch per gem) | 0.08s | Mana refill at turn start. Played in sequence. |
| `ui_mana_gem_spend` | Crystal click (descending pitch per gem) | 0.06s | Mana spent when playing a card. |
| `ui_xp_gain` | Tiny quill scratch | 0.1s | XP awarded after battle. |
| `ui_mastery_tier_up` | Metallic shimmer + ascending tone | 0.3s | Card reaches new mastery tier. |

**Production notes:**
- UI sounds are routed to a separate bus with a low-pass filter at 8 kHz. UI sounds should never be bright or sharp — they're parchment and wood, not glass and metal (except mana gems).
- `ui_button_click` must be tested against 100 rapid clicks in succession. If it's annoying at that rate, it's wrong.
- Mana gem sounds use a pentatonic scale (CDEGA) to ensure any sequence sounds musical.

### 5.6 Category 5: Ambient Foley

Environmental detail sounds that establish place. These are always present, always subtle, never noticed consciously — but their absence would be immediately felt.

| Sound | Description | Duration | Context |
|-------|------------|:--------:|---------|
| `amb_library_base` | Deep room tone — stone walls, vast space, near-silence with weight | Loop (30s+) | All Archives scenes |
| `amb_candle_crackle` | Quiet wax/wick crackle, irregular timing | Loop (20s+) | Hub, Battle, Rest |
| `amb_wind_distant` | Far-off wind against stone, muffled | Loop (45s+) | All scenes (very quiet) |
| `amb_page_rustle` | Random distant page movement, as if books are alive | One-shot, random interval 8–20s | Hub, Archives |
| `amb_drip_water` | Single water drip in a stone chamber | One-shot, random interval 15–30s | Vile chapters |
| `amb_birdsong` | Single distant bird call, muffled by walls | One-shot, random interval 20–40s | Primal chapters, Rest |
| `amb_choir_whisper` | Barely audible choral breath | One-shot, random interval 25–45s | Radiant chapters |
| `amb_chain_clink` | Distant metal chain shifting, settling | One-shot, random interval 20–35s | Vile chapters |
| `amb_wood_creak` | Old shelf or floorboard settling | One-shot, random interval 15–30s | All Archives scenes |
| `amb_fire_crackle` | Warm hearth fire (closer than candle) | Loop (25s+) | Rest nodes |
| `amb_quill_scratch` | Distant quill on parchment, as if the Grimoire is writing itself | One-shot, random interval 30–60s | Hub (Easter egg) |

**Production notes:**
- Ambient loops must have seamless loop points — no audible click or gap at the wrap.
- Random one-shots use a timer with `randf_range(min, max)` seconds between triggers. Never play on a fixed schedule — regularity kills immersion.
- Total ambient layer volume must never exceed -12 dB. These sounds should be felt, not heard.

### 5.7 Category 6: Magic Accents

The supernatural layer. These sounds have no physical source — they are the Grimoire's magic, the alignment energy, the soul of the book made audible.

| Sound | Description | Duration | Context |
|-------|------------|:--------:|---------|
| `magic_radiant_accent` | High harmonic shimmer, bell-like, warm | 0.3s | Radiant card play, heal, purify |
| `magic_vile_accent` | Low dissonant drone fragment, vocal growl undertone | 0.3s | Vile card play, poison, curse |
| `magic_primal_accent` | Organic whoosh, wood creak, animal breath | 0.3s | Primal card play, chain, transform |
| `magic_alignment_shift` | Tonal drone in alignment's register, building and fading | 1.0s | Alignment score changes |
| `magic_conflicted` | Two drones fighting, detuned oscillation | 1.5s | Entering conflicted state |
| `magic_attune` | Resonant hum + crystalline lock-in | 0.4s | Player declares alignment attunement |
| `magic_aura_idle` | Gentle tonal pulse (sine wave with vibrato) | Loop (6s) | Grimoire aura particle effect |
| `magic_sigil_pulse` | Deep subharmonic throb | 0.5s | Sigil animation pulse |
| `magic_ultimate_charge` | Building harmonic series, layered voices ascending | 2.0s | Ultimate Spell charging (Lv 20) |
| `magic_ultimate_release` | Full harmonic explosion → silence → resonant decay | 1.5s | Ultimate Spell resolving |

**Production notes:**
- Magic accents are always layered ON TOP of a physical foley sound, never alone. The ink slash is the action; the magic accent is the soul of that action.
- Alignment-specific magic accents share a consistent tonal identity (see Section 8).
- Magic sounds use more reverb than any other category. They come from the book's inner world, not the physical room.

---

## 6. Audio Mood by Scene

### 6.1 Scene-by-Scene Audio Prescription

#### Grimoire Hub (Main Menu)

```
MOOD: Intimate, reverent, personal. You and your book, alone.

MUSIC:     Hub theme — solo hammered dulcimer over tonal drone.
           D Dorian, 60–70 BPM, rubato. 2 layers.
AMBIENT:   Library base tone, candle crackle (2 sources, slightly offset),
           distant wind. Random: page rustle, wood creak, quill scratch.
SFX:       Grimoire open/close, page turns, clasp clicks.
MAGIC:     Aura idle loop, sigil pulse. Gentle. The book breathes.

VOLUME MIX:
  Ambient ████████░░ 70%
  Music   ██████░░░░ 50%
  SFX     ██████████ 100% (when triggered)
  Magic   ████░░░░░░ 35%
```

#### Battle Scene (Standard Combat)

```
MOOD: Tense, tactical, escalating. The room fades away; the fight is all that matters.

MUSIC:     Combat theme — layered. Builds from percussion-only to full arrangement
           over 6+ turns. A Aeolian, 90–130 BPM (escalating).
AMBIENT:   Library base (reduced -6 dB from hub). Candle crackle (1 source).
           No random one-shots during combat — too distracting.
SFX:       Card actions (draw, play, discard), combat impacts (damage, heal, block),
           status effects, enemy death.
MAGIC:     Alignment accents on every card play. Attunement hum.

VOLUME MIX:
  Ambient ████░░░░░░ 35%
  Music   ████████░░ 70%
  SFX     ██████████ 100% (when triggered)
  Magic   ██████░░░░ 50%
```

#### Boss Encounter

```
MOOD: Epic, dangerous, climactic. This is the moment everything built toward.

MUSIC:     Boss combat theme — starts at Layer 3 intensity (no warm-up).
           E Phrygian, 115+ BPM. Full arrangement from turn 1.
           Unique boss intro stinger before music begins.
AMBIENT:   Near-silent. Only room base tone at -24 dB.
SFX:       Same as standard combat + boss-specific sounds (intro, special attacks).
MAGIC:     Heightened accents. All magic sounds +3 dB louder than standard combat.

VOLUME MIX:
  Ambient ██░░░░░░░░ 15%
  Music   ██████████ 90%
  SFX     ██████████ 100% (when triggered)
  Magic   ████████░░ 65%
```

#### Moral Choice Event

```
MOOD: Heavy, still, consequential. Time stops. The choice is everything.

MUSIC:     Fades to drone only. No rhythm, no melody. Just a sustained tone
           that creates tension through emptiness.
AMBIENT:   Returns to hub-level presence. Candle crackle. Distant wind.
           The room becomes real again — grounding the weight of the choice.
SFX:       Single reverb-heavy bell toll when the choice appears.
           Each option has a distinct "resonance" when hovered.
           Final choice triggers a deep, definitive sound (alignment-specific).
MAGIC:     Alignment-specific drone for the hovered option. Three drones
           compete softly until one is chosen.

VOLUME MIX:
  Ambient ████████░░ 70%
  Music   ██░░░░░░░░ 15% (drone only)
  SFX     ██████████ 100% (single impacts only)
  Magic   ██████░░░░ 50%
```

#### Rest / Treasure Node

```
MOOD: Relief, warmth, safety. A brief exhale between battles.

MUSIC:     Rest theme — solo wooden flute over drone. G Mixolydian, 55–65 BPM.
           If treasure, add dulcimer arpeggios.
AMBIENT:   Fire crackle (close, warm). Birdsong (distant). No wind.
           The room is cozy and small.
SFX:       Soft interactions. Card browsing, page turns, healing sounds.
MAGIC:     Minimal. The Grimoire rests too.

VOLUME MIX:
  Ambient ██████████ 90%
  Music   ██████░░░░ 50%
  SFX     ████████░░ 80% (softer touches)
  Magic   ██░░░░░░░░ 15%
```

#### Chapter Map

```
MOOD: Strategic, purposeful, anticipatory. Planning the journey ahead.

MUSIC:     Map theme — light percussion loop + drone. 70–80 BPM.
AMBIENT:   Library base, quiet page rustles. Scholarly atmosphere.
SFX:       Map node hover (parchment crinkle), node select (ink stamp),
           path reveal (ink drawing across parchment).
MAGIC:     Subtle boss node resonance (foreshadowing).

VOLUME MIX:
  Ambient ██████░░░░ 55%
  Music   ██████░░░░ 55%
  SFX     ██████████ 100%
  Magic   ████░░░░░░ 30%
```

#### Evolution Screen

```
MOOD: Transformative, exciting, decisive. The card is becoming something new.

MUSIC:     Current music fades. Bowed psaltery enters — ethereal, suspended.
           When evolution is chosen, key modulates to the alignment's mode.
SFX:       Card shatter (0.4s) → silence (0.3s) → card reform (0.6s).
           The silence in the middle is critical. Let the moment breathe.
MAGIC:     Three alignment drones hover as options are presented.
           Chosen alignment's drone swells to full; others fade to nothing.

VOLUME MIX:
  Ambient ██░░░░░░░░ 15%
  Music   ████████░░ 70%
  SFX     ██████████ 100%
  Magic   ████████░░ 70%
```

---

## 7. Voice & Vocalization

### 7.1 No Voice Acting (Deliberate Choice)

**There is no recorded voice acting in this game.** This is an intentional design decision, not a budget compromise.

**Why:**
- The Grimoire is the protagonist — it communicates through ink, sigils, and magic, not words
- Voice acting anchors characters to a single interpretation. The player's internal voice is more personal.
- Medieval manuscripts communicated through written text. Voice would break the fourth wall of the aesthetic.
- Budget and localization complexity saved can be invested in music and SFX quality

### 7.2 Vocal Elements (Non-Verbal Only)

Vocals DO appear, but only as **instruments** — never as intelligible speech:

| Vocal Element | Description | Usage |
|--------------|-------------|-------|
| **Wordless choir ("ah" / "oh")** | Sustained choral pad, no words, mixed gender | Radiant alignment accent, sacred moments, level-up |
| **Throat singing / overtone drone** | Deep male voice, harmonic overtones | Vile alignment accent, boss encounters, dark chapters |
| **Breathy whisper (unintelligible)** | Layered whispered voices, reversed and processed. No actual words. | Moral choice appearance, Grimoire idle (very rare), Vile corruption |
| **Humming** | Solo female hum, simple melody, distant | Primal alignment accent, rest nodes, nature chapters |
| **Chanting (syllabic, not words)** | Rhythmic vocal pattern, pseudo-Latin syllables | Boss fight intensity layer, ultimate spell |
| **Sighs / breaths** | Single human exhale or inhale, processed | Grimoire open (exhale), Grimoire close (inhale), healing |

**Critical rule:** No vocal element should ever sound like recognizable language. If a tester reports hearing "words," the vocal must be re-processed (reversed, pitch-shifted, or layered with itself at detuned intervals).

### 7.3 The Grimoire's "Voice"

The Grimoire communicates emotionally through sound, not speech. Its "voice" is a combination of:

| State | Grimoire's Sound | Implementation |
|-------|-----------------|----------------|
| **Content / idle** | Low tonal hum, steady, warm | `magic_aura_idle` loop at -18 dB |
| **Excited (card mastery near)** | Hum rises slightly in pitch and volume | Pitch shift +50 cents on aura loop when card XP > 80 |
| **Distressed (low HP)** | Hum becomes unstable, slight detuning | Add LFO wobble to aura loop when HP < 30% |
| **Conflicted** | Two tones fight, oscillating dominance | Dual aura loops, alternating volume with 2s crossfade |
| **Evolving** | Hum breaks into harmonic series, ascending | Chord built from fundamental up during evolution |
| **Level-up** | Deep resonant gong + ascending overtones | Largest "voice" moment — the Grimoire sings |

---

## 8. Alignment Audio Identity

### 8.1 Each Alignment Has a Sonic Signature

Just as each alignment has a visual color palette (Art Bible Section 3), each has a distinct **tonal palette** — a set of sounds, intervals, and instruments that define it aurally.

#### Radiant Audio Identity

```
REGISTER:       High (upper harmonics, soprano range)
ROOT INTERVAL:  Perfect fifth (purity, openness)
KEY INSTRUMENT: Choir (wordless), finger cymbals, high strings
REVERB:         Cathedral (large, bright, long tail)
TEXTURE:        Clean, clear, resonant. No distortion.
COLOR:          Bright gold — warm without being harsh.
EXAMPLE:        A bell ringing in a sunlit stone church.
```

| Sound | Character |
|-------|-----------|
| Radiant card play accent | High chime + choir breath |
| Radiant alignment shift | Ascending perfect fifth + warm harmonic swell |
| Radiant evolution reform | Crystal chimes ascending in scale + choir resolve |
| Radiant chapter ambient | Distant choir whispers, bell-like resonances |

#### Vile Audio Identity

```
REGISTER:       Low (sub-bass, baritone/bass range)
ROOT INTERVAL:  Tritone / minor second (dissonance, unease)
KEY INSTRUMENT: Low brass (horn, trombone), throat singing, bowed metal
REVERB:         Cavern (dark, diffuse, irregular reflections)
TEXTURE:        Gritty, distorted, wet. Sounds slightly decomposed.
COLOR:          Deep purple — felt in the chest, not the ears.
EXAMPLE:        A rusted gate opening in a flooded crypt.
```

| Sound | Character |
|-------|-----------|
| Vile card play accent | Low growl + dissonant scrape |
| Vile alignment shift | Descending tritone + rumbling sub-bass |
| Vile evolution reform | Grinding low tone ascending reluctantly + distorted chord |
| Vile chapter ambient | Dripping water, chain clinks, distant growls |

#### Primal Audio Identity

```
REGISTER:       Mid (alto range, earth frequencies)
ROOT INTERVAL:  Perfect fourth / major second (folk, open, modal)
KEY INSTRUMENT: Wooden flute, frame drum, animal sounds (distant)
REVERB:         Forest (medium, warm, slightly dampened by foliage)
TEXTURE:        Organic, breathy, wooden. Sounds alive.
COLOR:          Deep teal — earthy, present, grounded.
EXAMPLE:        Wind through a hollow tree trunk in a deep forest.
```

| Sound | Character |
|-------|-----------|
| Primal card play accent | Wooden thud + breathy whoosh |
| Primal alignment shift | Ascending open fourth + rustling organic texture |
| Primal evolution reform | Organic growth (creaking wood, unfurling leaves) + flute trill |
| Primal chapter ambient | Birdsong, rustling leaves, distant animal calls |

### 8.2 Alignment Mixing Rules

| Rule | Rationale |
|------|-----------|
| **Only one alignment accent per card play.** Card's alignment determines which accent plays. | Clarity — the player hears which alignment they're engaging. |
| **Attunement declaration plays ONLY the declared alignment's hum.** | Reinforces the commitment mechanic. |
| **Alignment shift plays the GAINING alignment's sound, not the old one.** | Positive reinforcement — you hear what you're becoming, not what you're leaving. |
| **Conflicted state layers TWO alignment drones at -6 dB each.** | The dissonance of two competing alignments is the point — it should sound unsettled. |
| **Boss encounters use the BOSS'S alignment for ambient and accent.** | The boss owns the room. The player is in the enemy's domain. |

---

## 9. Dynamic Audio Triggers

### 9.1 Trigger System Architecture

Audio triggers are events that cause sounds to play, change, or adjust. They're implemented as signals in the Godot signal system:

```gdscript
# Signals emitted by game systems, connected to AudioManager

# Combat triggers
signal combat_started(enemy_count: int, has_boss: bool)
signal turn_started(turn_number: int)
signal card_played(card: CardResource, target_index: int)
signal damage_dealt(amount: int, target_type: String)
signal damage_received(amount: int)
signal heal_applied(amount: int)
signal block_gained(amount: int)
signal status_applied(status_type: GlobalEnums.StatusType, target_type: String)
signal status_ticked(status_type: GlobalEnums.StatusType)
signal enemy_died(enemy: EnemyResource)
signal combat_ended(victory: bool)

# Progression triggers
signal alignment_shifted(alignment: GlobalEnums.Alignment, new_value: int)
signal card_mastery_changed(card: CardResource, new_tier: GlobalEnums.MasteryTier)
signal card_evolved(card: CardResource, alignment: GlobalEnums.Alignment)
signal grimoire_leveled_up(new_level: int)

# Narrative triggers
signal moral_choice_presented()
signal moral_choice_option_hovered(alignment: GlobalEnums.Alignment)
signal moral_choice_selected(alignment: GlobalEnums.Alignment)

# UI triggers
signal scene_changed(new_scene: String)
signal attunement_declared(alignment: GlobalEnums.Alignment)
signal grimoire_opened()
signal grimoire_closed()
```

### 9.2 Trigger → Audio Response Table

| Trigger | SFX Response | Music Response | Ambient Response |
|---------|-------------|----------------|-----------------|
| `combat_started` | `card_shuffle` | Transition → combat theme, L0+L1 active | Reduce ambient -6 dB |
| `turn_started(n)` | `card_draw_multi` + `ui_mana_gem_fill` | Activate layer based on turn number (see 4.3) | — |
| `card_played` | `card_play` + alignment magic accent | — | — |
| `damage_dealt(amt)` | `damage_dealt` (if amt < 6) or `damage_heavy` (if amt ≥ 6) | — | — |
| `damage_received(amt)` | `damage_received` | If HP < 30%: activate L4 intensity | — |
| `heal_applied` | `heal_apply` + `magic_radiant_accent` | — | — |
| `block_gained` | `block_gain` | — | — |
| `status_applied(POISON)` | `poison_apply` + `magic_vile_accent` | — | — |
| `status_ticked(POISON)` | `poison_tick` (at -6 dB) | — | — |
| `enemy_died` | `enemy_death` → 0.2s silence | If last enemy: transition → victory stinger | — |
| `combat_ended(true)` | `stinger_victory` | Transition → hub/map theme | Restore ambient |
| `combat_ended(false)` | `stinger_defeat` | Transition → hub theme (somber variant) | Restore ambient |
| `alignment_shifted` | `magic_alignment_shift` (alignment-specific) | — | — |
| `card_mastery_changed` | `ui_mastery_tier_up` | — | — |
| `card_evolved` | `card_evolve_shatter` → silence → `card_evolve_reform` | Key modulation stinger | Reduce ambient to near-zero during evolution |
| `grimoire_leveled_up` | `stinger_levelup` | Brief fanfare interruption | Full ambient suppression for 2s |
| `moral_choice_presented` | Reverb bell toll | Fade to drone only | Restore to hub-level |
| `moral_choice_option_hovered` | Alignment-specific resonance | Alignment drone fades in for hovered option | — |
| `moral_choice_selected` | `ui_confirm` + alignment-specific deep impact | Drone resolves to alignment's mode | Alignment-specific ambient one-shot |
| `grimoire_opened` | `grimoire_open` + exhale | Begin hub theme | Begin hub ambient |
| `grimoire_closed` | `grimoire_close` + inhale | Fade music to silence | Fade ambient to silence |

### 9.3 Conditional Triggers (State-Dependent)

Some audio behavior depends on game state, not just discrete events:

| Condition | Audio Behavior |
|-----------|---------------|
| **Player HP < 30%** | Grimoire aura hum becomes detuned (LFO wobble). Music L4 (intensity) activates. Ambient heartbeat-like low pulse added at -15 dB. |
| **Player HP < 10%** | All non-essential audio ducks -3 dB. Only combat SFX and a single sustained low drone remain. Creates tunnel-vision focus. |
| **Enemy enrage (turn 7+)** | Music L5 (urgency) activates. Percussion tempo increases. Ambient fully suppressed. |
| **Card XP > 90 (near evolution)** | Card hover sound gains a subtle sparkle overtone. Player is subconsciously trained to notice evolve-ready cards. |
| **Grimoire conflicted state** | Hub aura plays dual-alignment loop. Music gains slight beat-frequency wobble (two detuned drones). |
| **All enemies have same alignment as player** | No Alignment Clash. Music is slightly quieter (-3 dB). Encounter feels routine, not epic. |
| **Alignment Clash (opposing alignment)** | Music gains +3 dB. Magic accents are louder. Room feels charged with opposing energy. |

### 9.4 Silence as a Design Tool

**Silence is sound design.** Specific moments use deliberate silence for maximum impact:

| Moment | Silence Duration | What Surrounds It |
|--------|:---:|------------------|
| After card evolution shatter, before reform | 0.3s | Shatter particles still visible. The player holds their breath. |
| After boss death, before victory stinger | 0.5s | The ink dissolve completes. Then the triumph. |
| After moral choice bell toll, before options appear | 0.8s | The bell reverb decays naturally. Then the drones begin. |
| After defeat stinger, before return to hub | 1.0s | The longest silence. Somber. The book rests. |
| Between the last card draw sound and the first turn | 0.3s | Combat has begun. A moment to assess before action. |

---

## 10. Audio Bus Architecture

### 10.1 Bus Layout

```
Master Bus (output)
├── Music Bus
│   ├── Volume: -6 dB default
│   ├── Effects: Limiter (ceiling -1 dB)
│   └── Sub-buses: None (layers are individual AudioStreamPlayers on this bus)
│
├── SFX Bus
│   ├── Volume: 0 dB default
│   ├── Effects: Limiter (ceiling -1 dB)
│   ├── Sub-bus: Combat SFX
│   │   └── Volume: 0 dB (ducked by Music in boss fights)
│   └── Sub-bus: UI SFX
│       ├── Volume: -3 dB
│       └── Effects: Low-pass filter (8 kHz cutoff)
│
├── Ambient Bus
│   ├── Volume: -12 dB default
│   ├── Effects: Low-pass filter (6 kHz cutoff, subtle warmth)
│   └── Sub-bus: Ambient One-Shots
│       └── Volume: -6 dB relative to ambient loops
│
├── Magic Bus
│   ├── Volume: -6 dB default
│   ├── Effects: Reverb (large hall, 40% wet, 2.5s decay)
│   └── No sub-buses
│
└── Voice Bus (reserved for future)
    └── Volume: 0 dB (unused — reserved for potential narration DLC)
```

### 10.2 Bus Mixing Rules

| Rule | Implementation |
|------|---------------|
| **SFX never ducks below Music** | SFX bus has priority. Music compresses before SFX. |
| **Music ducks -3 dB when any SFX plays** | Sidechain compression on Music bus, keyed by SFX bus activity. Attack: 5ms, Release: 200ms. |
| **Ambient auto-reduces in combat** | AudioManager sets ambient bus volume based on `BattleState`. |
| **Magic bus inherits scene reverb** | Reverb wet% changes per scene (Hub: 40%, Combat: 25%, Moral Choice: 60%). |
| **UI SFX always audible** | UI bus is NOT affected by music ducking or ambient changes. It sits on top of everything at a controlled volume. |
| **Master bus limiter prevents clipping** | Ceiling at -1 dB. No sound should ever clip, even with multiple simultaneous SFX. |

### 10.3 Player-Facing Volume Controls

```
Settings → Audio
├── Master Volume    [████████████████████░░] 85%
├── Music Volume     [██████████████████░░░░] 75%
├── Sound Effects    [████████████████████░░] 85%
└── Ambience         [██████████████░░░░░░░░] 60%
```

- **4 sliders** — no more, no less. Players don't need to control Magic vs. Combat SFX vs. UI SFX separately.
- Magic bus volume is tied to the SFX slider (magic accents are perceived as part of SFX by players).
- Each slider maps to 0–100%, stored as linear value, converted to dB via `linear_to_db()`.
- Default volumes are set to give the "intended" mix out of the box. Most players never touch audio settings — the defaults must be perfect.

---

## 11. Technical Specs & Performance

### 11.1 Audio Format Standards

| Format | Usage | Bit Depth | Sample Rate | Compression |
|--------|-------|:---------:|:-----------:|:-----------:|
| **OGG Vorbis (.ogg)** | Music tracks, ambient loops | 16-bit | 44.1 kHz | Quality 5 (~128 kbps) |
| **WAV (.wav)** | Short SFX (< 2 seconds) | 16-bit | 44.1 kHz | None (uncompressed) |
| **OGG Vorbis (.ogg)** | Long SFX (≥ 2 seconds), ambient one-shots | 16-bit | 44.1 kHz | Quality 6 (~160 kbps) |

**Why OGG for music and long sounds?** WAV files are large (1 minute of stereo 44.1kHz 16-bit = ~10 MB). OGG compresses ~10:1 with imperceptible quality loss at Q5+. For a card game, this quality is more than sufficient.

**Why WAV for short SFX?** Decoding overhead is negligible for short samples, and WAV has zero decode latency. Card plays and UI clicks must respond instantly.

### 11.2 Performance Budget

| Metric | Budget | Hard Limit |
|--------|--------|------------|
| **Simultaneous audio streams** | 12 | 20 |
| **Simultaneous music layers** | 6 | 8 |
| **SFX polyphony (concurrent one-shots)** | 4 | 8 |
| **Audio memory footprint** | 30 MB | 50 MB |
| **Total audio asset size on disk** | 80 MB | 120 MB |
| **Audio processing CPU** | < 2% | < 5% |
| **SFX trigger latency** | < 10ms | < 30ms |

### 11.3 Polyphony Management

When too many sounds try to play simultaneously:

```gdscript
# Polyphony rules (implemented in AudioManager)

# Priority system (highest to lowest):
# 1. UI feedback sounds (always play)
# 2. Combat impacts (damage_dealt, damage_received)
# 3. Card action sounds (card_play, card_draw)
# 4. Status effect ticks (lowest priority SFX)
# 5. Magic accents (steal from this pool first)
# 6. Ambient one-shots (skip if at limit)

# If at polyphony limit:
# - New high-priority sound steals the voice of the lowest-priority
#   currently playing sound
# - Stolen sound fades out over 50ms (not hard-cut)
# - Never steal from UI — UI has reserved voices (2 minimum)
```

### 11.4 Audio Memory Strategy

| Sound Type | Loading Strategy |
|-----------|-----------------|
| **Music tracks** | Stream from disk (AudioStreamOggVorbis). Never load into memory. |
| **Ambient loops** | Stream from disk. Max 3 ambient streams at once. |
| **SFX (short)** | Preload into memory at scene start. Reuse across the scene. |
| **SFX (per-scene)** | Load when entering scene, unload when leaving. |
| **Magic accents** | Preload all 3 alignment accents at game start (small, frequently used). |

---

## 12. Asset Production Pipeline

### 12.1 Audio Asset Naming Convention

```
category_name_variant.ext

Categories:
  mus_    → Music track
  sfx_    → Sound effect
  amb_    → Ambient sound
  mag_    → Magic accent
  ui_     → UI feedback
  vox_    → Vocal element

Examples:
  mus_hub_theme.ogg
  mus_combat_standard_layer0_drone.ogg
  mus_combat_standard_layer1_percussion.ogg
  mus_combat_standard_layer2_strings.ogg
  mus_stinger_victory.ogg
  sfx_card_play_01.wav
  sfx_card_play_02.wav
  sfx_card_play_03.wav
  sfx_damage_dealt_01.wav
  sfx_grimoire_open_01.wav
  amb_library_base.ogg
  amb_candle_crackle.ogg
  amb_drip_water_01.ogg
  mag_radiant_accent_01.wav
  mag_vile_accent_01.wav
  mag_primal_accent_01.wav
  ui_button_click.wav
  ui_mana_gem_fill.wav
  vox_choir_pad.ogg
  vox_whisper_layer.ogg
```

### 12.2 Variation Numbering

Multiple variations of the same sound prevent ear fatigue on repetition:

| Sound | Minimum Variations | Selection Method |
|-------|:-:|-----------------|
| `sfx_card_play` | 3 | Random (no immediate repeat) |
| `sfx_card_draw` | 3 | Random |
| `sfx_damage_dealt` | 3 | Random |
| `sfx_damage_received` | 2 | Random |
| `ui_button_click` | 1 | Single (must be perfectly consistent) |
| `amb_page_rustle` | 3 | Random + random pitch shift ±100 cents |
| `amb_wood_creak` | 3 | Random |
| `sfx_page_turn` | 4 | Sequential (cycle through in order) |

**Anti-repetition rule:** The AudioManager tracks the last-played variation index for each sound. It never plays the same variation twice in a row. For sounds with only 2 variations, it strictly alternates.

```gdscript
func play_varied(sound_name: String) -> void:
    var variations: Array = sound_pool[sound_name]
    var last: int = last_played.get(sound_name, -1)
    var next: int = last
    while next == last:
        next = randi_range(0, variations.size() - 1)
    last_played[sound_name] = next
    _play(variations[next])
```

### 12.3 Audio Asset Folder Structure

```
res://assets/audio/
├── music/
│   ├── hub/
│   │   └── mus_hub_theme.ogg
│   ├── combat/
│   │   ├── mus_combat_standard_layer0_drone.ogg
│   │   ├── mus_combat_standard_layer1_percussion.ogg
│   │   ├── mus_combat_standard_layer2_strings.ogg
│   │   ├── mus_combat_standard_layer3_lead.ogg
│   │   ├── mus_combat_standard_layer4_intensity.ogg
│   │   ├── mus_combat_standard_layer5_urgency.ogg
│   │   ├── mus_combat_boss_layer0_drone.ogg
│   │   ├── ... (boss layers)
│   │   └── mus_moral_drone.ogg
│   ├── stingers/
│   │   ├── mus_stinger_victory.ogg
│   │   ├── mus_stinger_defeat.ogg
│   │   ├── mus_stinger_evolution.ogg
│   │   └── mus_stinger_levelup.ogg
│   └── rest/
│       └── mus_rest_theme.ogg
│
├── sfx/
│   ├── grimoire/
│   │   ├── sfx_grimoire_open_01.wav
│   │   ├── sfx_grimoire_open_02.wav
│   │   ├── sfx_grimoire_close_01.wav
│   │   ├── sfx_page_turn_01.wav through _04.wav
│   │   ├── sfx_page_flutter_01.wav through _03.wav
│   │   ├── sfx_clasp_click_01.wav
│   │   └── sfx_ink_write_01.wav through _04.wav
│   ├── cards/
│   │   ├── sfx_card_draw_01.wav through _03.wav
│   │   ├── sfx_card_draw_multi_01.wav
│   │   ├── sfx_card_play_01.wav through _03.wav
│   │   ├── sfx_card_hover_01.wav
│   │   ├── sfx_card_discard_01.wav
│   │   ├── sfx_card_shuffle_01.wav
│   │   ├── sfx_card_unplayable.wav
│   │   ├── sfx_card_evolve_shatter.wav
│   │   └── sfx_card_evolve_reform_radiant.wav
│   │       sfx_card_evolve_reform_vile.wav
│   │       sfx_card_evolve_reform_primal.wav
│   ├── combat/
│   │   ├── sfx_damage_dealt_01.wav through _03.wav
│   │   ├── sfx_damage_heavy_01.wav through _02.wav
│   │   ├── sfx_damage_received_01.wav through _02.wav
│   │   ├── sfx_heal_apply_01.wav through _02.wav
│   │   ├── sfx_block_gain_01.wav through _02.wav
│   │   ├── sfx_block_absorb_01.wav
│   │   ├── sfx_block_break.wav
│   │   ├── sfx_poison_apply_01.wav
│   │   ├── sfx_poison_tick_01.wav
│   │   ├── sfx_burn_apply_01.wav
│   │   ├── sfx_burn_tick_01.wav
│   │   ├── sfx_stun_apply.wav
│   │   ├── sfx_regen_tick_01.wav
│   │   ├── sfx_enemy_death_01.wav through _02.wav
│   │   ├── sfx_enemy_spawn_01.wav
│   │   └── sfx_boss_intro_arbiter.wav
│   │       sfx_boss_intro_hollow_priest.wav
│   │       sfx_boss_intro_rootmother.wav
│   └── ui/
│       ├── ui_button_hover.wav
│       ├── ui_button_click.wav
│       ├── ui_button_back.wav
│       ├── ui_tab_switch.wav
│       ├── ui_scroll.wav
│       ├── ui_popup_open.wav
│       ├── ui_popup_close.wav
│       ├── ui_error.wav
│       ├── ui_confirm.wav
│       ├── ui_inscription_slot.wav
│       ├── ui_mana_gem_fill.wav
│       ├── ui_mana_gem_spend.wav
│       ├── ui_xp_gain.wav
│       └── ui_mastery_tier_up.wav
│
├── ambient/
│   ├── loops/
│   │   ├── amb_library_base.ogg
│   │   ├── amb_candle_crackle.ogg
│   │   ├── amb_wind_distant.ogg
│   │   └── amb_fire_crackle.ogg
│   └── oneshots/
│       ├── amb_page_rustle_01.ogg through _03.ogg
│       ├── amb_drip_water_01.ogg
│       ├── amb_birdsong_01.ogg
│       ├── amb_choir_whisper_01.ogg
│       ├── amb_chain_clink_01.ogg
│       ├── amb_wood_creak_01.ogg through _03.ogg
│       └── amb_quill_scratch_01.ogg
│
├── magic/
│   ├── mag_radiant_accent_01.wav
│   ├── mag_vile_accent_01.wav
│   ├── mag_primal_accent_01.wav
│   ├── mag_alignment_shift_radiant.wav
│   ├── mag_alignment_shift_vile.wav
│   ├── mag_alignment_shift_primal.wav
│   ├── mag_conflicted.ogg
│   ├── mag_attune.wav
│   ├── mag_aura_idle_radiant.ogg
│   ├── mag_aura_idle_vile.ogg
│   ├── mag_aura_idle_primal.ogg
│   ├── mag_sigil_pulse.wav
│   ├── mag_ultimate_charge.ogg
│   └── mag_ultimate_release.wav
│
└── vox/
    ├── vox_choir_pad_radiant.ogg
    ├── vox_throat_drone_vile.ogg
    ├── vox_whisper_layer.ogg
    ├── vox_hum_primal.ogg
    ├── vox_chant_boss.ogg
    └── vox_breath_exhale.wav
        vox_breath_inhale.wav
```

### 12.4 Total Asset Count (MVP)

| Category | Files | Est. Size |
|----------|:-----:|:---------:|
| Music (10 tracks × avg 6 layers) | ~35 | ~40 MB |
| SFX (Grimoire + Cards + Combat + UI) | ~65 | ~8 MB |
| Ambient (Loops + One-shots) | ~18 | ~15 MB |
| Magic Accents | ~15 | ~3 MB |
| Vocal Elements | ~7 | ~4 MB |
| **Total** | **~140 files** | **~70 MB** |

---

## 13. Audio Anti-Patterns

### 13.1 What We Do NOT Do

| Anti-Pattern | Why It's Wrong For Us | What To Do Instead |
|-------------|----------------------|-------------------|
| **Loud, constant music that fills every silence** | The Grimoire's world is quiet. Silence has meaning. Constant music is emotionally flat. | Music breathes. It fades. It makes room for foley and ambient. |
| **Stock "epic orchestral" battle music** | Generic orchestral screams "asset flip." Our sound is intimate, not Hollywood. | Chamber ensemble. Medieval instruments. Earn the epic moments. |
| **Cartoon sound effects (boing, splat, wahwah)** | Wrong tone entirely. This is a dark fantasy manuscript, not a party game. | Grounded foley with subtle magic layering. |
| **Notification-style UI sounds (dings, pings)** | Feels like a mobile app, not a grimoire. | Parchment, wood, and ink sounds for UI. Crystal only for mana gems. |
| **Voice acting / narration** | Anchors characters, breaks the manuscript aesthetic, adds localization cost. | Wordless vocals (choir, hums, whispers) as instruments only. |
| **Reverb on everything** | Makes the world sound like a bathroom. Reverb is a placement tool. | Reverb only on Magic bus and specific ambient sounds. SFX and UI are dry. |
| **Same sound every time** | Ear fatigue. The brain tunes out repeating identical sounds by the 3rd time. | 2–4 variations per frequent sound. Random selection with no-repeat rule. |
| **Audio that doesn't match animation timing** | A card-play sound that arrives 100ms after the visual is jarring. | SFX triggers are locked to animation keyframes. Test at 60 FPS and 30 FPS. |
| **Abrupt music cuts** | Sounds broken, not designed. | All music transitions use crossfade (min 0.5s) or beat-synced switching. |
| **Loud stingers with no dynamic range** | If the victory stinger is as loud as the combat music, it has no impact. | Stingers peak +3 dB above surrounding music, preceded by a brief dip. Dynamic range IS the impact. |
| **Background music with prominent melody loops** | A melody that loops every 30 seconds becomes torture by minute 5. | Melodies are sparse and emerge from texture. Base layers are rhythmic/harmonic, not melodic. Melodies are in upper layers that don't always play. |

### 13.2 The 100-Play Test

Before any sound is shipped, it must pass the **100-Play Test:**

1. Play the sound 100 times in a row at game volume
2. If it becomes annoying before play 50 → **reject and redesign**
3. If it becomes unnoticeable before play 30 → **too quiet or too bland, add character**
4. If it's still pleasant at play 100 → **ship it**

This test applies especially to: `ui_button_click`, `card_draw`, `card_play`, `damage_dealt`, `page_turn`.

---

## 14. Implementation Phases

### Phase 1: Data Architecture (Complete)
No audio. Silent foundation.

### Phase 2: Battle System — First Sounds
```
Priority SFX to implement:
├── sfx_card_play (3 variations) — most critical feedback sound
├── sfx_card_draw (3 variations) — second most frequent
├── sfx_damage_dealt (3 variations) — combat feedback
├── sfx_damage_received (2 variations) — player consequence
├── ui_button_click — universal interaction
├── ui_mana_gem_fill + spend — turn rhythm
└── sfx_enemy_death (2 variations) — combat resolution

Placeholder music:
├── Single loop for combat (no layers yet)
└── Single loop for UI screens

No ambient yet. No magic accents yet.
```

### Phase 3: PvE Campaign — Atmosphere Layer
```
Add:
├── Ambient loops (library base, candle crackle, wind)
├── Ambient one-shots (page rustle, wood creak)
├── sfx_grimoire_open + close
├── sfx_page_turn (4 variations)
├── Moral choice sounds (bell toll, alignment drones)
├── Map interaction sounds
└── Rest node ambient (fire, birds)

Upgrade music:
├── Hub theme (simple, 2 layers)
├── Distinct map theme
└── Moral choice drone
```

### Phase 4: Content & Progression — Full SFX Set
```
Add:
├── All remaining SFX variations
├── Evolution sounds (shatter, silence, reform × 3 alignments)
├── Level-up stinger
├── Mastery tier-up sound
├── Status effect sounds (all types)
├── Boss intro stingers (per boss)
└── Magic accents (all 3 alignments)
```

### Phase 5: Visual & Audio Polish — Final Mix
```
Complete:
├── Full layered music system (6 layers per combat track)
├── Dynamic layer activation tied to turn count
├── Beat-synced transitions
├── AudioManager autoload (full implementation)
├── Bus architecture with compression and limiting
├── Vocal elements (choir, whispers, hums)
├── Grimoire "voice" system (aura pitch/wobble based on state)
├── All conditional audio triggers
├── Player volume controls in settings
├── Final mix pass (balance all buses)
├── 100-Play Test on all frequent sounds
└── Platform-specific audio testing
```

### Phase 6: PvP & Live
```
Add:
├── PvP-specific stingers (match found, match start)
├── Opponent's turn ambient (waiting sounds)
├── Timer warning sounds (turn clock)
├── Matchmaking ambient
└── Seasonal music variants (if applicable)
```

---

## 15. Reference Listening

### 15.1 Soundtrack References

Listen to these for tonal guidance before composing or sourcing:

| Reference | What To Listen For | Relevance |
|-----------|-------------------|-----------|
| **Slay the Spire OST** (Clark Aboud) | How combat music builds tension without overwhelming. Restrained orchestration. | Combat music pacing, not-too-epic tone |
| **Inscryption OST** (Jonah Senzel) | Dark atmosphere through minimal means. Music box, isolated instruments, unease through subtlety. | Grimoire hub mood, defeat moments, intimate dread |
| **Darkest Dungeon OST** (Stuart Chatwood) | Dark fantasy narration-adjacent music. Cello as lead voice. Modal, not tonal. | Instrument palette, cello usage, modal composition |
| **Hades OST** (Darren Korb) | Use of lute/guitar in combat. Dynamic music that shifts with gameplay intensity. Vocal integration. | Lute in combat context, dynamic layering approach |
| **Return of the Obra Dinn OST** (Lucas Pope) | Extreme minimalism. Single instruments carrying entire emotional scenes. | Moral choice moments, less-is-more philosophy |
| **Pentiment OST** (Alkemie) | Medieval instruments (hurdy-gurdy, psaltery, recorder) in a game context. Period-authentic without being dry. | Instrument selection, medieval authenticity |
| **Hollow Knight OST** (Christopher Larkin) | How quiet ambient passages make combat music feel epic by contrast. Dynamic range between areas. | Hub vs. combat contrast, ambient design |

### 15.2 Sound Design References

| Reference | What To Listen For |
|-----------|-------------------|
| **Inscryption** card play sounds | Physical card foley — weight, texture, paper-on-wood |
| **Slay the Spire** UI sounds | Clean, quick, non-intrusive button feedback |
| **Baldur's Gate 3** inventory sounds | Book handling, scroll unfurling, potion clinking — grounded fantasy foley |
| **Hearthstone** card play and impact | Satisfying "thud" on card play. Over-produced for our needs, but the satisfaction target is right |
| **Library ASMR recordings** | Real library ambience — paper, silence, distant sounds, the weight of a quiet room |

### 15.3 Key Listening Exercises

Before beginning audio production, the sound designer/composer should:

1. **Sit in a real library for 30 minutes with eyes closed.** Note every sound — the building settling, pages turning three rooms away, the specific quality of silence in a space full of books. This is our ambient baseline.

2. **Handle an old, heavy book.** A leather-bound book if possible. Open it slowly. Turn pages. Close it. Listen to the clasp, the creak, the air between pages. Record these sounds. This is the Grimoire's physical voice.

3. **Listen to a single cello playing in a stone room.** Note how the reverb changes the emotional quality. This is our lead instrument in its natural habitat.

4. **Play Inscryption's Act 1 with headphones.** Ignore the gameplay. Focus on how sound creates the feeling of being alone with a strange, living artifact. That isolation + intimacy is our target.

---

*Audio carries 40% of emotional impact. A perfectly art-directed game with bad audio feels hollow. A moderately art-directed game with perfect audio feels alive. Invest in audio proportionally — it is not a garnish, it is half the meal.*

Sources:
- [Godot Audio Buses Documentation](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html)
- [Godot 4.3 New Music Features (AudioStreamInteractive)](https://blog.blips.fm/articles/the-new-music-features-in-godot-43-explained)
- [Dynamic Music: Vertical Layering vs. Horizontal Resequencing](https://www.thegameaudioco.com/making-your-game-s-music-more-dynamic-vertical-layering-vs-horizontal-resequencing)
- [Adaptive Music in Video Games](https://blog.blips.fm/articles/adaptive-music-in-video-games-what-it-is-and-how-it-works)
- [Dark Fantasy RPG Instruments Guide](https://www.ttrpg-games.com/blog/top-7-rpg-instruments-for-fantasy-worlds/)
- [Medieval Fantasy RPG Sound Effects Library](https://www.asoundeffect.com/sound-library/medieval-fantasy-rpg-sound-effects-library-role-playing-game-royalty-free-sfx-audio-pack-download/)
- [Slay the Spire OST (Clark Aboud)](https://clarkaboudmusic.bandcamp.com/album/slay-the-spire-original-soundtrack)
- [Inscryption OST (Jonah Senzel)](https://music.apple.com/us/album/inscryption-original-soundtrack/1660502329)
