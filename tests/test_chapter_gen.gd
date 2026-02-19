extends SceneTree

## Test suite for Phase 3 — ChapterResource, EncounterManager, MoralChoiceResource, ChapterGenerator.

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== PHASE 3: PVE CAMPAIGN TESTS ===\n")

	test_chapter_resource_loading()
	test_chapter_structure()
	test_encounter_manager_start()
	test_encounter_manager_advance()
	test_encounter_manager_complete_chapter()
	test_encounter_manager_fail_chapter()
	test_moral_choice_application()
	test_rest_healing()
	test_extraction_risk()
	test_lost_page_binding()
	test_chapter_generator()
	test_alignment_clash()

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
	var g: GrimoireResource = GrimoireResource.new()
	g.seed = 42
	g.true_name = "TestGrimoire"
	g.grimoire_level = 1
	g.alignment_radiant = 10
	g.alignment_vile = 10
	g.alignment_primal = 10
	for i: int in range(8):
		var card: CardResource = CardResource.new()
		card.card_id = "test_%d" % i
		card.card_name = "Test Card %d" % i
		card.card_type = GlobalEnums.CardType.ATTACK
		card.alignment = GlobalEnums.Alignment.PRIMAL
		card.mana_cost = 1
		card.base_value = 4
		g.cards.append(card)
	return g


func _make_test_chapter() -> ChapterResource:
	var chapter: ChapterResource = ChapterResource.new()
	chapter.chapter_id = "test_chapter"
	chapter.chapter_name = "Test Chapter"
	chapter.chapter_number = 1
	chapter.difficulty_level = 1
	chapter.chapter_alignment = GlobalEnums.Alignment.RADIANT
	chapter.completion_xp_bonus = 25

	# Combat encounter
	var enc1: EncounterResource = EncounterResource.new()
	enc1.encounter_id = "test_combat"
	enc1.encounter_name = "Test Combat"
	enc1.node_type = GlobalEnums.NodeType.COMBAT
	enc1.grimoire_xp_reward = 5
	var enemy: EnemyResource = EnemyResource.new()
	enemy.enemy_id = "test_enemy"
	enemy.enemy_name = "Test Enemy"
	enemy.max_hp = 10
	enemy.attack_damage = 3
	enc1.enemies = [enemy]

	# Moral choice encounter
	var enc2: EncounterResource = EncounterResource.new()
	enc2.encounter_id = "test_moral"
	enc2.encounter_name = "Test Choice"
	enc2.node_type = GlobalEnums.NodeType.MORAL_CHOICE
	enc2.grimoire_xp_reward = 5
	var choice: MoralChoiceResource = MoralChoiceResource.new()
	choice.choice_id = "test_choice"
	choice.title = "Test Dilemma"
	choice.narrative_text = "What do you do?"
	choice.option_a_text = "Help"
	choice.option_a_alignment = GlobalEnums.Alignment.RADIANT
	choice.option_a_shift = 3
	choice.option_a_result_text = "You helped."
	choice.option_b_text = "Harm"
	choice.option_b_alignment = GlobalEnums.Alignment.VILE
	choice.option_b_shift = 3
	choice.option_b_result_text = "You harmed."
	choice.option_c_text = "Balance"
	choice.option_c_alignment = GlobalEnums.Alignment.PRIMAL
	choice.option_c_shift = 3
	choice.option_c_result_text = "You balanced."
	enc2.moral_choice = choice

	# Treasure encounter
	var enc3: EncounterResource = EncounterResource.new()
	enc3.encounter_id = "test_treasure"
	enc3.encounter_name = "Test Treasure"
	enc3.node_type = GlobalEnums.NodeType.TREASURE
	enc3.treasure_choices = 3
	enc3.grimoire_xp_reward = 3

	# Rest encounter
	var enc4: EncounterResource = EncounterResource.new()
	enc4.encounter_id = "test_rest"
	enc4.encounter_name = "Test Rest"
	enc4.node_type = GlobalEnums.NodeType.REST
	enc4.rest_heal_percent = 0.3
	enc4.grimoire_xp_reward = 2

	# Boss encounter
	var enc5: EncounterResource = EncounterResource.new()
	enc5.encounter_id = "test_boss"
	enc5.encounter_name = "Test Boss"
	enc5.node_type = GlobalEnums.NodeType.BOSS
	enc5.grimoire_xp_reward = 15
	var boss: EnemyResource = EnemyResource.new()
	boss.enemy_id = "test_boss_enemy"
	boss.enemy_name = "Test Boss"
	boss.max_hp = 30
	boss.attack_damage = 6
	enc5.enemies = [boss]

	chapter.encounters = [enc1, enc2, enc3, enc4, enc5]
	return chapter


