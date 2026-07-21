extends BaseUnit
class_name EnemyBaseUnit

@export var unitData: EnemyData

var enemyTargets: Array[FriendlyBaseUnit]

func _ready() -> void:
	super()
	unitData = unitData.duplicate()
	UnitHandler.enemyUnits.append(self)
	base = find_child("Body", true)
	base.color = baseColour

func _process(delta: float) -> void:
	if IsDead():
		TransitionDeadState()

func IsDead() -> bool:
	return unitData.Health <= 0

func TransitionDeadState() -> void:
	stateMachine.onStateTransition(stateMachine.currentState, "EnemyDead")
	base.color = deadColour

func TakeHit(damage: float, attackDirection: Vector2) -> void:
	attackDirection = attackDirection.normalized()
	unitData.Health -= damage
	GlobalHelper.SpawnBloodSplatter(global_position + (5 * attackDirection), attackDirection.angle())
