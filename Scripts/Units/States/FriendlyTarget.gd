extends State
class_name FriendlyTarget

@export var friendly: FriendlyBaseUnit
@export var targetTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	targetTimer.timeout.connect(CallSelectEnemy)

func Enter() -> void:
	#faceTowardsVector = friendly.position + Vector2.LEFT
	
	friendly.enemyTargets = friendly.enemyTargets.filter(func(e):
		return e != null and e.unitData.Health > 0
	)
	
	targetTimer.start(friendly.unitData.Target_Time)

func PhysicsUpdate(delta: float) -> void:
	HandleRotation(delta)

func Exit() -> void:
	targetTimer.stop()

func CallSelectEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		friendly.enemyTargets = SelectEnemy()
		Transitioned.emit(self, "FriendlyRotateToTarget")

func SelectEnemy() -> Array[EnemyBaseUnit]:
	for enemiesInPriorityLevel in friendly.enemiesInRanges:
		if enemiesInPriorityLevel.size() > 0:
			var enemyWorkingList = enemiesInPriorityLevel.duplicate()
			enemyWorkingList.shuffle()
			for enemy in enemyWorkingList:
				var objectsInWay = GlobalHelper.GetObjectsOnLine(friendly.position, enemy.position, get_world_2d())
				objectsInWay.erase(enemy)
				objectsInWay.erase(friendly)
				var chanceToHit = GlobalHelper.GetModifiedChanceToHit(
					friendly.unitData.Accuracy_Attack,
					friendly,
					enemy,
					objectsInWay
					)
				if chanceToHit >= 0.0001:
					return [enemy]
	return []


func HandleRotation(delta: float) -> void:
	friendly.rotation = rotate_toward(friendly.rotation, (faceTowardsVector - friendly.global_position).angle(), friendly.unitData.Rotation_Speed * delta)
