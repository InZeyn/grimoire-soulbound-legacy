class_name BattleHUD
extends PanelContainer

signal attunement_changed(alignment: GlobalEnums.Alignment)
signal end_turn_pressed()

@onready var hp_bar: ProgressBar = %PlayerHPBar
@onready var hp_label: Label = %PlayerHPLabel
@onready var mana_label: Label = %ManaLabel
@onready var block_label: Label = %PlayerBlockLabel
@onready var turn_label: Label = %TurnLabel
@onready var attune_radiant_btn: Button = %AttuneRadiantBtn
@onready var attune_vile_btn: Button = %AttuneVileBtn
@onready var attune_primal_btn: Button = %AttunePrimalBtn
@onready var end_turn_btn: Button = %EndTurnBtn
@onready var draw_pile_label: Label = %DrawPileLabel
@onready var discard_pile_label: Label = %DiscardPileLabel
@onready var status_label: Label = %PlayerStatusLabel

var _current_attunement: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL


func _ready() -> void:
	attune_radiant_btn.pressed.connect(_on_attune_radiant)
	attune_vile_btn.pressed.connect(_on_attune_vile)
	attune_primal_btn.pressed.connect(_on_attune_primal)
	end_turn_btn.pressed.connect(_on_end_turn)


func update_player_hp(current: int, maximum: int) -> void:
	hp_bar.max_value = maximum
	hp_bar.value = current
	hp_label.text = "%d / %d" % [current, maximum]


func update_mana(current: int, maximum: int) -> void:
	mana_label.text = "Mana: %d / %d" % [current, maximum]


func update_block(block: int) -> void:
	block_label.text = "Block: %d" % block
	block_label.visible = block > 0


func update_turn(turn_number: int) -> void:
	turn_label.text = "Turn %d" % turn_number


func update_piles(draw_count: int, discard_count: int) -> void:
	draw_pile_label.text = "Draw: %d" % draw_count
	discard_pile_label.text = "Discard: %d" % discard_count


func update_attunement(alignment: GlobalEnums.Alignment) -> void:
	_current_attunement = alignment
	attune_radiant_btn.button_pressed = alignment == GlobalEnums.Alignment.RADIANT
	attune_vile_btn.button_pressed = alignment == GlobalEnums.Alignment.VILE
	attune_primal_btn.button_pressed = alignment == GlobalEnums.Alignment.PRIMAL


func update_statuses(statuses: Array[StatusEffectResource]) -> void:
	if statuses.is_empty():
		status_label.text = ""
		status_label.visible = false
		return
	var parts: PackedStringArray = PackedStringArray()
	for status: StatusEffectResource in statuses:
		var names: Dictionary = {
			GlobalEnums.StatusType.POISON: "PSN",
			GlobalEnums.StatusType.BURN: "BRN",
			GlobalEnums.StatusType.WEAKNESS: "WKN",
			GlobalEnums.StatusType.STRENGTH: "STR",
			GlobalEnums.StatusType.SHIELD: "SHD",
			GlobalEnums.StatusType.REGEN: "RGN",
		}
		parts.append("%s %d" % [names.get(status.status_type, "???"), status.stacks])
	status_label.text = " | ".join(parts)
	status_label.visible = true


func set_interactive(enabled: bool) -> void:
	end_turn_btn.disabled = not enabled
	attune_radiant_btn.disabled = not enabled
	attune_vile_btn.disabled = not enabled
	attune_primal_btn.disabled = not enabled


func _on_attune_radiant() -> void:
	attunement_changed.emit(GlobalEnums.Alignment.RADIANT)


func _on_attune_vile() -> void:
	attunement_changed.emit(GlobalEnums.Alignment.VILE)


func _on_attune_primal() -> void:
	attunement_changed.emit(GlobalEnums.Alignment.PRIMAL)


func _on_end_turn() -> void:
	end_turn_pressed.emit()
