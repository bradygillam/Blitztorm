extends State
class_name FriendlyAttack

@export var friendly: FriendlyBaseUnit
@export var attackTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	attackTimer.timeout.connect(CallAttackEnemy)

func Enter() -> void:
	faceTowardsVector = GetAttackDirection()
	attackTimer.start(friendly.unitData.Attack_Time)

func Update(delta: float) -> void:
	HandleRotation(delta)

func Exit() -> void:
	attackTimer.stop()

func CallAttackEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		AttackEnemy()
		Transitioned.emit(self, "FriendlyIdle")

func AttackEnemy() -> void:
	for enemy: EnemyBaseUnit in friendly.enemyTargets:
		if enemy == null:
			continue
		#var objectsInWay = GlobalHelper.GetObjectsOnLine(friendly.position, enemy.position, get_world_2d())
		var numberOfAttacks: int = randi_range(friendly.unitData.Number_Low_Attack, friendly.unitData.Number_High_Attack)
		for i in range(0, numberOfAttacks):
			if randf() <= friendly.unitData.Accuracy_Attack:
				enemy.unitData.Health -= randf_range(friendly.unitData.Damage_Low_Attack, friendly.unitData.Damage_High_Attack)

func GetAttackDirection() -> Vector2:
	if friendly.enemyTargets.size() == 0:
		return friendly.position + Vector2.LEFT
	else:
		return friendly.enemyTargets[0].position

func HandleRotation(delta: float) -> void:
	friendly.rotation = rotate_toward(friendly.rotation, (faceTowardsVector - friendly.global_position).angle(), friendly.unitData.Rotation_Speed * delta)
