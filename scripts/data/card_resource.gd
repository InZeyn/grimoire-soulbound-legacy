@tool
class_name CardResource
extends Resource

@export var card_id: String = ""
@export var card_name: String = ""
@export_multiline var description: String = ""
@export var card_type: GlobalEnums.CardType = GlobalEnums.CardType.ATTACK
@export var alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL
@export var rarity: GlobalEnums.Rarity = GlobalEnums.Rarity.COMMON
@export var mana_cost: int = 1
@export var base_value: int = 0
@export var target_type: GlobalEnums.TargetType = GlobalEnums.TargetType.SINGLE_ENEMY

@export_group("Mastery")
@export var mastery_xp: int = 0
@export var mastery_tier: GlobalEnums.MasteryTier = GlobalEnums.MasteryTier.UNMASTERED
@export var is_evolved: bool = false

@export_group("Effects")
@export var effects: Array[EffectResource] = []

@export_group("Evolution Paths")
@export var evolution_radiant: CardResource = null
@export var evolution_vile: CardResource = null
@export var evolution_primal: CardResource = null


func add_xp(amount: int) -> void:
	if is_evolved:
		return
	mastery_xp = clampi(mastery_xp + amount, 0, 100)
	_update_mastery_tier()


func can_evolve() -> bool:
	return mastery_xp >= 100 and not is_evolved


func get_effective_value() -> int:
	var bonus: int = 0
	match mastery_tier:
		GlobalEnums.MasteryTier.BRONZE:
			bonus = 1
		GlobalEnums.MasteryTier.SILVER:
			bonus = 2
		GlobalEnums.MasteryTier.GOLD:
			bonus = 3
		GlobalEnums.MasteryTier.EVOLVED:
			bonus = 3
	return base_value + bonus


func get_evolution_for_alignment(align: GlobalEnums.Alignment) -> CardResource:
	match align:
		GlobalEnums.Alignment.RADIANT:
			return evolution_radiant
		GlobalEnums.Alignment.VILE:
			return evolution_vile
		GlobalEnums.Alignment.PRIMAL:
			return evolution_primal
	return null


func _update_mastery_tier() -> void:
	if is_evolved:
		mastery_tier = GlobalEnums.MasteryTier.EVOLVED
	elif mastery_xp >= 75:
		mastery_tier = GlobalEnums.MasteryTier.GOLD
	elif mastery_xp >= 50:
		mastery_tier = GlobalEnums.MasteryTier.SILVER
	elif mastery_xp >= 25:
		mastery_tier = GlobalEnums.MasteryTier.BRONZE
	else:
		mastery_tier = GlobalEnums.MasteryTier.UNMASTERED
