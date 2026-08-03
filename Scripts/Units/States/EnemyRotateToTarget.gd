extends State
class_name EnemyRotateToTarget

@export var nextState: State

@export var enemy: EnemyBaseUnit

var targetVector: Vector2

func Enter() -> void:
	targetVector = PickTargetRotationVector()

func PhysicsUpdate(delta: float) -> void:
	if IsFacingTarget():
		Transitioned.emit(self, nextState)
	HandleRotation(delta)

func HandleRotation(delta: float) -> void:
	enemy.global_rotation = rotate_toward(enemy.global_rotation, (targetVector - enemy.global_position).angle(), enemy.GetObjectData().Rotation_Speed * delta)

func PickTargetRotationVector() -> Vector2:
	if enemy.enemyTargets.size() <= 0:
		return enemy.global_position + Vector2.RIGHT
	else:
		return enemy.enemyTargets[0].global_position

func IsFacingTarget() -> bool:
	var directionToTarget: Vector2 = (targetVector - enemy.global_position).normalized()
	var facingDirection: Vector2 = Vector2.RIGHT.rotated(enemy.global_rotation)

	return facingDirection.dot(directionToTarget) > 0.99
