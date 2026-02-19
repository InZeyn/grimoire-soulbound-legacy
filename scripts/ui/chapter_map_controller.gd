class_name ChapterMapController
extends Control

@onready var chapter_title_label: Label = %ChapterTitleLabel
@onready var chapter_desc_label: Label = %ChapterDescLabel
@onready var node_list: VBoxContainer = %NodeList
@onready var progress_bar: ProgressBar = %ChapterProgressBar
@onready var progress_label: Label = %ProgressLabel
@onready var retreat_btn: Button = %RetreatBtn

var encounter_manager: EncounterManager = EncounterManager.new()
var chapter: ChapterResource = null
var grimoire: GrimoireResource = null

const BATTLE_SCENE_PATH: String = "res://scenes/battle/battle_scene.tscn"
const MORAL_CHOICE_PATH: String = "res://scenes/campaign/moral_choice_scene.tscn"
const TREASURE_PATH: String = "res://scenes/campaign/treasure_scene.tscn"
const REST_PATH: String = "res://scenes/campaign/rest_scene.tscn"
const HUB_PATH: String = "res://scenes/hub/grimoire_hub.tscn"


func _ready() -> void:
	# Get chapter and grimoire from meta (set by hub)
	if has_meta("chapter"):
		chapter = get_meta("chapter")
	if has_meta("grimoire"):
		grimoire = get_meta("grimoire")

	if chapter == null or grimoire == null:
		_return_to_hub()
		return

	retreat_btn.pressed.connect(_on_retreat)

	encounter_manager.chapter_completed.connect(_on_chapter_completed)
	encounter_manager.chapter_failed.connect(_on_chapter_failed)

	encounter_manager.start_chapter(chapter, grimoire)
	_refresh_display()
	_advance_to_next_node()


func _refresh_display() -> void:
	chapter_title_label.text = chapter.chapter_name
	chapter_desc_label.text = chapter.description
	progress_bar.max_value = chapter.encounters.size()
	progress_bar.value = encounter_manager._completed_encounters.size()
	progress_label.text = "%d / %d" % [encounter_manager._completed_encounters.size(), chapter.encounters.size()]
	_update_node_list()


func _update_node_list() -> void:
	for child: Node in node_list.get_children():
		child.queue_free()

	for i: int in range(chapter.encounters.size()):
		var enc: EncounterResource = chapter.encounters[i]
		var label: Label = Label.new()
		var type_icons: Dictionary = {
			GlobalEnums.NodeType.COMBAT: "[Combat]",
			GlobalEnums.NodeType.MORAL_CHOICE: "[Choice]",
			GlobalEnums.NodeType.TREASURE: "[Treasure]",
			GlobalEnums.NodeType.REST: "[Rest]",
			GlobalEnums.NodeType.BOSS: "[BOSS]",
		}
		var status: String = ""
		if i < encounter_manager.current_encounter_index:
			status = " - DONE"
		elif i == encounter_manager.current_encounter_index:
			status = " << CURRENT"
		label.text = "%d. %s %s%s" % [i + 1, type_icons.get(enc.node_type, "?"), enc.encounter_name, status]

		# Color completed nodes
		if i < encounter_manager.current_encounter_index:
			label.modulate = Color(0.5, 0.5, 0.5)
		elif i == encounter_manager.current_encounter_index:
			label.modulate = Color(1.0, 0.9, 0.3)

		node_list.add_child(label)


func _advance_to_next_node() -> void:
	var enc: EncounterResource = encounter_manager.advance_to_next()
	if enc == null:
		# Chapter complete (handled by signal)
		return
	_refresh_display()
	_handle_encounter(enc)


func _handle_encounter(enc: EncounterResource) -> void:
	match enc.node_type:
		GlobalEnums.NodeType.COMBAT, GlobalEnums.NodeType.BOSS:
			_start_combat(enc)
		GlobalEnums.NodeType.MORAL_CHOICE:
			_start_moral_choice(enc)
		GlobalEnums.NodeType.TREASURE:
			_start_treasure(enc)
		GlobalEnums.NodeType.REST:
			_start_rest(enc)


