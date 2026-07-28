extends Node2D
class_name Explosion

@export var explosionArea: Area2D

@export var damage: float = 50

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()

func DealExplosiveDamage(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var objectHit = area.parent
	objectHit.TakeExplosiveHit(damage, objectHit.global_position - global_position)
