class_name AlignmentManager
extends RefCounted

## Shifts a grimoire's alignment from a moral choice event.
func apply_moral_choice(grimoire: GrimoireResource, alignment: GlobalEnums.Alignment, amount: int) -> void:
	shift(grimoire, alignment, amount)


## Applies the per-battle alignment drift from using alignment-matching cards.
func apply_battle_usage(grimoire: GrimoireResource, alignment: GlobalEnums.Alignment) -> void:
	shift(grimoire, alignment, 1)


## Shared alignment shift — used by AlignmentManager and EvolutionManager.
static func shift(grimoire: GrimoireResource, alignment: GlobalEnums.Alignment, amount: int) -> void:
	match alignment:
		GlobalEnums.Alignment.RADIANT:
			grimoire.alignment_radiant = clampi(grimoire.alignment_radiant + amount, 0, 100)
		GlobalEnums.Alignment.VILE:
			grimoire.alignment_vile = clampi(grimoire.alignment_vile + amount, 0, 100)
		GlobalEnums.Alignment.PRIMAL:
			grimoire.alignment_primal = clampi(grimoire.alignment_primal + amount, 0, 100)
