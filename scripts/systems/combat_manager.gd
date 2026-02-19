class_name CombatManager
extends RefCounted

signal battle_state_changed(new_state: GlobalEnums.BattleState)
signal turn_started(turn_number: int)
signal card_played(card: CardResource, results: Dictionary)
signal enemy_acted(enemy_index: int, intent: GlobalEnums.EnemyIntent, results: Dictionary)
signal enemy_defeated(enemy_index: int)
signal battle_ended(state: GlobalEnums.BattleState)

# --- Constants ---
const BASE_MANA: int = 3
const BASE_HP: int = 50

# --- Dependencies ---
var deck_manager: DeckManager = DeckManager.new()
var effect_resolver: EffectResolver = EffectResolver.new()
var enemy_ai: EnemyAI = EnemyAI.new()
var mastery_tracker: MasteryTracker = MasteryTracker.new()
var alignment_manager: AlignmentManager = AlignmentManager.new()

# --- Battle State ---
var state: GlobalEnums.BattleState = GlobalEnums.BattleState.NOT_STARTED
var turn_number: int = 0

# --- Player State ---
var player_hp: int = BASE_HP
var player_max_hp: int = BASE_HP
var player_mana: int = BASE_MANA
var player_max_mana: int = BASE_MANA
var player_block: int = 0
var player_statuses: Array[StatusEffectResource] = []
var cards_played_this_turn: int = 0
var attuned_alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL

# --- Enemy State ---
var enemies: Array[EnemyResource] = []
var enemy_hp: Array[int] = []
var enemy_intents: Array[GlobalEnums.EnemyIntent] = []
var enemy_block: Array[int] = []
var enemy_statuses: Array = []  # Array of Array[StatusEffectResource]

# --- Grimoire Reference ---
var grimoire: GrimoireResource = null

# --- Battle Log (cards used per alignment for post-battle rewards) ---
var _alignment_usage: Dictionary = {}  # Alignment -> int count


func start_battle(p_grimoire: GrimoireResource, p_enemies: Array[EnemyResource], rng_seed: int = 0) -> void:
	grimoire = p_grimoire
	enemies = p_enemies

	# Player setup
	player_hp = BASE_HP
	player_max_hp = BASE_HP
	player_mana = BASE_MANA
	player_max_mana = BASE_MANA
	player_block = 0
	player_statuses.clear()
	cards_played_this_turn = 0
	attuned_alignment = grimoire.get_dominant_alignment()
	_alignment_usage.clear()

	# Enemy setup
	enemy_hp.clear()
	enemy_intents.clear()
	enemy_block.clear()
	enemy_statuses.clear()
	for enemy: EnemyResource in enemies:
		enemy_hp.append(enemy.max_hp)
		enemy_intents.append(GlobalEnums.EnemyIntent.ATTACK)
		enemy_block.append(0)
		enemy_statuses.append([] as Array[StatusEffectResource])

	# Deck setup
	deck_manager.initialize(grimoire.cards, rng_seed)
	enemy_ai.initialize(rng_seed)

	turn_number = 0
	_change_state(GlobalEnums.BattleState.PLAYER_TURN)


func begin_player_turn() -> Array[CardResource]:
	turn_number += 1
	player_mana = player_max_mana
	player_block = 0
	cards_played_this_turn = 0

	# Tick player statuses
	var tick_result: Dictionary = effect_resolver.tick_statuses(player_statuses)
	if tick_result["tick_damage"] > 0:
		player_hp -= tick_result["tick_damage"]
		if player_hp <= 0:
			player_hp = 0
			_change_state(GlobalEnums.BattleState.DEFEAT)
			return []

	# Roll enemy intents for this turn
	for i: int in range(enemies.size()):
		if enemy_hp[i] > 0:
			enemy_intents[i] = enemy_ai.select_intent(enemies[i], enemy_hp[i], turn_number)

	# Draw cards
	var drawn: Array[CardResource] = deck_manager.draw_cards()
	turn_started.emit(turn_number)
	return drawn


func set_attunement(alignment: GlobalEnums.Alignment) -> void:
	attuned_alignment = alignment


func get_card_mana_cost(card: CardResource) -> int:
	var cost: int = card.mana_cost
	if card.alignment == attuned_alignment:
		cost = maxi(cost - 1, 0)
	return cost


func can_play_card(card: CardResource) -> bool:
	if state != GlobalEnums.BattleState.PLAYER_TURN:
		return false
	if deck_manager.hand.find(card) == -1:
		return false
	return player_mana >= get_card_mana_cost(card)


