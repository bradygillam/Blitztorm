extends Node

var parentContainer: Node2D
var lopLeftSpawnRectangleCorner: Vector2 = Vector2(1432, GlobalHelper.MIN_Y_POSITION_VALUE)
var bottomRightSpawnRectangleCorner: Vector2 = Vector2(1448, GlobalHelper.MAX_Y_POSITION_VALUE)

func _ready() -> void:
	parentContainer = get_tree().root.find_child("Player", true, false)

func SpawnRecruit() -> void:
	var recruit = load("res://Scene/Units/Friendly/Player/Recruit_Player.tscn").instantiate()
	recruit.global_position = GlobalHelper.GetRandomVectorInRectangle(lopLeftSpawnRectangleCorner, bottomRightSpawnRectangleCorner)
	parentContainer.add_child(recruit)
