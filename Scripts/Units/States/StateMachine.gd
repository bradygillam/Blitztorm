extends Node
class_name StateMachine

@export var initialState: State

var currentState: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transitioned.connect(onStateTransition)
	
	if initialState:
		initialState.Enter()
		currentState = initialState

func _process(delta: float) -> void:
	if currentState:
		currentState.Update(delta)


func _physics_process(delta: float) -> void:
	if currentState:
		currentState.PhysicsUpdate(delta)


func onStateTransition(state, newStateName) -> void:
	if state != currentState:
		return
	
	var newState: State = states.get(newStateName)
	if !newState:
		return
	
	if currentState:
		currentState.Exit()
	
	newState.Enter()
	
	currentState = newState