func _start_combat(enc: EncounterResource) -> void:
	var scene: PackedScene = load(BATTLE_SCENE_PATH)
	var battle: Control = scene.instantiate()
	get_tree().root.add_child(battle)
	# The battle scene controller needs grimoire and enemies
	battle.call_deferred("start_battle", grimoire, enc.enemies)
	# Connect to battle end
	battle.combat_manager.battle_ended.connect(_on_battle_ended.bind(battle))
	visible = false


func _start_moral_choice(enc: EncounterResource) -> void:
	var scene: PackedScene = load(MORAL_CHOICE_PATH)
	var choice_scene: Control = scene.instantiate()
	get_tree().root.add_child(choice_scene)
	choice_scene.setup(enc.moral_choice, grimoire, encounter_manager)
	choice_scene.choice_made.connect(_on_moral_choice_made.bind(choice_scene))
	visible = false


func _start_treasure(enc: EncounterResource) -> void:
	var scene: PackedScene = load(TREASURE_PATH)
	var treasure_scene: Control = scene.instantiate()
	get_tree().root.add_child(treasure_scene)
	treasure_scene.setup(enc, grimoire, encounter_manager)
	treasure_scene.treasure_collected.connect(_on_treasure_collected.bind(treasure_scene))
	visible = false


func _start_rest(enc: EncounterResource) -> void:
	var scene: PackedScene = load(REST_PATH)
	var rest_scene: Control = scene.instantiate()
	get_tree().root.add_child(rest_scene)
	rest_scene.setup(enc, encounter_manager)
	rest_scene.rest_complete.connect(_on_rest_complete.bind(rest_scene))
	visible = false


# --- Signal Handlers ---

func _on_battle_ended(state: GlobalEnums.BattleState, battle_scene: Control) -> void:
	battle_scene.queue_free()
	visible = true

	if state == GlobalEnums.BattleState.VICTORY:
		var result: Dictionary = {
			"player_hp": battle_scene.combat_manager.player_hp,
		}
		encounter_manager.complete_current_encounter(result)
		encounter_manager.player_hp = battle_scene.combat_manager.player_hp
		_refresh_display()
		# Small delay before advancing
		_advance_to_next_node()
	else:
		encounter_manager.fail_chapter()


func _on_moral_choice_made(choice_scene: Control) -> void:
	choice_scene.queue_free()
	visible = true
	encounter_manager.complete_current_encounter()
	_refresh_display()
	_advance_to_next_node()


func _on_treasure_collected(treasure_scene: Control) -> void:
	treasure_scene.queue_free()
	visible = true
	encounter_manager.complete_current_encounter()
	_refresh_display()
	_advance_to_next_node()


func _on_rest_complete(rest_scene: Control) -> void:
	rest_scene.queue_free()
	visible = true
	encounter_manager.complete_current_encounter()
	_refresh_display()
	_advance_to_next_node()


func _on_retreat() -> void:
	# Retreat = fail chapter (lose pending lost pages)
	encounter_manager.fail_chapter()


func _on_chapter_completed(_chap: ChapterResource, rewards: Dictionary) -> void:
	GameManager.save_grimoire(grimoire, "active")
	# Show completion then return to hub
	chapter_title_label.text = "CHAPTER COMPLETE!"
	chapter_desc_label.text = "XP earned: %d\nLost pages bound: %d" % [
		rewards.get("completion_xp", 0) + rewards.get("total_encounter_xp", 0),
		rewards.get("lost_pages_bound", 0),
	]
	retreat_btn.text = "Return to Grimoire"
	retreat_btn.pressed.disconnect(_on_retreat)
	retreat_btn.pressed.connect(_return_to_hub)


func _on_chapter_failed(_chap: ChapterResource) -> void:
	GameManager.save_grimoire(grimoire, "active")
	chapter_title_label.text = "CHAPTER FAILED"
	chapter_desc_label.text = "You fell in battle.\nUnbound lost pages have been consumed by the archives."
	retreat_btn.text = "Return to Grimoire"
	retreat_btn.pressed.disconnect(_on_retreat)
	retreat_btn.pressed.connect(_return_to_hub)


func _return_to_hub() -> void:
	var scene: PackedScene = load(HUB_PATH)
	var hub: Node = scene.instantiate()
	get_tree().root.add_child(hub)
	queue_free()
