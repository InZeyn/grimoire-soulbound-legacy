class_name EnemyAI
extends RefCounted

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func initialize(rng_seed: int = 0) -> void:
	if rng_seed != 0:
		_rng.seed = rng_seed
	else:
		_rng.randomize()


## Selects an intent for an enemy based on its weight table, HP%, and turn count.
func select_intent(enemy: EnemyResource, current_hp: int, turn_number: int) -> GlobalEnums.EnemyIntent:
	# Enrage check: if past enrage threshold, always attack
	if enemy.enrage_after_turns > 0 and turn_number >= enemy.enrage_after_turns:
		return GlobalEnums.EnemyIntent.ATTACK

	# HP-based weight adjustments
	var weights: Array[int] = enemy.intent_weights.duplicate()
	# Pad to 5 if short
	while weights.size() < 5:
		weights.append(0)

	var hp_ratio: float = float(current_hp) / float(enemy.max_hp) if enemy.max_hp > 0 else 1.0

	# Below 30% HP: boost attack weight, reduce defend
	if hp_ratio < 0.3:
		weights[0] = int(weights[0] * 1.5)  # ATTACK
		weights[1] = int(weights[1] * 0.5)  # DEFEND
	# Above 70% HP: boost buff weight
	elif hp_ratio > 0.7:
		weights[2] = int(weights[2] * 1.3)  # BUFF

	return _weighted_select(weights)


## Calculates the damage an enemy deals for its attack intent.
func get_attack_damage(enemy: EnemyResource, turn_number: int, strength_bonus: int = 0) -> int:
	var damage: int = enemy.attack_damage + strength_bonus
	if enemy.enrage_after_turns > 0 and turn_number >= enemy.enrage_after_turns:
		damage = int(damage * enemy.enrage_damage_multiplier)
	return damage


## Calculates the block an enemy gains for its defend intent.
func get_block_value(enemy: EnemyResource) -> int:
	return enemy.block_value


func _weighted_select(weights: Array[int]) -> GlobalEnums.EnemyIntent:
	var total: int = 0
	for w: int in weights:
		total += w
	if total <= 0:
		return GlobalEnums.EnemyIntent.ATTACK

	var roll: int = _rng.randi_range(1, total)
	var cumulative: int = 0
	for i: int in range(weights.size()):
		cumulative += weights[i]
		if roll <= cumulative:
			return i as GlobalEnums.EnemyIntent
	return GlobalEnums.EnemyIntent.ATTACK
