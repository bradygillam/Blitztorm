extends Node

enum States {
	SPAWN,
	IDLE,
	MOVING
}

static var playerUnits: Array[PlayerBaseUnits]
static var enemyUnits: Array[EnemyBaseUnits]
