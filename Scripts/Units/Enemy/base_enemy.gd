extends BaseUnit
class_name EnemyBaseUnit

@export var deadState: State

@export var unitData: EnemyData

var enemyTargets: Array[FriendlyBaseUnit]

var enemiesInRanges: Array

var knockbackVelocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	super()
	unitData = unitData.duplicate()
	UnitHandler.enemyUnits.append(self)
	base = find_child("Body", true)
	base.color = baseColour

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

func TakeHit(damage: float, attackDirection: Vector2) -> void:
	if damage <= 0:
		return
	attackDirection = attackDirection.normalized()
	unitData.Health -= int(damage)
	GlobalHelper.SpawnBloodSplatter(global_position + (5 * attackDirection), attackDirection.angle())

func TakeExplosiveHit(damage: float, attackDirection: Vector2) -> void:
	TakeHit(damage, attackDirection)

func TakeKnockback(distance: float, knockbackDirection: Vector2) -> void:
	if distance == 0:
		return
	knockbackVelocity = knockbackDirection.normalized() * distance

func AddEnemyToRange(body: Node2D, priority: int) -> void:
	while enemiesInRanges.size() <= priority:
		enemiesInRanges.append([])
	
	var enemy: FriendlyBaseUnit = body
	
	enemiesInRanges[priority].append(enemy)

func RemoveEnemyFromRange(body: Node2D, priority: int) -> void:
	var enemy: FriendlyBaseUnit = body
	enemiesInRanges[priority].erase(enemy)

func GetObjectData():
	return unitData
