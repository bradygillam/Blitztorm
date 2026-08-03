extends State
class_name FriendlyRotateToTarget

@export var nextState: State

@export var friendly: FriendlyBaseUnit

var targetVector: Vector2

func Enter() -> void:
	targetVector = PickTargetRotationVector()

func PhysicsUpdate(delta: float) -> void:
	if IsFacingTarget():
		Transitioned.emit(self, nextState)
	HandleRotation(delta)

func HandleRotation(delta: float) -> void:
	friendly.global_rotation = rotate_toward(friendly.global_rotation, (targetVector - friendly.global_position).angle(), friendly.GetObjectData().Rotation_Speed * delta)

func PickTargetRotationVector() -> Vector2:
	if friendly.enemyTargets.size() <= 0:
		return friendly.global_position + (1000 * Vector2.LEFT)
	else:
		return friendly.enemyTargets[0].global_position

func IsFacingTarget() -> bool:
	var directionToTarget: Vector2 = (targetVector - friendly.global_position).normalized()
	var facingDirection: Vector2 = Vector2.RIGHT.rotated(friendly.global_rotation)

	return facingDirection.dot(directionToTarget) > 0.99
