extends State
class_name EnemyTarget

@export var enemy: EnemyBaseUnit
@export var targetTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	targetTimer.timeout.connect(CallSelectEnemy)

func Enter() -> void:
	faceTowardsVector = enemy.position + Vector2.RIGHT
	
	enemy.enemyTargets = enemy.enemyTargets.filter(func(e):
		return e != null and e.unitData.Health > 0
	)
	
	targetTimer.start(enemy.unitData.Target_Time)

func PhysicsUpdate(delta: float) -> void:
	HandleRotation(delta)

func Exit() -> void:
	targetTimer.stop()

func CallSelectEnemy() -> void:
	if enemy.stateMachine.currentState == self:
		enemy.enemyTargets = SelectEnemy()
		Transitioned.emit(self, "EnemyRotateToTarget")

func SelectEnemy() -> Array[FriendlyBaseUnit]:
	for enemiesInPriorityLevel in enemy.enemiesInRanges:
		if enemiesInPriorityLevel.size() > 0:
			return [enemiesInPriorityLevel.pick_random()]
	
	return []

func HandleRotation(delta: float) -> void:
	enemy.rotation = rotate_toward(enemy.rotation, (faceTowardsVector - enemy.global_position).angle(), enemy.unitData.Rotation_Speed * delta)
