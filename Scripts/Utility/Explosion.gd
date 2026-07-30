extends Node2D
class_name Explosion

@export var explosionData: ExplosionData
@export var explosionArea: Area2D

func _ready() -> void:
	scale *= explosionData.Size
	await get_tree().create_timer(explosionData.Explosion_Time).timeout
	queue_free()

func DealExplosiveDamage(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	var objectHit = area.parent
	var objectsInWay = GlobalHelper.GetObjectsOnLine(global_position, objectHit.global_position, get_world_2d())
	objectsInWay.erase(self)
	objectsInWay.erase(objectHit)
	var damageModifier = GlobalHelper.ResolveExplosion(objectHit, objectsInWay)
	objectHit.TakeExplosiveHit(damageModifier * randf_range(explosionData.Damage_Low_Attack, explosionData.Damage_High_Attack), objectHit.global_position - global_position)
	objectHit.TakeKnockback(damageModifier * randf_range(explosionData.Knockback_Low, explosionData.Knockback_High), objectHit.global_position - global_position)
