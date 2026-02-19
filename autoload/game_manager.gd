extends Node

const GRIMOIRE_SAVE_DIR: String = "user://grimoires/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(GRIMOIRE_SAVE_DIR)


## Atomic save: writes to .tmp first, then renames to final path.
func save_grimoire(grimoire: GrimoireResource, filename: String) -> Error:
	var final_path: String = GRIMOIRE_SAVE_DIR + filename + ".tres"
	var tmp_path: String = GRIMOIRE_SAVE_DIR + filename + ".tmp.tres"
	var err: Error = ResourceSaver.save(grimoire, tmp_path)
	if err != OK:
		return err
	var dir: DirAccess = DirAccess.open(GRIMOIRE_SAVE_DIR)
	if dir == null:
		return ERR_CANT_OPEN
	if dir.file_exists(filename + ".tres"):
		dir.remove(filename + ".tres")
	return dir.rename(filename + ".tmp.tres", filename + ".tres")


func load_grimoire(filename: String) -> GrimoireResource:
	var path: String = GRIMOIRE_SAVE_DIR + filename + ".tres"
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path) as GrimoireResource
	return null
