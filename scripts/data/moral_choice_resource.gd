@tool
class_name MoralChoiceResource
extends Resource

@export var choice_id: String = ""
@export var title: String = ""
@export_multiline var narrative_text: String = ""

@export_group("Option A")
@export var option_a_text: String = ""
@export var option_a_alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.RADIANT
@export_range(1, 10) var option_a_shift: int = 3
@export_multiline var option_a_result_text: String = ""

@export_group("Option B")
@export var option_b_text: String = ""
@export var option_b_alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.VILE
@export_range(1, 10) var option_b_shift: int = 3
@export_multiline var option_b_result_text: String = ""

@export_group("Option C")
@export var option_c_text: String = ""
@export var option_c_alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL
@export_range(1, 10) var option_c_shift: int = 3
@export_multiline var option_c_result_text: String = ""
