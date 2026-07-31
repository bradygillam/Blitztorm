extends State
class_name FriendlyGrenadierAttack

@export var nextState: State

@export var friendly: FriendlyBaseUnit
@export var muzzleFlashTimer: Timer
@export var betweenAttacksTimer: Timer

var faceTowardsVector: Vector2
@export var muzzleFlashSprite: Polygon2D

var grenadePrefab: PackedScene = preload("res://Scene/Environment/Grenade.tscn")
var explosionContainer: Node2D 

func _ready() -> void:
	explosionContainer = friendly.worldRoot.find_child("Explosions", true, false)

func Enter() -> void:
	faceTowardsVector = GetAttackDirection()
	await CallAttackEnemy()

func CallAttackEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		await AttackEnemy()
		Transitioned.emit(self, nextState)

func AttackEnemy() -> void:
	for enemy: EnemyBaseUnit in friendly.enemyTargets:
		if enemy == null:
			continue
		
		var numberOfAttacks: int = randi_range(friendly.unitData.Number_Low_Attack, friendly.unitData.Number_High_Attack)
		
		for i in range(0, numberOfAttacks):
			var destination: Vector2 = GlobalHelper.GetRandomVectorInCircle(enemy.global_position, friendly.GetObjectData().AccuracyRadius_ExplosiveProjectile)
			SpawnGrenade(destination)
			betweenAttacksTimer.start(friendly.unitData.Time_Between_Attacks)
			await betweenAttacksTimer.timeout

func GetAttackDirection() -> Vector2:
	if friendly.enemyTargets.size() == 0:
		return friendly.position + Vector2.LEFT
	else:
		return friendly.enemyTargets[0].position

func SpawnGrenade(destination: Vector2) -> void:
	var grenade = grenadePrefab.instantiate()
	grenade.explosionContainer = explosionContainer
	grenade.destination = destination
	grenade.global_position = global_position
	explosionContainer.add_child(grenade)