func play_card(card: CardResource, target_index: int = 0) -> Dictionary:
	if not can_play_card(card):
		return {}

	# Spend mana
	player_mana -= get_card_mana_cost(card)
	cards_played_this_turn += 1

	# Build player state dict for resolver
	var player_state: Dictionary = _get_player_state_dict()

	# Build enemy state dicts
	var enemy_state_dicts: Array[Dictionary] = []
	for i: int in range(enemies.size()):
		enemy_state_dicts.append(_get_enemy_state_dict(i))

	# Resolve effects
	var results: Dictionary = effect_resolver.resolve_card(
		card, player_state, enemy_state_dicts, target_index, attuned_alignment
	)

	# Apply results
	_apply_card_results(results, card)

	# Move card from hand to discard
	deck_manager.play_card(card)

	# Track mastery XP
	mastery_tracker.on_card_used(card)

	# Track alignment usage
	var align_key: int = card.alignment
	_alignment_usage[align_key] = _alignment_usage.get(align_key, 0) + 1

	card_played.emit(card, results)

	# Check for victory
	if _all_enemies_dead():
		_change_state(GlobalEnums.BattleState.VICTORY)

	return results


func end_player_turn() -> void:
	if state != GlobalEnums.BattleState.PLAYER_TURN:
		return
	deck_manager.discard_hand()
	_change_state(GlobalEnums.BattleState.ENEMY_TURN)


func execute_enemy_turn() -> Array[Dictionary]:
	var results_list: Array[Dictionary] = []

	for i: int in range(enemies.size()):
		if enemy_hp[i] <= 0:
			continue

		# Tick enemy statuses
		var statuses: Array[StatusEffectResource] = enemy_statuses[i]
		var tick_result: Dictionary = effect_resolver.tick_statuses(statuses)
		if tick_result["tick_damage"] > 0:
			enemy_hp[i] -= tick_result["tick_damage"]
			if enemy_hp[i] <= 0:
				enemy_hp[i] = 0
				enemy_defeated.emit(i)
				continue

		# Reset enemy block
		enemy_block[i] = 0

		# Execute intent
		var intent: GlobalEnums.EnemyIntent = enemy_intents[i]
		var result: Dictionary = _execute_enemy_intent(i, intent)
		results_list.append(result)
		enemy_acted.emit(i, intent, result)

		# Check player death
		if player_hp <= 0:
			player_hp = 0
			_change_state(GlobalEnums.BattleState.DEFEAT)
			return results_list

	# Check victory after status ticks
	if _all_enemies_dead():
		_change_state(GlobalEnums.BattleState.VICTORY)
		return results_list

	# Back to player turn
	_change_state(GlobalEnums.BattleState.PLAYER_TURN)
	return results_list


func get_battle_rewards() -> Dictionary:
	# Award alignment drift for most-used alignment
	var most_used_alignment: GlobalEnums.Alignment = grimoire.get_dominant_alignment()
	var max_count: int = 0
	for align_key: int in _alignment_usage:
		if _alignment_usage[align_key] > max_count:
			max_count = _alignment_usage[align_key]
			most_used_alignment = align_key as GlobalEnums.Alignment

	return {
		"grimoire_xp": 10 + (turn_number * 2),
		"alignment_drift": most_used_alignment,
		"alignment_amount": 1,
		"cards_used": _alignment_usage,
	}


func apply_battle_rewards(rewards: Dictionary) -> void:
	if grimoire == null:
		return
	grimoire.grimoire_xp += rewards.get("grimoire_xp", 0)
	alignment_manager.apply_battle_usage(
		grimoire,
		rewards.get("alignment_drift", grimoire.get_dominant_alignment())
	)


# --- Private Helpers ---

func _change_state(new_state: GlobalEnums.BattleState) -> void:
	state = new_state
	battle_state_changed.emit(new_state)
	if new_state == GlobalEnums.BattleState.VICTORY or new_state == GlobalEnums.BattleState.DEFEAT:
		battle_ended.emit(new_state)


func _get_player_state_dict() -> Dictionary:
	return {
		"hp": player_hp,
		"max_hp": player_max_hp,
		"block": player_block,
		"mana": player_mana,
		"statuses": player_statuses,
		"cards_played_this_turn": cards_played_this_turn,
	}


func _get_enemy_state_dict(index: int) -> Dictionary:
	return {
		"hp": enemy_hp[index],
		"max_hp": enemies[index].max_hp,
		"block": enemy_block[index],
		"statuses": enemy_statuses[index],
	}


