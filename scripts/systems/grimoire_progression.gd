class_name GrimoireProgression
extends RefCounted

## Manages Grimoire leveling 1-20, XP curves, deck size scaling,
## inscription slot unlocks, and Ultimate Spell generation at level 20.

## XP required to reach each level (index = target level, so XP_CURVE[2] = XP needed for level 2).
## Levels 1-5 are faster (MVP range), 6-20 scale progressively.
const XP_CURVE: Array[int] = [
	0,    # Level 1 (starting)
	0,    # Level 1 → 1 (unused)
	20,   # Level 2
	45,   # Level 3
	75,   # Level 4
	110,  # Level 5
	155,  # Level 6
	210,  # Level 7
	275,  # Level 8
	350,  # Level 9
	440,  # Level 10
	540,  # Level 11
	650,  # Level 12
	775,  # Level 13
	910,  # Level 14
	1060, # Level 15
	1225, # Level 16
	1400, # Level 17
	1600, # Level 18
	1820, # Level 19
	2060, # Level 20
]


func get_xp_for_level(level: int) -> int:
	## Returns total XP required to reach the given level.
	if level < 1 or level > 20:
		return 0
	return XP_CURVE[level]


func get_xp_to_next_level(grimoire: GrimoireResource) -> int:
	## Returns XP remaining until next level, or 0 if max level.
	if grimoire.grimoire_level >= 20:
		return 0
	var needed: int = XP_CURVE[grimoire.grimoire_level + 1]
	return maxi(0, needed - grimoire.grimoire_xp)


func get_xp_progress(grimoire: GrimoireResource) -> float:
	## Returns 0.0–1.0 progress toward next level.
	if grimoire.grimoire_level >= 20:
		return 1.0
	var current_threshold: int = XP_CURVE[grimoire.grimoire_level]
	var next_threshold: int = XP_CURVE[grimoire.grimoire_level + 1]
	var range_size: int = next_threshold - current_threshold
	if range_size <= 0:
		return 1.0
	var progress_in_range: int = grimoire.grimoire_xp - current_threshold
	return clampf(float(progress_in_range) / float(range_size), 0.0, 1.0)


func award_xp(grimoire: GrimoireResource, amount: int) -> Array[int]:
	## Awards XP and handles level-ups. Returns array of new levels reached (may be multiple).
	var levels_gained: Array[int] = []
	grimoire.grimoire_xp += amount

	while grimoire.grimoire_level < 20:
		var next_level: int = grimoire.grimoire_level + 1
		if grimoire.grimoire_xp >= XP_CURVE[next_level]:
			grimoire.grimoire_level = next_level
			levels_gained.append(next_level)
		else:
			break

	return levels_gained


func get_deck_size_for_level(level: int) -> int:
	## Returns max deck size at a given level.
	if level <= 5:
		return 20
	elif level <= 10:
		return 25
	elif level <= 15:
		return 30
	elif level <= 19:
		return 35
	else:
		return 40


func get_inscription_slots_for_level(level: int) -> int:
	## Returns inscription slot count at a given level.
	if level < 3:
		return 0
	elif level <= 5:
		return mini(level - 2, 2)  # Level 3→1, Level 4→2, Level 5→2
	elif level <= 10:
		return 2
	elif level <= 15:
		return 3
	else:
		return 4


func generate_ultimate_spell(grimoire: GrimoireResource) -> CardResource:
	## Generates a unique Ultimate Spell at level 20 based on seed + alignment state.
	## Returns null if grimoire is not level 20.
	if grimoire.grimoire_level < 20:
		return null

	var rng := RandomNumberGenerator.new()
	rng.seed = grimoire.seed + grimoire.alignment_radiant * 1000 + grimoire.alignment_vile * 100 + grimoire.alignment_primal

	var dominant: GlobalEnums.Alignment = grimoire.get_dominant_alignment()
	var card := CardResource.new()
	card.card_id = "ultimate_%s_%d" % [grimoire.true_name.to_lower(), grimoire.seed]
	card.rarity = GlobalEnums.Rarity.LEGENDARY
	card.alignment = dominant
	card.mastery_tier = GlobalEnums.MasteryTier.EVOLVED
	card.is_evolved = true
	card.mana_cost = 4

	# Generate name and stats based on dominant alignment
	match dominant:
		GlobalEnums.Alignment.RADIANT:
			card.card_name = "%s's Radiance" % grimoire.true_name
			card.description = "Deal %d damage to all enemies. Heal %d HP. Remove all debuffs." % [_scale_value(rng, 6, 10), _scale_value(rng, 4, 8)]
			card.card_type = GlobalEnums.CardType.SPECIAL
			card.base_value = _scale_value(rng, 8, 12)
			card.target_type = GlobalEnums.TargetType.ALL_ENEMIES
		GlobalEnums.Alignment.VILE:
			card.card_name = "%s's Corruption" % grimoire.true_name
			card.description = "Deal %d damage. Apply %d poison and %d weakness to all enemies." % [_scale_value(rng, 5, 9), _scale_value(rng, 3, 6), _scale_value(rng, 2, 4)]
			card.card_type = GlobalEnums.CardType.SPECIAL
			card.base_value = _scale_value(rng, 7, 11)
			card.target_type = GlobalEnums.TargetType.ALL_ENEMIES
		GlobalEnums.Alignment.PRIMAL:
			card.card_name = "%s's Convergence" % grimoire.true_name
			card.description = "Deal %d damage to all enemies. Gain %d block. Draw %d cards." % [_scale_value(rng, 4, 8), _scale_value(rng, 5, 10), _scale_value(rng, 2, 3)]
			card.card_type = GlobalEnums.CardType.SPECIAL
			card.base_value = _scale_value(rng, 6, 10)
			card.target_type = GlobalEnums.TargetType.ALL_ENEMIES

	return card


func _scale_value(rng: RandomNumberGenerator, min_val: int, max_val: int) -> int:
	return rng.randi_range(min_val, max_val)
