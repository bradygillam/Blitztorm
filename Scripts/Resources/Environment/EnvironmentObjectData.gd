extends Resource
class_name EnvironmentalObjectData

@export var Name: String

var Size: float
@export var Size_min: float
@export var Size_max: float


@export_group("Cover")
@export var CoverEffectiveness_Projectile: float


func SetInitialData() -> void:
	Size = randf_range(Size_min, Size_max)
