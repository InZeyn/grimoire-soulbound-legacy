class_name BattleSceneController
extends Control

@onready var enemy_container: HBoxContainer = %EnemyContainer
@onready var card_hand: CardHandUI = %CardHand
@onready var battle_hud: BattleHUD = %BattleHUD
@onready var battle_log_label: Label = %BattleLogLabel
@onready var results_panel: PanelContainer = %ResultsPanel
@onready var results_label: Label = %ResultsLabel
@onready var continue_btn: Button = %ContinueBtn

var combat_manager: CombatManager = CombatManager.new()
var _selected_target: int = 0
var _enemy_displays: Array[EnemyDisplay] = []

const ENEMY_DISPLAY_SCENE_PATH: String = "res://scenes/battle/enemy_node.tscn"
var _enemy_display_scene: PackedScene = null


func _ready() -> void:
	_enemy_display_scene = load(ENEMY_DISPLAY_SCENE_PATH)
	results_panel.visible = false

	# Connect signals
	card_hand.card_selected.connect(_on_card_selected)
	battle_hud.attunement_changed.connect(_on_attunement_changed)
	battle_hud.end_turn_pressed.connect(_on_end_turn_pressed)
	continue_btn.pressed.connect(_on_continue_pressed)

	combat_manager.battle_state_changed.connect(_on_battle_state_changed)
	combat_manager.card_played.connect(_on_card_played)
	combat_manager.enemy_acted.connect(_on_enemy_acted)
	combat_manager.enemy_defeated.connect(_on_enemy_defeated)
	combat_manager.battle_ended.connect(_on_battle_ended)


func start_battle(grimoire: GrimoireResource, enemies: Array[EnemyResource]) -> void:
	_setup_enemy_displays(enemies)
	card_hand.setup(combat_manager)
	combat_manager.start_battle(grimoire, enemies)
	_begin_turn()


func _begin_turn() -> void:
	var drawn: Array[CardResource] = combat_manager.begin_player_turn()
	card_hand.display_hand(combat_manager.deck_manager.hand)
	_update_hud()
	_update_enemy_displays()
	battle_hud.set_interactive(true)
	_log("Turn %d — Draw %d cards. Choose your attunement and play cards." % [combat_manager.turn_number, drawn.size()])


func _setup_enemy_displays(enemies: Array[EnemyResource]) -> void:
	_enemy_displays.clear()
	for child: Node in enemy_container.get_children():
		child.queue_free()
	for i: int in range(enemies.size()):
		var display: EnemyDisplay = _enemy_display_scene.instantiate()
		enemy_container.add_child(display)
		display.setup(enemies[i], i)
		display.enemy_clicked.connect(_on_enemy_clicked)
		_enemy_displays.append(display)


func _update_hud() -> void:
	battle_hud.update_player_hp(combat_manager.player_hp, combat_manager.player_max_hp)
	battle_hud.update_mana(combat_manager.player_mana, combat_manager.player_max_mana)
	battle_hud.update_block(combat_manager.player_block)
	battle_hud.update_turn(combat_manager.turn_number)
	battle_hud.update_piles(
		combat_manager.deck_manager.get_draw_pile_size(),
		combat_manager.deck_manager.get_discard_pile_size()
	)
	battle_hud.update_attunement(combat_manager.attuned_alignment)
	battle_hud.update_statuses(combat_manager.player_statuses)


func _update_enemy_displays() -> void:
	for i: int in range(_enemy_displays.size()):
		if i >= combat_manager.enemies.size():
			continue
		var display: EnemyDisplay = _enemy_displays[i]
		display.update_hp(combat_manager.enemy_hp[i])
		display.update_block(combat_manager.enemy_block[i])

		# Show intent with value
		var intent: GlobalEnums.EnemyIntent = combat_manager.enemy_intents[i]
		var value: int = 0
		match intent:
			GlobalEnums.EnemyIntent.ATTACK:
				value = combat_manager.enemy_ai.get_attack_damage(
					combat_manager.enemies[i], combat_manager.turn_number
				)
			GlobalEnums.EnemyIntent.DEFEND:
				value = combat_manager.enemies[i].block_value
			GlobalEnums.EnemyIntent.BUFF, GlobalEnums.EnemyIntent.DEBUFF:
				value = combat_manager.enemies[i].buff_value
			GlobalEnums.EnemyIntent.SPECIAL:
				value = int(combat_manager.enemy_ai.get_attack_damage(
					combat_manager.enemies[i], combat_manager.turn_number
				) * 1.5)
		display.update_intent(intent, value)
		display.update_statuses(combat_manager.enemy_statuses[i])


func _log(text: String) -> void:
	battle_log_label.text = text


# --- Signal Handlers ---

