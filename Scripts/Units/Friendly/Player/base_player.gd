extends FriendlyBaseUnit
class_name PlayerBaseUnit

@export var moveState: State

@export var selectedColour: Color

var isSelected: bool

func _ready() -> void:
	super()
	UnitHandler.playerUnits.append(self)

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
	stateMachine.onStateTransition(stateMachine.currentState, moveState)
	isSelected = false
	base.color = baseColour
