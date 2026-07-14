extends State
class_name FriendlyMove

@export var friendly: FriendlyBaseUnit
var destinationVector: Vector2

func Enter() -> void:
	destinationVector = friendly.destination

func Exit() -> void:
	pass

func Update(delta: float) -> void:
	HandleMovement(delta)
	if friendly.position.distance_to(destinationVector) < 1:
		Transitioned.emit(self, "FriendlyIdle")

func HandleMovement(delta: float) -> void:
	friendly.position = friendly.position.move_toward(destinationVector, friendly.unitData.Movement_Speed * delta)
	friendly.rotation = rotate_toward(friendly.rotation, (destinationVector - friendly.global_position).angle(), friendly.unitData.Rotation_Speed * delta)
