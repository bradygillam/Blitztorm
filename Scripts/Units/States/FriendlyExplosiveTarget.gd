extends State
class_name FriendlyExplosiveTarget

@export var nextState: State

@export var friendly: FriendlyBaseUnit
@export var targetTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	targetTimer.timeout.connect(CallSelectEnemy)

func Enter() -> void:
	faceTowardsVector = friendly.global_position + (1000 * Vector2.LEFT)
	
	friendly.enemyTargets = friendly.enemyTargets.filter(func(e):
		return e != null and e.unitData.Health > 0
	)
	
	targetTimer.start(friendly.GetObjectData().Target_Time)

func PhysicsUpdate(delta: float) -> void:
	HandleRotation(delta)

func Exit() -> void:
	targetTimer.stop()

func CallSelectEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		friendly.enemyTargets = SelectEnemy()
		Transitioned.emit(self, nextState)

func SelectEnemy() -> Array[EnemyBaseUnit]:
	for enemiesInPriorityLevel in friendly.enemiesInRanges:
		if enemiesInPriorityLevel.size() > 0:
			var enemyWorkingList = enemiesInPriorityLevel.duplicate()
			enemyWorkingList.shuffle()
			for enemy in enemyWorkingList:
				if friendly.enemiesInRanges[0].has(enemy):
					continue
				if GlobalHelper.AreTeammatesCloseToTarget(enemy, friendly):
					continue
				return [enemy]
	return []

func HandleRotation(delta: float) -> void:
	friendly.global_rotation = rotate_toward(friendly.global_rotation, (faceTowardsVector - friendly.global_position).angle(), friendly.GetObjectData().Rotation_Speed * delta)
