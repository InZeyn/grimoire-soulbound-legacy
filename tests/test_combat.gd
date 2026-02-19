extends SceneTree

## Test suite for CombatManager — full battle loop, turn flow, victory/defeat.

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== COMBAT MANAGER TESTS ===\n")

	test_start_battle()
	test_player_turn_draw()
	test_play_card_spends_mana()
	test_attunement_discount()
	test_cannot_play_without_mana()
	test_end_turn_discards_hand()
	test_enemy_turn_deals_damage()
	test_victory_on_enemy_death()
	test_defeat_on_player_death()
	test_battle_rewards()
	test_full_battle_loop()

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


func _make_grimoire(card_count: int = 10) -> GrimoireResource:
	var g: GrimoireResource = GrimoireResource.new()
	g.seed = 12345
	g.true_name = "TestGrimoire"
	g.alignment_radiant = 10
	g.alignment_vile = 10
	g.alignment_primal = 30
	for i: int in range(card_count):
		var card: CardResource = CardResource.new()
		card.card_id = "test_%d" % i
		card.card_name = "Test Card %d" % i
		card.card_type = GlobalEnums.CardType.ATTACK
		card.alignment = GlobalEnums.Alignment.PRIMAL
		card.mana_cost = 1
		card.base_value = 3
		g.cards.append(card)
	return g


func _make_weak_enemy() -> EnemyResource:
	var e: EnemyResource = EnemyResource.new()
	e.enemy_id = "weak"
	e.enemy_name = "Weak Enemy"
	e.max_hp = 5
	e.attack_damage = 2
	e.block_value = 0
	e.buff_value = 0
	e.intent_weights = [100, 0, 0, 0, 0]  # Always attacks
	return e


func _make_strong_enemy() -> EnemyResource:
	var e: EnemyResource = EnemyResource.new()
	e.enemy_id = "strong"
	e.enemy_name = "Strong Enemy"
	e.max_hp = 100
	e.attack_damage = 60
	e.block_value = 0
	e.buff_value = 0
	e.intent_weights = [100, 0, 0, 0, 0]
	return e


func test_start_battle() -> void:
	print("-- Start Battle --")
	var cm: CombatManager = CombatManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	var enemies: Array[EnemyResource] = [_make_weak_enemy()]
	cm.start_battle(grimoire, enemies, 42)

	_assert(cm.state == GlobalEnums.BattleState.PLAYER_TURN, "State is PLAYER_TURN")
	_assert(cm.player_hp == 50, "Player HP = 50")
	_assert(cm.player_mana == 3, "Player mana = 3")
	_assert(cm.enemy_hp[0] == 5, "Enemy HP = 5")
	_assert(cm.turn_number == 0, "Turn number = 0 (not yet begun)")


func test_player_turn_draw() -> void:
	print("-- Player Turn Draw --")
	var cm: CombatManager = CombatManager.new()
	cm.start_battle(_make_grimoire(), [_make_weak_enemy()] as Array[EnemyResource], 42)
	var drawn: Array[CardResource] = cm.begin_player_turn()

	_assert(drawn.size() == 5, "Drew 5 cards")
	_assert(cm.deck_manager.get_hand_size() == 5, "Hand has 5 cards")
	_assert(cm.turn_number == 1, "Turn number = 1")
	_assert(cm.player_mana == 3, "Mana reset to 3")


func test_play_card_spends_mana() -> void:
	print("-- Play Card Spends Mana --")
	var cm: CombatManager = CombatManager.new()
	cm.start_battle(_make_grimoire(), [_make_weak_enemy()] as Array[EnemyResource], 42)
	cm.begin_player_turn()
	# Attune to non-matching alignment so cards cost full mana
	cm.set_attunement(GlobalEnums.Alignment.RADIANT)

	var card: CardResource = cm.deck_manager.hand[0]
	_assert(cm.can_play_card(card), "Can play card with mana")

	var results: Dictionary = cm.play_card(card, 0)
	_assert(not results.is_empty(), "Results returned")
	_assert(cm.player_mana == 2, "Mana decreased by 1")
	_assert(cm.deck_manager.get_hand_size() == 4, "Hand reduced to 4")


func test_attunement_discount() -> void:
	print("-- Attunement Discount --")
	var cm: CombatManager = CombatManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	# Cards are PRIMAL alignment
	cm.start_battle(grimoire, [_make_weak_enemy()] as Array[EnemyResource], 42)
	cm.begin_player_turn()

	# Attune to PRIMAL (matching card alignment)
	cm.set_attunement(GlobalEnums.Alignment.PRIMAL)
	var card: CardResource = cm.deck_manager.hand[0]
	_assert(cm.get_card_mana_cost(card) == 0, "PRIMAL attunement: 1-cost card becomes 0")

	# Attune to RADIANT (not matching)
	cm.set_attunement(GlobalEnums.Alignment.RADIANT)
	_assert(cm.get_card_mana_cost(card) == 1, "RADIANT attunement: card stays at 1")


func test_cannot_play_without_mana() -> void:
	print("-- Cannot Play Without Mana --")
	var cm: CombatManager = CombatManager.new()
	var grimoire: GrimoireResource = _make_grimoire()
	# Use 2-cost cards so 3 mana runs out after 1 play with 1 left over
	for card: CardResource in grimoire.cards:
		card.mana_cost = 2
	cm.start_battle(grimoire, [_make_weak_enemy()] as Array[EnemyResource], 42)
	cm.begin_player_turn()
	# Attune to RADIANT so PRIMAL cards don't get discount
	cm.set_attunement(GlobalEnums.Alignment.RADIANT)
	cm.play_card(cm.deck_manager.hand[0], 0)  # 3 - 2 = 1 mana left
	_assert(cm.player_mana == 1, "1 mana remaining after 2-cost card")

	if cm.deck_manager.get_hand_size() > 0:
		var remaining_card: CardResource = cm.deck_manager.hand[0]
		_assert(not cm.can_play_card(remaining_card), "Cannot play 2-cost card with 1 mana")


