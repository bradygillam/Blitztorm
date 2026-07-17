extends Node
class_name EnemyPawnSpawnHandler

var parentContainer: Node2D
var lopLeftSpawnRectangleCorner: Vector2 = Vector2(-30, GlobalHelper.MIN_Y_POSITION_VALUE)
var bottomRightSpawnRectangleCorner: Vector2 = Vector2(-10, GlobalHelper.MAX_Y_POSITION_VALUE)

func _ready() -> void:
	parentContainer = get_tree().root.find_child("Enemy", true, false)

func SpawnUnit(unit: PackedScene) -> void:
	var spawnedUnit = unit.instantiate()
	spawnedUnit.global_position = GlobalHelper.GetRandomVectorInRectangle(lopLeftSpawnRectangleCorner, bottomRightSpawnRectangleCorner)
	parentContainer.add_child(spawnedUnit)
