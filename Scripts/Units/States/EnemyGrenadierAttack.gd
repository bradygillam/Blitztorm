extends State
class_name EnemyGrenadierAttack

@export var nextState: State

@export var enemy: EnemyBaseUnit
@export var muzzleFlashTimer: Timer
@export var betweenAttacksTimer: Timer

var faceTowardsVector: Vector2
@export var muzzleFlashSprite: Polygon2D

var grenadePrefab: PackedScene = preload("res://Scene/Environment/Grenade.tscn")
var explosionContainer: Node2D 

func _ready() -> void:
	explosionContainer = enemy.worldRoot.find_child("Explosions", true, false)

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
		
		var numberOfAttacks: int = randi_range(enemy.unitData.Number_Low_Attack, enemy.unitData.Number_High_Attack)
		
		for i in range(0, numberOfAttacks):
			var destination: Vector2 = GlobalHelper.GetRandomVectorInCircle(friendly.global_position, enemy.GetObjectData().AccuracyRadius_ExplosiveProjectile)
			SpawnGrenade(destination)
			betweenAttacksTimer.start(enemy.unitData.Time_Between_Attacks)
			await betweenAttacksTimer.timeout

func GetAttackDirection() -> Vector2:
	if enemy.enemyTargets.size() == 0:
		return enemy.position + Vector2.LEFT
	else:
		return enemy.enemyTargets[0].position

func SpawnGrenade(destination: Vector2) -> void:
	var grenade = grenadePrefab.instantiate()
	grenade.explosionContainer = explosionContainer
	grenade.destination = destination
	grenade.global_position = global_position
	explosionContainer.add_child(grenade)
