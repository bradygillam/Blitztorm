extends State
class_name FriendlyExplosiveAttack

@export var nextState: State

@export var friendly: FriendlyBaseUnit
@export var muzzleFlashTimer: Timer
@export var betweenAttacksTimer: Timer

var faceTowardsVector: Vector2
@export var muzzleFlashSprite: Polygon2D

@export var grenadePrefab: PackedScene
var explosionContainer: Node2D 

func _ready() -> void:
	await get_tree().physics_frame
	explosionContainer = friendly.worldRoot.find_child("Explosions", true, false)

func Enter() -> void:
	await CallAttackEnemy()

func CallAttackEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		await AttackEnemy()
		Transitioned.emit(self, nextState)

func AttackEnemy() -> void:
	for enemy: EnemyBaseUnit in friendly.enemyTargets:
		if enemy == null:
			continue
		
		var numberOfAttacks: int = randi_range(friendly.GetObjectData().Number_Low_Attack, friendly.GetObjectData().Number_High_Attack)
		
		for i in range(0, numberOfAttacks):
			if friendly.IsDead():
				return
			var destination: Vector2 = GlobalHelper.GetRandomVectorInCircle(enemy.global_position, friendly.GetObjectData().AccuracyRadius_ExplosiveProjectile)
			SpawnGrenade(destination)
			if muzzleFlashSprite:
				await AttackVisuals()
			betweenAttacksTimer.start(friendly.GetObjectData().Time_Between_Attacks)
			await betweenAttacksTimer.timeout

func SpawnGrenade(destination: Vector2) -> void:
	var grenade = grenadePrefab.instantiate()
	grenade.explosionContainer = explosionContainer
	grenade.destination = destination
	grenade.global_position = global_position
	explosionContainer.add_child(grenade)

func AttackVisuals() -> void:
	muzzleFlashSprite.visible = true
	muzzleFlashTimer.start(GlobalData.muzzleFlashDuration)
	await muzzleFlashTimer.timeout
	muzzleFlashSprite.visible = false
