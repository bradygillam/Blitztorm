extends FriendlyBaseUnit
class_name PlayerBaseUnit

@export var selectedColour: Color

var isSelected: bool


func WasSelected() -> void:
	isSelected = true
	base.color = selectedColour


func WasDeselected() -> void:
	isSelected = false
	base.color = baseColour


func AssignDestination(destinationIn: Vector2) -> void:
	destination = destinationIn
	isSelected = false
	base.color = baseColour
	state = UnitHandler.States.MOVING
