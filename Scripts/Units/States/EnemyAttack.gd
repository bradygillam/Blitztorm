extends State
class_name EnemyAttack

@export var enemy: EnemyBaseUnit
@export var attackTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	attackTimer.timeout.connect(CallAttackEnemy)

func Enter() -> void:
	faceTowardsVector = GetAttackDirection()
	attackTimer.start(enemy.unitData.Attack_Time)

func Update(delta: float) -> void:
	HandleRotation(delta)

func Exit() -> void:
	attackTimer.stop()

func CallAttackEnemy() -> void:
	if enemy.stateMachine.currentState == self:
		AttackEnemy()
		Transitioned.emit(self, "EnemyMove")

func AttackEnemy() -> void:
	for friendly: FriendlyBaseUnit in enemy.enemyTargets:
		if friendly == null:
			continue
		var numberOfAttacks: int = randi_range(enemy.unitData.Number_Low_Attack, enemy.unitData.Number_High_Attack)
		for i in range(0, numberOfAttacks):
			if randf() <= enemy.unitData.Accuracy_Attack:
				friendly.unitData.Health -= randf_range(enemy.unitData.Damage_Low_Attack, enemy.unitData.Damage_High_Attack)

func GetAttackDirection() -> Vector2:
	if enemy.enemyTargets.size() == 0:
		return enemy.position + Vector2.RIGHT
	else:
		return enemy.enemyTargets[0].position

func HandleRotation(delta: float) -> void:
	enemy.rotation = rotate_toward(enemy.rotation, (faceTowardsVector - enemy.global_position).angle(), enemy.unitData.Rotation_Speed * delta)
