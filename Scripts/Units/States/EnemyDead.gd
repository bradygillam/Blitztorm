extends State
class_name EnemyDead

@export var enemy: EnemyBaseUnit

func Enter() -> void:
	UnitHandler.enemyUnits.erase(enemy)
