extends Node

var spawnHandler: EnemyPawnSpawnHandler
@export var enemies: Dictionary[EnemyData, PackedScene]

func _ready() -> void:
	spawnHandler = get_tree().root.find_child("EnemyUnitSpawnHandler", true, false)

func SpawnWave() -> void:
	GlobalData.IncreaseWaveNumber(1)
	GlobalData.IncreasePlayerCash(100)
	GlobalData.IncreaseEnemyCash(CalculateWaveCash())
	#print("Wave Number: " + str(GlobalData.waveNumber) + " - Cash: " + str(GlobalData.enemyCash))
	SpawnEnemies()

func CalculateWaveCash() -> float:
	return GlobalData.enemyStartingCash# * ((float(GlobalData.waveNumber ** 2) / 50) + 2)

func SpawnEnemies() -> void:
	while GlobalData.enemyCash >= 100:
		var enemyToSpawn: EnemyData = enemies.keys().pick_random()
		if enemyToSpawn.Cost <= GlobalData.enemyCash:
			spawnHandler.SpawnUnit(enemies[enemyToSpawn])
			GlobalData.DecreaseEnemyCash(enemyToSpawn.Cost)
