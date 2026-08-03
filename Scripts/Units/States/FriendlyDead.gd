extends State
class_name FriendlyDead

@export var friendly: FriendlyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func Enter() -> void:
	UnitHandler.playerUnits.erase(friendly)
	if characterAgent:
		characterAgent.set_physics_process(false)
		characterAgent.set_process(false)
		characterAgent.collision_layer = 0
		characterAgent.collision_mask = 0
	if navAgent:
		navAgent.avoidance_enabled = false
	friendly.z_index = 1
	await friendly.get_tree().create_timer(10).timeout
	friendly.queue_free()