func _on_card_selected(card: CardResource, _card_node: Control) -> void:
	if combat_manager.state != GlobalEnums.BattleState.PLAYER_TURN:
		return
	if not combat_manager.can_play_card(card):
		_log("Not enough mana to play %s (costs %d)." % [card.card_name, combat_manager.get_card_mana_cost(card)])
		return

	var results: Dictionary = combat_manager.play_card(card, _selected_target)
	if results.is_empty():
		return

	var damage: int = results.get("damage_dealt", 0)
	var healing: int = results.get("healing_done", 0)
	var block: int = results.get("block_gained", 0)
	var parts: PackedStringArray = PackedStringArray()
	if damage > 0:
		parts.append("%d damage" % damage)
	if healing > 0:
		parts.append("%d healing" % healing)
	if block > 0:
		parts.append("%d block" % block)

	_log("Played %s: %s" % [card.card_name, ", ".join(parts) if parts.size() > 0 else "effect applied"])
	card_hand.display_hand(combat_manager.deck_manager.hand)
	_update_hud()
	_update_enemy_displays()


func _on_enemy_clicked(index: int) -> void:
	_selected_target = index
	_log("Target: %s" % combat_manager.enemies[index].enemy_name)


func _on_attunement_changed(alignment: GlobalEnums.Alignment) -> void:
	combat_manager.set_attunement(alignment)
	var names: Array[String] = ["Radiant", "Vile", "Primal"]
	_log("Attuned to %s — matching cards cost 1 less mana." % names[alignment])
	battle_hud.update_attunement(alignment)
	card_hand.display_hand(combat_manager.deck_manager.hand)


func _on_end_turn_pressed() -> void:
	if combat_manager.state != GlobalEnums.BattleState.PLAYER_TURN:
		return
	battle_hud.set_interactive(false)
	combat_manager.end_player_turn()


func _on_battle_state_changed(new_state: GlobalEnums.BattleState) -> void:
	match new_state:
		GlobalEnums.BattleState.ENEMY_TURN:
			_log("Enemy turn...")
			# Use a timer to show enemy actions sequentially
			var results: Array[Dictionary] = combat_manager.execute_enemy_turn()
			for result: Dictionary in results:
				var idx: int = result.get("enemy_index", 0)
				var intent: GlobalEnums.EnemyIntent = result.get("intent", GlobalEnums.EnemyIntent.ATTACK)
				var enemy_name: String = combat_manager.enemies[idx].enemy_name if idx < combat_manager.enemies.size() else "Enemy"
				var msg: String = "%s: " % enemy_name
				match intent:
					GlobalEnums.EnemyIntent.ATTACK:
						msg += "attacks for %d damage" % result.get("damage_dealt", 0)
					GlobalEnums.EnemyIntent.DEFEND:
						msg += "gains %d block" % result.get("block_gained", 0)
					GlobalEnums.EnemyIntent.BUFF:
						msg += "buffs +%d strength" % result.get("buff_applied", 0)
					GlobalEnums.EnemyIntent.DEBUFF:
						msg += "debuffs -%d weakness" % result.get("debuff_applied", 0)
					GlobalEnums.EnemyIntent.SPECIAL:
						msg += "special attack for %d damage" % result.get("damage_dealt", 0)
				_log(msg)
			_update_hud()
			_update_enemy_displays()
		GlobalEnums.BattleState.PLAYER_TURN:
			if combat_manager.turn_number > 0:
				_begin_turn()


func _on_card_played(_card: CardResource, _results: Dictionary) -> void:
	pass


func _on_enemy_acted(_enemy_index: int, _intent: GlobalEnums.EnemyIntent, _results: Dictionary) -> void:
	pass


func _on_enemy_defeated(enemy_index: int) -> void:
	if enemy_index < _enemy_displays.size():
		_enemy_displays[enemy_index].modulate = Color(0.3, 0.3, 0.3, 0.5)
	_log("%s defeated!" % combat_manager.enemies[enemy_index].enemy_name)


func _on_battle_ended(final_state: GlobalEnums.BattleState) -> void:
	battle_hud.set_interactive(false)
	results_panel.visible = true

	if final_state == GlobalEnums.BattleState.VICTORY:
		var rewards: Dictionary = combat_manager.get_battle_rewards()
		combat_manager.apply_battle_rewards(rewards)
		results_label.text = "VICTORY!\n\nGrimoire XP: +%d\nTurns: %d" % [
			rewards.get("grimoire_xp", 0), combat_manager.turn_number
		]
	else:
		results_label.text = "DEFEAT\n\nYou fell in battle.\nTurns survived: %d" % combat_manager.turn_number


func _on_continue_pressed() -> void:
	# Return to hub (Phase 3 will wire this properly)
	get_tree().quit()
