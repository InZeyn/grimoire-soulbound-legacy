@tool
extends SceneTree
## Run from command line: godot --headless --script res://tools/generate_placeholders.gd
## Generates all placeholder art and audio assets for Phase 5.


func _init() -> void:
	_generate_card_art()
	_generate_enemy_sprites()
	_generate_grimoire_covers()
	_generate_page_backgrounds()
	_generate_ui_elements()
	_generate_audio_stubs()
	print("All placeholder assets generated.")
	quit()


# --- Card Art (60 cards: 200x300) ---

func _generate_card_art() -> void:
	var types: Dictionary = {
		"atk": Color(0.8, 0.2, 0.2),
		"def": Color(0.2, 0.3, 0.8),
		"sup": Color(0.2, 0.7, 0.3),
		"spc": Color(0.6, 0.2, 0.7),
	}
	var card_names: Array[String] = [
		"arcane_bolt", "flame_strike", "shadow_cut", "lightning_lash", "poison_dart",
		"iron_wall", "mystic_barrier", "stone_skin", "ward_of_light", "shadow_cloak",
		"healing_word", "mana_surge", "battle_cry", "dark_pact", "natures_gift",
		"soul_rend", "void_step", "time_warp", "chaos_storm", "primal_roar",
		"ember_slash", "frost_shield", "vine_whip", "corruption_touch", "holy_smite",
		"blood_drain", "earth_shatter", "wind_slash", "death_mark", "life_bloom",
	]

	var dir_path: String = "res://assets/art/cards/"
	var idx: int = 0
	for card_name: String in card_names:
		var type_key: String = ["atk", "def", "sup", "spc"][idx % 4]
		var color: Color = types[type_key]
		var img: Image = _create_colored_rect(200, 300, color)

		# Base version
		img.save_png(dir_path + "card_%s_base.png" % card_name)

		# Evolved version (gold border effect via brighter center)
		var evolved_img: Image = _create_colored_rect(200, 300, color.lightened(0.3))
		evolved_img.save_png(dir_path + "card_%s_evolved.png" % card_name)
		idx += 1

	print("Generated %d card art files." % (card_names.size() * 2))


# --- Enemy Sprites (8 enemies: 160x200) ---

func _generate_enemy_sprites() -> void:
	var enemies: Dictionary = {
		"ink_wisp": Color(0.2, 0.2, 0.3),
		"page_golem": Color(0.7, 0.6, 0.4),
		"shadow_scribe": Color(0.15, 0.1, 0.2),
		"flame_keeper": Color(0.9, 0.4, 0.1),
		"vine_crawler": Color(0.2, 0.5, 0.15),
		"bone_librarian": Color(0.85, 0.8, 0.7),
		"crystal_sentinel": Color(0.3, 0.6, 0.9),
		"void_reader": Color(0.1, 0.05, 0.15),
	}
	var dir_path: String = "res://assets/art/enemies/"
	for enemy_name: String in enemies:
		var color: Color = enemies[enemy_name]
		var img: Image = _create_colored_rect(160, 200, color)
		img.save_png(dir_path + "enemy_%s.png" % enemy_name)
	print("Generated %d enemy sprites." % enemies.size())


# --- Grimoire Covers (5 covers: 512x512) ---

func _generate_grimoire_covers() -> void:
	var covers: Dictionary = {
		"leather": Color(0.45, 0.3, 0.15),
		"bone": Color(0.9, 0.88, 0.82),
		"crystal": Color(0.3, 0.5, 0.8),
		"cloth": Color(0.7, 0.15, 0.15),
		"metal": Color(0.5, 0.5, 0.55),
	}
	var dir_path: String = "res://assets/art/grimoire/"
	for cover_name: String in covers:
		var color: Color = covers[cover_name]
		var img: Image = _create_colored_rect(512, 512, color)
		img.save_png(dir_path + "cover_%s.png" % cover_name)
	print("Generated %d grimoire covers." % covers.size())


# --- Page Backgrounds (3 pages: 1920x1080) ---

func _generate_page_backgrounds() -> void:
	var pages: Dictionary = {
		"radiant": Color(0.85, 0.75, 0.5),
		"vile": Color(0.25, 0.15, 0.35),
		"primal": Color(0.3, 0.5, 0.25),
	}
	var dir_path: String = "res://assets/art/grimoire/"
	for page_name: String in pages:
		var color: Color = pages[page_name]
		var img: Image = _create_colored_rect(1920, 1080, color)
		img.save_png(dir_path + "page_%s.png" % page_name)
	print("Generated %d page backgrounds." % pages.size())


# --- UI Elements ---

