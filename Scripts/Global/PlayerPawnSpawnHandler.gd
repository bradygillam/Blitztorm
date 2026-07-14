extends Node

var parentContainer: Node2D
var lopLeftSpawnRectangleCorner: Vector2 = Vector2(1432, GlobalHelper.MIN_Y_POSITION_VALUE)
var bottomRightSpawnRectangleCorner: Vector2 = Vector2(1448, GlobalHelper.MAX_Y_POSITION_VALUE)

func _ready() -> void:
	parentContainer = get_tree().root.find_child("Player", true, false)

func spawn_unit(scene: PackedScene) -> void:
	var unit  = scene.instantiate()
	
	if GlobalData.playerCash < unit.unitData.Cost:
		unit.queue_free()
		return
	
	GlobalData.DecreasePlayerCash(unit.unitData.Cost)
	
	unit.global_position = GlobalHelper.GetRandomVectorInRectangle(
		lopLeftSpawnRectangleCorner,
		bottomRightSpawnRectangleCorner
	)
	parentContainer.add_child(unit)

func SpawnRecruit() -> void:
	spawn_unit(load("res://Scene/Units/Friendly/Player/Recruit_Player.tscn"))

func SpawnElite() -> void:
	spawn_unit(load("res://Scene/Units/Friendly/Player/Elite_Player.tscn"))
