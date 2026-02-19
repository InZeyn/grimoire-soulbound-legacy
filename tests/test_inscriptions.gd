extends SceneTree

## Test suite for Phase 4 — InscriptionManager, inscription equip/unequip, effects.

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== PHASE 4: INSCRIPTION TESTS ===\n")

	test_inscription_resource_loading()
	test_equip_inscription()
	test_unequip_inscription()
	test_duplicate_prevention()
	test_slot_limit()
	test_effect_value_lookup()
	test_alignment_filtering()

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


func _make_grimoire(level: int, dominant: GlobalEnums.Alignment) -> GrimoireResource:
	var g := GrimoireResource.new()
	g.seed = 42
	g.true_name = "TestGrimoire"
	g.grimoire_level = level
	match dominant:
		GlobalEnums.Alignment.RADIANT:
			g.alignment_radiant = 50
			g.alignment_vile = 10
			g.alignment_primal = 10
		GlobalEnums.Alignment.VILE:
			g.alignment_radiant = 10
			g.alignment_vile = 50
			g.alignment_primal = 10
		GlobalEnums.Alignment.PRIMAL:
			g.alignment_radiant = 10
			g.alignment_vile = 10
			g.alignment_primal = 50
	return g


func _make_inscription(id: String, name: String, alignment: GlobalEnums.Alignment, key: String, value: int) -> InscriptionResource:
	var insc := InscriptionResource.new()
	insc.inscription_id = id
	insc.inscription_name = name
	insc.alignment = alignment
	insc.effect_key = key
	insc.effect_value = value
	return insc


func test_inscription_resource_loading() -> void:
	print("-- Inscription Resource Loading --")
	var insc: InscriptionResource = ResourceLoader.load("res://resources/inscriptions/radiant_ink.tres") as InscriptionResource
	_assert(insc != null, "Radiant Ink loads")
	if insc != null:
		_assert(insc.inscription_id == "radiant_ink", "ID is correct")
		_assert(insc.effect_key == "heal_bonus", "Effect key is heal_bonus")
		_assert(insc.effect_value == 1, "Effect value is 1")
		_assert(insc.alignment == GlobalEnums.Alignment.RADIANT, "Alignment is RADIANT")


func test_equip_inscription() -> void:
	print("-- Equip Inscription --")
	var im := InscriptionManager.new()
	var g: GrimoireResource = _make_grimoire(5, GlobalEnums.Alignment.RADIANT)  # 2 slots
	var insc: InscriptionResource = _make_inscription("test_1", "Test", GlobalEnums.Alignment.RADIANT, "heal_bonus", 1)

	_assert(im.can_equip(g), "Can equip at level 5 (2 slots, 0 equipped)")
	var success: bool = im.equip_inscription(g, insc)
	_assert(success, "Equip returns true")
	_assert(g.inscriptions.size() == 1, "1 inscription equipped")


func test_unequip_inscription() -> void:
	print("-- Unequip Inscription --")
	var im := InscriptionManager.new()
	var g: GrimoireResource = _make_grimoire(5, GlobalEnums.Alignment.RADIANT)
	var insc: InscriptionResource = _make_inscription("test_1", "Test", GlobalEnums.Alignment.RADIANT, "heal_bonus", 1)
	im.equip_inscription(g, insc)

	var removed: bool = im.unequip_inscription(g, "test_1")
	_assert(removed, "Unequip returns true")
	_assert(g.inscriptions.size() == 0, "0 inscriptions after unequip")

	var removed_again: bool = im.unequip_inscription(g, "test_1")
	_assert(not removed_again, "Unequip nonexistent returns false")


func test_duplicate_prevention() -> void:
	print("-- Duplicate Prevention --")
	var im := InscriptionManager.new()
	var g: GrimoireResource = _make_grimoire(5, GlobalEnums.Alignment.RADIANT)
	var insc: InscriptionResource = _make_inscription("test_1", "Test", GlobalEnums.Alignment.RADIANT, "heal_bonus", 1)

	im.equip_inscription(g, insc)
	var dupe: bool = im.equip_inscription(g, insc)
	_assert(not dupe, "Cannot equip duplicate inscription")
	_assert(g.inscriptions.size() == 1, "Still only 1 inscription")


func test_slot_limit() -> void:
	print("-- Slot Limit --")
	var im := InscriptionManager.new()
	var g: GrimoireResource = _make_grimoire(3, GlobalEnums.Alignment.RADIANT)  # 1 slot
	_assert(g.get_inscription_slot_count() == 1, "Level 3 has 1 slot")

	var insc_a: InscriptionResource = _make_inscription("a", "A", GlobalEnums.Alignment.RADIANT, "heal_bonus", 1)
	var insc_b: InscriptionResource = _make_inscription("b", "B", GlobalEnums.Alignment.RADIANT, "block_bonus", 1)

	im.equip_inscription(g, insc_a)
	_assert(not im.can_equip(g), "Cannot equip when full")
	var overflow: bool = im.equip_inscription(g, insc_b)
	_assert(not overflow, "Equip fails when slots full")
	_assert(g.inscriptions.size() == 1, "Still only 1 inscription")

	# Level 2 has 0 slots
	var g2: GrimoireResource = _make_grimoire(2, GlobalEnums.Alignment.RADIANT)
	_assert(g2.get_inscription_slot_count() == 0, "Level 2 has 0 slots")
	_assert(not im.can_equip(g2), "Cannot equip at level 2")


func test_effect_value_lookup() -> void:
	print("-- Effect Value Lookup --")
	var im := InscriptionManager.new()
	var g: GrimoireResource = _make_grimoire(10, GlobalEnums.Alignment.RADIANT)  # 2 slots
	var insc_a: InscriptionResource = _make_inscription("a", "A", GlobalEnums.Alignment.RADIANT, "heal_bonus", 1)
	var insc_b: InscriptionResource = _make_inscription("b", "B", GlobalEnums.Alignment.RADIANT, "heal_bonus", 2)

	im.equip_inscription(g, insc_a)
	im.equip_inscription(g, insc_b)

	_assert(im.get_effect_value(g, "heal_bonus") == 3, "Stacked heal_bonus = 3")
	_assert(im.get_effect_value(g, "block_bonus") == 0, "Unequipped effect = 0")


func test_alignment_filtering() -> void:
	print("-- Alignment Filtering --")
	var im := InscriptionManager.new()

	# Radiant dominant grimoire
	var g: GrimoireResource = _make_grimoire(5, GlobalEnums.Alignment.RADIANT)
	var available: Array[InscriptionResource] = im.get_available_inscriptions(g)
	for insc: InscriptionResource in available:
		_assert(insc.alignment == GlobalEnums.Alignment.RADIANT, "Available inscription '%s' is RADIANT" % insc.inscription_name)

	# Conflicted grimoire should see all alignments
	var g_conflicted: GrimoireResource = _make_grimoire(5, GlobalEnums.Alignment.RADIANT)
	g_conflicted.alignment_radiant = 50
	g_conflicted.alignment_vile = 48  # Within 5 of top
	_assert(g_conflicted.is_conflicted(), "Grimoire is conflicted")
	var available_conflicted: Array[InscriptionResource] = im.get_available_inscriptions(g_conflicted)
	_assert(available_conflicted.size() > available.size(), "Conflicted grimoire has more options (%d > %d)" % [available_conflicted.size(), available.size()])
