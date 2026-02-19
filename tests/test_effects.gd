extends SceneTree

## Test suite for EffectResolver — damage, heal, block, statuses, conditions.

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== EFFECT RESOLVER TESTS ===\n")

	test_damage_effect()
	test_heal_effect()
	test_block_effect()
	test_poison_status()
	test_burn_status()
	test_weakness_modifier()
	test_strength_modifier()
	test_condition_alignment_match()
	test_condition_hp_below_half()
	test_enemy_attack_with_block()
	test_fallback_base_value()

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


func _make_player_state(hp: int = 50, max_hp: int = 50, block: int = 0) -> Dictionary:
	return {
		"hp": hp,
		"max_hp": max_hp,
		"block": block,
		"mana": 3,
		"statuses": [] as Array[StatusEffectResource],
		"cards_played_this_turn": 0,
	}


func _make_enemy_states(count: int = 1) -> Array[Dictionary]:
	var states: Array[Dictionary] = []
	for i: int in range(count):
		states.append({ "hp": 20, "max_hp": 20, "block": 0, "statuses": [] })
	return states


func _make_card_with_effect(effect_type: GlobalEnums.EffectType, value: int,
		condition: GlobalEnums.ConditionType = GlobalEnums.ConditionType.NONE) -> CardResource:
	var card: CardResource = CardResource.new()
	card.card_id = "test"
	card.card_name = "Test Card"
	card.card_type = GlobalEnums.CardType.ATTACK
	card.alignment = GlobalEnums.Alignment.RADIANT
	card.mana_cost = 1
	card.base_value = 0

	var effect: EffectResource = EffectResource.new()
	effect.effect_type = effect_type
	effect.value = value
	effect.condition = condition
	card.effects.append(effect)
	return card


func test_damage_effect() -> void:
	print("-- Damage Effect --")
	var resolver: EffectResolver = EffectResolver.new()
	var card: CardResource = _make_card_with_effect(GlobalEnums.EffectType.DAMAGE, 5)
	var results: Dictionary = resolver.resolve_card(card, _make_player_state(), _make_enemy_states(), 0, GlobalEnums.Alignment.PRIMAL)
	_assert(results["damage_dealt"] == 5, "Damage dealt = 5")
	_assert(results["target_indices"].size() == 1, "Single target")


func test_heal_effect() -> void:
	print("-- Heal Effect --")
	var resolver: EffectResolver = EffectResolver.new()
	var card: CardResource = _make_card_with_effect(GlobalEnums.EffectType.HEAL, 8)
	var results: Dictionary = resolver.resolve_card(card, _make_player_state(), _make_enemy_states(), 0, GlobalEnums.Alignment.PRIMAL)
	_assert(results["healing_done"] == 8, "Healing done = 8")


func test_block_effect() -> void:
	print("-- Block Effect --")
	var resolver: EffectResolver = EffectResolver.new()
	var card: CardResource = _make_card_with_effect(GlobalEnums.EffectType.BLOCK, 6)
	var results: Dictionary = resolver.resolve_card(card, _make_player_state(), _make_enemy_states(), 0, GlobalEnums.Alignment.PRIMAL)
	_assert(results["block_gained"] == 6, "Block gained = 6")


func test_poison_status() -> void:
	print("-- Poison Status --")
	var status: StatusEffectResource = StatusEffectResource.new()
	status.status_type = GlobalEnums.StatusType.POISON
	status.stacks = 3
	status.remaining_turns = 2

	var tick1: int = status.tick()
	_assert(tick1 == 3, "Poison tick deals 3 damage")
	_assert(status.remaining_turns == 1, "1 turn remaining")
	_assert(not status.is_expired(), "Not expired yet")

	var tick2: int = status.tick()
	_assert(tick2 == 3, "Poison tick still 3")
	_assert(status.is_expired(), "Expired after 2 ticks")


