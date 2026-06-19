extends Node2D
class_name BaseUnits

@export var baseColour: Color
@export var health: float
@export var damage: float
@export var movement_speed: float
@export var rotation_speed: float

var destinationSpawn: Vector2
var destination: Vector2
var state: UnitHandler.States
var base: Polygon2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	StateHandler(delta)

func StateHandler(delta: float) -> void:
	match state:
		UnitHandler.States.SPAWN:
			HandleMovement(delta)
			if global_position.distance_to(destinationSpawn) <= 1:
				state = UnitHandler.States.IDLE
		UnitHandler.States.IDLE:
			pass
		UnitHandler.States.MOVING:
			HandleMovement(delta)

func HandleMovement(delta: float) -> void:
	position = position.move_toward(destination, movement_speed * delta)
	rotation = rotate_toward(rotation, (destination - global_position).angle(), rotation_speed * delta)

func SetMovementDestination(destinationIn: Vector2) -> void:
	destination = destinationIn
