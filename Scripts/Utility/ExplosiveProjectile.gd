extends Node2D
class_name ExplosiveProjectile

@export var explosiveData: ExplosiveData
var explosionContainer: Node2D
var destination: Vector2
var midPoint: Vector2
var startPoint: Vector2

func _ready() -> void:
	startPoint = self.global_position
	midPoint = destination.lerp(self.global_position, 0.5)

func _physics_process(delta: float) -> void:
	var distanceRemaining = global_position.distance_to(destination)
	
	if distanceRemaining <= explosiveData.Speed_Movement * delta:
		global_position = destination
		SpawnExplosion(global_position)
		queue_free()
		return
	
	scale = Vector2.ONE * (1 + (explosiveData.Height_Max * (min(startPoint.distance_to(global_position), destination.distance_to(global_position)) / startPoint.distance_to(midPoint))))
	global_position += (destination - global_position).normalized() * explosiveData.Speed_Movement * delta

func SpawnExplosion(explosionPosition: Vector2) -> void:
	var e:Explosion = explosiveData.Explosion_Prefab.instantiate()
	e.explosionData = explosiveData.duplicate()
	e.global_position = explosionPosition + Vector2.LEFT
	explosionContainer.add_child(e)
