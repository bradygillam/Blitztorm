extends Node2D
class_name BaseEnvironmentalObject

@export var objectData: EnvironmentalObjectData

func _ready() -> void:
	objectData.SetInitialData()
	scale *= objectData.Size

func TakeHit(damage: float, attackDirection: Vector2) -> void:
	if damage <= 0:
		return
	attackDirection = attackDirection.normalized()
	GlobalHelper.SpawnDebris(global_position + (10 * attackDirection), attackDirection.angle())

func GetObjectData():
	return objectData
