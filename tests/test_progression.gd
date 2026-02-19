extends SceneTree

## Test suite for Phase 4 — GrimoireProgression (XP curve, leveling, deck size, slots, ultimate spell).

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== PHASE 4: PROGRESSION TESTS ===\n")

	test_xp_curve_monotonic()
	test_xp_to_next_level()
	test_award_xp_single_level()
	test_award_xp_multi_level()
	test_max_level_cap()
	test_xp_progress()
	test_deck_size_scaling()
	test_inscription_slot_scaling()
	test_ultimate_spell_generation()
	test_ultimate_spell_determinism()
	test_ultimate_spell_alignment_variants()
	test_full_progression_1_to_5()

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


func _make_grimoire() -> GrimoireResource:
	var g := GrimoireResource.new()
	g.seed = 42
	g.true_name = "TestGrimoire"
	g.grimoire_level = 1
	g.grimoire_xp = 0
	g.alignment_radiant = 10
	g.alignment_vile = 10
	g.alignment_primal = 10
	return g


func test_xp_curve_monotonic() -> void:
	print("-- XP Curve Monotonic --")
	var gp := GrimoireProgression.new()
	var prev: int = 0
	var all_increasing: bool = true
	for level: int in range(2, 21):
		var xp: int = gp.get_xp_for_level(level)
		if xp <= prev:
			all_increasing = false
		prev = xp
	_assert(all_increasing, "XP curve is strictly increasing from level 2 to 20")


