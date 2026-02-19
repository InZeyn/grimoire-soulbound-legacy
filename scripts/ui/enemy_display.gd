class_name EnemyDisplay
extends VBoxContainer

signal enemy_clicked(index: int)

var enemy_index: int = -1
var enemy: EnemyResource = null

@onready var name_label: Label = %EnemyNameLabel
@onready var hp_bar: ProgressBar = %HPBar
@onready var hp_label: Label = %HPLabel
@onready var intent_label: Label = %IntentLabel
@onready var block_label: Label = %BlockLabel
@onready var status_label: Label = %StatusLabel


func setup(p_enemy: EnemyResource, p_index: int) -> void:
	enemy = p_enemy
	enemy_index = p_index


func _ready() -> void:
	if enemy == null:
		return
	name_label.text = enemy.enemy_name
	hp_bar.max_value = enemy.max_hp
	update_hp(enemy.max_hp)
	update_intent(GlobalEnums.EnemyIntent.ATTACK, enemy.attack_damage)
	update_block(0)
	update_statuses([])

	var click_area: Control = self
	click_area.gui_input.connect(_on_gui_input)


func update_hp(current_hp: int) -> void:
	var previous_hp: int = int(hp_bar.value)
	hp_bar.value = current_hp
	hp_label.text = "%d / %d" % [current_hp, enemy.max_hp]
	# Flash on damage
	if current_hp < previous_hp:
		AnimationHelper.damage_flash(self)
		AnimationHelper.enemy_hit(self)


func update_intent(intent: GlobalEnums.EnemyIntent, value: int = 0) -> void:
	var intent_icons: Dictionary = {
		GlobalEnums.EnemyIntent.ATTACK: "ATK %d",
		GlobalEnums.EnemyIntent.DEFEND: "DEF %d",
		GlobalEnums.EnemyIntent.BUFF: "BUFF +%d",
		GlobalEnums.EnemyIntent.DEBUFF: "DBUF -%d",
		GlobalEnums.EnemyIntent.SPECIAL: "SPL %d",
	}
	intent_label.text = intent_icons.get(intent, "???") % value


func update_block(block: int) -> void:
	block_label.text = "Block: %d" % block
	block_label.visible = block > 0


func update_statuses(statuses: Array[StatusEffectResource]) -> void:
	if statuses.is_empty():
		status_label.text = ""
		status_label.visible = false
		return
	var parts: PackedStringArray = PackedStringArray()
	for status: StatusEffectResource in statuses:
		var status_names: Dictionary = {
			GlobalEnums.StatusType.POISON: "PSN",
			GlobalEnums.StatusType.BURN: "BRN",
			GlobalEnums.StatusType.WEAKNESS: "WKN",
			GlobalEnums.StatusType.STRENGTH: "STR",
			GlobalEnums.StatusType.SHIELD: "SHD",
			GlobalEnums.StatusType.REGEN: "RGN",
		}
		var name: String = status_names.get(status.status_type, "???")
		parts.append("%s %d" % [name, status.stacks])
	status_label.text = " | ".join(parts)
	status_label.visible = true


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			enemy_clicked.emit(enemy_index)
