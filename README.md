# Grimoire: The Soulbound Legacy

A roguelite card RPG where every Grimoire is unique. Built in Godot 4.5 with GDScript.

## The Concept

You are bound to a living spellbook — a Grimoire with its own name, personality, and moral compass. Every card you play, every choice you make, and every alignment you embrace permanently shapes your Grimoire's identity. No two playthroughs are the same.

**Core Pillars:**
- **Soulbound Identity** — Your Grimoire is generated from a seed, giving it a unique name, deck, and personality
- **Moral Weight** — Every choice shifts your alignment (Radiant, Vile, or Primal), altering your cards and abilities
- **Earned Mastery** — Cards evolve through use, branching into 3 alignment paths per card
- **Meaningful Risk** — Die in a chapter and lose unbound pages forever

## Features

- **Turn-based card combat** with Alignment Attunement (declare an alignment each turn to reduce matching card costs)
- **30 base cards** with 30+ evolved variants across 3 alignment paths
- **3 PvE chapters** with combat encounters, moral choices, treasure, rest nodes, and bosses
- **Grimoire progression** from level 1–20 with deck size scaling, inscription slots, and an Ultimate Spell at max level
- **Seed-based generation** — share seeds to compare builds with friends
- **5 custom shaders** (aura pulse, corruption overlay, page turn, card glow, damage flash)
- **Audio system** with 5-bus architecture, crossfading, and vertical layering support
- **Settings menu** with volume sliders and quality presets (Low/Medium/High)
- **Export presets** for Windows, Linux, and macOS

## Project Status

| Phase | Name | Status | Version |
|:-----:|------|:------:|:-------:|
| 1 | Data Architecture | Complete | 0.1.0 |
| 2 | Battle System | Complete | 0.2.0 |
| 3 | PvE Campaign | Complete | 0.3.0 |
| 4 | Content & Progression | Complete | 0.4.0 |
| 5 | Visual & Audio Polish | In Progress | 0.5.0 |
| 6 | PvP & Live Service | Planned | 0.6.0 |

**Progress:** 108/140 tasks complete (77%)

## Requirements

- [Godot 4.5.1](https://godotengine.org/download/) or later

## Getting Started

1. Clone the repository
2. Open `project.godot` in the Godot editor
3. Press F5 to run

### Generating Placeholder Assets

Placeholder art and audio stubs can be regenerated with:

```
godot --headless --path . --script res://tools/generate_placeholders.gd
```

### Running Tests

Run all 8 test suites (235+ tests):

```bash
for test in test_phase1 test_combat test_effects test_deck test_chapter_gen test_seed_validator test_inscriptions test_progression; do
  godot --headless --path . --script res://tests/${test}.gd
done
```

## Project Structure

```
grimoire-soulbound-legacy/
├── autoload/              # Singletons (GameManager, AudioManager, etc.)
├── assets/
│   ├── art/               # Card, enemy, grimoire, and UI sprites
│   ├── audio/             # Music, SFX, and ambient stubs
│   └── shaders/           # 5 canvas_item shaders
├── resources/
│   ├── cards/             # 30 base + 30 evolved card .tres files
│   ├── chapters/          # 3 chapter definitions
│   ├── enemies/           # Enemy stat blocks
│   ├── inscriptions/      # Passive buff definitions
│   └── moral_choices/     # Moral choice events
├── scenes/
│   ├── battle/            # Combat scene, card nodes, enemy nodes
│   ├── campaign/          # Chapter map, moral choice, treasure, rest
│   ├── hub/               # Grimoire hub (main menu)
│   └── ui/                # Settings menu
├── scripts/
│   ├── data/              # Resource class definitions
│   ├── systems/           # Core game logic (combat, deck, AI, etc.)
│   └── ui/                # UI controllers and animation helpers
├── tests/                 # 8 test suites
└── tools/                 # Asset generation scripts
```

## Documentation

- [GDD.md](GDD.md) — Game Design Document
- [TDD.md](TDD.md) — Technical Design Document
- [ART_BIBLE.md](ART_BIBLE.md) — Visual Style Guide
- [ADD.md](ADD.md) — Audio Design Document
- [CGP.md](CGP.md) — Core Game Pillars
- [ECONOMY.md](ECONOMY.md) — Economy System Design
- [ROADMAP.md](ROADMAP.md) — Production Roadmap

## License

All rights reserved.
