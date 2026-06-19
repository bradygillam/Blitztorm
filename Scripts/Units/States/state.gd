class_name State

var unit: BaseUnit
var isComplete: bool

func onStart() -> void:
	isComplete = false
	pass

func processState(delta: float) -> void:
	pass

func onExit() -> void:
	pass
