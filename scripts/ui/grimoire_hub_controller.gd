class_name GrimoireHubController
extends Control

@onready var true_name_label: Label = %TrueNameLabel
@onready var level_label: Label = %LevelLabel
@onready var xp_bar: ProgressBar = %XPBar
@onready var alignment_label: Label = %AlignmentLabel
@onready var deck_count_label: Label = %DeckCountLabel
@onready var lore_label: Label = %LoreLabel
@onready var chapter_list: VBoxContainer = %ChapterList
@onready var new_grimoire_btn: Button = %NewGrimoireBtn
@onready var seed_input: LineEdit = %SeedInput

var grimoire: GrimoireResource = null
var _chapter_generator: ChapterGenerator = ChapterGenerator.new()
var _grimoire_generator: GrimoireGenerator = GrimoireGenerator.new()

const BATTLE_SCENE_PATH: String = "res://scenes/battle/battle_scene.tscn"
const CHAPTER_MAP_PATH: String = "res://scenes/campaign/chapter_map.tscn"


func _ready() -> void:
	new_grimoire_btn.pressed.connect(_on_new_grimoire)

	# Try to load existing grimoire
	grimoire = GameManager.load_grimoire("active")
	if grimoire == null:
		_generate_new_grimoire()
	else:
		_refresh_display()


func _generate_new_grimoire(custom_seed: int = 0) -> void:
	var seed_val: int = custom_seed
	if seed_val == 0:
		seed_val = randi()
	grimoire = _grimoire_generator.generate(seed_val)
	# Give starting cards if empty
	if grimoire.cards.is_empty():
		_add_starter_cards()
	GameManager.save_grimoire(grimoire, "active")
	_refresh_display()


func _add_starter_cards() -> void:
	# Load available base cards
	var card_dir: String = "res://resources/cards/base/"
	var dir: DirAccess = DirAccess.open(card_dir)
	if dir == null:
		return
	var card_paths: Array[String] = []
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			card_paths.append(card_dir + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	# Load and duplicate cards into the grimoire
	for path: String in card_paths:
		var card: CardResource = ResourceLoader.load(path) as CardResource
		if card != null:
			var copy: CardResource = card.duplicate(true) as CardResource
			copy.mastery_xp = 0
			copy.mastery_tier = GlobalEnums.MasteryTier.UNMASTERED
			copy.is_evolved = false
			grimoire.cards.append(copy)


func _refresh_display() -> void:
	if grimoire == null:
		return
	true_name_label.text = grimoire.true_name
	level_label.text = "Level %d" % grimoire.grimoire_level
	xp_bar.value = grimoire.grimoire_xp
	xp_bar.max_value = _get_xp_for_next_level()

	var align_names: Array[String] = ["Radiant", "Vile", "Primal"]
	var dominant: GlobalEnums.Alignment = grimoire.get_dominant_alignment()
	alignment_label.text = "%s (R:%d V:%d P:%d)" % [
		align_names[dominant],
		grimoire.alignment_radiant,
		grimoire.alignment_vile,
		grimoire.alignment_primal
	]
	var conflicted_text: String = " [CONFLICTED]" if grimoire.is_conflicted() else ""
	alignment_label.text += conflicted_text

	deck_count_label.text = "Deck: %d / %d cards" % [grimoire.cards.size(), grimoire.get_max_deck_size()]
	lore_label.text = grimoire.lore_text

	_populate_chapter_list()


func _populate_chapter_list() -> void:
	for child: Node in chapter_list.get_children():
		child.queue_free()

	var chapters: Array[ChapterResource] = _chapter_generator.load_all_chapters()
	if chapters.is_empty():
		var label: Label = Label.new()
		label.text = "No chapters available."
		chapter_list.add_child(label)
		return

	for chapter: ChapterResource in chapters:
		var btn: Button = Button.new()
		var can_enter: bool = _chapter_generator.can_enter_chapter(chapter, grimoire)
		var clash_text: String = " [CLASH!]" if _chapter_generator.has_alignment_clash(chapter, grimoire) else ""
		btn.text = "%s (Lv.%d)%s" % [chapter.chapter_name, chapter.difficulty_level, clash_text]
		btn.disabled = not can_enter
		btn.pressed.connect(_on_chapter_selected.bind(chapter))
		chapter_list.add_child(btn)


func _on_chapter_selected(chapter: ChapterResource) -> void:
	# Store chapter selection for the map scene to pick up
	var scene: PackedScene = load(CHAPTER_MAP_PATH)
	var map_instance: Node = scene.instantiate()
	map_instance.set_meta("chapter", chapter)
	map_instance.set_meta("grimoire", grimoire)
	get_tree().root.add_child(map_instance)
	queue_free()


func _on_new_grimoire() -> void:
	var seed_text: String = seed_input.text.strip_edges()
	var seed_val: int = 0
	if seed_text != "":
		seed_val = seed_text.hash()
	_generate_new_grimoire(seed_val)


func _get_xp_for_next_level() -> int:
	# Simple XP curve: 50 * level
	return 50 * grimoire.grimoire_level
