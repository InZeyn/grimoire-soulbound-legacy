class_name EvolutionManager
extends RefCounted

## Evolves a card along the chosen alignment path and shifts the grimoire's alignment.
## Returns the evolved CardResource, or null if evolution is not possible.
func evolve_card(card: CardResource, chosen_alignment: GlobalEnums.Alignment, grimoire: GrimoireResource) -> CardResource:
	if not card.can_evolve():
		return null

	var evolved: CardResource = card.get_evolution_for_alignment(chosen_alignment)
	if evolved == null:
		return null

	AlignmentManager.shift(grimoire, chosen_alignment, 10)
	return evolved
