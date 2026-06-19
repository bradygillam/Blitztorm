extends Node

var spawnHandler: EnemyPawnSpawnHandler
@export var recruitData: Resource
@export var eliteData: Resource


func _ready() -> void:
	spawnHandler = get_tree().root.find_child("EnemyUnitSpawnHandler", true, false)


func SpawnWave() -> void:
	spawnHandler.SpawnUnit(recruitData.Unit)
