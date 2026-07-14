extends State
class_name FriendlySpawn

@export var friendly: FriendlyBaseUnit
var spawnVector: Vector2

func Enter() -> void:
	spawnVector = GlobalHelper.GetSpawnTargetVector(friendly.global_position, false)

func Exit() -> void:
	pass

func Update(delta: float) -> void:
	HandleMovement(delta)
	if friendly.position.distance_to(spawnVector) < 1:
		Transitioned.emit(self, "FriendlyIdle")

func HandleMovement(delta: float) -> void:
	friendly.position = friendly.position.move_toward(spawnVector, friendly.unitData.Movement_Speed * delta)
	friendly.rotation = rotate_toward(friendly.rotation, (spawnVector - friendly.global_position).angle(), friendly.unitData.Rotation_Speed * delta)
