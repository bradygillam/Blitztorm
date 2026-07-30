extends BaseUnit
class_name FriendlyBaseUnit

@export var deadState: State

@export var unitData: FriendlyData

var playerInfoUI: UnitInfoUI

var enemyTargets: Array[EnemyBaseUnit]

var enemiesInRanges: Array

var knockbackVelocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	super()
	enemiesInRanges = []
	unitData = unitData.duplicate()
	UnitHandler.playerUnits.append(self)
	base = find_child("Body", true)
	base.color = baseColour
	playerInfoUI = get_tree().root.find_child("UnitInfo", true, false)


func _process(_delta: float) -> void:
	if IsDead():
		TransitionDeadState()

func _physics_process(delta: float) -> void:
	knockbackVelocity = knockbackVelocity.move_toward(Vector2.ZERO, unitData.DecayRate_Knockback * delta)
	velocity = knockbackVelocity
	move_and_slide()

func IsDead() -> bool:
	return unitData.Health <= 0

func TransitionDeadState() -> void:
	stateMachine.onStateTransition(stateMachine.currentState, deadState)
	base.color = deadColour


func DrawPawnInfoUI() -> void:
	playerInfoUI.DrawPawnInfo(unitData, position, stateMachine.currentState)

func UnDrawPawnInfoUI() -> void:
	playerInfoUI.UnDrawPawnInfoUI()

func TakeHit(damage: float, attackDirection: Vector2) -> void:
	if damage <= 0:
		return
	attackDirection = attackDirection.normalized()
	unitData.Health -= int(damage)
	GlobalHelper.SpawnBloodSplatter(global_position + (10 * attackDirection), attackDirection.angle())

func TakeExplosiveHit(damage: float, attackDirection: Vector2) -> void:
	TakeHit(damage, attackDirection)

func TakeKnockback(distance: float, knockbackDirection: Vector2) -> void:
	if distance == 0:
		return
	knockbackVelocity = knockbackDirection.normalized() * distance

func AddEnemyToRange(body: Node2D, priority: int) -> void:
	while enemiesInRanges.size() <= priority:
		enemiesInRanges.append([])
	
	var enemy: EnemyBaseUnit = body
	
	enemiesInRanges[priority].append(enemy)

func RemoveEnemyFromRange(body: Node2D, priority: int) -> void:
	var enemy: EnemyBaseUnit = body
	enemiesInRanges[priority].erase(enemy)

func GetObjectData():
	return unitData
