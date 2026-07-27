extends Node
class_name EquipmentSpawnHandler

var parentContainer: Node2D
var playerControls: PlayerControls
var lopLeftSpawnRectangleCorner: Vector2 = Vector2(1432, GlobalHelper.MIN_Y_POSITION_VALUE)
var bottomRightSpawnRectangleCorner: Vector2 = Vector2(1448, GlobalHelper.MAX_Y_POSITION_VALUE)

var equipmentSelected: PackedScene

func _ready() -> void:
	parentContainer = get_tree().root.find_child("PlayableNavigationRegion2D", true, false)
	playerControls = get_tree().root.find_child("Controls", true, false)

func SpawnEquipmentState(equipmentToSpawn: PackedScene) -> void:
	var equipment = equipmentToSpawn.instantiate()
	var data = equipment.GetObjectData()
	var preview = data.Preview
	equipmentSelected = equipmentToSpawn
	playerControls.EnterPlacingState(preview)

func SpawnSandbags() -> void:
	SpawnEquipmentState(load("res://Scene/Environment/Spawnable/Sandbags.tscn"))

func SpawnTrench() -> void:
	SpawnEquipmentState(load("res://Scene/Environment/Spawnable/Trench.tscn"))

func SpawnEquipmentAtPosition(position: Vector2, rotation: float) -> void:
	var equipment = equipmentSelected.instantiate()
	
	if GlobalData.playerCash < equipment.GetObjectData().Cost:
		equipment.queue_free()
		return
	
	GlobalData.DecreasePlayerCash(equipment.GetObjectData().Cost)
	
	equipment.global_position = position
	equipment.rotation = rotation
	
	parentContainer.add_child(equipment)
