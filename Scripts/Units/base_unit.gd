extends CharacterBody2D
class_name BaseUnit

@export var baseColour: Color
@export var deadColour: Color

var base: Polygon2D
var worldRoot: Node2D

var stateMachine: StateMachine

func _ready() -> void:
	worldRoot = get_tree().current_scene
	stateMachine = find_child("StateMachine")
