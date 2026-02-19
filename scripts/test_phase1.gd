extends SceneTree

## Phase 1 validation test.
## Run from editor: Project > Tools > Execute Script, or set as main scene via a wrapper.
## Alternatively run via command line: godot --script res://scripts/test_phase1.gd

func _init() -> void:
	print("=== Phase 1 Data Architecture Test ===\n")

	_test_grimoire_generation()
	_test_card_mastery_and_evolution()
	_test_alignment_manager()
	_test_grimoire_progression()
	_test_save_load()

	print("\n=== All tests completed ===")
	quit()


func _test_grimoire_generation() -> void:
	print("--- Test: Grimoire Generation ---")
	var generator := GrimoireGenerator.new()
	var grimoire := generator.generate(12345)

	print("  True Name: %s" % grimoire.true_name)
	print("  Cover: %s" % GlobalEnums.GrimoireCover.keys()[grimoire.cover_type])
	print("  Binding: %s" % GlobalEnums.GrimoireBinding.keys()[grimoire.binding_type])
	print("  Aura Color: %s" % str(grimoire.aura_color))
	print("  Lore: %s" % grimoire.lore_text)
	print("  Alignment (R/V/P): %d / %d / %d" % [
		grimoire.alignment_radiant, grimoire.alignment_vile, grimoire.alignment_primal
	])
	print("  Dominant: %s" % GlobalEnums.Alignment.keys()[grimoire.get_dominant_alignment()])
	print("  Sigil params: %s" % str(grimoire.sigil_params))

	# Determinism check: same seed should produce same name
	var grimoire2 := generator.generate(12345)
	assert(grimoire.true_name == grimoire2.true_name, "Seed determinism failed!")
	print("  Determinism check: PASSED")
	print("")


func _test_card_mastery_and_evolution() -> void:
	print("--- Test: Card Mastery & Evolution ---")

	# Create a base card manually for the test
	var card := CardResource.new()
	card.card_id = "spark_bolt"
	card.card_name = "Spark Bolt"
	card.base_value = 4
	card.mana_cost = 1
	card.mastery_xp = 0

	# Create evolved variants
	var evolved_radiant := CardResource.new()
	evolved_radiant.card_id = "spark_bolt_radiant"
	evolved_radiant.card_name = "Purifying Bolt"
	evolved_radiant.base_value = 3
	evolved_radiant.is_evolved = true
	evolved_radiant.mastery_tier = GlobalEnums.MasteryTier.EVOLVED

	card.evolution_radiant = evolved_radiant

	# Simulate XP gain
	var tracker := MasteryTracker.new()
	print("  Starting XP: %d, Tier: %s, Value: %d" % [
		card.mastery_xp,
		GlobalEnums.MasteryTier.keys()[card.mastery_tier],
		card.get_effective_value()
	])

	# Use card 25 times (25 XP -> Bronze)
	for i in range(25):
		tracker.on_card_used(card)
	print("  After 25 uses -> XP: %d, Tier: %s, Value: %d" % [
		card.mastery_xp,
		GlobalEnums.MasteryTier.keys()[card.mastery_tier],
		card.get_effective_value()
	])
	assert(card.mastery_tier == GlobalEnums.MasteryTier.BRONZE, "Should be Bronze at 25 XP")
	assert(card.get_effective_value() == 5, "Effective value should be 4+1=5")

	# Push to 50 (Silver)
	for i in range(25):
		tracker.on_card_used(card)
	assert(card.mastery_tier == GlobalEnums.MasteryTier.SILVER, "Should be Silver at 50 XP")
	assert(card.get_effective_value() == 6, "Effective value should be 4+2=6")
	print("  After 50 uses -> XP: %d, Tier: %s, Value: %d" % [
		card.mastery_xp,
		GlobalEnums.MasteryTier.keys()[card.mastery_tier],
		card.get_effective_value()
	])

	# Push to 100 via perfect plays (Gold at 75, then can_evolve at 100)
	for i in range(10):
		tracker.on_perfect_play(card)
	assert(card.mastery_xp == 100, "Should be at 100 XP")
	assert(card.can_evolve(), "Should be evolvable at 100 XP")
	print("  After 10 perfect plays -> XP: %d, Tier: %s, can_evolve: %s" % [
		card.mastery_xp,
		GlobalEnums.MasteryTier.keys()[card.mastery_tier],
		str(card.can_evolve())
	])

	# Evolve the card
	var grimoire := GrimoireResource.new()
	grimoire.alignment_radiant = 20
	var evo_mgr := EvolutionManager.new()
	var evolved := evo_mgr.evolve_card(card, GlobalEnums.Alignment.RADIANT, grimoire)

	assert(evolved != null, "Evolution should succeed")
	assert(evolved.card_name == "Purifying Bolt", "Should evolve to Purifying Bolt")
	assert(grimoire.alignment_radiant == 30, "Radiant alignment should shift +10")
	print("  Evolved to: %s (alignment shift: Radiant now %d)" % [
		evolved.card_name, grimoire.alignment_radiant
	])
	print("")


