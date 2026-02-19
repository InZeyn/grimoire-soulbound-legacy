# Grimoire: The Soulbound Legacy — Art Bible

> **Version:** 1.0
> **Last Updated:** 2026-02-18
> **Companion Documents:** [GDD.md](GDD.md) | [TDD.md](TDD.md)
> **Art Direction Summary:** Dark fantasy meets illuminated manuscript — parchment, ink, and gold leaf collide with crackling magical auras
> **Render Target:** 1920×1080 (design resolution), minimum 1280×720

---

## Table of Contents

1. [Visual Identity & Pillars](#1-visual-identity--pillars)
2. [Art Style References](#2-art-style-references)
3. [Color Bible](#3-color-bible)
4. [The Grimoire (Hero Asset)](#4-the-grimoire-hero-asset)
5. [Card Art](#5-card-art)
6. [Character & Enemy Art](#6-character--enemy-art)
7. [Environment & Background Art](#7-environment--background-art)
8. [Lighting Philosophy](#8-lighting-philosophy)
9. [VFX & Particle Language](#9-vfx--particle-language)
10. [UI Style Rules](#10-ui-style-rules)
11. [Typography System](#11-typography-system)
12. [Iconography](#12-iconography)
13. [Animation Principles](#13-animation-principles)
14. [Audio-Visual Pairing](#14-audio-visual-pairing)
15. [Asset Production Guidelines](#15-asset-production-guidelines)
16. [Anti-Patterns (What We Are NOT)](#16-anti-patterns-what-we-are-not)

---

## 1. Visual Identity & Pillars

### 1.1 One-Sentence Identity

> **"A living manuscript — ancient ink that breathes, gold leaf that bleeds, and parchment that remembers."**

Every visual in the game must feel like it could exist inside a medieval codex that has been touched by magic. The aesthetic is rooted in the real history of illuminated manuscripts — carbon black ink, vermilion red, ultramarine blue, burnished gold — but twisted by supernatural forces. Pages flutter on their own. Sigils pulse with inner light. Ink crawls across borders when the alignment shifts.

### 1.2 The Four Visual Pillars

Every art asset must satisfy at least two of these pillars:

| Pillar | Meaning | Test Question |
|--------|---------|---------------|
| **Handcrafted** | Everything looks drawn, painted, or lettered by hand. No photorealism. No sterile vector art. Visible brushstrokes, ink splatters, imperfect edges. | "Could a medieval scribe have started this?" |
| **Living** | The world is not static. Pages breathe. Auras pulse. Ink shifts. Even idle states have subtle motion. | "Does this feel alive when nothing is happening?" |
| **Soulbound** | The visuals tell a story of ownership and history. Wear marks, alignment corruption, mastery glow — your Grimoire looks different from everyone else's because it IS different. | "Can I read this object's history by looking at it?" |
| **Readable** | Despite the ornate aesthetic, gameplay information is always clear. Card costs, enemy intents, HP bars — clarity over decoration every single time. | "Can a player parse this in under 1 second?" |

### 1.3 Mood Keywords

```
Ancient        Handwritten       Alive           Weathered
Sacred         Forbidden         Intimate        Earned
Ink-stained    Gold-touched      Soul-scarred    Atmospheric
```

**NOT these:**
```
Clean          Modern            Cute            Photorealistic
Chibi          Neon              Corporate       Minimalist
Pixelated      Voxel             Low-poly        Anime (full style)
```

We borrow *themes* from Black Clover (grimoire lore, magic knight orders, soulbound books) but NOT its anime art style. The visual language is Western dark fantasy manuscript, not Eastern anime.

---

## 2. Art Style References

### 2.1 Primary Influences

#### Illuminated Manuscripts (The Foundation)

The core visual language is drawn from medieval illuminated manuscripts — handwritten texts decorated with gold leaf, intricate borders, and miniature paintings created by monastery scribes between the 6th and 15th centuries.

**What we take from manuscripts:**
- **Parchment as the universal surface.** Every UI panel, card, and background has a parchment or vellum texture — never flat color, never glossy
- **Ink as the drawing medium.** Line art uses visible brushstrokes with slight irregularity — not perfect vectors
- **Gold leaf as the accent.** Gold is sacred. It marks important elements: card borders at mastery, legendary rarity glow, Grimoire cover embellishments, UI headers
- **Decorated initials and borders.** UI section dividers use illuminated border patterns — vine scrollwork, geometric knotwork, or alignment-themed motifs
- **The Illuminator's Palette.** Our color system is derived from historical pigments: vermilion, ultramarine, orpiment, verdigris, carbon black, lead white

**Key references:**
- The Book of Kells (intricate knotwork borders, zoomorphic initials)
- Les Très Riches Heures du Duc de Berry (rich miniature paintings, gold leaf calendars)
- The Lindisfarne Gospels (carpet pages with geometric precision)

#### Inkulinati (Game Reference — Manuscript Style in Practice)

The game *Inkulinati* demonstrates how illuminated manuscript aesthetics translate into interactive game art — hand-drawn characters on parchment, ink-based animations, quill-scratch effects.

**What we take from Inkulinati:**
- Proof that manuscript style works for games at 1080p
- Parchment texture as a universal background that never tires the eye
- Ink-line characters feel handcrafted without requiring AAA production values

#### Slay the Spire (Card Game UI & Information Hierarchy)

**What we take from Slay the Spire:**
- Enemy intent telegraphing with clear icons above enemy heads
- Card layout: cost in top-left, art in center, text at bottom, border indicating type
- Map screen with branching paths and node types distinguished by icon
- Mana/energy gems as discrete filled/empty objects (not a bar)

#### Inscryption (Cards as Living Objects)

**What we take from Inscryption:**
- Cards that feel like physical objects with weight and texture
- The sense that cards are *creatures trapped in paper* — not just data displays
- Environmental storytelling through card wear and damage
- Dark, candlelit atmosphere that makes gold elements glow dramatically

#### Black Clover (Thematic, Not Visual)

**What we take from Black Clover:**
- The emotional weight of receiving your grimoire — a life-defining moment
- Grimoire covers as identity markers (each is visually unique, tied to the mage's soul)
- Magic circles and sigils as casting visuals
- The concept of grimoire pages appearing as power grows
- Three-leaf (common), four-leaf (rare), five-leaf (legendary) visual hierarchy for rarity

**What we do NOT take:** Anime character proportions, bright saturated anime coloring, speed lines, or chibi expressions.

### 2.2 Mood Board Keywords (For Asset Sourcing)

When searching for reference images or briefing artists, use these keyword combinations:

```
"illuminated manuscript dark fantasy"
"medieval codex magic spell page"
"parchment ink gold leaf game UI"
"gothic manuscript border ornament"
"dark fantasy card game handpainted"
"alchemical diagram grimoire page"
"medieval bestiary creature illustration"
"candlelit parchment atmospheric"
```

---

## 3. Color Bible

### 3.1 Master Palette

The palette is derived from historical illuminated manuscript pigments, digitized for screen use. Every color in the game must come from this master palette or be a direct tint/shade of a master color.

#### Foundation Colors (Always Present)

| Swatch | Name | Hex | RGB | Historical Pigment | Usage |
|:------:|------|:---:|-----|-------------------|-------|
| ██ | **Parchment Light** | `#F5E6C8` | 245, 230, 200 | Vellum / Calfskin | Primary background, card faces, UI panels |
| ██ | **Parchment Mid** | `#E8D5A3` | 232, 213, 163 | Aged parchment | Secondary backgrounds, card text area |
| ██ | **Parchment Dark** | `#C4A265` | 196, 162, 101 | Heavily aged vellum | Shadows on parchment, depth layers |
| ██ | **Ink Black** | `#1A1410` | 26, 20, 16 | Carbon black (lamp soot) | Primary text, line art, outlines |
| ██ | **Ink Brown** | `#3D2B1F` | 61, 43, 31 | Iron gall ink | Secondary text, aged writing, subtitles |
| ██ | **Burnished Gold** | `#D4A847` | 212, 168, 71 | Gold leaf | Rarity accents, mastery glow, headers, ornamental borders |
| ██ | **Tarnished Gold** | `#8B7332` | 139, 115, 50 | Oxidized gold | Disabled states, aged gold, shadow on gold elements |

#### Radiant Alignment Colors

| Swatch | Name | Hex | RGB | Historical Pigment | Usage |
|:------:|------|:---:|-----|-------------------|-------|
| ██ | **Sacred Gold** | `#FFE4A0` | 255, 228, 160 | Orpiment (arsenic sulfide) | Radiant aura core, evolution glow |
| ██ | **Holy White** | `#FFF8EE` | 255, 248, 238 | Lead white | Radiant highlight, purification flash |
| ██ | **Illumination Gold** | `#F0C75E` | 240, 199, 94 | Shell gold (ground gold) | Radiant card borders, shield effects |
| ██ | **Warm Ivory** | `#F5E1C0` | 245, 225, 192 | — | Radiant UI tint, background warmth |
| ██ | **Blessing Blue** | `#7BA7CC` | 123, 167, 204 | Azurite blue | Radiant support spell accent |

#### Vile Alignment Colors

| Swatch | Name | Hex | RGB | Historical Pigment | Usage |
|:------:|------|:---:|-----|-------------------|-------|
| ██ | **Corruption Purple** | `#6B2D8B` | 107, 45, 139 | Tyrian purple (murex snail) | Vile aura core, curse effects |
| ██ | **Poison Green** | `#4A7A2E` | 74, 122, 46 | Verdigris (copper green) | Poison status, DOT indicators |
| ██ | **Venom Drip** | `#8BC34A` | 139, 195, 74 | — | Poison splash, active DOT ticks |
| ██ | **Blood Crimson** | `#8B1A1A` | 139, 26, 26 | Vermilion / Dragon's blood | Life-steal effects, sacrifice cost |
| ██ | **Shadow Ink** | `#2A1B3D` | 42, 27, 61 | — | Vile UI tint, dark backgrounds |

#### Primal Alignment Colors

| Swatch | Name | Hex | RGB | Historical Pigment | Usage |
|:------:|------|:---:|-----|-------------------|-------|
| ██ | **Deep Teal** | `#2E7D6B` | 46, 125, 107 | Malachite green | Primal aura core, chain effects |
| ██ | **Earth Brown** | `#6B4E37` | 107, 78, 55 | Raw umber | Primal card borders, root/vine motifs |
| ██ | **Amber Sap** | `#D4A03C` | 212, 160, 60 | Yellow ochre | Primal energy, transformation flash |
| ██ | **Moss Green** | `#5B7A4A` | 91, 122, 74 | Terre verte | Primal UI tint, nature backgrounds |
| ██ | **Bark Dark** | `#3D2E1F` | 61, 46, 31 | — | Primal frame shadows, wood texture |

#### System & UI Colors

| Swatch | Name | Hex | RGB | Usage |
|:------:|------|:---:|-----|-------|
| ██ | **Mana Blue** | `#3D6B99` | 61, 107, 153 | Mana gems (filled), mana cost numbers |
| ██ | **Mana Empty** | `#2A3D4F` | 42, 61, 79 | Mana gems (spent) |
| ██ | **HP Crimson** | `#A83232` | 168, 50, 50 | Health bars, damage numbers |
| ██ | **HP Lost** | `#4A1E1E` | 74, 30, 30 | Empty health bar segment |
| ██ | **Block Steel** | `#7A8B99` | 122, 139, 153 | Block/shield indicators |
| ██ | **XP Fill** | `#C8A84A` | 200, 168, 74 | Mastery XP progress bars |
| ██ | **XP Empty** | `#4A3D2A` | 74, 61, 42 | Empty mastery bar |
| ██ | **Success Green** | `#4A8B4A` | 74, 139, 74 | Victory state, positive feedback |
| ██ | **Warning Amber** | `#CC8B2E` | 204, 139, 46 | Low HP warning, cautionary text |
| ██ | **Error Red** | `#CC3D3D` | 204, 61, 61 | Failed action, negative feedback |
| ██ | **Disabled Gray** | `#6B6155` | 107, 97, 85 | Unplayable cards, locked UI elements |

### 3.2 Color Usage Rules

| Rule | Rationale |
|------|-----------|
| **Parchment is the default background, always.** Never use flat white, flat black, or solid color backgrounds for UI panels. | Maintains the manuscript feel universally |
| **Gold is earned, never decorative.** Gold appears on: mastery borders, legendary rarity, Grimoire cover accents, UI section headers. It does NOT appear on common cards, basic buttons, or body text. | Preserves gold's emotional value as a reward indicator |
| **Alignment colors only appear in alignment contexts.** Radiant gold doesn't tint the main menu unless the player's Grimoire is Radiant-dominant. | Prevents visual noise; alignment colors carry meaning |
| **Black ink outlines everything.** All card art, enemy sprites, UI icons, and borders use `Ink Black` (#1A1410) outlines — never pure #000000. | Pure black is too harsh; warm-black ink feels handcrafted |
| **Red means HP or danger. Blue means mana. Always.** Never use HP Crimson for decoration. Never use Mana Blue for non-mana elements. | Cognitive consistency — players learn the color language once |
| **Maximum 3 alignment colors on screen simultaneously.** If the battle has Radiant cards, Vile enemies, and Primal effects, each gets its color. But UI chrome stays neutral (parchment + ink). | Prevents visual chaos in multi-alignment scenarios |

### 3.3 Contrast & Accessibility

| Requirement | Standard | Implementation |
|-------------|----------|----------------|
| Text on parchment | WCAG AA (4.5:1 minimum) | Ink Black (#1A1410) on Parchment Light (#F5E6C8) = **12.7:1** ratio. Pass. |
| Card cost numbers | WCAG AA Large (3:1 minimum) | Burnished Gold (#D4A847) on Ink Black (#1A1410) = **5.2:1** ratio. Pass. |
| HP/Mana numbers | WCAG AA (4.5:1 minimum) | Holy White (#FFF8EE) on HP Crimson (#A83232) = **5.8:1** ratio. Pass. |
| Status icons | Must be distinguishable without color alone | All status effects use unique silhouette icons in addition to color. Poison = dripping flask. Burn = flame. Stun = spiral. |
| Enemy intent | Readable at a glance | Intent icons are 48×48px minimum at 1080p, with a contrasting backdrop behind the icon |

---

## 4. The Grimoire (Hero Asset)

The Grimoire is the most important visual element in the entire game. It IS the main character. It IS the main menu. It IS the player's identity. It must feel handcrafted, ancient, and alive.

### 4.1 Grimoire Anatomy

```
┌─────────────────────────────────────┐
│           FRONT COVER               │
│                                     │
│  ┌─── Binding (spine edge) ───┐    │
│  │                            │    │
│  │   ┌────────────────────┐   │    │
│  │   │   COVER MATERIAL   │   │    │
│  │   │                    │   │    │
│  │   │  ┌──────────────┐  │   │    │
│  │   │  │    CENTRAL   │  │   │    │
│  │   │  │    SIGIL     │  │   │    │
│  │   │  │  (animated)  │  │   │    │
│  │   │  └──────────────┘  │   │    │
│  │   │                    │   │    │
│  │   │   ╔════ CLASP ═══╗ │   │    │
│  │   └────────────────────┘   │    │
│  │                            │    │
│  └────────────────────────────┘    │
│                                     │
│  ~~~ AURA (particle layer) ~~~     │
│                                     │
│  === ALIGNMENT CORRUPTION ===      │
│  (overlay shader, intensity varies) │
└─────────────────────────────────────┘
```

### 4.2 Cover Materials (5 Types — Seed-Determined)

| Material | Visual | Texture Notes | Seed Enum |
|----------|--------|--------------|-----------|
| **Leather** | Warm brown, slightly cracked, tooled edges | Visible grain, subtle stitch marks along spine. The "default" and most grounded look. | `LEATHER` |
| **Bone** | Off-white to pale gray, smooth with hairline fractures | Subtle vein patterns like marble. Slightly unsettling — feels like it was once alive. | `BONE` |
| **Crystal** | Deep blue-black, translucent at edges | Internal luminescence, prismatic edge highlights. Most "magical" looking cover. | `CRYSTAL` |
| **Cloth** | Rich textile — woven fibers visible | Embroidered border patterns. Feels humble but sacred, like a prayer book. Thread texture. | `CLOTH` |
| **Metal** | Dark iron or tarnished bronze | Hammered texture, rivets at corners, engraved runes. Heavy, imposing, armored. | `METAL` |

Each cover is a **single layered texture** (1024×1024) with a normal map for material depth. The central sigil, binding, and clasp are composited on top.

### 4.3 Binding Styles (5 Types — Seed-Determined)

| Binding | Visual | Notes |
|---------|--------|-------|
| **Chain** | Interlocking metal links wrapping the spine | Industrial, heavy. Links tarnish or polish based on alignment. |
| **Ribbon** | Silk or velvet ribbon laced through eyelets | Elegant, formal. Ribbon color shifts with dominant alignment. |
| **Vine** | Living plant growth winding around the spine | Organic, primal. Vines grow leaves/thorns based on alignment. |
| **Clasp** | Ornate metal clasp holding the book shut | Classic grimoire look. Clasp sigil matches the central sigil. |
| **Rune Thread** | Glowing thread stitched in runic patterns | Magical, arcane. Thread color = aura color. Pulses with idle animation. |

### 4.4 Central Sigil (Procedurally Generated)

The sigil is generated from `sigil_params: { sides, rotation, inner_ratio }`:

```
Parameters:
  sides: 3–8        → Triangle, Square, Pentagon, Hexagon, Heptagon, Octagon
  rotation: 0–TAU   → Base rotation angle
  inner_ratio: 0.3–0.7  → Inner ring size relative to outer

Rendering:
  1. Outer ring — geometric shape with [sides] vertices
  2. Inner ring — same shape, scaled by [inner_ratio], counter-rotated
  3. Connecting lines — each outer vertex connects to corresponding inner vertex
  4. Center dot — alignment-colored focal point
  5. Decorative flourishes — small circles at vertices, hash marks on lines
```

**Sigil shader:** The sigil glows with `aura_color` and pulses gently in idle state (sine wave on emission intensity, period 3 seconds).

### 4.5 Aura Effect (Alignment-Driven Particles)

The Grimoire emits a subtle particle aura when displayed in the hub:

| Alignment | Aura Color | Particle Shape | Behavior |
|-----------|-----------|----------------|----------|
| **Radiant** | `#FFE4A0` (Sacred Gold) | Soft circles, tiny crosses | Drift upward slowly, gentle glow, fade out |
| **Vile** | `#6B2D8B` (Corruption Purple) | Wisps, irregular blobs | Drip downward, trail, dissolve into smoke |
| **Primal** | `#2E7D6B` (Deep Teal) | Leaf shapes, small spirals | Orbit around book, occasional burst outward |
| **Conflicted** | Two-color blend | Mixed shapes | Chaotic — particles fight each other, jitter |

**Particle budget:** Max 100 particles for the aura. Must run at 60 FPS on Intel Iris Plus.

### 4.6 Alignment Corruption (Visual History)

The Grimoire's appearance changes permanently based on alignment history. This is the "Soulbound" pillar in action — the book shows its scars.

**Radiant Corruption (High Radiant Score):**
- Gold leaf spreads from sigil outward across the cover
- Page edges gain golden gilding
- Binding develops light-emitting runes
- Cover material lightens and appears "blessed"

**Vile Corruption (High Vile Score):**
- Dark veins spread from the spine like infection
- Page edges become charred and curled
- Binding material corrodes — chain rusts, ribbon frays, vine grows thorns
- Cover develops cracks that leak purple light

**Primal Corruption (High Primal Score):**
- Moss and lichen grow across the cover surface
- Page edges sprout tiny roots
- Binding becomes overgrown with living vines (even non-vine bindings)
- Cover material develops bark-like texture patches

**Conflicted State (Two Alignments Near-Equal):**
- Two corruption types fight for territory on the cover
- Visible boundary line where they clash — crackling energy, shifting border
- Most visually dramatic state — the book is at war with itself

**Implementation:** A shader overlay (`alignment_corruption.gdshader`) reads three float uniforms (radiant_intensity, vile_intensity, primal_intensity, each 0.0–1.0) and blends corruption textures accordingly. Performance: single shader pass, 3 texture samples.

---

## 5. Card Art

### 5.1 Card Layout (Canonical Template)

```
┌──────────────────────────────┐
│ ┌──┐                   ★★☆  │ ← Rarity stars (top-right)
│ │⬡2│                        │ ← Mana cost (top-left, gem shape)
│ └──┘                        │
│ ┌──────────────────────────┐ │
│ │                          │ │
│ │                          │ │
│ │     ILLUSTRATION         │ │ ← Card art (hand-painted ink style)
│ │     (400×280px @2x)      │ │
│ │                          │ │
│ │                          │ │
│ └──────────────────────────┘ │
│                              │
│  SPARK BOLT                  │ ← Card name (manuscript title font)
│  ────────────────────────    │ ← Decorative divider line
│                              │
│  Deal 4 damage to a         │ ← Rules text (body font)
│  single enemy.               │
│                              │
│  ┌────────────────────────┐  │
│  │  ████████████░░░ 75%   │  │ ← Mastery XP bar (bottom)
│  └────────────────────────┘  │
│                              │
│  ⚔ ATTACK    ◈ PRIMAL       │ ← Type + Alignment badges (bottom)
└──────────────────────────────┘
```

**Card dimensions (at 1080p):** 200×300px (2:3 ratio). Art-safe zone: 180×280px.

### 5.2 Card Border Treatments (By Mastery Tier)

| Tier | Border Style | Material |
|------|-------------|----------|
| **Unmastered** | Simple thin ink line, no decoration | Plain parchment edge |
| **Bronze** | Ink line with small corner dots | Slightly warm parchment tint |
| **Silver** | Double ink line with hash-mark decoration | Subtle metallic sheen on corners |
| **Gold** | Ornate illuminated border — vine scrollwork or geometric knotwork | Gold leaf on border, subtle glow shader |
| **Evolved** | Alignment-colored border with animated particles along the edge | Full alignment corruption on the card itself |

### 5.3 Card Art Style Guidelines

**DO:**
- Use visible ink outlines (2–3px at 1080p) in Ink Black (#1A1410)
- Apply flat-ish coloring with subtle texture (think watercolor on parchment, not blended digital painting)
- Include cross-hatching for shadows instead of smooth gradients
- Add tiny imperfections: ink splatters, slightly uneven lines, paper grain showing through
- Draw creatures and effects FROM THE MANUSCRIPT PERSPECTIVE — as if a scribe illustrated them in a book

**DON'T:**
- Use photorealistic rendering, smooth gradients, or heavy digital painting techniques
- Draw anime-style characters with large eyes, speed lines, or manga proportions
- Use pure black (#000000) for outlines — always use Ink Black (#1A1410) or Ink Brown (#3D2B1F)
- Add 3D bevels, drop shadows, or glossy highlights to card elements
- Use more than 5 colors per card illustration (excluding outline ink). The medieval palette was limited — embrace that.

### 5.4 Card Art by Alignment

| Alignment | Illustration Style | Color Range | Motif Elements |
|-----------|-------------------|-------------|----------------|
| **Radiant** | Clean linework, symmetrical compositions, halos and rays | Sacred Gold, Holy White, Blessing Blue | Geometric patterns, clean circles, stars, rays of light, dove/angel wings |
| **Vile** | Rough linework, asymmetrical compositions, dripping elements | Corruption Purple, Poison Green, Blood Crimson | Thorns, bones, skulls, dripping liquid, cracked surfaces, serpents |
| **Primal** | Flowing organic linework, spiraling compositions | Deep Teal, Earth Brown, Amber Sap, Moss Green | Roots, leaves, animal silhouettes, spirals, natural fractals, antlers |
| **Neutral/Unaligned** | Balanced mix, classical manuscript style | Parchment tones, Ink Brown, Burnished Gold | Quills, books, stars, simple geometric borders |

### 5.5 Rarity Visual Indicators

| Rarity | Star Count | Border Accent | Card Back Detail |
|--------|:----------:|---------------|-----------------|
| **Common** | ★☆☆☆☆ | No accent | Plain parchment back |
| **Uncommon** | ★★☆☆☆ | Thin silver line inside border | Small corner flourish on back |
| **Rare** | ★★★☆☆ | Blue (azurite) accent lines | Decorative knot on back |
| **Epic** | ★★★★☆ | Purple (Tyrian) accent, animated shimmer | Full illuminated pattern on back |
| **Legendary** | ★★★★★ | Full gold leaf border, particle trail | Animated golden mandala on back |

---

## 6. Character & Enemy Art

### 6.1 Proportions & Style

**No player character sprite.** The player IS the Grimoire. There is no avatar, no visible protagonist. This is deliberate — the Grimoire is the hero.

**Enemies** are the primary character art. They are drawn as **bestiary illustrations** — as if a medieval naturalist catalogued them in a codex.

**Proportions:**
- Realistic-ish proportions (NOT chibi, NOT anime). ~6–7 head heights.
- Stylization comes from the ink-and-watercolor rendering, not from exaggerated anatomy
- Creatures can be exaggerated (massive jaws, elongated limbs) for fantasy effect, but humanoids stay grounded
- Scale reference: an enemy sprite at 1080p should be approximately 200–300px tall in the battle scene

### 6.2 Enemy Art by Alignment

#### Radiant Enemies (Order, Light, Duty)

| Archetype | Visual Description |
|-----------|-------------------|
| **Paladin** | Heavy plate armor with gold filigree, closed-face helm with cross-shaped visor slit. Cape with radiant sigil. Clean, symmetrical, imposing. |
| **Cleric** | Robed figure with staff topped by a radiant crystal. Face obscured by deep hood — only golden light where eyes should be. Manuscript-style halo. |
| **Light Construct** | Geometric being made of interlocking golden shapes — cubes, octahedra, pyramids. Lines of light connect the shapes. No organic features. |

**Design language:** Symmetry, geometric precision, gold and white, clean edges. Radiant enemies are beautiful and terrifying — the danger of absolute order.

#### Vile Enemies (Chaos, Darkness, Ambition)

| Archetype | Visual Description |
|-----------|-------------------|
| **Demon** | Twisted humanoid with too many joints. Skin like cracked obsidian with purple light leaking from fissures. Horns that curve in impossible directions. |
| **Cursed Knight** | Corroded armor fused to decomposing flesh. Sword drips with ichor. One eye socket glows green, the other is hollow. Heraldry on shield is scratched out. |
| **Shadow Beast** | Amorphous shape with multiple yellow-green eyes. Body is made of layered ink washes — no clear outline, just darkness that moves. Tendrils at edges. |

**Design language:** Asymmetry, organic corruption, thorns, dripping textures, things that are wrong. Vile enemies make the viewer uncomfortable — anatomy that doesn't work, beauty that has rotted.

#### Primal Enemies (Nature, Instinct, Adaptation)

| Archetype | Visual Description |
|-----------|-------------------|
| **Forest Spirit** | Humanoid figure made of interwoven branches and leaves. Face is a smooth wooden mask with simple carved features. Moss hangs from arms. Flowers grow from head. |
| **Elemental** | Swirling mass of a natural element (stone, water, wind) loosely shaped like a torso and arms. No legs — lower body dissolves into raw element. |
| **Shapeshifter** | Appears as a normal animal at first, but proportions are slightly wrong. Too many legs, or limbs that are too long. Eyes are too intelligent. Mid-transformation state. |

**Design language:** Organic curves, spirals, fractal branching. Primal enemies are nature unchained — not evil, not good, just overwhelming force.

### 6.3 Boss Design Rules

Bosses are **full-page illustrations** — they fill the bestiary entry. They command visual attention.

| Rule | Application |
|------|-------------|
| **3× scale of regular enemies** | Boss sprite is 600–900px tall at 1080p |
| **Unique silhouette** | Must be identifiable as a black silhouette from across the room |
| **Alignment exaggeration** | Boss design pushes alignment visual language to the extreme |
| **Telegraphed body language** | Intent must be readable from pose/animation, not just UI icons |
| **Environmental interaction** | Boss art extends beyond the sprite boundary — roots growing off-screen, light flooding the background, shadow consuming the UI edges |

### 6.4 Enemy Intent Icons

Large, clear icons displayed above the enemy sprite:

| Intent | Icon (Silhouette) | Color |
|--------|------------------|-------|
| **Attack** | Downward sword slash | HP Crimson (#A83232) |
| **Defend** | Shield with chevron | Block Steel (#7A8B99) |
| **Buff** | Upward arrow with sparkle | Burnished Gold (#D4A847) |
| **Debuff** | Downward spiral | Corruption Purple (#6B2D8B) |
| **Summon** | Open portal / hatching egg | Deep Teal (#2E7D6B) |
| **Special** | Exclamation mark in circle | Warning Amber (#CC8B2E) |

**Size:** 48×48px minimum at 1080p. White outline (2px) to ensure readability over any background.

---

## 7. Environment & Background Art

### 7.1 The Archives (Primary Game World)

The Archives is an infinite magical library — the setting for all PvE content. It is not a cheerful library. It is ancient, vast, dimly lit, and slightly unsettling. Books have minds of their own here.

**Visual Description:**
- Towering bookshelves that stretch into darkness above
- Floating books drifting lazily through the air
- Candles and lanterns as the primary light source — warm pools of light surrounded by deep shadow
- Dust motes visible in the light beams
- Cobwebs between shelves, but the books themselves are perfectly preserved
- Floor is worn stone, cracked, with moss growing in the fissures
- Occasional magic circles glowing faintly on the floor or walls

### 7.2 Environment by Chapter Theme

| Theme | Background Treatment | Lighting | Details |
|-------|---------------------|----------|---------|
| **Radiant Archive** | White marble shelves, gold-spined books, stained glass windows letting in warm light | Warm daylight from above, golden God-rays | Incense smoke, prayer candles, clean floors, holy inscriptions on walls |
| **Vile Crypt** | Obsidian shelves, books bound in dark leather, chains holding some books shut | Sickly green torchlight, deep shadows, occasional purple flash | Cobwebs, dripping liquid from ceiling, books that writhe, scratched warnings on walls |
| **Primal Grove** | Shelves made of living trees, books nestled in root systems, open-air canopy above | Dappled sunlight through leaves, firefly particles | Moss everywhere, mushrooms growing on book spines, animal nests in corners |
| **Mixed Archive** | Standard stone and wood shelves, neutral tones | Candle and lantern light, warm-neutral | The "default" — comfortable but mysterious |

### 7.3 Background Layer System

Backgrounds are composed of parallax layers for subtle depth:

```
Layer 0 (Farthest): Deep shadow / distant shelves (very dark, minimal detail)
Layer 1:            Mid-distance shelves and architecture (medium detail)
Layer 2:            Near architecture framing the battle area (full detail)
Layer 3 (Nearest):  Foreground elements — candle stands, floating book, dust particles

Parallax movement: ±5% shift on player interaction for subtle life
```

**Performance:** Backgrounds are static textures with a particle overlay. No real-time rendering of shelves or books. The parallax shift is a simple shader offset.

### 7.4 Chapter Map Visual

The Chapter Map (node selection screen) is a **parchment scroll** with the path drawn in ink:

```
┌──────────────────────────────────────────────────────┐
│                  ≈≈≈ SCROLL EDGE ≈≈≈                 │
│                                                      │
│    ✦ ─── ⚔ ─── ⚔ ─┬─ ❓ ─── ⚔ ─── 💀              │
│                     │                                │
│                     └─ 🏕 ─── ⚔ ─── 💀              │
│                                                      │
│  ✦ = Start    ⚔ = Combat    ❓ = Moral Choice        │
│  🏕 = Rest     💀 = Boss                              │
│                                                      │
│                  ≈≈≈ SCROLL EDGE ≈≈≈                 │
└──────────────────────────────────────────────────────┘
```

- Path lines are drawn in Ink Brown (#3D2B1F) with slight hand-wobble
- Node icons are ink-drawn with alignment-colored fills
- Visited nodes are tinted with a coffee-stain wash effect
- Current node has a pulsing ink-circle highlight
- Scroll edges curl slightly (layered texture)

---

## 8. Lighting Philosophy

### 8.1 Core Lighting Rule

> **"Candlelight and ink."** The game is lit by warm, intimate light sources — candles, lanterns, magical glow — surrounded by deep, rich shadow. Never flat, never fully lit, never clinical.

### 8.2 Lighting by Context

| Context | Primary Light | Shadow Depth | Mood |
|---------|--------------|:------------:|------|
| **Grimoire Hub** | Single warm spotlight from above on the Grimoire. Aura provides secondary color light. | Deep — book floats in darkness | Intimate, personal, reverent |
| **Battle Scene** | Two warm candle sources (left and right). Enemy side is slightly dimmer than player side. | Medium — clear visibility but atmospheric | Tense, focused, confrontational |
| **Chapter Map** | Even diffuse light (reading a scroll) | Light — the map is practical, not dramatic | Strategic, calm, planning |
| **Moral Choice** | Single dramatic spotlight on the choice subject. Shadows radiating outward. | Very deep — only the choice is lit | Heavy, weighty, consequential |
| **Evolution Choice** | Three colored lights from the three evolution options. They compete for dominance. | Medium with color contrast | Exciting, decisive, transformative |
| **Victory Screen** | Bright, warm wash. Gold particles. | Minimal shadow | Triumphant, rewarding |
| **Defeat Screen** | Dim, cold. Light fading out. | Very deep, encroaching | Somber, not punishing |

### 8.3 Lighting Implementation

All lighting is **baked into textures and enhanced with shaders.** We do not use Godot's 2D lighting system extensively — it's too performance-heavy for our particle budget.

**Approach:**
1. Background textures are painted with lighting already applied (dark edges, bright centers)
2. A single vignette shader darkens screen edges (adjustable intensity per context)
3. Aura/magic light effects use additive-blend particles, not point lights
4. Card glow uses an emission texture multiplied by a sine-wave animation
5. Screen-wide color grading via a CanvasLayer with a color lookup shader (LUT)

**Performance cost:** One full-screen shader (vignette + LUT). ~0.5ms on Intel Iris Plus. Well within budget.

---

## 9. VFX & Particle Language

### 9.1 VFX Philosophy

> **"Ink that moves."** Visual effects should look like animated manuscript illustrations — ink that flows, gold that sparkles, pages that flutter. Not modern game VFX (no lens flares, no screen shake, no chromatic aberration).

### 9.2 Effect Vocabulary

| Effect | Visual Description | Particles | Duration |
|--------|-------------------|:---------:|:--------:|
| **Card Play** | Card glides from hand to play area, leaves an ink trail that fades | Ink droplet particles (8–12) following card path | 0.3s |
| **Damage Dealt** | Ink slash mark appears on target, damage number rises and fades | Ink splatter (5–8 particles) at impact point | 0.5s |
| **Heal** | Golden ink circle expands from target, pages flutter around | Gold motes rising (10–15 particles) | 0.6s |
| **Block Gained** | Translucent shield page appears in front of player, then folds into position | Paper fragment particles (3–5) settling | 0.4s |
| **Poison Tick** | Green drip runs down the target, small splash at bottom | Green drip particles (3–4) | 0.3s |
| **Evolution** | Card shatters into ink, reforms as new card. Alignment-colored burst. | Ink fragments (20–30), alignment motes (15–20) | 1.2s |
| **Grimoire Level-Up** | Pages erupt from the book, spiral outward, golden light fills screen | Page particles (30–40), gold motes (20–30) | 2.0s |
| **Alignment Shift** | Ink of the alignment color bleeds across screen edges briefly | Edge bleed effect (shader, not particles) | 0.8s |
| **Enemy Death** | Enemy dissolves into ink that drains downward off-screen | Ink dissolve particles (15–20) | 0.6s |
| **Chapter Start** | Page turn animation — parchment sweeps across screen | Single page texture, tween animation | 0.5s |

### 9.3 Particle Budget Per Context

| Context | Max Active Particles | Emitter Count |
|---------|:-------------------:|:-------------:|
| **Grimoire Hub (idle)** | 100 | 1 (aura) |
| **Battle (no effects)** | 50 | 2 (candle flicker left + right) |
| **Battle (card play)** | 150 | 3 (ambient + card trail + impact) |
| **Battle (peak moment)** | 300 | 5 (ambient + multiple effects) |
| **Evolution sequence** | 500 | 3 (shatter + reform + burst) |
| **Level-up sequence** | 500 | 2 (page eruption + gold motes) |

**Hard ceiling:** 500 particles at any moment. No exceptions.

### 9.4 Particle Art Style

- Particles use small (16×16 or 32×32) hand-drawn textures — not procedural circles
- **Ink particles:** Irregular blob shapes with visible brush texture
- **Gold particles:** Tiny squares with soft glow (like gold flake)
- **Page particles:** Rectangular with slight curve and parchment texture
- **Leaf particles:** (Primal only) Simple 2–3 stroke leaf silhouette
- **Wisp particles:** (Vile only) Amorphous smoke puff, fading at edges
- All particles use alpha fade-out over lifetime (never hard cut-off)

---

## 10. UI Style Rules

### 10.1 Universal UI Principles

| Principle | Rule |
|-----------|------|
| **Parchment over panels** | Every UI container uses a parchment texture background — never flat color, never transparency over game world |
| **Ink over icons** | Prefer hand-drawn ink icons over symbolic/geometric icons where practical |
| **No sharp corners** | All UI panels have slightly rounded corners (4px radius) OR torn-edge texture borders |
| **Border language** | Thin ink line (1px) for standard containers. Double ink line for important containers. Illuminated border for legendary/critical UI |
| **Spacing feels like margins** | UI padding uses generous margins — as if the content is typeset on a page with room to breathe. Minimum 16px padding. |
| **No UI hides game state** | HP, mana, block, and enemy intent must NEVER be occluded by popups, tooltips, or overlays. Critical info is sacred. |

### 10.2 Button Styles

| Button State | Visual |
|-------------|--------|
| **Default** | Parchment Mid (#E8D5A3) background, Ink Black text, thin ink border |
| **Hover** | Parchment Light (#F5E6C8) background, border thickens to 2px, subtle inner glow |
| **Pressed** | Parchment Dark (#C4A265) background, text shifts down 1px, border becomes double-line |
| **Disabled** | Desaturated parchment, Disabled Gray text, dashed ink border |
| **Critical Action** | Burnished Gold border, gold accent on text, pulsing glow on hover |

### 10.3 Panel/Container Styles

```
┌─ Standard Panel ──────────────────────────────────┐
│                                                    │
│  Background: Parchment Light texture               │
│  Border: 1px Ink Black                             │
│  Corner: 4px radius OR torn-paper edge             │
│  Padding: 16px all sides                           │
│  Shadow: None (no drop shadows in manuscripts)     │
│                                                    │
└────────────────────────────────────────────────────┘

╔═ Important Panel ═════════════════════════════════╗
║                                                    ║
║  Background: Parchment Mid texture                 ║
║  Border: 2px Ink Black, decorative corners         ║
║  Corner flourish: Small ink scroll at each corner  ║
║  Padding: 20px all sides                           ║
║                                                    ║
╚════════════════════════════════════════════════════╝

┌─ Tooltip ──────────────┐
│                        │  Background: Parchment Dark
│  Small text here.      │  Border: 1px Ink Brown
│                        │  Max width: 250px
└────────────────────────┘  Arrow pointing to source
```

### 10.4 Progress Bars

All progress bars are styled as **ink-filled channels** carved into parchment:

```
HP Bar:
  ┌──────────────────────────────────┐
  │ ██████████████████░░░░░░░░░░░░░ │  Fill: HP Crimson (#A83232)
  │ 45 / 60                         │  Empty: HP Lost (#4A1E1E)
  └──────────────────────────────────┘  Text: Holy White on fill area

Mana: Discrete gems, not a bar
  ◆ ◆ ◆ ◇ ◇     Filled: Mana Blue (#3D6B99)
                   Empty: Mana Empty (#2A3D4F)

Mastery XP Bar:
  ┌──────────────────────────────────┐
  │ ████████████████████████░░░░░░░ │  Fill: XP Fill (#C8A84A)
  │ 75 / 100                        │  Empty: XP Empty (#4A3D2A)
  └──────────────────────────────────┘

Grimoire Level XP:
  Same as mastery bar but wider, with level number displayed as an illuminated numeral
```

### 10.5 Card-in-Hand Interaction States

| State | Visual Change |
|-------|--------------|
| **In Hand (default)** | Cards fanned, slight overlap, bottom-aligned |
| **Hover** | Card rises 20px, scales to 110%, other cards shift aside. Subtle glow on border. |
| **Dragging** | Card follows cursor at 90% opacity, play zone highlights with parchment tint |
| **Playable** | Normal brightness and saturation |
| **Unplayable (insufficient mana)** | Desaturated, Disabled Gray overlay at 40% opacity, mana cost turns red |
| **Attuned Match** | Mana cost number shows crossed-out original cost with reduced cost below. Faint alignment-colored border glow. |

---

## 11. Typography System

### 11.1 Font Selection

The game uses **three fonts** total. Fewer fonts = stronger identity.

| Role | Font Style | Usage | Characteristics |
|------|-----------|-------|----------------|
| **Display / Title** | Blackletter / Gothic | Grimoire True Name, screen titles, boss names, "VICTORY" / "DEFEAT" | Heavy, ornate, medieval. Must feel hand-lettered. Think: Cinzel Decorative, Almendra Display, or a custom blackletter. |
| **Body / Card Text** | Humanist Serif | Card names, rules text, lore text, descriptions, UI labels | Readable at small sizes, warm personality, slight calligraphic quality. Think: Crimson Text, EB Garamond, Cormorant. |
| **Data / Numbers** | Tabular Serif or Sans | Mana costs, damage numbers, HP values, XP counts, stat readouts | Monospaced numerals (tabular figures) so numbers don't shift when values change. Clear at 12px. Think: Lora, Source Serif Pro, or a tabular sans. |

### 11.2 Font Size Hierarchy (at 1080p)

| Level | Size | Weight | Usage |
|-------|:----:|--------|-------|
| **H1 — Screen Title** | 48px | Bold | "THE ARCHIVES", "CLASH OF TOMES" |
| **H2 — Section Header** | 32px | Bold | "YOUR HAND", "INSCRIPTIONS", chapter names |
| **H3 — Card Name** | 20px | SemiBold | Card name on the card face |
| **Body — Rules Text** | 16px | Regular | Card description, lore text, NPC dialogue |
| **Caption** | 14px | Regular | Tooltips, secondary info, flavor text |
| **Data — Large** | 24px | Bold | Mana cost on card, damage numbers in combat |
| **Data — Small** | 16px | SemiBold | HP bar value, XP count, stat numbers |
| **Data — Tiny** | 12px | Regular | Mastery percentage, minor UI stats |

### 11.3 Text Color Rules

| Context | Color | Hex |
|---------|-------|:---:|
| Body text on parchment | Ink Black | `#1A1410` |
| Secondary / flavor text | Ink Brown | `#3D2B1F` |
| Card name | Ink Black | `#1A1410` |
| Mana cost number | Mana Blue (on dark gem) OR Ink Black (on parchment) | `#3D6B99` / `#1A1410` |
| Damage numbers (floating) | HP Crimson with Holy White outline | `#A83232` |
| Heal numbers (floating) | Success Green with Holy White outline | `#4A8B4A` |
| Block numbers (floating) | Block Steel with Holy White outline | `#7A8B99` |
| Disabled / locked text | Disabled Gray | `#6B6155` |
| Critical / warning text | Warning Amber | `#CC8B2E` |
| Grimoire True Name | Burnished Gold | `#D4A847` |

### 11.4 Text Rendering Rules

| Rule | Details |
|------|---------|
| **Never outline body text.** | Outlines are for floating combat numbers only. Body text sits on parchment and needs no outline. |
| **All floating numbers get a 2px outline** in a contrasting color | Ensures readability over any background (combat happens over varied art) |
| **Numbers use tabular figures** | So "10" and "99" occupy the same width, preventing layout jitter in HP bars and mana displays |
| **Kerning is generous** | Tighter tracking feels modern. Manuscript text is spacious. Letter-spacing +0.5px on body text. |
| **Decorative initials on lore text** | The first letter of lore paragraphs is rendered at 2× size with a gold tint — classic illuminated manuscript drop cap treatment |

---

## 12. Iconography

### 12.1 Icon Style

All icons are **hand-drawn ink silhouettes** on transparent backgrounds. They look like they were sketched by a scribe with a quill — slightly imperfect, with visible stroke weight variation.

**NOT:** Flat material design icons. NOT: Outlined geometric icons. NOT: Emoji or pixel art.

### 12.2 Core Icon Set

| Icon | Silhouette Description | Size (1080p) | Used In |
|------|----------------------|:------------:|---------|
| **Attack (Sword)** | Single-edge sword, angled 45°, simple crossguard | 24×24 | Card type badge, intent icon |
| **Defense (Shield)** | Heater shield with central boss, no heraldry | 24×24 | Card type badge, block indicator |
| **Support (Chalice)** | Chalice / goblet, simple stem, slight glow lines above | 24×24 | Card type badge |
| **Special (Star)** | Irregular 6-pointed star with asymmetric rays | 24×24 | Card type badge, special intent |
| **Radiant (Sun)** | Circle with 8 tapered rays, clean geometry | 20×20 | Alignment badge, attunement button |
| **Vile (Crescent)** | Crescent moon with thorny inner edge | 20×20 | Alignment badge, attunement button |
| **Primal (Leaf)** | Three-lobed leaf with stem, organic curves | 20×20 | Alignment badge, attunement button |
| **Mana (Gem)** | Hexagonal gem, faceted, slight sparkle lines | 20×20 | Mana cost, mana display |
| **HP (Heart)** | Anatomical-ish heart (not cartoon), with vein lines | 20×20 | HP display |
| **XP (Quill)** | Feather quill, angled as if writing | 16×16 | Mastery bar label |
| **Gold (Coin)** | Round coin with worn edge, simple sigil stamp | 16×16 | Currency display |
| **Poison (Flask)** | Round-bottom flask with drip from stopper | 20×20 | Status effect |
| **Burn (Flame)** | Single flame, organic shape, flickering tip | 20×20 | Status effect |
| **Stun (Spiral)** | Inward spiral, 3 rotations | 20×20 | Status effect |
| **Regen (Sprout)** | Small plant sprouting from cracked ground | 20×20 | Status effect |

### 12.3 Icon Production Rules

| Rule | Rationale |
|------|-----------|
| All icons are drawn at 4× target size (96×96 for a 24×24 icon) then scaled down | Clean edges with anti-aliasing, preserves detail |
| Stroke weight is 2–3px at final render size | Readable at small sizes, feels hand-drawn |
| Maximum 2 colors per icon (ink + one accent) | Keeps icons simple and scannable |
| Every icon must be identifiable as a 16×16 silhouette | If it's not readable at minimum size, it fails |
| Status effects must be distinguishable by shape alone, not just color | Accessibility — colorblind players can still identify effects |

---

## 13. Animation Principles

### 13.1 Animation Philosophy

> **"Pages, not pixels."** All motion should feel like animated manuscript art — things slide, fold, flutter, and flow. Nothing teleports. Nothing bounces like a rubber ball. Nothing has cartoon squash-and-stretch.

### 13.2 Timing & Easing

| Animation Type | Duration | Easing | Example |
|---------------|:--------:|--------|---------|
| **Card draw** | 0.3s | Ease-out (fast start, slow arrival) | Card slides from deck to hand position |
| **Card play** | 0.25s | Ease-in (slow start, fast finish) | Card glides from hand to play area |
| **Card hover** | 0.15s | Ease-out | Card rises and scales up |
| **Page turn** | 0.4s | Ease-in-out (smooth both ends) | Grimoire page flip transition |
| **Damage number** | 0.6s | Linear rise, fade in last 0.2s | Number floats upward and dissolves |
| **Enemy death** | 0.5s | Ease-in (slow start, fast dissolve) | Dissolves into ink, drains downward |
| **Screen transition** | 0.5s | Ease-in-out | Parchment sweeps across screen |
| **Idle pulse** | 3.0s loop | Sine wave | Aura glow, sigil pulse, candle flicker |
| **Evolution** | 1.2s | Custom (slow shatter → pause → fast reform) | Card shatters into ink, reforms as evolved card |

### 13.3 Idle Animations (Always Running)

| Element | Animation | Frequency |
|---------|-----------|-----------|
| **Grimoire aura** | Particle emission pulses (sine wave on rate) | 3s cycle |
| **Grimoire sigil** | Slow rotation + emission pulse | 5s cycle |
| **Grimoire pages** | Occasional single page flutter (as if wind caught it) | Random 8–15s interval |
| **Candle flames** | Flicker (random Y-offset on flame sprite, ±2px) | Continuous, subtle |
| **Dust motes** | Drift particles in background | Continuous, 20–30 particles |
| **Enemy breathing** | Slight Y-scale oscillation (0.98–1.02) | 2s cycle |

### 13.4 Animation Don'ts

| Don't | Why |
|-------|-----|
| **No screen shake** | Manuscripts don't shake. Damage is communicated through ink slashes, not camera violence. |
| **No squash-and-stretch** | This is a manuscript, not a cartoon. Objects maintain their form. |
| **No particle explosions** | Ink disperses, it doesn't explode. Gold flakes scatter, they don't burst. |
| **No quick flashes / strobes** | Accessibility concern + breaks the atmosphere. Bright effects fade in over ≥0.1s. |
| **No bouncing or spring physics** | Cards slide and settle, they don't bounce into place. |

---

## 14. Audio-Visual Pairing

### 14.1 Sound Design Philosophy

> **"Foley for a magical library."** Every sound should be grounded in a physical action — pages turning, ink scratching, metal clasps clicking, crystal humming — then subtly layered with a magical undertone.

### 14.2 Audio-Visual Pairings

| Visual Event | Sound Design |
|-------------|-------------|
| **Grimoire opens** | Heavy leather/wood creak + metal clasp click + faint magical hum rising |
| **Page turn** | Paper slide + fabric whoosh + subtle bell chime at completion |
| **Card draw** | Quick paper slide (like drawing from a stack) + faint whoosh |
| **Card play** | Paper slap on surface + ink splash (wet impact) + effect-specific accent |
| **Damage dealt** | Ink slash (quick whip sound) + impact thud + brief tonal accent matching alignment |
| **Heal** | Warm chime + liquid shimmer + soft exhale sound |
| **Block** | Stone/metal impact (shield) + muted thud + brief ring |
| **Poison tick** | Wet drip + sizzle + faint bubbling |
| **Evolution** | Glass shatter (card breaking) + swirling wind + crystalline reform + triumphant chord |
| **Level-up** | Deep resonant gong + pages fluttering (like flock of birds) + ascending harmonic |
| **Enemy death** | Ink dissolving (wet fade) + low bass drop + silence beat |
| **Moral choice appears** | Reverb-heavy bell toll + whispering voices (unintelligible) |
| **Alignment shift** | Tonal drone in alignment's register (Radiant=high, Vile=low, Primal=mid) |

### 14.3 Music Direction

| Context | Musical Direction | Instrumentation |
|---------|------------------|-----------------|
| **Grimoire Hub** | Ambient, contemplative, warm | Solo lute or harp + sustained strings + subtle choir pad |
| **Battle (standard)** | Tense, rhythmic, building | Percussion (frame drum, bodhrán) + strings + low brass |
| **Battle (boss)** | Urgent, dramatic, full arrangement | Full orchestra hit + choir stabs + driving percussion |
| **Moral choice** | Still, heavy, sparse | Solo cello + silence + single bell |
| **Victory** | Triumphant, brief | Brass fanfare + major chord resolution (3–5 seconds) |
| **Defeat** | Somber, fading | Descending strings + final low note (3–5 seconds) |

---

## 15. Asset Production Guidelines

### 15.1 Resolution & Format Standards

| Asset Type | Working Resolution | Export Resolution | Format |
|-----------|:-----------------:|:----------------:|--------|
| Card illustration | 800×560 (4× render) | 400×280 | PNG-8 (indexed color, ≤256 colors per card) |
| Card frame/border | 400×600 (2× render) | 200×300 | PNG-32 (alpha for transparency) |
| Enemy sprite | 600×900 (3× render) | 200–300px tall | PNG-32 |
| Boss sprite | 1800×2700 (3× render) | 600–900px tall | PNG-32 |
| Grimoire cover | 2048×2048 (2× render) | 1024×1024 | PNG-32 + normal map |
| Background layer | 3840×2160 (2× render) | 1920×1080 | PNG-8 (no alpha needed) |
| UI icon | 96×96 (4× render) | 24×24 | PNG-32 |
| Particle texture | 64×64 or 128×128 | 16×16 or 32×32 | PNG-32 |
| Status icon | 80×80 (4× render) | 20×20 | PNG-32 |

### 15.2 Texture Atlas Strategy

Pack small repeated assets into atlases to minimize draw calls:

| Atlas | Contents | Max Size |
|-------|----------|:--------:|
| `ui_icons.png` | All 15+ UI icons | 512×512 |
| `particles.png` | All particle textures (ink, gold, leaf, wisp, page) | 256×256 |
| `status_effects.png` | All status effect icons | 256×256 |
| `card_borders.png` | All 5 mastery tier borders × 3 alignments | 1024×1024 |
| `rarity_stars.png` | Star icons (filled + empty) | 128×128 |

### 15.3 Naming Conventions

```
Type_Name_Variant_State.png

Examples:
  card_spark_bolt_art.png           → Card illustration
  card_spark_bolt_border_gold.png   → Gold mastery border for this card
  enemy_paladin_idle.png            → Paladin idle sprite
  enemy_paladin_attack.png          → Paladin attack telegraph pose
  boss_arbiter_idle.png             → Boss idle sprite
  grimoire_cover_leather.png        → Leather cover texture
  grimoire_cover_leather_n.png      → Leather cover normal map
  icon_attack_sword.png             → Attack type icon
  particle_ink_blob_01.png          → Ink particle variant 1
  bg_radiant_archive_layer1.png     → Background layer 1 for Radiant chapters
```

### 15.4 Color Validation Checklist

Before any asset is committed, verify:

- [ ] All colors used exist in the Master Palette (Section 3.1) or are a tint/shade thereof
- [ ] Text passes WCAG AA contrast ratio against its background
- [ ] Alignment colors are only used in alignment-relevant contexts
- [ ] Gold is only used for earned/important elements (not decoration)
- [ ] No pure black (#000000) — use Ink Black (#1A1410) instead
- [ ] No pure white (#FFFFFF) — use Holy White (#FFF8EE) or Parchment Light (#F5E6C8)
- [ ] Status effect icons are distinguishable by shape alone (cover color channel and check)

---

## 16. Anti-Patterns (What We Are NOT)

This section exists to prevent style drift. If an asset starts looking like any of these, it's wrong.

### 16.1 Visual Anti-Patterns

| Anti-Pattern | Why It's Wrong For Us | What To Do Instead |
|-------------|----------------------|-------------------|
| **Clean vector UI** (flat, Material Design, geometric) | Feels modern and corporate. Manuscripts are handmade. | Use parchment textures, ink borders, hand-drawn elements |
| **Anime art style** (big eyes, sharp chins, speed lines) | We borrow Black Clover's *lore*, not its *look*. Anime style clashes with manuscript aesthetic. | Western dark fantasy illustration, bestiary style |
| **Photorealistic rendering** (3D, PBR, raytracing) | Too heavy, too modern, breaks the 2D manuscript fantasy | Ink and watercolor on parchment — painterly, not realistic |
| **Pixel art** | Wrong genre association (retro games). Our aesthetic is pre-digital, not low-res digital. | Full-resolution hand-drawn art scaled to appropriate sizes |
| **Neon / cyberpunk colors** (hot pink, electric blue, lime green) | Completely wrong era and mood. We're candlelit, not backlit. | Historical pigment palette — warm, earthy, muted brights |
| **Glossy / glassy UI** (glass morphism, reflections, gradients) | Too modern. Manuscripts don't have glass. | Matte parchment, ink lines, no reflections |
| **Cluttered UI with many small elements** | Manuscripts use generous margins and clear hierarchy. Cluttered UI feels like a spreadsheet. | Generous padding, clear typography hierarchy, breathing room |
| **Random Fiverr / stock asset mix** | Inconsistent line weights, color palettes, and styles destroy visual cohesion instantly | Every asset must pass the Four Pillars test (Section 1.2) and color validation (Section 15.4) |
| **Over-designed card frames** | If the frame is more interesting than the card art, the hierarchy is broken | Frame serves the art. Ornate borders are for Gold/Evolved mastery only |
| **Lens flares, bloom, chromatic aberration** | Modern camera effects. A manuscript doesn't have a camera. | Glow effects use soft additive blending. No post-processing tricks. |

### 16.2 The "Random Fiverr Assets" Test

If you commission or source art externally, every asset must pass this checklist before integration:

1. **Line weight consistency:** Does the outline thickness match existing assets? (2–3px at 1080p render)
2. **Palette compliance:** Are all colors from our Master Palette?
3. **Ink black match:** Are outlines drawn in #1A1410, not #000000?
4. **Texture grain:** Does the asset have parchment/paper texture, or is it on a flat white/transparent background?
5. **Proportion match:** Do characters match our 6–7 head height standard?
6. **Rendering technique:** Is it ink-and-watercolor style, or is it digitally blended/airbrushed?
7. **Pillar check:** Does it satisfy at least 2 of the 4 Visual Pillars?

**If any answer is "no," the asset needs rework before integration.**

---

## Appendix: Quick Reference Card

```
╔══════════════════════════════════════════════════════════╗
║  GRIMOIRE: THE SOULBOUND LEGACY — ART QUICK REFERENCE   ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  STYLE: Dark fantasy illuminated manuscript              ║
║  MOOD:  Ancient, handcrafted, living, atmospheric        ║
║                                                          ║
║  SURFACES:     Parchment (always)                        ║
║  DRAWING:      Ink outlines (#1A1410), watercolor fill   ║
║  ACCENTS:      Burnished Gold (#D4A847) — earned only    ║
║  BACKGROUNDS:  Candlelit, warm shadows, deep vignette    ║
║                                                          ║
║  RADIANT:  #FFE4A0  Gold / White / Blue                  ║
║  VILE:     #6B2D8B  Purple / Green / Crimson             ║
║  PRIMAL:   #2E7D6B  Teal / Brown / Amber                 ║
║                                                          ║
║  FONTS:    3 total (Display, Body, Data)                 ║
║  ICONS:    Hand-drawn ink silhouettes                    ║
║  VFX:      Ink that moves (max 500 particles)            ║
║  ANIMATE:  Slide, fold, flutter — never bounce/shake     ║
║                                                          ║
║  NOT: Anime, pixel art, vectors, neon, photorealistic    ║
║  NOT: Drop shadows, glass effects, lens flares           ║
║  NOT: Random mixed-style assets                          ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

---

*This Art Bible is a living document. Update it when new visual systems are added or when art direction decisions are refined during production. Every artist, contractor, or AI tool working on this project must read this document first.*

Sources:
- [The Illuminators' Palette — Fitzwilliam Museum](https://colour-illuminated.fitzmuseum.cam.ac.uk/explore/illuminators-palette)
- [Inkulinati Medieval Manuscript Art — ScreenRant](https://screenrant.com/inkulinati-medieval-art-game-strategy-illuminated-manuscripts/)
- [Illustrating Slay the Spire — Medium](https://moregamesplease.medium.com/illustrating-slay-the-spire-discovering-the-art-in-games-191bd1a64569)
- [Deckbuilder UI Design Best Practices](https://www.gunslingersrevenge.com/posts/development/deckbuilder-ui-design-best-practices.html)
- [Medieval Manuscript Colors — Brainly](https://brainly.com/topic/arts/medieval-manuscript-colors)
- [Black Clover Unique Grimoires — Sportskeeda](https://www.sportskeeda.com/anime/9-unique-grimoires-black-clover)
- [Gaming Fonts Typography — 99designs](https://99designs.com/blog/design-history-movements/gaming-fonts/)
