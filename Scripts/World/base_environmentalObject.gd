extends Node2D
class_name BaseEnvironmentalObject

@export var objectData: EnvironmentalObjectData

func _ready() -> void:
	objectData.SetInitialData()
	scale *= objectData.Size

func hit() -> void:
	pass