func _test_alignment_manager() -> void:
	print("--- Test: Alignment Manager ---")
	var grimoire := GrimoireResource.new()
	grimoire.alignment_radiant = 10
	grimoire.alignment_vile = 10
	grimoire.alignment_primal = 10

	var align_mgr := AlignmentManager.new()

	# Moral choice: spare an enemy (Radiant +3)
	align_mgr.apply_moral_choice(grimoire, GlobalEnums.Alignment.RADIANT, 3)
	print("  After moral choice (Radiant +3): R=%d V=%d P=%d" % [
		grimoire.alignment_radiant, grimoire.alignment_vile, grimoire.alignment_primal
	])
	assert(grimoire.alignment_radiant == 13)

	# Battle usage: used Vile cards
	align_mgr.apply_battle_usage(grimoire, GlobalEnums.Alignment.VILE)
	print("  After battle usage (Vile +1): R=%d V=%d P=%d" % [
		grimoire.alignment_radiant, grimoire.alignment_vile, grimoire.alignment_primal
	])
	assert(grimoire.alignment_vile == 11)

	# Test conflicted state (top two within 5)
	grimoire.alignment_radiant = 50
	grimoire.alignment_vile = 48
	grimoire.alignment_primal = 10
	print("  Conflicted check (R=50, V=48, P=10): %s" % str(grimoire.is_conflicted()))
	assert(grimoire.is_conflicted(), "Should be conflicted when top two within 5")

	grimoire.alignment_radiant = 50
	grimoire.alignment_vile = 30
	print("  Conflicted check (R=50, V=30, P=10): %s" % str(grimoire.is_conflicted()))
	assert(not grimoire.is_conflicted(), "Should NOT be conflicted when gap > 5")
	print("")


func _test_grimoire_progression() -> void:
	print("--- Test: Grimoire Progression ---")
	var grimoire := GrimoireResource.new()

	for lvl in [1, 3, 6, 11, 16, 20]:
		grimoire.grimoire_level = lvl
		print("  Level %d -> Deck: %d, Inscriptions: %d, Lost Pages: %d" % [
			lvl, grimoire.get_max_deck_size(),
			grimoire.get_inscription_slot_count(),
			grimoire.get_max_lost_pages()
		])

	grimoire.grimoire_level = 1
	assert(grimoire.get_max_deck_size() == 20)
	assert(grimoire.get_inscription_slot_count() == 0)
	assert(grimoire.get_max_lost_pages() == 0)

	grimoire.grimoire_level = 20
	assert(grimoire.get_max_deck_size() == 40)
	assert(grimoire.get_inscription_slot_count() == 4)
	assert(grimoire.get_max_lost_pages() == 4)
	print("")


func _test_save_load() -> void:
	print("--- Test: Save/Load ---")
	var generator := GrimoireGenerator.new()
	var grimoire := generator.generate(99999)
	grimoire.grimoire_level = 5
	grimoire.alignment_radiant = 42

	var save_path := "user://test_grimoire.tres"
	var err := ResourceSaver.save(grimoire, save_path)
	assert(err == OK, "Save should succeed")
	print("  Saved grimoire to: %s" % save_path)

	var loaded := ResourceLoader.load(save_path) as GrimoireResource
	assert(loaded != null, "Load should succeed")
	assert(loaded.true_name == grimoire.true_name, "True name should persist")
	assert(loaded.grimoire_level == 5, "Level should persist")
	assert(loaded.alignment_radiant == 42, "Alignment should persist")
	print("  Loaded: name=%s, level=%d, radiant=%d" % [
		loaded.true_name, loaded.grimoire_level, loaded.alignment_radiant
	])
	print("  Save/Load: PASSED")
	print("")
