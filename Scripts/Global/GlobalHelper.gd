extends Node
class_name GlobalHelper

static var MIN_Y_POSITION_VALUE: float = 4
static var MAX_Y_POSITION_VALUE: float = 796

static var MIN_X_POSITION_VALUE: float = 8
static var MAX_X_POSITION_VALUE: float = 1414

static func GetSpawnTargetVector(currentPosition: Vector2, isEnemySpawn: bool) -> Vector2:
	if isEnemySpawn:
		return Vector2(MIN_X_POSITION_VALUE, currentPosition.y)
	else:
		return Vector2(MAX_X_POSITION_VALUE, currentPosition.y) 

static func GetRandomVectorInRectangle(topLeft: Vector2, bottomRight: Vector2) -> Vector2:
	return Vector2(randf_range(topLeft.x, bottomRight.x), randf_range(topLeft.y, bottomRight.y))

static func GetMovementRectangleVectors(currentPosition: Vector2, forwardScalar: float, horizontalVariabilityScalar: float, verticalVariabilityScalar: float) -> Array[Vector2]:
	var centerRectangle: Vector2 = currentPosition + (forwardScalar * Vector2.RIGHT)
	var topLeftRectangle: Vector2 = centerRectangle + (horizontalVariabilityScalar * Vector2.LEFT) + (verticalVariabilityScalar * Vector2.UP)
	var bottomRightRectangle: Vector2 = centerRectangle + (horizontalVariabilityScalar * Vector2.RIGHT) + (verticalVariabilityScalar * Vector2.DOWN)
	
	if topLeftRectangle.y < MIN_Y_POSITION_VALUE and bottomRightRectangle.y > MAX_Y_POSITION_VALUE:
		topLeftRectangle.y = MIN_Y_POSITION_VALUE
		bottomRightRectangle.y = MAX_Y_POSITION_VALUE
	elif topLeftRectangle.y < MIN_Y_POSITION_VALUE:
		var dif = MIN_Y_POSITION_VALUE - topLeftRectangle.y
		topLeftRectangle.y += dif
		bottomRightRectangle.y += dif
	elif bottomRightRectangle.y > MAX_Y_POSITION_VALUE:
		var dif = MAX_Y_POSITION_VALUE - bottomRightRectangle.y
		topLeftRectangle.y += dif
		bottomRightRectangle.y += dif
	
	return [topLeftRectangle, bottomRightRectangle]
