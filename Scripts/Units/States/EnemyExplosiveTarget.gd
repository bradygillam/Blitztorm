extends State
class_name EnemyExplosiveTarget

@export var nextState: State

@export var enemy: EnemyBaseUnit
@export var targetTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	targetTimer.timeout.connect(CallSelectEnemy)

func Enter() -> void:
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
		Transitioned.emit(self, nextState)

func SelectEnemy() -> Array[FriendlyBaseUnit]:
	for enemiesInPriorityLevel in enemy.enemiesInRanges:
		if enemiesInPriorityLevel.size() > 0:
			var enemyWorkingList = enemiesInPriorityLevel.duplicate()
			enemyWorkingList.shuffle()
			for friendly in enemyWorkingList:
				if enemy.enemiesInRanges[0].has(friendly):
					continue
				if GlobalHelper.AreTeammatesCloseToTarget(friendly, enemy):
					continue
				return [friendly]
	return []

func HandleRotation(delta: float) -> void:
	enemy.rotation = rotate_toward(enemy.rotation, (faceTowardsVector - enemy.global_position).angle(), enemy.unitData.Rotation_Speed * delta)
