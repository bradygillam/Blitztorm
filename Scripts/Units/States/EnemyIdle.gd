extends State
class_name EnemyIdle

@export var enemy: EnemyBaseUnit
@export var idleTimer: Timer

func _ready() -> void:
	idleTimer.timeout.connect(OnTimeout)

func Enter() -> void:
	idleTimer.start(enemy.unitData.Idle_Time)

func Exit() -> void:
	idleTimer.stop()

func OnTimeout() -> void:
	Transitioned.emit(self, "EnemyTarget")
