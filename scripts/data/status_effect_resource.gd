@tool
class_name StatusEffectResource
extends Resource

@export var status_type: GlobalEnums.StatusType = GlobalEnums.StatusType.POISON
@export var stacks: int = 1
@export var remaining_turns: int = 1


func tick() -> int:
	var tick_damage: int = 0
	match status_type:
		GlobalEnums.StatusType.POISON:
			tick_damage = stacks
		GlobalEnums.StatusType.BURN:
			tick_damage = stacks
			stacks = maxi(stacks - 1, 0)
	remaining_turns -= 1
	return tick_damage


func is_expired() -> bool:
	if status_type == GlobalEnums.StatusType.BURN:
		return stacks <= 0
	return remaining_turns <= 0


func get_stat_modifier() -> int:
	match status_type:
		GlobalEnums.StatusType.WEAKNESS:
			return -stacks
		GlobalEnums.StatusType.STRENGTH:
			return stacks
	return 0
