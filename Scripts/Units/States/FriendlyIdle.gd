extends State
class_name FriendlyIdle

@export var friendly: FriendlyBaseUnit
@export var idleTimer: Timer

func _ready() -> void:
	idleTimer.timeout.connect(OnTimeout)

func Enter() -> void:
	idleTimer.start(friendly.unitData.Idle_Time)

func Exit() -> void:
	idleTimer.stop()

func OnTimeout() -> void:
	Transitioned.emit(self, "FriendlyTarget")
