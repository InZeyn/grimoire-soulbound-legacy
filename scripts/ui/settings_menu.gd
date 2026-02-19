class_name SettingsMenu
extends Control

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var quality_dropdown: OptionButton = %QualityDropdown
@onready var back_btn: Button = %BackBtn

const SETTINGS_PATH: String = "user://settings.cfg"
var _previous_scene_path: String = ""


func _ready() -> void:
	_load_settings()

	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	quality_dropdown.item_selected.connect(_on_quality_selected)
	back_btn.pressed.connect(_on_back_pressed)


func set_previous_scene(path: String) -> void:
	_previous_scene_path = path


func _on_master_changed(value: float) -> void:
	AudioManager.set_bus_volume(&"Master", value / 100.0)
	_save_settings()


func _on_music_changed(value: float) -> void:
	AudioManager.set_bus_volume(&"Music", value / 100.0)
	_save_settings()


func _on_sfx_changed(value: float) -> void:
	AudioManager.set_bus_volume(&"SFX", value / 100.0)
	_save_settings()


func _on_quality_selected(index: int) -> void:
	QualityManager.set_quality(index as QualityManager.QualityLevel)
	_save_settings()


func _on_back_pressed() -> void:
	_save_settings()
	if _previous_scene_path != "":
		get_tree().change_scene_to_file(_previous_scene_path)
	else:
		get_tree().change_scene_to_file("res://scenes/hub/grimoire_hub.tscn")


func _save_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("audio", "master_volume", master_slider.value)
	config.set_value("audio", "music_volume", music_slider.value)
	config.set_value("audio", "sfx_volume", sfx_slider.value)
	config.set_value("graphics", "quality", quality_dropdown.selected)
	config.save(SETTINGS_PATH)


func _load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	var err: Error = config.load(SETTINGS_PATH)

	if err == OK:
		master_slider.value = config.get_value("audio", "master_volume", 80.0)
		music_slider.value = config.get_value("audio", "music_volume", 70.0)
		sfx_slider.value = config.get_value("audio", "sfx_volume", 80.0)
		quality_dropdown.selected = config.get_value("graphics", "quality", 2)
	else:
		master_slider.value = 80.0
		music_slider.value = 70.0
		sfx_slider.value = 80.0
		quality_dropdown.selected = 2

	# Apply loaded values immediately
	AudioManager.set_bus_volume(&"Master", master_slider.value / 100.0)
	AudioManager.set_bus_volume(&"Music", music_slider.value / 100.0)
	AudioManager.set_bus_volume(&"SFX", sfx_slider.value / 100.0)
	QualityManager.set_quality(quality_dropdown.selected as QualityManager.QualityLevel)
