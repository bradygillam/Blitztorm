extends State
class_name EnemySpawn

@export var enemy: EnemyBaseUnit
var spawnVector: Vector2

func Enter() -> void:
	spawnVector = GlobalHelper.GetSpawnTargetVector(enemy.global_position, true)

func Exit() -> void:
	pass

func Update(delta: float) -> void:
	HandleMovement(delta)
	if enemy.position.distance_to(spawnVector) < 1:
		Transitioned.emit(self, "EnemyIdle")

func HandleMovement(delta: float) -> void:
	enemy.position = enemy.position.move_toward(spawnVector, enemy.unitData.Movement_Speed * delta)
	enemy.rotation = rotate_toward(enemy.rotation, (spawnVector - enemy.global_position).angle(), enemy.unitData.Rotation_Speed * delta)
