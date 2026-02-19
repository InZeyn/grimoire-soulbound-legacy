class_name GrimoireGenerator
extends RefCounted

const SYLLABLES_START: Array[String] = ["Vex", "Thar", "Mor", "Ael", "Kyn", "Zor", "Ith", "Nal", "Bre", "Fen"]
const SYLLABLES_MID: Array[String] = ["i", "a", "o", "u", "e", "al", "or", "en", "is", "ar"]
const SYLLABLES_END: Array[String] = ["thorn", "wick", "grim", "vale", "bone", "flux", "rend", "shade", "crest", "forge"]

const LORE_TEMPLATES: Array[String] = [
	"Bound in %s and sealed with %s, this grimoire whispers of %s to those who listen.",
	"Forged in the age of %s, its pages shimmer with %s, echoing the will of %s.",
	"A tome of %s, wrapped in %s, pulsing with the ancient resonance of %s.",
]

const LORE_MATERIAL_WORDS: Array[String] = ["shadow", "starlight", "ash", "crystal", "iron"]
const LORE_SEAL_WORDS: Array[String] = ["blood", "moonfire", "silence", "thunder", "frost"]
const LORE_THEME_WORDS: Array[String] = ["forgotten kings", "wild storms", "deep roots", "lost hymns", "endless night"]

var _seed_validator: SeedValidator = null


func generate(master_seed: int) -> GrimoireResource:
	var rng := RandomNumberGenerator.new()
	rng.seed = master_seed

	var grimoire := GrimoireResource.new()
	grimoire.seed = master_seed
	grimoire.true_name = _generate_true_name(rng)
	grimoire.cover_type = rng.randi_range(0, 4) as GlobalEnums.GrimoireCover
	grimoire.binding_type = rng.randi_range(0, 4) as GlobalEnums.GrimoireBinding

	# Starting affinity: nudge one axis by +10
	var starting_affinity: int = rng.randi_range(0, 2)
	match starting_affinity:
		0: grimoire.alignment_radiant = 10
		1: grimoire.alignment_vile = 10
		2: grimoire.alignment_primal = 10

	# Aura color derived from starting affinity
	match starting_affinity:
		0: grimoire.aura_color = Color(1.0, 0.9, 0.5)  # Gold
		1: grimoire.aura_color = Color(0.6, 0.2, 0.8)  # Purple
		2: grimoire.aura_color = Color(0.3, 0.8, 0.6)  # Teal

	grimoire.sigil_params = {
		"sides": rng.randi_range(3, 8),
		"rotation": rng.randf_range(0.0, TAU),
		"inner_ratio": rng.randf_range(0.3, 0.7),
	}

	grimoire.lore_text = _generate_lore(rng)
	grimoire.grimoire_level = 1
	grimoire.grimoire_xp = 0

	# Select starting deck from card library
	grimoire.cards = _select_starting_deck(master_seed)

	return grimoire


func generate_validated(master_seed: int, max_attempts: int = 100) -> GrimoireResource:
	## Generates a grimoire, retrying with seed offsets if validation fails.
	if _seed_validator == null:
		_seed_validator = SeedValidator.new()
		_seed_validator.load_card_pool()

	for attempt: int in range(max_attempts):
		var test_seed: int = master_seed + attempt
		var result: Dictionary = _seed_validator.validate_seed(test_seed)
		if result["valid"]:
			var grimoire: GrimoireResource = generate(test_seed)
			return grimoire

	# Fallback: generate anyway with original seed
	return generate(master_seed)


func _select_starting_deck(master_seed: int) -> Array[CardResource]:
	## Uses SeedValidator's deck selection for consistent seed-based card picking.
	if _seed_validator == null:
		_seed_validator = SeedValidator.new()
		_seed_validator.load_card_pool()

	if _seed_validator.get_card_pool().is_empty():
		return []

	var result: Dictionary = _seed_validator.validate_seed(master_seed)
	var deck: Array[CardResource] = []
	for card: CardResource in result["deck"]:
		var copy: CardResource = card.duplicate() as CardResource
		copy.mastery_xp = 0
		copy.mastery_tier = GlobalEnums.MasteryTier.UNMASTERED
		copy.is_evolved = false
		deck.append(copy)
	return deck


func _generate_true_name(rng: RandomNumberGenerator) -> String:
	var start: String = SYLLABLES_START[rng.randi_range(0, SYLLABLES_START.size() - 1)]
	var mid: String = SYLLABLES_MID[rng.randi_range(0, SYLLABLES_MID.size() - 1)]
	var end: String = SYLLABLES_END[rng.randi_range(0, SYLLABLES_END.size() - 1)]
	return start + mid + end


func _generate_lore(rng: RandomNumberGenerator) -> String:
	var template: String = LORE_TEMPLATES[rng.randi_range(0, LORE_TEMPLATES.size() - 1)]
	var mat: String = LORE_MATERIAL_WORDS[rng.randi_range(0, LORE_MATERIAL_WORDS.size() - 1)]
	var seal: String = LORE_SEAL_WORDS[rng.randi_range(0, LORE_SEAL_WORDS.size() - 1)]
	var theme: String = LORE_THEME_WORDS[rng.randi_range(0, LORE_THEME_WORDS.size() - 1)]
	return template % [mat, seal, theme]