func test_xp_to_next_level() -> void:
	print("-- XP To Next Level --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()
	_assert(gp.get_xp_to_next_level(g) == 20, "Level 1 needs 20 XP to reach level 2")

	g.grimoire_xp = 10
	_assert(gp.get_xp_to_next_level(g) == 10, "With 10 XP, needs 10 more")

	g.grimoire_level = 20
	_assert(gp.get_xp_to_next_level(g) == 0, "Max level needs 0 XP")


func test_award_xp_single_level() -> void:
	print("-- Award XP Single Level --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()
	var levels: Array[int] = gp.award_xp(g, 20)
	_assert(g.grimoire_level == 2, "Level is now 2")
	_assert(levels.size() == 1, "1 level gained")
	_assert(levels[0] == 2, "Gained level 2")


func test_award_xp_multi_level() -> void:
	print("-- Award XP Multi Level --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()
	# Award enough XP to jump from 1 to 3 (need 45 XP for level 3)
	var levels: Array[int] = gp.award_xp(g, 50)
	_assert(g.grimoire_level == 3, "Level is now 3")
	_assert(levels.size() == 2, "2 levels gained")
	_assert(levels[0] == 2, "First gained level 2")
	_assert(levels[1] == 3, "Then gained level 3")


func test_max_level_cap() -> void:
	print("-- Max Level Cap --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()
	var levels: Array[int] = gp.award_xp(g, 99999)
	_assert(g.grimoire_level == 20, "Capped at level 20")
	_assert(levels.size() == 19, "Gained 19 levels (1→20)")

	# Award more XP at max level — should stay at 20
	var extra: Array[int] = gp.award_xp(g, 1000)
	_assert(g.grimoire_level == 20, "Still at level 20")
	_assert(extra.size() == 0, "No more levels gained")


func test_xp_progress() -> void:
	print("-- XP Progress --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()
	# Level 1, XP 0, need 20 for level 2
	_assert(gp.get_xp_progress(g) == 0.0, "0%% progress at start")

	g.grimoire_xp = 10
	var progress: float = gp.get_xp_progress(g)
	_assert(progress > 0.4 and progress < 0.6, "~50%% progress at 10/20 XP")

	g.grimoire_level = 20
	_assert(gp.get_xp_progress(g) == 1.0, "100%% at max level")


func test_deck_size_scaling() -> void:
	print("-- Deck Size Scaling --")
	var gp := GrimoireProgression.new()
	_assert(gp.get_deck_size_for_level(1) == 20, "Level 1 → 20 cards")
	_assert(gp.get_deck_size_for_level(5) == 20, "Level 5 → 20 cards")
	_assert(gp.get_deck_size_for_level(6) == 25, "Level 6 → 25 cards")
	_assert(gp.get_deck_size_for_level(10) == 25, "Level 10 → 25 cards")
	_assert(gp.get_deck_size_for_level(11) == 30, "Level 11 → 30 cards")
	_assert(gp.get_deck_size_for_level(15) == 30, "Level 15 → 30 cards")
	_assert(gp.get_deck_size_for_level(16) == 35, "Level 16 → 35 cards")
	_assert(gp.get_deck_size_for_level(19) == 35, "Level 19 → 35 cards")
	_assert(gp.get_deck_size_for_level(20) == 40, "Level 20 → 40 cards")


func test_inscription_slot_scaling() -> void:
	print("-- Inscription Slot Scaling --")
	var gp := GrimoireProgression.new()
	_assert(gp.get_inscription_slots_for_level(1) == 0, "Level 1 → 0 slots")
	_assert(gp.get_inscription_slots_for_level(2) == 0, "Level 2 → 0 slots")
	_assert(gp.get_inscription_slots_for_level(3) == 1, "Level 3 → 1 slot")
	_assert(gp.get_inscription_slots_for_level(5) == 2, "Level 5 → 2 slots")
	_assert(gp.get_inscription_slots_for_level(10) == 2, "Level 10 → 2 slots")
	_assert(gp.get_inscription_slots_for_level(11) == 3, "Level 11 → 3 slots")
	_assert(gp.get_inscription_slots_for_level(15) == 3, "Level 15 → 3 slots")
	_assert(gp.get_inscription_slots_for_level(16) == 4, "Level 16 → 4 slots")
	_assert(gp.get_inscription_slots_for_level(20) == 4, "Level 20 → 4 slots")


func test_ultimate_spell_generation() -> void:
	print("-- Ultimate Spell Generation --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()

	# Not level 20 — should return null
	var spell_early: CardResource = gp.generate_ultimate_spell(g)
	_assert(spell_early == null, "No ultimate at level 1")

	# Level 20
	g.grimoire_level = 20
	g.alignment_radiant = 60
	var spell: CardResource = gp.generate_ultimate_spell(g)
	_assert(spell != null, "Ultimate generated at level 20")
	if spell != null:
		_assert(spell.rarity == GlobalEnums.Rarity.LEGENDARY, "Ultimate is LEGENDARY")
		_assert(spell.is_evolved, "Ultimate is evolved")
		_assert(spell.mana_cost == 4, "Ultimate costs 4 mana")
		_assert(spell.card_type == GlobalEnums.CardType.SPECIAL, "Ultimate is SPECIAL type")
		_assert("TestGrimoire" in spell.card_name, "Ultimate name contains grimoire name")


func test_ultimate_spell_determinism() -> void:
	print("-- Ultimate Spell Determinism --")
	var gp := GrimoireProgression.new()
	var g1: GrimoireResource = _make_grimoire()
	g1.grimoire_level = 20
	g1.alignment_radiant = 60
	var g2: GrimoireResource = _make_grimoire()
	g2.grimoire_level = 20
	g2.alignment_radiant = 60

	var s1: CardResource = gp.generate_ultimate_spell(g1)
	var s2: CardResource = gp.generate_ultimate_spell(g2)
	_assert(s1.card_name == s2.card_name, "Same state → same ultimate name")
	_assert(s1.base_value == s2.base_value, "Same state → same base value")


func test_ultimate_spell_alignment_variants() -> void:
	print("-- Ultimate Spell Alignment Variants --")
	var gp := GrimoireProgression.new()

	# Radiant dominant
	var g_rad: GrimoireResource = _make_grimoire()
	g_rad.grimoire_level = 20
	g_rad.alignment_radiant = 80
	var spell_rad: CardResource = gp.generate_ultimate_spell(g_rad)
	_assert(spell_rad.alignment == GlobalEnums.Alignment.RADIANT, "Radiant dominant → Radiant ultimate")
	_assert("Radiance" in spell_rad.card_name, "Radiant ultimate has 'Radiance' in name")

	# Vile dominant
	var g_vile: GrimoireResource = _make_grimoire()
	g_vile.grimoire_level = 20
	g_vile.alignment_vile = 80
	var spell_vile: CardResource = gp.generate_ultimate_spell(g_vile)
	_assert(spell_vile.alignment == GlobalEnums.Alignment.VILE, "Vile dominant → Vile ultimate")
	_assert("Corruption" in spell_vile.card_name, "Vile ultimate has 'Corruption' in name")

	# Primal dominant
	var g_pri: GrimoireResource = _make_grimoire()
	g_pri.grimoire_level = 20
	g_pri.alignment_primal = 80
	var spell_pri: CardResource = gp.generate_ultimate_spell(g_pri)
	_assert(spell_pri.alignment == GlobalEnums.Alignment.PRIMAL, "Primal dominant → Primal ultimate")
	_assert("Convergence" in spell_pri.card_name, "Primal ultimate has 'Convergence' in name")


func test_full_progression_1_to_5() -> void:
	print("-- Full Progression 1 to 5 --")
	var gp := GrimoireProgression.new()
	var g: GrimoireResource = _make_grimoire()

	# Simulate chapter completions awarding XP
	gp.award_xp(g, 25)  # → level 2 (need 20)
	_assert(g.grimoire_level == 2, "After 25 XP: level 2")
	_assert(g.get_max_deck_size() == 20, "Level 2: 20 deck size")
	_assert(g.get_inscription_slot_count() == 0, "Level 2: 0 inscription slots")

	gp.award_xp(g, 25)  # Total 50 → level 3 (need 45)
	_assert(g.grimoire_level == 3, "After 50 XP: level 3")
	_assert(g.get_inscription_slot_count() == 1, "Level 3: 1 inscription slot")

	gp.award_xp(g, 30)  # Total 80 → level 4 (need 75)
	_assert(g.grimoire_level == 4, "After 80 XP: level 4")

	gp.award_xp(g, 35)  # Total 115 → level 5 (need 110)
	_assert(g.grimoire_level == 5, "After 115 XP: level 5")
	_assert(g.get_inscription_slot_count() == 2, "Level 5: 2 inscription slots")
	_assert(g.get_max_deck_size() == 20, "Level 5: 20 deck size")
