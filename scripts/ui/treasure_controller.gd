class_name TreasureController
extends Control

signal treasure_collected()

@onready var title_label: Label = %TreasureTitleLabel
@onready var info_label: Label = %TreasureInfoLabel
@onready var options_container: VBoxContainer = %TreasureOptions
@onready var skip_btn: Button = %SkipTreasureBtn

var _encounter: EncounterResource = null
var _grimoire: GrimoireResource = null
var _encounter_manager: EncounterManager = null


func setup(encounter: EncounterResource, grimoire: GrimoireResource, encounter_manager: EncounterManager) -> void:
	_encounter = encounter
	_grimoire = grimoire
	_encounter_manager = encounter_manager


func _ready() -> void:
	if _encounter == null:
		return

	title_label.text = "Lost Pages Found"

	var max_pages: int = _grimoire.get_max_lost_pages()
	var current_pages: int = _grimoire.lost_pages.size() + _encounter_manager.pending_lost_pages.size()
	var has_room: bool = current_pages < max_pages

	if has_room:
		info_label.text = "Choose a page to take. It will be bound to your Grimoire upon extraction.\nSlots: %d / %d" % [current_pages, max_pages]
		_generate_page_options()
	else:
		info_label.text = "Your Grimoire cannot hold more Lost Pages. (Slots: %d / %d)" % [current_pages, max_pages]

	skip_btn.pressed.connect(_on_skip)


func _generate_page_options() -> void:
	# Generate placeholder lost pages (in Phase 4 these will be real cards from the library)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()

	var alignments: Array[GlobalEnums.Alignment] = [
		GlobalEnums.Alignment.RADIANT,
		GlobalEnums.Alignment.VILE,
		GlobalEnums.Alignment.PRIMAL,
	]
	var align_names: Array[String] = ["Radiant", "Vile", "Primal"]
	var type_names: Array[String] = ["Attack", "Defense", "Support"]

	for i: int in range(_encounter.treasure_choices):
		var card: CardResource = CardResource.new()
		var align_idx: int = rng.randi_range(0, 2)
		var type_idx: int = rng.randi_range(0, 2)
		card.card_id = "lost_page_%d" % rng.randi()
		card.card_name = "%s %s Page" % [align_names[align_idx], type_names[type_idx]]
		card.alignment = alignments[align_idx]
		card.card_type = type_idx as GlobalEnums.CardType
		card.mana_cost = rng.randi_range(1, 3)
		card.base_value = rng.randi_range(2, 6)
		card.rarity = GlobalEnums.Rarity.UNCOMMON
		card.description = "A page torn from the archives."

		var btn: Button = Button.new()
		btn.text = "%s — %s %s, Cost: %d, Value: %d" % [
			card.card_name, align_names[align_idx], type_names[type_idx], card.mana_cost, card.base_value
		]
		btn.pressed.connect(_on_page_selected.bind(card))
		options_container.add_child(btn)


func _on_page_selected(card: CardResource) -> void:
	_encounter_manager.add_pending_lost_page(card)
	info_label.text = "Acquired: %s\nThis page will be bound upon chapter extraction." % card.card_name
	# Disable all options
	for child: Node in options_container.get_children():
		if child is Button:
			(child as Button).disabled = true
	skip_btn.text = "Continue"
	skip_btn.pressed.disconnect(_on_skip)
	skip_btn.pressed.connect(func() -> void: treasure_collected.emit())


func _on_skip() -> void:
	treasure_collected.emit()