func _apply_card_results(results: Dictionary, card: CardResource) -> void:
	# Damage to enemies
	var damage: int = results.get("damage_dealt", 0)
	var target_indices: Array = results.get("target_indices", [])
	for idx: int in target_indices:
		if idx < 0 or idx >= enemies.size():
			continue
		if enemy_hp[idx] <= 0:
			continue
		var actual_damage: int = damage
		var blocked: int = mini(enemy_block[idx], actual_damage)
		actual_damage -= blocked
		enemy_block[idx] -= blocked
		enemy_hp[idx] -= actual_damage
		if enemy_hp[idx] <= 0:
			enemy_hp[idx] = 0
			mastery_tracker.on_card_kill_or_combo(card)
			enemy_defeated.emit(idx)

	# Apply statuses to enemies
	var statuses_applied: Array = results.get("statuses_applied", [])
	for status: StatusEffectResource in statuses_applied:
		match status.status_type:
			GlobalEnums.StatusType.POISON, GlobalEnums.StatusType.BURN, GlobalEnums.StatusType.WEAKNESS:
				# Apply to targeted enemies
				for idx: int in target_indices:
					if idx >= 0 and idx < enemies.size() and enemy_hp[idx] > 0:
						enemy_statuses[idx].append(status)
			GlobalEnums.StatusType.STRENGTH, GlobalEnums.StatusType.REGEN, GlobalEnums.StatusType.SHIELD:
				# Buffs go to player
				player_statuses.append(status)

	# Healing
	var healing: int = results.get("healing_done", 0)
	if healing > 0:
		player_hp = mini(player_hp + healing, player_max_hp)

	# Block
	var block: int = results.get("block_gained", 0)
	if block > 0:
		player_block += block

	# Mana
	var mana: int = results.get("mana_gained", 0)
	if mana > 0:
		player_mana += mana


func _execute_enemy_intent(index: int, intent: GlobalEnums.EnemyIntent) -> Dictionary:
	var enemy: EnemyResource = enemies[index]
	var result: Dictionary = { "intent": intent, "enemy_index": index }
	var strength_bonus: int = _get_enemy_strength(index)

	match intent:
		GlobalEnums.EnemyIntent.ATTACK:
			var damage: int = enemy_ai.get_attack_damage(enemy, turn_number, strength_bonus)
			var attack_result: Dictionary = effect_resolver.resolve_enemy_attack(enemy, damage, _get_player_state_dict())
			player_hp -= attack_result["damage_dealt"]
			player_block -= attack_result["block_consumed"]
			result["damage_dealt"] = attack_result["damage_dealt"]
			result["block_consumed"] = attack_result["block_consumed"]
		GlobalEnums.EnemyIntent.DEFEND:
			var block: int = enemy_ai.get_block_value(enemy)
			enemy_block[index] += block
			result["block_gained"] = block
		GlobalEnums.EnemyIntent.BUFF:
			var status: StatusEffectResource = StatusEffectResource.new()
			status.status_type = GlobalEnums.StatusType.STRENGTH
			status.stacks = enemy.buff_value
			status.remaining_turns = 3
			enemy_statuses[index].append(status)
			result["buff_applied"] = enemy.buff_value
		GlobalEnums.EnemyIntent.DEBUFF:
			var status: StatusEffectResource = StatusEffectResource.new()
			status.status_type = GlobalEnums.StatusType.WEAKNESS
			status.stacks = enemy.buff_value
			status.remaining_turns = 2
			player_statuses.append(status)
			result["debuff_applied"] = enemy.buff_value
		GlobalEnums.EnemyIntent.SPECIAL:
			# Treat as a stronger attack for now
			var damage: int = int(enemy_ai.get_attack_damage(enemy, turn_number, strength_bonus) * 1.5)
			var attack_result: Dictionary = effect_resolver.resolve_enemy_attack(enemy, damage, _get_player_state_dict())
			player_hp -= attack_result["damage_dealt"]
			player_block -= attack_result["block_consumed"]
			result["damage_dealt"] = attack_result["damage_dealt"]

	return result


func _get_enemy_strength(index: int) -> int:
	var bonus: int = 0
	for status: StatusEffectResource in enemy_statuses[index]:
		bonus += status.get_stat_modifier()
	return bonus


func _all_enemies_dead() -> bool:
	for hp: int in enemy_hp:
		if hp > 0:
			return false
	return true
