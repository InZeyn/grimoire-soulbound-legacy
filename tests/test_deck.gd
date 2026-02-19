extends SceneTree

## Test suite for DeckManager — draw pile, hand, discard, shuffle.

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("\n=== DECK MANAGER TESTS ===\n")

	test_initialize()
	test_draw_cards()
	test_play_card()
	test_discard_hand()
	test_reshuffle_on_empty_draw()
	test_max_hand_size()
	test_draw_more_than_available()

	print("\n=== RESULTS: %d passed, %d failed ===" % [_pass_count, _fail_count])
	if _fail_count > 0:
		print("SOME TESTS FAILED!")
	else:
		print("ALL TESTS PASSED!")
	quit()


func _assert(condition: bool, test_name: String) -> void:
	if condition:
		_pass_count += 1
		print("  PASS: %s" % test_name)
	else:
		_fail_count += 1
		print("  FAIL: %s" % test_name)


func _make_cards(count: int) -> Array[CardResource]:
	var cards: Array[CardResource] = []
	for i: int in range(count):
		var card: CardResource = CardResource.new()
		card.card_id = "test_card_%d" % i
		card.card_name = "Test Card %d" % i
		card.mana_cost = 1
		card.base_value = i + 1
		cards.append(card)
	return cards


func test_initialize() -> void:
	print("-- Initialize --")
	var dm: DeckManager = DeckManager.new()
	var cards: Array[CardResource] = _make_cards(10)
	dm.initialize(cards, 42)
	_assert(dm.get_draw_pile_size() == 10, "Draw pile has 10 cards")
	_assert(dm.get_hand_size() == 0, "Hand is empty")
	_assert(dm.get_discard_pile_size() == 0, "Discard is empty")


func test_draw_cards() -> void:
	print("-- Draw Cards --")
	var dm: DeckManager = DeckManager.new()
	dm.initialize(_make_cards(20), 42)
	var drawn: Array[CardResource] = dm.draw_cards(5)
	_assert(drawn.size() == 5, "Drew 5 cards")
	_assert(dm.get_hand_size() == 5, "Hand has 5 cards")
	_assert(dm.get_draw_pile_size() == 15, "Draw pile has 15 remaining")


func test_play_card() -> void:
	print("-- Play Card --")
	var dm: DeckManager = DeckManager.new()
	dm.initialize(_make_cards(20), 42)
	dm.draw_cards(5)
	var card: CardResource = dm.hand[0]
	var success: bool = dm.play_card(card)
	_assert(success, "Play card returns true")
	_assert(dm.get_hand_size() == 4, "Hand reduced to 4")
	_assert(dm.get_discard_pile_size() == 1, "Discard has 1 card")


func test_discard_hand() -> void:
	print("-- Discard Hand --")
	var dm: DeckManager = DeckManager.new()
	dm.initialize(_make_cards(20), 42)
	dm.draw_cards(5)
	dm.discard_hand()
	_assert(dm.get_hand_size() == 0, "Hand is empty after discard")
	_assert(dm.get_discard_pile_size() == 5, "Discard has 5 cards")


func test_reshuffle_on_empty_draw() -> void:
	print("-- Reshuffle on Empty Draw --")
	var dm: DeckManager = DeckManager.new()
	dm.initialize(_make_cards(6), 42)
	dm.draw_cards(5)
	dm.discard_hand()
	# Draw pile has 1 card, discard has 5. Drawing 5 should trigger reshuffle.
	var drawn: Array[CardResource] = dm.draw_cards(5)
	_assert(drawn.size() == 5, "Drew 5 cards after reshuffle")
	_assert(dm.get_hand_size() == 5, "Hand has 5 cards")
	_assert(dm.get_discard_pile_size() == 0, "Discard is empty after reshuffle")


func test_max_hand_size() -> void:
	print("-- Max Hand Size --")
	var dm: DeckManager = DeckManager.new()
	dm.initialize(_make_cards(20), 42)
	dm.draw_cards(10)
	_assert(dm.get_hand_size() == 10, "Hand capped at MAX_HAND_SIZE (10)")
	var extra: Array[CardResource] = dm.draw_cards(5)
	_assert(extra.size() == 0, "Cannot draw past max hand size")
	_assert(dm.get_hand_size() == 10, "Hand still 10")


func test_draw_more_than_available() -> void:
	print("-- Draw More Than Available --")
	var dm: DeckManager = DeckManager.new()
	dm.initialize(_make_cards(3), 42)
	var drawn: Array[CardResource] = dm.draw_cards(5)
	_assert(drawn.size() == 3, "Drew only 3 (all available)")
	_assert(dm.get_hand_size() == 3, "Hand has 3")
	_assert(dm.get_draw_pile_size() == 0, "Draw pile empty")
