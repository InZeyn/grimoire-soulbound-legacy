class_name ChapterGenerator
extends RefCounted

## Loads handcrafted chapters from the resources directory.
## For MVP, chapters are pre-authored .tres files, not procedurally generated.

const CHAPTER_DIR: String = "res://resources/chapters/"


func load_chapter(chapter_id: String) -> ChapterResource:
	var path: String = CHAPTER_DIR + chapter_id + ".tres"
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path) as ChapterResource
	return null


func load_all_chapters() -> Array[ChapterResource]:
	var chapters: Array[ChapterResource] = []
	var dir: DirAccess = DirAccess.open(CHAPTER_DIR)
	if dir == null:
		return chapters
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var path: String = CHAPTER_DIR + file_name
			var chapter: ChapterResource = ResourceLoader.load(path) as ChapterResource
			if chapter != null:
				chapters.append(chapter)
		file_name = dir.get_next()
	dir.list_dir_end()
	# Sort by chapter number
	chapters.sort_custom(func(a: ChapterResource, b: ChapterResource) -> bool:
		return a.chapter_number < b.chapter_number
	)
	return chapters


## Returns whether the player's grimoire meets the minimum level for a chapter.
func can_enter_chapter(chapter: ChapterResource, grimoire: GrimoireResource) -> bool:
	return grimoire.grimoire_level >= chapter.difficulty_level


## Checks if the player's alignment opposes the chapter's alignment (clash bonus).
func has_alignment_clash(chapter: ChapterResource, grimoire: GrimoireResource) -> bool:
	var player_align: GlobalEnums.Alignment = grimoire.get_dominant_alignment()
	return player_align != chapter.chapter_alignment
