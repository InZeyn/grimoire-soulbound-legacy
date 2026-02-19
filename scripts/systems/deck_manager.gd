class_name DeckManager
extends RefCounted

var draw_pile: Array[CardResource] = []
var hand: Array[CardResource] = []
var discard_pile: Array[CardResource] = []

const MAX_HAND_SIZE: int = 10
const DRAW_PER_TURN: int = 5

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func initialize(cards: Array[CardResource], rng_seed: int = 0) -> void:
	draw_pile = cards.duplicate()
	hand.clear()
	discard_pile.clear()
	if rng_seed != 0:
		_rng.seed = rng_seed
	else:
		_rng.randomize()
	_shuffle_draw_pile()


func draw_cards(count: int = DRAW_PER_TURN) -> Array[CardResource]:
	var drawn: Array[CardResource] = []
	for i: int in range(count):
		if hand.size() >= MAX_HAND_SIZE:
			break
		if draw_pile.is_empty():
			_reshuffle_discard_into_draw()
		if draw_pile.is_empty():
			break
		var card: CardResource = draw_pile.pop_back()
		hand.append(card)
		drawn.append(card)
	return drawn


func play_card(card: CardResource) -> bool:
	var idx: int = hand.find(card)
	if idx == -1:
		return false
	hand.remove_at(idx)
	discard_pile.append(card)
	return true


func discard_hand() -> void:
	discard_pile.append_array(hand)
	hand.clear()


func get_hand_size() -> int:
	return hand.size()


func get_draw_pile_size() -> int:
	return draw_pile.size()


func get_discard_pile_size() -> int:
	return discard_pile.size()


func _shuffle_draw_pile() -> void:
	for i: int in range(draw_pile.size() - 1, 0, -1):
		var j: int = _rng.randi_range(0, i)
		var temp: CardResource = draw_pile[i]
		draw_pile[i] = draw_pile[j]
		draw_pile[j] = temp


func _reshuffle_discard_into_draw() -> void:
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
	_shuffle_draw_pile()
