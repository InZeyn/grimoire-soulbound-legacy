extends Node

signal quality_changed(level: int)

enum QualityLevel { LOW = 0, MEDIUM = 1, HIGH = 2 }

var current_quality: QualityLevel = QualityLevel.HIGH
var max_particles: int = 500
var shaders_enabled: bool = true

const SETTINGS_PATH: String = "user://settings.cfg"


func _ready() -> void:
	_load_quality_from_settings()


func set_quality(level: QualityLevel) -> void:
	current_quality = level
	match level:
		QualityLevel.LOW:
			max_particles = 0
			shaders_enabled = false
		QualityLevel.MEDIUM:
			max_particles = 250
			shaders_enabled = true
		QualityLevel.HIGH:
			max_particles = 500
			shaders_enabled = true
	quality_changed.emit(level)


func apply_shader_to_node(node: CanvasItem, shader_material: ShaderMaterial) -> void:
	if shaders_enabled:
		node.material = shader_material
	else:
		node.material = null


func get_max_particles() -> int:
	return max_particles


func _load_quality_from_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	var err: Error = config.load(SETTINGS_PATH)
	if err != OK:
		return
	var level: int = config.get_value("graphics", "quality", QualityLevel.HIGH)
	set_quality(level as QualityLevel)
