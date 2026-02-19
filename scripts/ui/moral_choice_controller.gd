class_name MoralChoiceController
extends Control

signal choice_made()

@onready var title_label: Label = %ChoiceTitleLabel
@onready var narrative_label: Label = %NarrativeLabel
@onready var option_a_btn: Button = %OptionABtn
@onready var option_b_btn: Button = %OptionBBtn
@onready var option_c_btn: Button = %OptionCBtn
@onready var result_label: Label = %ResultLabel
@onready var continue_btn: Button = %ChoiceContinueBtn

var _choice: MoralChoiceResource = null
var _grimoire: GrimoireResource = null
var _encounter_manager: EncounterManager = null


func setup(choice: MoralChoiceResource, grimoire: GrimoireResource, encounter_manager: EncounterManager) -> void:
	_choice = choice
	_grimoire = grimoire
	_encounter_manager = encounter_manager


func _ready() -> void:
	if _choice == null:
		return

	title_label.text = _choice.title
	narrative_label.text = _choice.narrative_text

	var align_names: Array[String] = ["Radiant", "Vile", "Primal"]
	option_a_btn.text = "%s [%s +%d]" % [_choice.option_a_text, align_names[_choice.option_a_alignment], _choice.option_a_shift]
	option_b_btn.text = "%s [%s +%d]" % [_choice.option_b_text, align_names[_choice.option_b_alignment], _choice.option_b_shift]
	option_c_btn.text = "%s [%s +%d]" % [_choice.option_c_text, align_names[_choice.option_c_alignment], _choice.option_c_shift]

	option_a_btn.pressed.connect(_on_option_selected.bind(0))
	option_b_btn.pressed.connect(_on_option_selected.bind(1))
	option_c_btn.pressed.connect(_on_option_selected.bind(2))
	continue_btn.pressed.connect(_on_continue)

	result_label.visible = false
	continue_btn.visible = false


func _on_option_selected(option_index: int) -> void:
	var result: Dictionary = _encounter_manager.apply_moral_choice(_choice, option_index)
	if result.is_empty():
		return

	# Disable buttons
	option_a_btn.disabled = true
	option_b_btn.disabled = true
	option_c_btn.disabled = true

	var align_names: Array[String] = ["Radiant", "Vile", "Primal"]
	result_label.text = "%s\n\n%s +%d" % [
		result.get("result_text", ""),
		align_names[result.get("alignment", 0)],
		result.get("shift", 0),
	]
	result_label.visible = true
	continue_btn.visible = true


func _on_continue() -> void:
	choice_made.emit()
