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

func TransitionDeadState() -> void:
	super()
	isSelected = false

func AssignDestination(destinationIn: Vector2) -> void:
	destination = destinationIn
	stateMachine.onStateTransition(stateMachine.currentState, "FriendlyMove")
	isSelected = false
	base.color = baseColour
