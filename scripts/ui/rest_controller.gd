class_name RestController
extends Control

signal rest_complete()

@onready var title_label: Label = %RestTitleLabel
@onready var info_label: Label = %RestInfoLabel
@onready var rest_btn: Button = %RestBtn

var _encounter: EncounterResource = null
var _encounter_manager: EncounterManager = null


func setup(encounter: EncounterResource, encounter_manager: EncounterManager) -> void:
	_encounter = encounter
	_encounter_manager = encounter_manager


func _ready() -> void:
	if _encounter == null:
		return

	title_label.text = "A Moment of Respite"
	var heal_pct: int = int(_encounter.rest_heal_percent * 100)
	info_label.text = "Rest here to recover %d%% of your maximum HP.\nCurrent HP: %d / %d" % [
		heal_pct, _encounter_manager.player_hp, _encounter_manager.player_max_hp
	]
	rest_btn.pressed.connect(_on_rest)


func _on_rest() -> void:
	var healed: int = _encounter_manager.apply_rest(_encounter)
	info_label.text = "Healed %d HP.\nCurrent HP: %d / %d" % [
		healed, _encounter_manager.player_hp, _encounter_manager.player_max_hp
	]
	rest_btn.text = "Continue"
	rest_btn.pressed.disconnect(_on_rest)
	rest_btn.pressed.connect(func() -> void: rest_complete.emit())
