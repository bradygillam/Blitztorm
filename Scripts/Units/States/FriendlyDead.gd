extends State
class_name FriendlyDead

@export var friendly: FriendlyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func Enter() -> void:
	UnitHandler.playerUnits.erase(friendly)
	friendly.z_index = 1
	characterAgent.collision_layer = 0
	characterAgent.collision_mask = 0
	navAgent.avoidance_enabled = false
