@tool
class_name InscriptionResource
extends Resource

@export var inscription_id: String = ""
@export var inscription_name: String = ""
@export_multiline var description: String = ""
@export var alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL
@export var effect_key: String = ""
@export var effect_value: int = 0
