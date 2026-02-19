@tool
class_name ChapterResource
extends Resource

@export var chapter_id: String = ""
@export var chapter_name: String = ""
@export_multiline var description: String = ""
@export var theme: GlobalEnums.ChapterTheme = GlobalEnums.ChapterTheme.FORGOTTEN_LIBRARY
@export var chapter_number: int = 1

@export_group("Encounters")
## Ordered list of encounters in this chapter.
@export var encounters: Array[EncounterResource] = []

@export_group("Difficulty")
@export_range(1, 10) var difficulty_level: int = 1
## Grimoire XP bonus awarded for completing the entire chapter.
@export var completion_xp_bonus: int = 25

@export_group("Alignment")
## The dominant alignment theme of this chapter. Opposing alignments get a clash bonus.
@export var chapter_alignment: GlobalEnums.Alignment = GlobalEnums.Alignment.PRIMAL


func get_node_count() -> int:
	return encounters.size()


func get_combat_count() -> int:
	var count: int = 0
	for enc: EncounterResource in encounters:
		if enc.node_type == GlobalEnums.NodeType.COMBAT or enc.node_type == GlobalEnums.NodeType.BOSS:
			count += 1
	return count
