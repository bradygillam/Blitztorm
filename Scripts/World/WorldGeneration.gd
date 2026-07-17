extends Node2D
class_name World

@export var treePrefab: PackedScene
@export var trees_max: int
@export var rockPrefab: PackedScene
@export var rocks_max: int

func _ready() -> void:
	SpawnItems()

func SpawnItems() -> void:
	var numTrees = randi_range(0, trees_max)
	var numRocks = randi_range(0, rocks_max)
	
	for i in range(numTrees):
		var tree = treePrefab.instantiate()
		tree.global_position = GlobalHelper.GetRandomVectorInRectangle(
		Vector2(GlobalHelper.MIN_X_POSITION_VALUE, GlobalHelper.MIN_Y_POSITION_VALUE),
		Vector2(GlobalHelper.MAX_X_POSITION_VALUE, GlobalHelper.MAX_Y_POSITION_VALUE)
		)
		self.add_child(tree)
	
	for i in range(numRocks):
		var rock = rockPrefab.instantiate()
		rock.global_position = GlobalHelper.GetRandomVectorInRectangle(
		Vector2(GlobalHelper.MIN_X_POSITION_VALUE, GlobalHelper.MIN_Y_POSITION_VALUE),
		Vector2(GlobalHelper.MAX_X_POSITION_VALUE, GlobalHelper.MAX_Y_POSITION_VALUE)
		)
		self.add_child(rock)
