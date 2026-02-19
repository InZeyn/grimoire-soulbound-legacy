@tool
class_name EffectResource
extends Resource

@export var effect_type: GlobalEnums.EffectType = GlobalEnums.EffectType.DAMAGE
@export var value: int = 0
@export var duration: int = 0
@export var target_type: GlobalEnums.TargetType = GlobalEnums.TargetType.SINGLE_ENEMY
@export var condition: GlobalEnums.ConditionType = GlobalEnums.ConditionType.NONE
@export_multiline var description_override: String = ""
