@tool
class_name GrimoireResource
extends Resource

@export_group("Identity")
@export var seed: int = 0
@export var true_name: String = ""
@export_multiline var lore_text: String = ""

@export_group("Visuals")
@export var cover_type: GlobalEnums.GrimoireCover = GlobalEnums.GrimoireCover.LEATHER
@export var binding_type: GlobalEnums.GrimoireBinding = GlobalEnums.GrimoireBinding.CHAIN
@export var sigil_params: Dictionary = {}
@export var aura_color: Color = Color.WHITE

@export_group("Alignment")
@export_range(0, 100) var alignment_radiant: int = 0
@export_range(0, 100) var alignment_vile: int = 0
@export_range(0, 100) var alignment_primal: int = 0

@export_group("Progression")
@export_range(1, 20) var grimoire_level: int = 1
@export var grimoire_xp: int = 0

@export_group("Collections")
@export var cards: Array[CardResource] = []
@export var lost_pages: Array[CardResource] = []
@export var inscriptions: Array[Resource] = []


func get_max_deck_size() -> int:
	if grimoire_level <= 5:
		return 20
	elif grimoire_level <= 10:
		return 25
	elif grimoire_level <= 15:
		return 30
	elif grimoire_level <= 19:
		return 35
	else:
		return 40


func get_dominant_alignment() -> GlobalEnums.Alignment:
	if alignment_radiant >= alignment_vile and alignment_radiant >= alignment_primal:
		return GlobalEnums.Alignment.RADIANT
	elif alignment_vile >= alignment_primal:
		return GlobalEnums.Alignment.VILE
	else:
		return GlobalEnums.Alignment.PRIMAL


func is_conflicted() -> bool:
	var values: Array[int] = [alignment_radiant, alignment_vile, alignment_primal]
	values.sort()
	return values[2] - values[1] <= 5


func get_max_lost_pages() -> int:
	return grimoire_level / 5


func get_inscription_slot_count() -> int:
	if grimoire_level < 3:
		return 0
	elif grimoire_level <= 4:
		return 1
	elif grimoire_level <= 5:
		return 2
	elif grimoire_level <= 10:
		return 2
	elif grimoire_level <= 15:
		return 3
	else:
		return 4
