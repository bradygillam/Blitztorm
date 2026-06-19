extends BaseUnits
class_name EnemyBaseUnits

var spawnXTargetValue: float = 8


func _ready() -> void:
	destinationSpawn = Vector2(spawnXTargetValue, global_position.y)
	destination = destinationSpawn
	state = UnitHandler.States.SPAWN
	UnitHandler.enemyUnits.append(self)
	base = find_child("Body", true)
	base.color = baseColour

func StateHandler(delta: float) -> void:
	var nextState: UnitHandler.States
	
	match state:
		UnitHandler.States.SPAWN:
			HandleMovement(delta)
			if global_position.distance_to(destination) <= 1:
				state = UnitHandler.States.MOVING
		UnitHandler.States.IDLE:
			pass
		UnitHandler.States.MOVING:
			if global_position.distance_to(destination) <= 1:
				var movementRectangle: Array[Vector2] = GlobalHelper.GetMovementRectangleVectors(
					global_position, 20, 10, 100)
				destination = GlobalHelper.GetRandomVectorInRectangle(movementRectangle[0], movementRectangle[1])
			HandleMovement(delta)
