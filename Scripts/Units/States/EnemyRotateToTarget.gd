extends State
class_name EnemyRotateToTarget

@export var enemy: EnemyBaseUnit

var targetVector: Vector2

func Enter() -> void:
	targetVector = PickTargetRotationVector()

func PhysicsUpdate(delta: float) -> void:
	if IsFacingTarget():
		Transitioned.emit(self, "EnemyAttack")
	HandleRotation(delta)

func HandleRotation(delta: float) -> void:
	enemy.rotation = rotate_toward(enemy.rotation, (targetVector - enemy.global_position).angle(), enemy.unitData.Rotation_Speed * delta)

func PickTargetRotationVector() -> Vector2:
	if enemy.enemyTargets.size() <= 0:
		return enemy.position + Vector2.LEFT
	else:
		return enemy.enemyTargets[0].global_position

func IsFacingTarget() -> bool:
	var directionToTarget: Vector2 = (targetVector - enemy.global_position).normalized()
	var facingDirection: Vector2 = Vector2.RIGHT.rotated(enemy.rotation)

	return facingDirection.dot(directionToTarget) > 0.99