func test_chapter_resource_loading() -> void:
	print("-- Chapter Resource Loading --")
	var chapter: ChapterResource = ResourceLoader.load("res://resources/chapters/ch1_forgotten_library.tres") as ChapterResource
	_assert(chapter != null, "Chapter 1 loads successfully")
	if chapter != null:
		_assert(chapter.chapter_name == "The Forgotten Library", "Chapter name correct")
		_assert(chapter.encounters.size() == 6, "Chapter 1 has 6 encounters")
		_assert(chapter.chapter_alignment == GlobalEnums.Alignment.RADIANT, "Chapter alignment is RADIANT")


func test_chapter_structure() -> void:
	print("-- Chapter Structure --")
	var chapter: ChapterResource = _make_test_chapter()
	_assert(chapter.get_node_count() == 5, "Test chapter has 5 nodes")
	_assert(chapter.get_combat_count() == 2, "Test chapter has 2 combat nodes (combat + boss)")


func test_encounter_manager_start() -> void:
	print("-- Encounter Manager Start --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)
	_assert(em.is_active, "Chapter is active")
	_assert(em.current_encounter_index == -1, "Start index is -1")
	_assert(em.player_hp == 50, "Player HP initialized")
	_assert(em.pending_lost_pages.is_empty(), "No pending lost pages")


func test_encounter_manager_advance() -> void:
	print("-- Encounter Manager Advance --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)

	var enc1: EncounterResource = em.advance_to_next()
	_assert(enc1 != null, "First encounter returned")
	_assert(enc1.node_type == GlobalEnums.NodeType.COMBAT, "First encounter is COMBAT")
	_assert(em.current_encounter_index == 0, "Index is 0")

	var enc2: EncounterResource = em.advance_to_next()
	_assert(enc2 != null, "Second encounter returned")
	_assert(enc2.node_type == GlobalEnums.NodeType.MORAL_CHOICE, "Second encounter is MORAL_CHOICE")


func test_encounter_manager_complete_chapter() -> void:
	print("-- Encounter Manager Complete Chapter --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	var xp_before: int = grimoire.grimoire_xp

	em.start_chapter(chapter, grimoire, 50)

	# Advance through all encounters
	for i: int in range(chapter.encounters.size()):
		em.advance_to_next()
		em.complete_current_encounter()

	# One more advance triggers chapter completion
	em.advance_to_next()

	_assert(not em.is_active, "Chapter is no longer active")
	_assert(grimoire.grimoire_xp > xp_before, "Grimoire XP increased")
	print("  INFO: Total XP gained: %d" % (grimoire.grimoire_xp - xp_before))


func test_encounter_manager_fail_chapter() -> void:
	print("-- Encounter Manager Fail Chapter --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)

	# Add a pending lost page
	var page: CardResource = CardResource.new()
	page.card_name = "Test Lost Page"
	em.add_pending_lost_page(page)
	_assert(em.pending_lost_pages.size() == 1, "1 pending lost page")

	em.fail_chapter()
	_assert(not em.is_active, "Chapter is no longer active")
	_assert(em.pending_lost_pages.is_empty(), "Pending lost pages cleared on failure")


func test_moral_choice_application() -> void:
	print("-- Moral Choice Application --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)

	var choice: MoralChoiceResource = chapter.encounters[1].moral_choice
	var radiant_before: int = grimoire.alignment_radiant

	# Choose option A (Radiant +3)
	var result: Dictionary = em.apply_moral_choice(choice, 0)
	_assert(not result.is_empty(), "Result returned")
	_assert(result["alignment"] == GlobalEnums.Alignment.RADIANT, "Alignment is RADIANT")
	_assert(result["shift"] == 3, "Shift is 3")
	_assert(grimoire.alignment_radiant == radiant_before + 3, "Radiant alignment increased by 3")

	# Choose option B (Vile +3)
	var vile_before: int = grimoire.alignment_vile
	var result_b: Dictionary = em.apply_moral_choice(choice, 1)
	_assert(result_b["alignment"] == GlobalEnums.Alignment.VILE, "Option B is VILE")
	_assert(grimoire.alignment_vile == vile_before + 3, "Vile alignment increased by 3")


func test_rest_healing() -> void:
	print("-- Rest Healing --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)
	em.player_hp = 30  # Simulate damage taken

	var rest_enc: EncounterResource = chapter.encounters[3]  # REST node
	var healed: int = em.apply_rest(rest_enc)
	_assert(healed == 15, "Healed 15 HP (30%% of 50)")
	_assert(em.player_hp == 45, "Player HP is now 45")


func test_extraction_risk() -> void:
	print("-- Extraction Risk --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)

	# Add 2 pending pages
	var page1: CardResource = CardResource.new()
	page1.card_name = "Page 1"
	var page2: CardResource = CardResource.new()
	page2.card_name = "Page 2"
	em.add_pending_lost_page(page1)
	em.add_pending_lost_page(page2)

	var pages_before_fail: int = em.pending_lost_pages.size()
	_assert(pages_before_fail == 2, "2 pending pages before fail")

	em.fail_chapter()
	_assert(em.pending_lost_pages.size() == 0, "All pending pages lost on extraction failure")


func test_lost_page_binding() -> void:
	print("-- Lost Page Binding --")
	var em: EncounterManager = EncounterManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	grimoire.grimoire_level = 6  # Allows 1 lost page (6/5 = 1)
	var chapter: ChapterResource = _make_test_chapter()
	em.start_chapter(chapter, grimoire, 50)

	# Add pending page
	var page: CardResource = CardResource.new()
	page.card_name = "Bound Page"
	em.add_pending_lost_page(page)

	# Complete all encounters
	for i: int in range(chapter.encounters.size()):
		em.advance_to_next()
		em.complete_current_encounter()
	em.advance_to_next()  # Triggers completion

	_assert(grimoire.lost_pages.size() == 1, "Lost page bound to grimoire")
	_assert(grimoire.lost_pages[0].card_name == "Bound Page", "Correct page bound")


func test_chapter_generator() -> void:
	print("-- Chapter Generator --")
	var gen: ChapterGenerator = ChapterGenerator.new()

	var ch1: ChapterResource = gen.load_chapter("ch1_forgotten_library")
	_assert(ch1 != null, "Chapter 1 loaded by ID")
	if ch1 != null:
		_assert(ch1.chapter_name == "The Forgotten Library", "Name matches")

	var all_chapters: Array[ChapterResource] = gen.load_all_chapters()
	_assert(all_chapters.size() >= 3, "At least 3 chapters loaded")
	if all_chapters.size() >= 3:
		_assert(all_chapters[0].chapter_number <= all_chapters[1].chapter_number, "Chapters sorted by number")

	# Test can_enter_chapter
	var grimoire: GrimoireResource = _make_grimoire()
	grimoire.grimoire_level = 1
	_assert(gen.can_enter_chapter(ch1, grimoire), "Level 1 grimoire can enter chapter 1")
	var ch3: ChapterResource = gen.load_chapter("ch3_overgrown_scriptorium")
	if ch3 != null:
		grimoire.grimoire_level = 1
		_assert(not gen.can_enter_chapter(ch3, grimoire), "Level 1 cannot enter difficulty 3 chapter")
		grimoire.grimoire_level = 5
		_assert(gen.can_enter_chapter(ch3, grimoire), "Level 5 can enter difficulty 3 chapter")


func test_alignment_clash() -> void:
	print("-- Alignment Clash --")
	var gen: ChapterGenerator = ChapterGenerator.new()
	var ch1: ChapterResource = gen.load_chapter("ch1_forgotten_library")
	if ch1 == null:
		_assert(false, "Chapter 1 needed for clash test")
		return

	var grimoire: GrimoireResource = _make_grimoire()
	# Ch1 is RADIANT. Set grimoire to VILE dominant.
	grimoire.alignment_vile = 50
	grimoire.alignment_radiant = 10
	grimoire.alignment_primal = 10
	_assert(gen.has_alignment_clash(ch1, grimoire), "Vile grimoire clashes with Radiant chapter")

	# Set grimoire to RADIANT dominant.
	grimoire.alignment_radiant = 50
	grimoire.alignment_vile = 10
	_assert(not gen.has_alignment_clash(ch1, grimoire), "Radiant grimoire does not clash with Radiant chapter")
