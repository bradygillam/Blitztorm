extends Node2D
class_name State

@warning_ignore("unused_signal")
signal Transitioned

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func PhysicsUpdate(_delta: float) -> void:
	pass