func test_end_turn_discards_hand() -> void:
	print("-- End Turn Discards Hand --")
	var cm: CombatManager = CombatManager.new()
	cm.start_battle(_make_grimoire(), [_make_weak_enemy()] as Array[EnemyResource], 42)
	cm.begin_player_turn()
	_assert(cm.deck_manager.get_hand_size() == 5, "Hand has 5 before end turn")

	cm.end_player_turn()
	_assert(cm.deck_manager.get_hand_size() == 0, "Hand empty after end turn")
	_assert(cm.state == GlobalEnums.BattleState.ENEMY_TURN, "State is ENEMY_TURN")


func test_enemy_turn_deals_damage() -> void:
	print("-- Enemy Turn Deals Damage --")
	var cm: CombatManager = CombatManager.new()
	cm.start_battle(_make_grimoire(), [_make_weak_enemy()] as Array[EnemyResource], 42)
	cm.begin_player_turn()
	var hp_before: int = cm.player_hp
	cm.end_player_turn()
	var results: Array[Dictionary] = cm.execute_enemy_turn()

	_assert(results.size() > 0, "Enemy acted")
	_assert(cm.player_hp < hp_before, "Player took damage")


func test_victory_on_enemy_death() -> void:
	print("-- Victory On Enemy Death --")
	var cm: CombatManager = CombatManager.new()
	var enemy: EnemyResource = _make_weak_enemy()
	enemy.max_hp = 3  # Very weak
	cm.start_battle(_make_grimoire(), [enemy] as Array[EnemyResource], 42)
	cm.begin_player_turn()

	# Attune to PRIMAL for free cards (cost 0)
	cm.set_attunement(GlobalEnums.Alignment.PRIMAL)
	# Play cards until enemy dies (3 HP, each card does 3 damage)
	cm.play_card(cm.deck_manager.hand[0], 0)

	_assert(cm.enemy_hp[0] <= 0, "Enemy HP <= 0")
	_assert(cm.state == GlobalEnums.BattleState.VICTORY, "State is VICTORY")


func test_defeat_on_player_death() -> void:
	print("-- Defeat On Player Death --")
	var cm: CombatManager = CombatManager.new()
	cm.start_battle(_make_grimoire(), [_make_strong_enemy()] as Array[EnemyResource], 42)
	cm.begin_player_turn()
	cm.end_player_turn()
	cm.execute_enemy_turn()

	_assert(cm.player_hp <= 0, "Player HP <= 0")
	_assert(cm.state == GlobalEnums.BattleState.DEFEAT, "State is DEFEAT")


func test_battle_rewards() -> void:
	print("-- Battle Rewards --")
	var cm: CombatManager = CombatManager.new()
	var enemy: EnemyResource = _make_weak_enemy()
	enemy.max_hp = 3
	var grimoire: GrimoireResource = _make_grimoire()
	var xp_before: int = grimoire.grimoire_xp
	var primal_before: int = grimoire.alignment_primal

	cm.start_battle(grimoire, [enemy] as Array[EnemyResource], 42)
	cm.begin_player_turn()
	cm.set_attunement(GlobalEnums.Alignment.PRIMAL)
	cm.play_card(cm.deck_manager.hand[0], 0)

	_assert(cm.state == GlobalEnums.BattleState.VICTORY, "Won the battle")

	var rewards: Dictionary = cm.get_battle_rewards()
	_assert(rewards["grimoire_xp"] > 0, "Grimoire XP reward > 0")

	cm.apply_battle_rewards(rewards)
	_assert(grimoire.grimoire_xp > xp_before, "Grimoire XP increased")
	_assert(grimoire.alignment_primal > primal_before, "Primal alignment drifted")


func test_full_battle_loop() -> void:
	print("-- Full Battle Loop (Multi-Turn) --")
	var cm: CombatManager = CombatManager.new()
	var enemy: EnemyResource = _make_weak_enemy()
	enemy.max_hp = 15
	cm.start_battle(_make_grimoire(20), [enemy] as Array[EnemyResource], 42)

	var max_turns: int = 20
	var turns_played: int = 0
	while cm.state != GlobalEnums.BattleState.VICTORY and cm.state != GlobalEnums.BattleState.DEFEAT:
		if turns_played >= max_turns:
			break
		cm.begin_player_turn()
		if cm.state == GlobalEnums.BattleState.DEFEAT:
			break
		# Play all affordable cards
		cm.set_attunement(GlobalEnums.Alignment.PRIMAL)
		while cm.deck_manager.get_hand_size() > 0 and cm.player_mana > 0:
			var card: CardResource = cm.deck_manager.hand[0]
			if cm.can_play_card(card):
				cm.play_card(card, 0)
			else:
				break
			if cm.state == GlobalEnums.BattleState.VICTORY:
				break
		if cm.state == GlobalEnums.BattleState.VICTORY:
			break
		cm.end_player_turn()
		if cm.state == GlobalEnums.BattleState.ENEMY_TURN:
			cm.execute_enemy_turn()
		turns_played += 1

	_assert(cm.state == GlobalEnums.BattleState.VICTORY or cm.state == GlobalEnums.BattleState.DEFEAT,
		"Battle ended (state: %d, turns: %d)" % [cm.state, turns_played])
	_assert(turns_played < max_turns, "Battle completed within %d turns" % max_turns)
	print("  INFO: Battle ended in %d turns, state=%d, player_hp=%d, enemy_hp=%d" % [
		turns_played, cm.state, cm.player_hp, cm.enemy_hp[0]])
