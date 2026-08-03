extends PlayerBaseUnit
class_name PlayerBaseVehicleUnit

var passengers: Array[FriendlyBaseUnit]
@export var dependentComponenets: Array[PlayerBaseDependentUnit]

func TransitionDeadState() -> void:
	super()
	for dependent in dependentComponenets:
		dependent.TransitionDeadState()
