class_name MasteryTracker
extends RefCounted

## Awards XP for a standard card use in battle.
func on_card_used(card: CardResource) -> void:
	card.add_xp(1)


## Awards XP for a kill or combo.
func on_card_kill_or_combo(card: CardResource) -> void:
	card.add_xp(2)


## Awards XP for a perfect play.
func on_perfect_play(card: CardResource) -> void:
	card.add_xp(5)
