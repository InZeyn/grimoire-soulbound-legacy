class_name EncounterManager
extends RefCounted

signal encounter_started(encounter: EncounterResource, index: int)
signal encounter_completed(encounter: EncounterResource, index: int)
signal chapter_completed(chapter: ChapterResource, rewards: Dictionary)
signal chapter_failed(chapter: ChapterResource)
signal extraction_risk_triggered(lost_pages_removed: int)

var chapter: ChapterResource = null
var grimoire: GrimoireResource = null
var current_encounter_index: int = -1
var is_active: bool = false

## Lost pages found during this chapter run (not yet permanently bound).
var pending_lost_pages: Array[CardResource] = []
## Player HP carried across encounters within a chapter.
var player_hp: int = 50
var player_max_hp: int = 50

## Track completed encounters for rewards.
var _completed_encounters: Array[int] = []


func start_chapter(p_chapter: ChapterResource, p_grimoire: GrimoireResource, start_hp: int = 50) -> void:
	chapter = p_chapter
	grimoire = p_grimoire
	current_encounter_index = -1
	is_active = true
	pending_lost_pages.clear()
	_completed_encounters.clear()
	player_hp = start_hp
	player_max_hp = start_hp


func get_current_encounter() -> EncounterResource:
	if chapter == null or current_encounter_index < 0 or current_encounter_index >= chapter.encounters.size():
		return null
	return chapter.encounters[current_encounter_index]


func advance_to_next() -> EncounterResource:
	current_encounter_index += 1
	if current_encounter_index >= chapter.encounters.size():
		_on_chapter_complete()
		return null
	var enc: EncounterResource = chapter.encounters[current_encounter_index]
	encounter_started.emit(enc, current_encounter_index)
	return enc


func complete_current_encounter(battle_result: Dictionary = {}) -> void:
	if current_encounter_index < 0 or current_encounter_index >= chapter.encounters.size():
		return
	var enc: EncounterResource = chapter.encounters[current_encounter_index]

	# Award encounter XP
	grimoire.grimoire_xp += enc.grimoire_xp_reward

	# Update player HP from battle result
	if battle_result.has("player_hp"):
		player_hp = battle_result["player_hp"]

	_completed_encounters.append(current_encounter_index)
	encounter_completed.emit(enc, current_encounter_index)


func fail_chapter() -> void:
	is_active = false
	# Extraction risk: lose all pending (unbound) lost pages
	var pages_lost: int = pending_lost_pages.size()
	if pages_lost > 0:
		extraction_risk_triggered.emit(pages_lost)
	pending_lost_pages.clear()
	chapter_failed.emit(chapter)


func add_pending_lost_page(card: CardResource) -> void:
	pending_lost_pages.append(card)


func apply_rest(enc: EncounterResource) -> int:
	var heal_amount: int = int(player_max_hp * enc.rest_heal_percent)
	player_hp = mini(player_hp + heal_amount, player_max_hp)
	return heal_amount


func apply_moral_choice(choice: MoralChoiceResource, option_index: int) -> Dictionary:
	var alignment: GlobalEnums.Alignment
	var shift: int
	var result_text: String

	match option_index:
		0:
			alignment = choice.option_a_alignment
			shift = choice.option_a_shift
			result_text = choice.option_a_result_text
		1:
			alignment = choice.option_b_alignment
			shift = choice.option_b_shift
			result_text = choice.option_b_result_text
		2:
			alignment = choice.option_c_alignment
			shift = choice.option_c_shift
			result_text = choice.option_c_result_text
		_:
			return {}

	AlignmentManager.shift(grimoire, alignment, shift)
	return {
		"alignment": alignment,
		"shift": shift,
		"result_text": result_text,
	}


func get_chapter_progress() -> float:
	if chapter == null or chapter.encounters.is_empty():
		return 0.0
	return float(_completed_encounters.size()) / float(chapter.encounters.size())


func get_remaining_encounters() -> int:
	if chapter == null:
		return 0
	return chapter.encounters.size() - current_encounter_index - 1


func _on_chapter_complete() -> void:
	is_active = false
	# Bind pending lost pages to grimoire
	var bound_count: int = 0
	for page: CardResource in pending_lost_pages:
		if grimoire.lost_pages.size() < grimoire.get_max_lost_pages():
			grimoire.lost_pages.append(page)
			bound_count += 1
	pending_lost_pages.clear()

	# Award chapter completion bonus
	grimoire.grimoire_xp += chapter.completion_xp_bonus

	var rewards: Dictionary = {
		"completion_xp": chapter.completion_xp_bonus,
		"total_encounter_xp": _get_total_encounter_xp(),
		"lost_pages_bound": bound_count,
		"encounters_completed": _completed_encounters.size(),
	}
	chapter_completed.emit(chapter, rewards)


func _get_total_encounter_xp() -> int:
	var total: int = 0
	for idx: int in _completed_encounters:
		if idx < chapter.encounters.size():
			total += chapter.encounters[idx].grimoire_xp_reward
	return total
