extends State
class_name EnemySpawn

@export var enemy: EnemyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func _ready() -> void:
	navAgent.velocity_computed.connect(UpdateCharacterAgent)

func Enter() -> void:
	enemy.destination = GlobalHelper.GetSpawnTargetVector(enemy.global_position, true)
	navAgent.target_position = enemy.destination
	characterAgent.set_collision_mask_value(5, false)

func Exit() -> void:
	navAgent.velocity = Vector2.ZERO
	characterAgent.velocity = Vector2.ZERO
	characterAgent.set_collision_mask_value(5, true)

func PhysicsUpdate(delta: float) -> void:
	if navAgent.is_navigation_finished():
		Transitioned.emit(self, "EnemyIdle")
	var next_point = navAgent.get_next_path_position()
	var direction = (next_point - characterAgent.global_position).normalized()
	var desired_velocity = direction * enemy.unitData.Movement_Speed
	characterAgent.rotation = lerp_angle(
		characterAgent.rotation,
		desired_velocity.angle(),
		enemy.unitData.Rotation_Speed * delta
	)
	navAgent.velocity = desired_velocity

func UpdateCharacterAgent(safe_velocity: Vector2):
	characterAgent.velocity = safe_velocity
	characterAgent.move_and_slide()
