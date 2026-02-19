extends Node

signal music_beat

const MAX_SIMULTANEOUS_STREAMS: int = 12

var _music_player: AudioStreamPlayer = null
var _crossfade_player: AudioStreamPlayer = null
var _active_streams: Array[AudioStreamPlayer] = []
var _beat_timer: Timer = null
var _music_layers: Array[AudioStreamPlayer] = []


func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = &"Music"
	add_child(_music_player)

	_crossfade_player = AudioStreamPlayer.new()
	_crossfade_player.bus = &"Music"
	add_child(_crossfade_player)

	_beat_timer = Timer.new()
	_beat_timer.wait_time = 0.5
	_beat_timer.autostart = true
	_beat_timer.timeout.connect(_on_beat_timer)
	add_child(_beat_timer)


func play_sfx(stream: AudioStream, bus: StringName = &"SFX") -> void:
	if stream == null:
		return
	_cleanup_finished_streams()
	if _active_streams.size() >= MAX_SIMULTANEOUS_STREAMS:
		return
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
	_active_streams.append(player)


func play_music(stream: AudioStream) -> void:
	if stream == null:
		return
	_music_player.stream = stream
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()
	for layer: AudioStreamPlayer in _music_layers:
		layer.stop()


func crossfade_music(new_stream: AudioStream, duration: float = 1.0) -> void:
	if new_stream == null:
		return
	_crossfade_player.stream = new_stream
	_crossfade_player.volume_db = -80.0
	_crossfade_player.play()

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(_music_player, "volume_db", -80.0, duration)
	tween.tween_property(_crossfade_player, "volume_db", 0.0, duration)
	tween.set_parallel(false)
	tween.tween_callback(_swap_music_players)


func set_music_layer_active(layer_index: int, active: bool) -> void:
	if layer_index < 0 or layer_index >= _music_layers.size():
		return
	var target_db: float = 0.0 if active else -80.0
	var tween: Tween = create_tween()
	tween.tween_property(_music_layers[layer_index], "volume_db", target_db, 0.5)


func set_bus_volume(bus_name: StringName, linear: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return
	var db: float = linear_to_db(clampf(linear, 0.0, 1.0))
	AudioServer.set_bus_volume_db(bus_idx, db)


func get_bus_volume(bus_name: StringName) -> float:
	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return 0.0
	return db_to_linear(AudioServer.get_bus_volume_db(bus_idx))


func _swap_music_players() -> void:
	var temp: AudioStreamPlayer = _music_player
	_music_player = _crossfade_player
	_crossfade_player = temp
	_crossfade_player.stop()
	_music_player.volume_db = 0.0


func _cleanup_finished_streams() -> void:
	var still_active: Array[AudioStreamPlayer] = []
	for player: AudioStreamPlayer in _active_streams:
		if is_instance_valid(player) and player.playing:
			still_active.append(player)
	_active_streams = still_active


func _on_beat_timer() -> void:
	music_beat.emit()
