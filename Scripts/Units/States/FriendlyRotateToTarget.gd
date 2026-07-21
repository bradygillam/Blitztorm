extends State
class_name FriendlyRotateToTarget

@export var friendly: FriendlyBaseUnit

var targetVector: Vector2

func Enter() -> void:
	targetVector = PickTargetRotationVector()

func PhysicsUpdate(delta: float) -> void:
	if IsFacingTarget():
		Transitioned.emit(self, "FriendlyAttack")
	HandleRotation(delta)

func HandleRotation(delta: float) -> void:
	friendly.rotation = rotate_toward(friendly.rotation, (targetVector - friendly.global_position).angle(), friendly.unitData.Rotation_Speed * delta)

func PickTargetRotationVector() -> Vector2:
	if friendly.enemyTargets.size() <= 0:
		return friendly.position + Vector2.LEFT
	else:
		return friendly.enemyTargets[0].global_position

func IsFacingTarget() -> bool:
	var directionToTarget: Vector2 = (targetVector - friendly.global_position).normalized()
	var facingDirection: Vector2 = Vector2.RIGHT.rotated(friendly.rotation)

	return facingDirection.dot(directionToTarget) > 0.99
