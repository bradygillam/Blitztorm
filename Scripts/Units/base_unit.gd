extends Node2D
class_name BaseUnit

@export var baseColour: Color
@export var deadColour: Color

var destinationSpawn: Vector2
var destination: Vector2
var base: Polygon2D

var stateMachine: StateMachine

func _ready() -> void:
	stateMachine = find_child("StateMachine")

func hit() -> void:
	pass