func _generate_ui_elements() -> void:
	var dir_path: String = "res://assets/art/ui/"

	# HP bar fill (gradient green to red, 256x32)
	var hp_img: Image = Image.create(256, 32, false, Image.FORMAT_RGBA8)
	for x: int in range(256):
		var t: float = float(x) / 255.0
		var color: Color = Color(t, 1.0 - t, 0.0, 1.0)
		for y: int in range(32):
			hp_img.set_pixel(x, y, color)
	hp_img.save_png(dir_path + "hp_bar_fill.png")

	# Mana pip (blue circle, 32x32)
	var mana_img: Image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	var center: Vector2 = Vector2(16.0, 16.0)
	for x: int in range(32):
		for y: int in range(32):
			var dist: float = Vector2(float(x), float(y)).distance_to(center)
			if dist <= 14.0:
				mana_img.set_pixel(x, y, Color(0.2, 0.4, 0.9, 1.0))
			else:
				mana_img.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.0))
	mana_img.save_png(dir_path + "mana_pip.png")

	# Intent icons (32x32 each)
	var intent_sword: Image = _create_colored_rect(32, 32, Color(0.8, 0.2, 0.2))
	intent_sword.save_png(dir_path + "intent_attack.png")

	var intent_shield: Image = _create_colored_rect(32, 32, Color(0.3, 0.5, 0.8))
	intent_shield.save_png(dir_path + "intent_defend.png")

	var intent_buff: Image = _create_colored_rect(32, 32, Color(0.2, 0.8, 0.3))
	intent_buff.save_png(dir_path + "intent_buff.png")

	# Card frame (gold border on parchment, 200x300)
	var frame_img: Image = Image.create(200, 300, false, Image.FORMAT_RGBA8)
	var parchment: Color = Color(0.85, 0.78, 0.65, 1.0)
	var gold: Color = Color(0.85, 0.7, 0.3, 1.0)
	for x: int in range(200):
		for y: int in range(300):
			if x < 4 or x >= 196 or y < 4 or y >= 296:
				frame_img.set_pixel(x, y, gold)
			else:
				frame_img.set_pixel(x, y, parchment)
	frame_img.save_png(dir_path + "card_frame.png")

	print("Generated UI elements.")


# --- Audio Stubs ---

func _generate_audio_stubs() -> void:
	# Generate silent WAV stubs (44100Hz, 16-bit, mono)
	var music_dir: String = "res://assets/audio/music/"
	var sfx_dir: String = "res://assets/audio/sfx/"
	var ambient_dir: String = "res://assets/audio/ambient/"

	# Music stubs (1 second of silence as WAV, will be imported as-is)
	var music_files: Array[String] = [
		"mus_hub", "mus_combat_standard", "mus_combat_boss", "mus_moral_choice",
	]
	for file_name: String in music_files:
		_write_silent_wav(music_dir + file_name + ".wav", 44100)

	# SFX stubs (0.1 second of silence)
	var sfx_files: Array[String] = [
		"sfx_card_draw", "sfx_card_play", "sfx_damage", "sfx_heal", "sfx_block",
		"sfx_button_click", "sfx_page_turn", "sfx_card_discard", "sfx_card_evolve",
		"sfx_mana_spend", "sfx_mana_gain", "sfx_enemy_attack", "sfx_enemy_defend",
		"sfx_enemy_death", "sfx_player_hit", "sfx_status_apply", "sfx_status_tick",
		"sfx_attunement_shift", "sfx_grimoire_open", "sfx_grimoire_close",
	]
	for file_name: String in sfx_files:
		_write_silent_wav(sfx_dir + file_name + ".wav", 4410)

	# Ambient stubs (1 second of silence)
	var ambient_files: Array[String] = [
		"amb_library", "amb_archive_fire", "amb_forest",
	]
	for file_name: String in ambient_files:
		_write_silent_wav(ambient_dir + file_name + ".wav", 44100)

	print("Generated %d audio stubs." % (music_files.size() + sfx_files.size() + ambient_files.size()))


func _write_silent_wav(path: String, sample_count: int) -> void:
	# Write minimal WAV file: 44100Hz, 16-bit, mono, silent
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write: %s" % path)
		return
	var data_size: int = sample_count * 2  # 16-bit = 2 bytes per sample
	var file_size: int = 36 + data_size

	# RIFF header
	file.store_buffer("RIFF".to_ascii_buffer())
	file.store_32(file_size)
	file.store_buffer("WAVE".to_ascii_buffer())

	# fmt chunk
	file.store_buffer("fmt ".to_ascii_buffer())
	file.store_32(16)       # Chunk size
	file.store_16(1)        # PCM format
	file.store_16(1)        # Mono
	file.store_32(44100)    # Sample rate
	file.store_32(88200)    # Byte rate (44100 * 1 * 2)
	file.store_16(2)        # Block align (1 * 2)
	file.store_16(16)       # Bits per sample

	# data chunk
	file.store_buffer("data".to_ascii_buffer())
	file.store_32(data_size)
	# Write silence (zeros)
	var silence: PackedByteArray = PackedByteArray()
	silence.resize(data_size)
	silence.fill(0)
	file.store_buffer(silence)
	file.close()


func _create_colored_rect(width: int, height: int, color: Color) -> Image:
	var img: Image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	img.fill(color)
	return img
