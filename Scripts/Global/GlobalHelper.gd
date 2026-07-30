extends Node

static var MIN_Y_POSITION_VALUE: float = 4
static var MAX_Y_POSITION_VALUE: float = 796

static var MIN_X_POSITION_VALUE: float = 8
static var MAX_X_POSITION_VALUE: float = 1414

static var bloodSplatterContainer: Node2D
static var bloodSplatterPrefab: PackedScene = preload("res://Scene/Environment/Blood/BloodSplatter.tscn")
static var debrisContainer: Node2D
static var debrisPrefab: PackedScene = preload("res://Scene/Environment/Debris.tscn")

func _ready() -> void:
	await get_tree().process_frame
	bloodSplatterContainer = get_tree().root.find_child("BloodSplatters", true, false)
	debrisContainer = get_tree().root.find_child("DebrisPiles", true, false)

func GetSpawnTargetVector(currentPosition: Vector2, isEnemySpawn: bool) -> Vector2:
	if isEnemySpawn:
		return Vector2(MIN_X_POSITION_VALUE, currentPosition.y)
	else:
		return Vector2(MAX_X_POSITION_VALUE, currentPosition.y) 

func GetRandomVectorInRectangle(topLeft: Vector2, bottomRight: Vector2) -> Vector2:
	return Vector2(randf_range(topLeft.x, bottomRight.x), randf_range(topLeft.y, bottomRight.y))

func GetMovementRectangleVectors(currentPosition: Vector2, forwardScalar: float, horizontalVariabilityScalar: float, verticalVariabilityScalar: float) -> Array[Vector2]:
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


func GetObjectsOnLine(start: Vector2, end: Vector2, world: World2D) -> Array:
	var direction: Vector2 = end - start
	var length: float = direction.length()
	
	if length == 0:
		return []
		
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(length, 2.0)

	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(
		direction.angle(),
		(start + end) * 0.5
	)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = GlobalConstants.LAYER_COVER
	
	var hits = world.direct_space_state.intersect_shape(query)
	
	var objectsInLine = []
	
	for hit in hits:
		objectsInLine.append(hit.collider.parent)
	
	return objectsInLine

func GetModifiedChanceToHit(baseChanceToHit: float, attacker: Node2D, attackee: Node2D, objectsInWay) -> float:
	var modifiedChanceToHit = baseChanceToHit
	for item: Node2D in objectsInWay:
			modifiedChanceToHit *= (1 - item.GetObjectData().GetModifiedCoverEffectiveness(
				item.global_position.distance_to(attacker.global_position),
				item.global_position.distance_to(attackee.global_position)
			))
	return modifiedChanceToHit

func ResolveShot(attacker: Node2D, attackee: Node2D, objectsInWay) -> Node2D:
	var objectsProbabilities = []
	var modifiedChanceToHit = attacker.GetObjectData().Accuracy_Attack
	for item in objectsInWay:
		var itemCoverEffectiveness = item.GetObjectData().GetModifiedCoverEffectiveness(
				item.global_position.distance_to(attacker.global_position),
				item.global_position.distance_to(attackee.global_position)
			)
		var chanceToHitItem = modifiedChanceToHit * itemCoverEffectiveness
		modifiedChanceToHit *= (1 - itemCoverEffectiveness)
		
		objectsProbabilities.append({
			"Object" : item,
			"Chance" : chanceToHitItem
			})
	
	var randomRoll: float = randf()
	if randomRoll <= modifiedChanceToHit:
		return attackee
	randomRoll -= modifiedChanceToHit
	
	for item in objectsProbabilities:
		if randomRoll <= item.Chance:
			return item.Object
		randomRoll -= item.Chance
	
	return null

func ResolveExplosion(attackee: Node2D, objectsInWay) -> float:
	var effectiveness = 1.0
	for object in objectsInWay:
		if object.global_position.distance_to(attackee.global_position) < object.GetObjectData().Attackee_MaxDistanceForEffectiveness_Explosive:
			effectiveness *= (1 - object.GetObjectData().Cover_Effectiveness_Explosive)
	return effectiveness

func SpawnBloodSplatter(position: Vector2, rotation: float) -> void:
	var newSplatter: Node2D = bloodSplatterPrefab.instantiate()
	
	var offset: Vector2 = Vector2(
		randf_range(-5.0, 5.0),
		randf_range(-5.0, 5.0)
	)
	
	newSplatter.global_position = position + offset
	newSplatter.global_rotation = rotation + randf_range(-0.5, 0.5)
	bloodSplatterContainer.add_child(newSplatter)

func SpawnDebris(position: Vector2, rotation: float) -> void:
	var newDebrisPile: Node2D = debrisPrefab.instantiate()
	
	var offset: Vector2 = Vector2(
		randf_range(-5.0, 5.0),
		randf_range(-5.0, 5.0)
	)
	
	newDebrisPile.global_position = position + offset
	newDebrisPile.global_rotation = rotation + randf_range(-0.5, 0.5)
	debrisContainer.add_child(newDebrisPile)
