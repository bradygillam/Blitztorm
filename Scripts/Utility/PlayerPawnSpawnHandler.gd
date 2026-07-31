extends Node

var parentContainer: Node2D
var lopLeftSpawnRectangleCorner: Vector2 = Vector2(1432, GlobalHelper.MIN_Y_POSITION_VALUE)
var bottomRightSpawnRectangleCorner: Vector2 = Vector2(1448, GlobalHelper.MAX_Y_POSITION_VALUE)

func _ready() -> void:
	parentContainer = get_tree().root.find_child("Player", true, false)

func spawnUnit(scene: PackedScene) -> void:
	var unit = scene.instantiate()
	
	if GlobalData.playerCash < unit.GetObjectData().Cost:
		unit.queue_free()
		return
	
	unit.worldRoot = get_tree().current_scene
	
	GlobalData.DecreasePlayerCash(unit.GetObjectData().Cost)
	
	unit.global_position = GlobalHelper.GetRandomVectorInRectangle(
		lopLeftSpawnRectangleCorner,
		bottomRightSpawnRectangleCorner
	)
	parentContainer.add_child(unit)

func SpawnRecruit() -> void:
	spawnUnit(load("res://Scene/Units/Friendly/Player/Recruit_Player.tscn"))

func SpawnElite() -> void:
	spawnUnit(load("res://Scene/Units/Friendly/Player/Elite_Player.tscn"))

func SpawnGrenadier() -> void:
	spawnUnit(load("res://Scene/Units/Friendly/Player/Grenadier_Player.tscn"))
