extends State
class_name EnemyMove

@export var enemy: EnemyBaseUnit
var destinationVector: Vector2


func Enter() -> void:
	var movementAreaVectors: Array[Vector2]
	movementAreaVectors = GlobalHelper.GetMovementRectangleVectors(
		enemy.position, 
		enemy.unitData.Movement_ForwardStep, 
		enemy.unitData.Movement_ForwardVarience, 
		enemy.unitData.Movement_VerticalVarience)
	destinationVector = GlobalHelper.GetRandomVectorInRectangle(movementAreaVectors[0], movementAreaVectors[1])

func Exit() -> void:
	pass

func Update(delta: float) -> void:
	HandleMovement(delta)
	if enemy.position.distance_to(destinationVector) < 1:
		Transitioned.emit(self, "EnemyIdle")

func HandleMovement(delta: float) -> void:
	enemy.position = enemy.position.move_toward(destinationVector, enemy.unitData.Movement_Speed * delta)
	enemy.rotation = rotate_toward(enemy.rotation, (destinationVector - enemy.global_position).angle(), enemy.unitData.Rotation_Speed * delta)
