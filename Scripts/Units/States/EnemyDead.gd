extends State
class_name EnemyDead

@export var enemy: EnemyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func Enter() -> void:
	UnitHandler.enemyUnits.erase(enemy)
	characterAgent.set_physics_process(false)
	characterAgent.set_process(false)
	enemy.z_index = 1
	characterAgent.collision_layer = 0
	characterAgent.collision_mask = 0
	navAgent.avoidance_enabled = false
	await enemy.get_tree().create_timer(10).timeout
	enemy.queue_free()
