@tool
class_name EncounterResource
extends Resource

@export var encounter_id: String = ""
@export var encounter_name: String = ""
@export_multiline var description: String = ""
@export var node_type: GlobalEnums.NodeType = GlobalEnums.NodeType.COMBAT

@export_group("Combat")
@export var enemies: Array[EnemyResource] = []

@export_group("Moral Choice")
@export var moral_choice: MoralChoiceResource = null

@export_group("Treasure")
## Number of Lost Page options to present (pick 1).
@export_range(0, 5) var treasure_choices: int = 3
## Ink (currency) reward for this node.
@export var ink_reward: int = 0

@export_group("Rest")
## HP healed as percentage of max HP (0.0–1.0).
@export_range(0.0, 1.0) var rest_heal_percent: float = 0.3

@export_group("Rewards")
@export var grimoire_xp_reward: int = 5
