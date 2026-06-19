extends Node

enum States {
	SPAWN,
	IDLE,
	MOVING
}

static var playerUnits: Array[PlayerBaseUnit]
static var enemyUnits: Array[EnemyBaseUnit]
