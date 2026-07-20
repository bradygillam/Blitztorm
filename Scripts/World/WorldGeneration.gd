extends Node2D
class_name World

@export var treePrefab: PackedScene
@export var trees_max: int
@export var rockPrefab: PackedScene
@export var rocks_max: int

var navMesh: NavigationRegion2D
var navPolygon: NavigationPolygon

func _ready() -> void:
	navMesh = find_child("PlayableNavigationRegion2D")
	navPolygon = navMesh.navigation_polygon
	SpawnItems()
	RebakeNavMesh()

func SpawnItems() -> void:
	var numTrees = randi_range(0, trees_max)
	var numRocks = randi_range(0, rocks_max)
	
	for i in range(numTrees):
		var tree = treePrefab.instantiate()
		tree.global_position = GlobalHelper.GetRandomVectorInRectangle(
			Vector2(GlobalHelper.MIN_X_POSITION_VALUE, GlobalHelper.MIN_Y_POSITION_VALUE),
			Vector2(GlobalHelper.MAX_X_POSITION_VALUE, GlobalHelper.MAX_Y_POSITION_VALUE)
		)
		navMesh.add_child(tree)
	
	for i in range(numRocks):
		var rock = rockPrefab.instantiate()
		rock.global_position = GlobalHelper.GetRandomVectorInRectangle(
			Vector2(GlobalHelper.MIN_X_POSITION_VALUE, GlobalHelper.MIN_Y_POSITION_VALUE),
			Vector2(GlobalHelper.MAX_X_POSITION_VALUE, GlobalHelper.MAX_Y_POSITION_VALUE)
		)
		navMesh.add_child(rock)

func RebakeNavMesh() -> void:
	navMesh.bake_navigation_polygon()
