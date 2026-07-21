extends State
class_name FriendlyTarget

@export var friendly: FriendlyBaseUnit
@export var targetTimer: Timer

var faceTowardsVector: Vector2

func _ready() -> void:
	targetTimer.timeout.connect(CallSelectEnemy)

func Enter() -> void:
	faceTowardsVector = friendly.position + Vector2.LEFT
	
	friendly.enemyTargets = friendly.enemyTargets.filter(func(e):
		return e != null and e.unitData.Health > 0
	)
	
	targetTimer.start(friendly.unitData.Target_Time)

func PhysicsUpdate(delta: float) -> void:
	HandleRotation(delta)

func Exit() -> void:
	targetTimer.stop()

func CallSelectEnemy() -> void:
	if friendly.stateMachine.currentState == self:
		friendly.enemyTargets = SelectEnemy()
		Transitioned.emit(self, "FriendlyRotateToTarget")

func SelectEnemy() -> Array[EnemyBaseUnit]:
	if UnitHandler.enemyUnits.size() == 0:
		return []
	return [UnitHandler.enemyUnits.pick_random()]

func HandleRotation(delta: float) -> void:
	friendly.rotation = rotate_toward(friendly.rotation, (faceTowardsVector - friendly.global_position).angle(), friendly.unitData.Rotation_Speed * delta)
