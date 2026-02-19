class_name CardNodeUI
extends PanelContainer

signal card_clicked(card: CardResource, card_node: Control)
signal card_mouse_entered(card: CardResource)
signal card_mouse_exited()

var card: CardResource = null
var _combat_manager: CombatManager = null

@onready var name_label: Label = %NameLabel
@onready var cost_label: Label = %CostLabel
@onready var value_label: Label = %ValueLabel
@onready var type_label: Label = %TypeLabel
@onready var description_label: Label = %DescriptionLabel
@onready var mastery_bar: ProgressBar = %MasteryBar


func setup(p_card: CardResource, combat_manager: CombatManager) -> void:
	card = p_card
	_combat_manager = combat_manager


func _ready() -> void:
	if card == null:
		return
	_update_display()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func _update_display() -> void:
	if card == null:
		return
	name_label.text = card.card_name

	var mana_cost: int = card.mana_cost
	if _combat_manager != null:
		mana_cost = _combat_manager.get_card_mana_cost(card)
	cost_label.text = str(mana_cost)

	value_label.text = str(card.get_effective_value())

	var type_names: Array[String] = ["ATK", "DEF", "SUP", "SPL"]
	type_label.text = type_names[card.card_type]

	description_label.text = card.description
	mastery_bar.value = card.mastery_xp
	mastery_bar.max_value = 100

	# Visual feedback: can this card be played?
	if _combat_manager != null:
		modulate = Color.WHITE if _combat_manager.can_play_card(card) else Color(0.5, 0.5, 0.5, 0.8)

	# Alignment color tint on the border
	var align_colors: Dictionary = {
		GlobalEnums.Alignment.RADIANT: Color(1.0, 0.9, 0.5, 1.0),
		GlobalEnums.Alignment.VILE: Color(0.6, 0.3, 0.8, 1.0),
		GlobalEnums.Alignment.PRIMAL: Color(0.3, 0.7, 0.4, 1.0),
	}
	var border_color: Color = align_colors.get(card.alignment, Color.WHITE)
	var stylebox: StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.12, 0.1, 0.08, 0.95)
	stylebox.border_color = border_color
	stylebox.set_border_width_all(2)
	stylebox.set_corner_radius_all(4)
	stylebox.set_content_margin_all(8)
	add_theme_stylebox_override("panel", stylebox)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			card_clicked.emit(card, self)


func _on_mouse_entered() -> void:
	if card != null:
		card_mouse_entered.emit(card)
		# Hover scale
		scale = Vector2(1.1, 1.1)
		z_index = 10
		# Glow shader on hover
		_set_glow_intensity(1.2)


func _on_mouse_exited() -> void:
	card_mouse_exited.emit()
	scale = Vector2.ONE
	z_index = 0
	_set_glow_intensity(0.0)


func _set_glow_intensity(intensity: float) -> void:
	var mat: ShaderMaterial = material as ShaderMaterial
	if mat == null:
		return
	mat.set_shader_parameter("glow_intensity", intensity)
