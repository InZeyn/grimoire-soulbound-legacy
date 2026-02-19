class_name SeedValidator
extends RefCounted

## Validates a grimoire seed by simulating sample hands.
## Rejects seeds that produce fewer than 2 cards per CardType.

const SIMULATION_COUNT: int = 1000
const HAND_SIZE: int = 5
const MIN_CARDS_PER_TYPE: int = 2
const REQUIRED_DECK_SIZE: int = 20

var _card_pool: Array[CardResource] = []


func load_card_pool() -> void:
	_card_pool.clear()
	var dir: DirAccess = DirAccess.open("res://resources/cards/base/")
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var card: CardResource = ResourceLoader.load("res://resources/cards/base/" + file_name) as CardResource
			if card != null:
				_card_pool.append(card)
		file_name = dir.get_next()
	dir.list_dir_end()


func get_card_pool() -> Array[CardResource]:
	return _card_pool


func validate_seed(master_seed: int) -> Dictionary:
	## Returns {"valid": bool, "reason": String, "deck": Array[CardResource]}
	if _card_pool.is_empty():
		load_card_pool()

	if _card_pool.size() < REQUIRED_DECK_SIZE:
		return {"valid": false, "reason": "Card pool too small (%d < %d)" % [_card_pool.size(), REQUIRED_DECK_SIZE], "deck": []}

	var deck: Array[CardResource] = _select_deck(master_seed)

	# Check type distribution
	var type_counts: Dictionary = {}
	for t: int in range(4):  # ATTACK, DEFENSE, SUPPORT, SPECIAL
		type_counts[t] = 0
	for card: CardResource in deck:
		type_counts[card.card_type] += 1

	for t: int in range(4):
		if type_counts[t] < MIN_CARDS_PER_TYPE:
			return {"valid": false, "reason": "Too few %s cards (%d)" % [_type_name(t), type_counts[t]], "deck": deck}

	# Simulate hands to check playability
	var unplayable_hands: int = _simulate_hands(deck, master_seed)
	var unplayable_rate: float = float(unplayable_hands) / float(SIMULATION_COUNT)
	if unplayable_rate > 0.3:
		return {"valid": false, "reason": "%.0f%% unplayable hands" % (unplayable_rate * 100.0), "deck": deck}

	return {"valid": true, "reason": "OK", "deck": deck}


func _select_deck(master_seed: int) -> Array[CardResource]:
	## Seed-based selection of 20 cards from pool, guaranteeing type minimums.
	var rng := RandomNumberGenerator.new()
	rng.seed = master_seed

	var deck: Array[CardResource] = []
	var available: Array[CardResource] = _card_pool.duplicate()

	# Phase 1: Guarantee minimums — pick 2 of each type
	for card_type: int in range(4):
		var typed: Array[CardResource] = []
		for c: CardResource in available:
			if c.card_type == card_type:
				typed.append(c)
		var picked: int = 0
		while picked < MIN_CARDS_PER_TYPE and typed.size() > 0:
			var idx: int = rng.randi_range(0, typed.size() - 1)
			deck.append(typed[idx])
			available.erase(typed[idx])
			typed.remove_at(idx)
			picked += 1

	# Phase 2: Fill remaining slots randomly
	while deck.size() < REQUIRED_DECK_SIZE and available.size() > 0:
		var idx: int = rng.randi_range(0, available.size() - 1)
		deck.append(available[idx])
		available.remove_at(idx)

	# If pool is smaller than deck size, duplicate some cards
	if deck.size() < REQUIRED_DECK_SIZE:
		var fill_rng_idx: int = 0
		while deck.size() < REQUIRED_DECK_SIZE:
			var source: CardResource = _card_pool[rng.randi_range(0, _card_pool.size() - 1)]
			var copy: CardResource = source.duplicate() as CardResource
			deck.append(copy)
			fill_rng_idx += 1

	return deck


func _simulate_hands(deck: Array[CardResource], base_seed: int) -> int:
	## Simulates drawing hands. A hand is "unplayable" if no card costs <= 3 mana.
	var rng := RandomNumberGenerator.new()
	var unplayable: int = 0

	for sim: int in range(SIMULATION_COUNT):
		rng.seed = base_seed + sim + 1
		# Shuffle deck indices
		var indices: Array[int] = []
		for i: int in range(deck.size()):
			indices.append(i)
		# Fisher-Yates
		for i: int in range(indices.size() - 1, 0, -1):
			var j: int = rng.randi_range(0, i)
			var tmp: int = indices[i]
			indices[i] = indices[j]
			indices[j] = tmp

		# Draw hand
		var playable: bool = false
		var draw_count: int = mini(HAND_SIZE, indices.size())
		for h: int in range(draw_count):
			if deck[indices[h]].mana_cost <= 3:
				playable = true
				break
		if not playable:
			unplayable += 1

	return unplayable


func _type_name(t: int) -> String:
	match t:
		0: return "ATTACK"
		1: return "DEFENSE"
		2: return "SUPPORT"
		3: return "SPECIAL"
	return "UNKNOWN"
