@tool
class_name EnemyResource
extends Resource

@export var enemy_id: String = ""
@export var enemy_name: String = ""
@export var max_hp: int = 10
@export var alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL
@export_multiline var description: String = ""

@export_group("Combat")
@export var attack_damage: int = 5
@export var block_value: int = 3
@export var buff_value: int = 2

@export_group("Intent Weights")
## Weights for [ATTACK, DEFEND, BUFF, DEBUFF, SPECIAL]. Higher = more likely.
@export var intent_weights: Array[int] = [50, 20, 15, 10, 5]

@export_group("Enrage")
## Turns before enrage. 0 = no enrage.
@export var enrage_after_turns: int = 0
## Damage multiplier when enraged (1.0 = no change).
@export var enrage_damage_multiplier: float = 1.5
