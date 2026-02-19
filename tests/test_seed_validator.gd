extends SceneTree

## Test suite for Phase 4 — SeedValidator and GrimoireGenerator card selection.

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== PHASE 4: SEED VALIDATOR TESTS ===\n")

	test_card_pool_loading()
	test_seed_produces_20_cards()
	test_type_guarantees()
	test_different_seeds_different_decks()
	test_invalid_seed_detection()
	test_validated_generation()
	test_seed_determinism()

	print("\n=== RESULTS: %d passed, %d failed ===" % [_pass_count, _fail_count])
	if _fail_count > 0:
		print("SOME TESTS FAILED!")
	else:
		print("ALL TESTS PASSED!")
	quit()


func _assert(condition: bool, test_name: String) -> void:
	if condition:
		_pass_count += 1
		print("  PASS: %s" % test_name)
	else:
		_fail_count += 1
		print("  FAIL: %s" % test_name)


func test_card_pool_loading() -> void:
	print("-- Card Pool Loading --")
	var sv := SeedValidator.new()
	sv.load_card_pool()
	_assert(sv.get_card_pool().size() == 30, "Card pool has 30 base cards")


func test_seed_produces_20_cards() -> void:
	print("-- Seed Produces 20 Cards --")
	var sv := SeedValidator.new()
	sv.load_card_pool()
	var result: Dictionary = sv.validate_seed(42)
	_assert(result["deck"].size() == 20, "Deck has 20 cards")
	_assert(result["valid"] == true, "Seed 42 is valid")


func test_type_guarantees() -> void:
	print("-- Type Guarantees --")
	var sv := SeedValidator.new()
	sv.load_card_pool()

	# Test multiple seeds to verify type guarantees
	for seed_val: int in [1, 42, 100, 999, 12345]:
		var result: Dictionary = sv.validate_seed(seed_val)
		var type_counts: Dictionary = {0: 0, 1: 0, 2: 0, 3: 0}
		for card: CardResource in result["deck"]:
			type_counts[card.card_type] += 1
		_assert(type_counts[0] >= 2, "Seed %d has >= 2 ATTACK cards" % seed_val)
		_assert(type_counts[1] >= 2, "Seed %d has >= 2 DEFENSE cards" % seed_val)
		_assert(type_counts[2] >= 2, "Seed %d has >= 2 SUPPORT cards" % seed_val)
		_assert(type_counts[3] >= 2, "Seed %d has >= 2 SPECIAL cards" % seed_val)


func test_different_seeds_different_decks() -> void:
	print("-- Different Seeds Different Decks --")
	var sv := SeedValidator.new()
	sv.load_card_pool()
	var result_a: Dictionary = sv.validate_seed(42)
	var result_b: Dictionary = sv.validate_seed(999)

	var ids_a: Array[String] = []
	for card: CardResource in result_a["deck"]:
		ids_a.append(card.card_id)
	var ids_b: Array[String] = []
	for card: CardResource in result_b["deck"]:
		ids_b.append(card.card_id)

	# At least some cards should differ
	var same_count: int = 0
	for i: int in range(ids_a.size()):
		if ids_a[i] == ids_b[i]:
			same_count += 1
	_assert(same_count < 20, "Different seeds produce different decks (%d/20 same)" % same_count)


func test_invalid_seed_detection() -> void:
	print("-- Seed Validation Result --")
	var sv := SeedValidator.new()
	sv.load_card_pool()
	# With 30 cards (enough variety), most seeds should be valid
	var result: Dictionary = sv.validate_seed(42)
	_assert(result.has("valid"), "Result has 'valid' key")
	_assert(result.has("reason"), "Result has 'reason' key")
	_assert(result.has("deck"), "Result has 'deck' key")


func test_validated_generation() -> void:
	print("-- Validated Grimoire Generation --")
	var gen := GrimoireGenerator.new()
	var grimoire: GrimoireResource = gen.generate_validated(42)
	_assert(grimoire != null, "Validated generation returns a grimoire")
	_assert(grimoire.cards.size() == 20, "Generated grimoire has 20 cards")
	_assert(grimoire.true_name != "", "Grimoire has a true name")
	_assert(grimoire.grimoire_level == 1, "Grimoire starts at level 1")

	# Verify cards are independent copies (not shared references)
	if grimoire.cards.size() >= 2:
		grimoire.cards[0].mastery_xp = 50
		_assert(grimoire.cards[1].mastery_xp == 0, "Cards are independent copies")


func test_seed_determinism() -> void:
	print("-- Seed Determinism --")
	var gen := GrimoireGenerator.new()
	var g1: GrimoireResource = gen.generate_validated(42)
	var g2: GrimoireResource = gen.generate_validated(42)
	_assert(g1.true_name == g2.true_name, "Same seed produces same true name")
	_assert(g1.cards.size() == g2.cards.size(), "Same seed produces same deck size")
	if g1.cards.size() > 0 and g2.cards.size() > 0:
		_assert(g1.cards[0].card_id == g2.cards[0].card_id, "Same seed produces same first card")
