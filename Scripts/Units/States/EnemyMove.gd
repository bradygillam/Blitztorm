extends State
class_name EnemyMove

@export var enemy: EnemyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func _ready() -> void:
	navAgent.velocity_computed.connect(UpdateCharacterAgent)

func Enter() -> void:
	var movementAreaVectors: Array[Vector2]
	movementAreaVectors = GlobalHelper.GetMovementRectangleVectors(
		enemy.position, 
		enemy.unitData.Movement_ForwardStep, 
		enemy.unitData.Movement_ForwardVarience, 
		enemy.unitData.Movement_VerticalVarience)
	enemy.destination = GlobalHelper.GetRandomVectorInRectangle(movementAreaVectors[0], movementAreaVectors[1])
	navAgent.target_position = enemy.destination

func Exit() -> void:
	navAgent.velocity = Vector2.ZERO
	characterAgent.velocity = Vector2.ZERO

func PhysicsUpdate(delta: float) -> void:
	if navAgent.is_navigation_finished() or !navAgent.is_target_reachable():
		Transitioned.emit(self, "EnemyIdle")
		return
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
