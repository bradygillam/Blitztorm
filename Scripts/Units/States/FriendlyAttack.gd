extends State
class_name FriendlyAttack

@export var friendly: FriendlyBaseUnit
@export var muzzleFlashTimer: Timer
@export var betweenAttacksTimer: Timer

var faceTowardsVector: Vector2
@export var muzzleFlashSprite: Polygon2D

func Enter() -> void:
	faceTowardsVector = GetAttackDirection()
	await CallAttackEnemy()

func CallAttackEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		await AttackEnemy()
		Transitioned.emit(self, "FriendlyIdle")

func AttackEnemy() -> void:
	for enemy: EnemyBaseUnit in friendly.enemyTargets:
		if enemy == null:
			continue
		#var objectsInWay = GlobalHelper.GetObjectsOnLine(friendly.position, enemy.position, get_world_2d())
		var numberOfAttacks: int = randi_range(friendly.unitData.Number_Low_Attack, friendly.unitData.Number_High_Attack)
		for i in range(0, numberOfAttacks):
			if randf() <= friendly.unitData.Accuracy_Attack:
				enemy.TakeHit(
					randf_range(friendly.unitData.Damage_Low_Attack, friendly.unitData.Damage_High_Attack),
					enemy.global_position - global_position
				)
			await AttackVisuals()
			betweenAttacksTimer.start(friendly.unitData.Time_Between_Attacks)
			await betweenAttacksTimer.timeout

func GetAttackDirection() -> Vector2:
	if friendly.enemyTargets.size() == 0:
		return friendly.position + Vector2.LEFT
	else:
		return friendly.enemyTargets[0].position

func AttackVisuals() -> void:
	muzzleFlashSprite.visible = true
	muzzleFlashTimer.start(GlobalData.muzzleFlashDuration)
	await muzzleFlashTimer.timeout
	muzzleFlashSprite.visible = false
