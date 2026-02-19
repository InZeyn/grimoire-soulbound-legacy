class_name InscriptionManager
extends RefCounted

## Manages inscription slots, equip/unequip, and passive buff application.
## Inscriptions are alignment-filtered permanent passive buffs.

## Known effect keys and their meanings:
## "heal_bonus" — Healing cards restore +N HP
## "poison_duration" — Poison duration +N turns
## "multi_hit_bonus" — Multi-hit cards gain +N hits
## "block_bonus" — Block cards gain +N block
## "mana_start_bonus" — Start battle with +N mana
## "draw_bonus" — Draw +N extra cards per turn


func get_available_inscriptions(grimoire: GrimoireResource) -> Array[InscriptionResource]:
	## Returns inscriptions matching grimoire's dominant alignment or any if conflicted.
	var all_inscriptions: Array[InscriptionResource] = _load_all_inscriptions()
	var dominant: GlobalEnums.Alignment = grimoire.get_dominant_alignment()
	var is_conflicted: bool = grimoire.is_conflicted()

	var available: Array[InscriptionResource] = []
	for insc: InscriptionResource in all_inscriptions:
		if is_conflicted or insc.alignment == dominant:
			available.append(insc)
	return available


func can_equip(grimoire: GrimoireResource) -> bool:
	return grimoire.inscriptions.size() < grimoire.get_inscription_slot_count()


func equip_inscription(grimoire: GrimoireResource, inscription: InscriptionResource) -> bool:
	## Equips an inscription if a slot is available. Returns true on success.
	if not can_equip(grimoire):
		return false
	# Prevent duplicate inscriptions
	for existing: Resource in grimoire.inscriptions:
		var existing_insc: InscriptionResource = existing as InscriptionResource
		if existing_insc != null and existing_insc.inscription_id == inscription.inscription_id:
			return false
	grimoire.inscriptions.append(inscription)
	return true


func unequip_inscription(grimoire: GrimoireResource, inscription_id: String) -> bool:
	## Removes an inscription by ID. Returns true if found and removed.
	for i: int in range(grimoire.inscriptions.size()):
		var insc: InscriptionResource = grimoire.inscriptions[i] as InscriptionResource
		if insc != null and insc.inscription_id == inscription_id:
			grimoire.inscriptions.remove_at(i)
			return true
	return false


func get_effect_value(grimoire: GrimoireResource, effect_key: String) -> int:
	## Returns the total value for a given effect key across all equipped inscriptions.
	var total: int = 0
	for res: Resource in grimoire.inscriptions:
		var insc: InscriptionResource = res as InscriptionResource
		if insc != null and insc.effect_key == effect_key:
			total += insc.effect_value
	return total


func _load_all_inscriptions() -> Array[InscriptionResource]:
	var result: Array[InscriptionResource] = []
	var dir: DirAccess = DirAccess.open("res://resources/inscriptions/")
	if dir == null:
		return result
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var insc: InscriptionResource = ResourceLoader.load("res://resources/inscriptions/" + file_name) as InscriptionResource
			if insc != null:
				result.append(insc)
		file_name = dir.get_next()
	dir.list_dir_end()
	return result
