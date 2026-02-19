extends Node

enum TransitionType { FADE, PAGE_TURN, INSTANT }

var _canvas_layer: CanvasLayer = null
var _overlay: ColorRect = null
var _is_transitioning: bool = false

const PAGE_TURN_SHADER_PATH: String = "res://assets/shaders/page_turn.gdshader"


func _ready() -> void:
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 100
	add_child(_canvas_layer)

	_overlay = ColorRect.new()
	_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_canvas_layer.add_child(_overlay)


func transition_to(scene_path: String, transition_type: TransitionType = TransitionType.FADE) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	match transition_type:
		TransitionType.INSTANT:
			get_tree().change_scene_to_file(scene_path)
			_is_transitioning = false
		TransitionType.FADE:
			await _fade_transition(scene_path)
		TransitionType.PAGE_TURN:
			await _page_turn_transition(scene_path)


func _fade_transition(scene_path: String) -> void:
	_overlay.material = null
	_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP

	# Fade to black
	var tween: Tween = create_tween()
	tween.tween_property(_overlay, "color:a", 1.0, 0.5)
	await tween.finished

	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame

	# Fade from black
	var tween_out: Tween = create_tween()
	tween_out.tween_property(_overlay, "color:a", 0.0, 0.5)
	await tween_out.finished

	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_is_transitioning = false


func _page_turn_transition(scene_path: String) -> void:
	var shader: Shader = load(PAGE_TURN_SHADER_PATH) as Shader
	if shader == null:
		await _fade_transition(scene_path)
		return

	var mat: ShaderMaterial = ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("progress", 0.0)
	_overlay.material = mat
	_overlay.color = Color.WHITE
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP

	# Page turn forward
	var tween: Tween = create_tween()
	tween.tween_method(func(val: float) -> void: mat.set_shader_parameter("progress", val), 0.0, 1.0, 0.6)
	await tween.finished

	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame

	# Page turn reverse
	var tween_out: Tween = create_tween()
	tween_out.tween_method(func(val: float) -> void: mat.set_shader_parameter("progress", val), 1.0, 0.0, 0.6)
	await tween_out.finished

	_overlay.material = null
	_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_is_transitioning = false
