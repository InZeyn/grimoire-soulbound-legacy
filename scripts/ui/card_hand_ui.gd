class_name CardHandUI
extends HBoxContainer

signal card_selected(card: CardResource, card_node: Control)
signal card_hovered(card: CardResource)
signal card_unhovered()

const CARD_SCENE_PATH: String = "res://scenes/battle/card_node.tscn"
var _card_scene: PackedScene = null
var _combat_manager: CombatManager = null


func setup(combat_manager: CombatManager) -> void:
	_combat_manager = combat_manager
	_card_scene = load(CARD_SCENE_PATH)


func display_hand(cards: Array[CardResource]) -> void:
	_clear_hand()
	for card: CardResource in cards:
		var card_node: Control = _card_scene.instantiate()
		add_child(card_node)
		card_node.setup(card, _combat_manager)
		card_node.card_clicked.connect(_on_card_clicked)
		card_node.card_mouse_entered.connect(_on_card_hovered)
		card_node.card_mouse_exited.connect(_on_card_unhovered)


func refresh_hand() -> void:
	if _combat_manager == null:
		return
	display_hand(_combat_manager.deck_manager.hand)


func _clear_hand() -> void:
	for child: Node in get_children():
		child.queue_free()


func _on_card_clicked(card: CardResource, card_node: Control) -> void:
	card_selected.emit(card, card_node)


func _on_card_hovered(card: CardResource) -> void:
	card_hovered.emit(card)


func _on_card_unhovered() -> void:
	card_unhovered.emit()
