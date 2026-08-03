extends State
class_name FriendlyIdle

@export var nextState: State

@export var friendly: FriendlyBaseUnit
@export var idleTimer: Timer

func _ready() -> void:
	idleTimer.timeout.connect(OnTimeout)

func Enter() -> void:
	idleTimer.start(friendly.GetObjectData().Idle_Time)

func Exit() -> void:
	idleTimer.stop()

func OnTimeout() -> void:
	Transitioned.emit(self, nextState)
