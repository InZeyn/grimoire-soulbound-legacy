class_name AnimationHelper
extends RefCounted


static func card_draw(node: Control, from: Vector2, to: Vector2, duration: float = 0.3) -> Tween:
	node.position = from
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "position", to, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	return tween


static func card_play(node: Control, target: Vector2, duration: float = 0.25) -> Tween:
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "position", target, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	return tween


static func damage_flash(node: CanvasItem, duration: float = 0.2) -> Tween:
	var mat: ShaderMaterial = node.material as ShaderMaterial
	if mat == null:
		return null
	mat.set_shader_parameter("flash_intensity", 1.0)
	var tween: Tween = node.create_tween()
	tween.tween_method(
		func(val: float) -> void: mat.set_shader_parameter("flash_intensity", val),
		1.0, 0.0, duration
	)
	return tween


static func enemy_hit(node: Control, duration: float = 0.15) -> Tween:
	var original_x: float = node.position.x
	var tween: Tween = node.create_tween()
	tween.tween_property(node, "position:x", original_x + 4.0, duration * 0.25)
	tween.tween_property(node, "position:x", original_x - 4.0, duration * 0.25)
	tween.tween_property(node, "position:x", original_x + 2.0, duration * 0.25)
	tween.tween_property(node, "position:x", original_x, duration * 0.25)
	return tween


static func enemy_death(node: CanvasItem, duration: float = 0.4) -> Tween:
	var tween: Tween = node.create_tween()
	tween.set_parallel(true)
	tween.tween_property(node, "modulate:a", 0.0, duration)
	tween.tween_property(node, "scale", Vector2(0.5, 0.5), duration)
	return tween


static func aura_breathe(node: CanvasItem) -> Tween:
	var tween: Tween = node.create_tween()
	tween.set_loops()
	tween.tween_property(node, "modulate:a", 0.5, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "modulate:a", 1.0, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	return tween


static func sigil_rotate(node: Control) -> Tween:
	var tween: Tween = node.create_tween()
	tween.set_loops()
	tween.tween_property(node, "rotation", TAU, 5.0).as_relative()
	return tween


static func page_flutter(node: Control) -> Tween:
	var original_y: float = node.position.y
	var tween: Tween = node.create_tween()
	tween.set_loops()
	var wait_time: float = randf_range(8.0, 15.0)
	tween.tween_interval(wait_time)
	tween.tween_property(node, "position:y", original_y - 2.0, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "position:y", original_y + 1.0, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "position:y", original_y, 0.2).set_trans(Tween.TRANS_SINE)
	return tween
