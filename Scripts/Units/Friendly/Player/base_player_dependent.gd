extends FriendlyBaseUnit
class_name PlayerBaseDependentUnit

@export var parent: PlayerBaseUnit

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	if IsDead():
		TransitionDeadState()

func _physics_process(_delta: float) -> void:
	pass

func IsDead() -> bool:
	return parent.IsDead() or GetObjectData().Health <= 0

func TakeKnockback(_distance: float, _knockbackDirection: Vector2) -> void:
	return

func GetObjectData() -> FriendlyData:
	return parent.GetObjectData()