func test_burn_status() -> void:
	print("-- Burn Status --")
	var status: StatusEffectResource = StatusEffectResource.new()
	status.status_type = GlobalEnums.StatusType.BURN
	status.stacks = 3
	status.remaining_turns = 99

	var tick1: int = status.tick()
	_assert(tick1 == 3, "Burn tick deals 3")
	_assert(status.stacks == 2, "Stacks reduced to 2")
	_assert(not status.is_expired(), "Not expired")

	status.tick()  # 2 damage, stacks -> 1
	status.tick()  # 1 damage, stacks -> 0
	_assert(status.is_expired(), "Expired at 0 stacks")


func test_weakness_modifier() -> void:
	print("-- Weakness Modifier --")
	var status: StatusEffectResource = StatusEffectResource.new()
	status.status_type = GlobalEnums.StatusType.WEAKNESS
	status.stacks = 2
	_assert(status.get_stat_modifier() == -2, "Weakness gives -2")


func test_strength_modifier() -> void:
	print("-- Strength Modifier --")
	var status: StatusEffectResource = StatusEffectResource.new()
	status.status_type = GlobalEnums.StatusType.STRENGTH
	status.stacks = 3
	_assert(status.get_stat_modifier() == 3, "Strength gives +3")


func test_condition_alignment_match() -> void:
	print("-- Condition: Alignment Match --")
	var resolver: EffectResolver = EffectResolver.new()
	var card: CardResource = _make_card_with_effect(
		GlobalEnums.EffectType.DAMAGE, 10, GlobalEnums.ConditionType.IF_ALIGNMENT_MATCH
	)
	card.alignment = GlobalEnums.Alignment.RADIANT

	# Matching
	var results_match: Dictionary = resolver.resolve_card(card, _make_player_state(), _make_enemy_states(), 0, GlobalEnums.Alignment.RADIANT)
	_assert(results_match["damage_dealt"] == 10, "Condition met: 10 damage")

	# Not matching
	var results_no: Dictionary = resolver.resolve_card(card, _make_player_state(), _make_enemy_states(), 0, GlobalEnums.Alignment.VILE)
	_assert(results_no["damage_dealt"] == 0, "Condition not met: 0 damage")


func test_condition_hp_below_half() -> void:
	print("-- Condition: HP Below Half --")
	var resolver: EffectResolver = EffectResolver.new()
	var card: CardResource = _make_card_with_effect(
		GlobalEnums.EffectType.HEAL, 15, GlobalEnums.ConditionType.IF_HP_BELOW_HALF
	)

	var low_hp: Dictionary = _make_player_state(20, 50)
	var results_low: Dictionary = resolver.resolve_card(card, low_hp, _make_enemy_states(), 0, GlobalEnums.Alignment.PRIMAL)
	_assert(results_low["healing_done"] == 15, "HP below half: heals 15")

	var high_hp: Dictionary = _make_player_state(40, 50)
	var results_high: Dictionary = resolver.resolve_card(card, high_hp, _make_enemy_states(), 0, GlobalEnums.Alignment.PRIMAL)
	_assert(results_high["healing_done"] == 0, "HP above half: no heal")


func test_enemy_attack_with_block() -> void:
	print("-- Enemy Attack With Block --")
	var resolver: EffectResolver = EffectResolver.new()
	var enemy: EnemyResource = EnemyResource.new()
	enemy.attack_damage = 8

	var player: Dictionary = _make_player_state(50, 50, 5)
	var result: Dictionary = resolver.resolve_enemy_attack(enemy, 8, player)
	_assert(result["damage_dealt"] == 3, "8 attack - 5 block = 3 damage")
	_assert(result["block_consumed"] == 5, "5 block consumed")


func test_fallback_base_value() -> void:
	print("-- Fallback Base Value (No Effects) --")
	var resolver: EffectResolver = EffectResolver.new()
	var card: CardResource = CardResource.new()
	card.card_type = GlobalEnums.CardType.ATTACK
	card.base_value = 4
	card.effects = []

	var results: Dictionary = resolver.resolve_card(card, _make_player_state(), _make_enemy_states(), 0, GlobalEnums.Alignment.PRIMAL)
	_assert(results["damage_dealt"] == 4, "Fallback: 4 damage from base_value")
