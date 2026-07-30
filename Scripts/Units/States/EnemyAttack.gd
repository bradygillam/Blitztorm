extends State
class_name EnemyAttack

@export var nextState: State

@export var enemy: EnemyBaseUnit
@export var muzzleFlashTimer: Timer
@export var betweenAttacksTimer: Timer

var faceTowardsVector: Vector2
@export var muzzleFlashSprite: Polygon2D

func Enter() -> void:
	faceTowardsVector = GetAttackDirection()
	await CallAttackEnemy()

func CallAttackEnemy() -> void:
	if enemy.stateMachine.currentState == self:
		await AttackEnemy()
		Transitioned.emit(self, nextState)

func AttackEnemy() -> void:
	for friendly: FriendlyBaseUnit in enemy.enemyTargets:
		if friendly == null:
			continue
		
		var objectsInWay = GlobalHelper.GetObjectsOnLine(enemy.position, friendly.position, get_world_2d())
		objectsInWay.erase(friendly)
		objectsInWay.erase(enemy)
		
		var modifiedAccuracy = GlobalHelper.GetModifiedChanceToHit(
			enemy.unitData.Accuracy_Attack,
			enemy,
			friendly,
			objectsInWay
			)
		
		var numberOfAttacks: int = randi_range(enemy.unitData.Number_Low_Attack, enemy.unitData.Number_High_Attack)
		
		for i in range(0, numberOfAttacks):
			if randf() <= modifiedAccuracy:
				friendly.TakeHit(
					randf_range(enemy.unitData.Damage_Low_Attack, enemy.unitData.Damage_High_Attack),
					friendly.global_position - global_position
				)
			await AttackVisuals()
			betweenAttacksTimer.start(enemy.unitData.Time_Between_Attacks)
			await betweenAttacksTimer.timeout

func GetAttackDirection() -> Vector2:
	if enemy.enemyTargets.size() == 0:
		return enemy.position + Vector2.RIGHT
	else:
		return enemy.enemyTargets[0].position

func AttackVisuals() -> void:
	muzzleFlashSprite.visible = true
	muzzleFlashTimer.start(GlobalData.muzzleFlashDuration)
	await muzzleFlashTimer.timeout
	muzzleFlashSprite.visible = false
