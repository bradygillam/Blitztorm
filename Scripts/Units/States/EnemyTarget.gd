extends State
class_name EnemyTarget

@export var nextState: State

@export var enemy: EnemyBaseUnit
@export var targetTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	targetTimer.timeout.connect(CallSelectEnemy)

func Enter() -> void:
	faceTowardsVector = enemy.global_position + Vector2.RIGHT
	
	enemy.enemyTargets = enemy.enemyTargets.filter(func(e):
		return e != null and e.GetObjectData().Health > 0
	)
	
	targetTimer.start(enemy.GetObjectData().Target_Time)

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
			var targetWorkingList = enemiesInPriorityLevel.duplicate()
			targetWorkingList.shuffle()
			for target in targetWorkingList:
				var objectsInWay = GlobalHelper.GetObjectsOnLine(enemy.global_position, target.global_position, get_world_2d())
				objectsInWay.erase(target)
				objectsInWay.erase(enemy)
				var chanceToHit = GlobalHelper.GetModifiedChanceToHit(
					enemy.GetObjectData().Accuracy_Attack,
					enemy,
					target,
					objectsInWay
					)
				if chanceToHit >= 0.0001:
					return [target]
	
	return []

func HandleRotation(delta: float) -> void:
	enemy.global_rotation = rotate_toward(enemy.global_rotation, (faceTowardsVector - enemy.global_position).angle(), enemy.GetObjectData().Rotation_Speed * delta)
