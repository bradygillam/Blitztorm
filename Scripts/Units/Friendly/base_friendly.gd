extends BaseUnit
class_name FriendlyBaseUnit

@export var unitData: FriendlyData

var playerInfoUI: UnitInfoUI

var enemyTargets: Array[EnemyBaseUnit]

func _ready() -> void:
	super()
	unitData = unitData.duplicate()
	UnitHandler.playerUnits.append(self)
	base = find_child("Body", true)
	base.color = baseColour
	playerInfoUI = get_tree().root.find_child("UnitInfo", true, false)


func _process(_delta: float) -> void:
	if IsDead():
		TransitionDeadState()

func IsDead() -> bool:
	return unitData.Health <= 0

func TransitionDeadState() -> void:
	stateMachine.onStateTransition(stateMachine.currentState, "FriendlyDead")
	base.color = deadColour


func DrawPawnInfoUI() -> void:
	playerInfoUI.DrawPawnInfo(unitData, position, stateMachine.currentState)

func UnDrawPawnInfoUI() -> void:
	playerInfoUI.UnDrawPawnInfoUI()

func TakeHit(damage: float, attackDirection: Vector2) -> void:
	attackDirection = attackDirection.normalized()
	unitData.Health -= damage
	GlobalHelper.SpawnBloodSplatter(global_position + (10 * attackDirection), attackDirection.angle())
