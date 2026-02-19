class_name EffectResolver
extends RefCounted

## Resolves a card's effects against the battle state.
## Returns a Dictionary with results: { "damage_dealt": int, "healing_done": int, "block_gained": int,
## "cards_drawn": int, "mana_gained": int, "statuses_applied": Array[StatusEffectResource] }


func resolve_card(card: CardResource, player_state: Dictionary, enemy_states: Array[Dictionary],
		target_index: int, attuned_alignment: GlobalEnums.Alignment) -> Dictionary:
	var results: Dictionary = {
		"damage_dealt": 0,
		"healing_done": 0,
		"block_gained": 0,
		"cards_drawn": 0,
		"mana_gained": 0,
		"statuses_applied": [],
		"target_indices": [],
	}

	for effect: EffectResource in card.effects:
		if not _check_condition(effect, card, player_state, attuned_alignment):
			continue
		_apply_effect(effect, card, player_state, enemy_states, target_index, results)

	# Fallback: if card has no effects, use base_value as raw damage/heal/block
	if card.effects.is_empty():
		match card.card_type:
			GlobalEnums.CardType.ATTACK:
				results["damage_dealt"] = card.get_effective_value() + _get_strength(player_state)
				results["target_indices"] = _resolve_target_indices(card.target_type, target_index, enemy_states.size())
			GlobalEnums.CardType.DEFENSE:
				results["block_gained"] = card.get_effective_value()
			GlobalEnums.CardType.SUPPORT:
				results["healing_done"] = card.get_effective_value()

	return results


func resolve_enemy_attack(enemy: EnemyResource, damage: int, player_state: Dictionary) -> Dictionary:
	var actual_damage: int = damage
	var block: int = player_state.get("block", 0)
	var blocked: int = mini(block, actual_damage)
	actual_damage -= blocked
	return {
		"damage_dealt": actual_damage,
		"block_consumed": blocked,
	}


func tick_statuses(statuses: Array[StatusEffectResource]) -> Dictionary:
	var total_damage: int = 0
	var expired: Array[StatusEffectResource] = []
	for status: StatusEffectResource in statuses:
		total_damage += status.tick()
		if status.is_expired():
			expired.append(status)
	for status: StatusEffectResource in expired:
		statuses.erase(status)
	return { "tick_damage": total_damage }


func _check_condition(effect: EffectResource, card: CardResource,
		player_state: Dictionary, attuned_alignment: GlobalEnums.Alignment) -> bool:
	match effect.condition:
		GlobalEnums.ConditionType.NONE:
			return true
		GlobalEnums.ConditionType.IF_ALIGNMENT_MATCH:
			return card.alignment == attuned_alignment
		GlobalEnums.ConditionType.IF_HP_BELOW_HALF:
			var hp: int = player_state.get("hp", 1)
			var max_hp: int = player_state.get("max_hp", 1)
			return hp <= max_hp / 2
		GlobalEnums.ConditionType.IF_FIRST_PLAY:
			return player_state.get("cards_played_this_turn", 0) == 0
	return true


func _apply_effect(effect: EffectResource, card: CardResource, player_state: Dictionary,
		enemy_states: Array[Dictionary], target_index: int, results: Dictionary) -> void:
	match effect.effect_type:
		GlobalEnums.EffectType.DAMAGE:
			var value: int = effect.value + card.get_effective_value() - card.base_value + _get_strength(player_state)
			results["damage_dealt"] += value
			results["target_indices"] = _resolve_target_indices(effect.target_type, target_index, enemy_states.size())
		GlobalEnums.EffectType.HEAL:
			results["healing_done"] += effect.value
		GlobalEnums.EffectType.BLOCK:
			results["block_gained"] += effect.value
		GlobalEnums.EffectType.DRAW:
			results["cards_drawn"] += effect.value
		GlobalEnums.EffectType.MANA_GAIN:
			results["mana_gained"] += effect.value
		GlobalEnums.EffectType.BUFF_ATTACK:
			var status: StatusEffectResource = StatusEffectResource.new()
			status.status_type = GlobalEnums.StatusType.STRENGTH
			status.stacks = effect.value
			status.remaining_turns = effect.duration if effect.duration > 0 else 3
			results["statuses_applied"].append(status)
		GlobalEnums.EffectType.DEBUFF_ATTACK:
			var status: StatusEffectResource = StatusEffectResource.new()
			status.status_type = GlobalEnums.StatusType.WEAKNESS
			status.stacks = effect.value
			status.remaining_turns = effect.duration if effect.duration > 0 else 3
			results["statuses_applied"].append(status)
		GlobalEnums.EffectType.POISON:
			var status: StatusEffectResource = StatusEffectResource.new()
			status.status_type = GlobalEnums.StatusType.POISON
			status.stacks = effect.value
			status.remaining_turns = effect.duration if effect.duration > 0 else 3
			results["statuses_applied"].append(status)
			results["target_indices"] = _resolve_target_indices(effect.target_type, target_index, enemy_states.size())
		GlobalEnums.EffectType.BURN:
			var status: StatusEffectResource = StatusEffectResource.new()
			status.status_type = GlobalEnums.StatusType.BURN
			status.stacks = effect.value
			status.remaining_turns = 99
			results["statuses_applied"].append(status)
			results["target_indices"] = _resolve_target_indices(effect.target_type, target_index, enemy_states.size())


func _get_strength(player_state: Dictionary) -> int:
	var bonus: int = 0
	var statuses: Array = player_state.get("statuses", [])
	for status: StatusEffectResource in statuses:
		bonus += status.get_stat_modifier()
	return bonus


func _resolve_target_indices(target_type: GlobalEnums.TargetType, chosen: int, enemy_count: int) -> Array[int]:
	match target_type:
		GlobalEnums.TargetType.SINGLE_ENEMY:
			return [clampi(chosen, 0, enemy_count - 1)]
		GlobalEnums.TargetType.ALL_ENEMIES:
			var indices: Array[int] = []
			for i: int in range(enemy_count):
				indices.append(i)
			return indices
	return [clampi(chosen, 0, maxi(enemy_count - 1, 0))]
