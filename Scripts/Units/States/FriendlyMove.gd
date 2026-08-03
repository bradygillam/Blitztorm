extends State
class_name FriendlyMove

@export var nextState: State

@export var friendly: FriendlyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func _ready() -> void:
	navAgent.velocity_computed.connect(UpdateCharacterAgent)

func Enter() -> void:
	friendly.destination = NavigationServer2D.map_get_closest_point(navAgent.get_navigation_map(), friendly.destination)
	navAgent.target_position = friendly.destination
	characterAgent.set_collision_layer_value(5, false)
	characterAgent.set_collision_mask_value(5, false)
	characterAgent.set_collision_layer_value(6, false)
	characterAgent.set_collision_mask_value(6, false)

func Exit() -> void:
	navAgent.velocity = Vector2.ZERO
	characterAgent.velocity = Vector2.ZERO
	characterAgent.set_collision_layer_value(5, true)
	characterAgent.set_collision_mask_value(5, true)
	characterAgent.set_collision_layer_value(6, true)
	characterAgent.set_collision_mask_value(6, true)

func PhysicsUpdate(delta: float) -> void:
	if navAgent.is_navigation_finished() or !navAgent.is_target_reachable():
		Transitioned.emit(self, nextState)
		return
	var next_point = navAgent.get_next_path_position()
	var direction = (next_point - characterAgent.global_position).normalized()
	var desired_velocity = direction * friendly.GetObjectData().Movement_Speed
	characterAgent.global_rotation = lerp_angle(
		characterAgent.global_rotation,
		desired_velocity.angle(),
		friendly.GetObjectData().Rotation_Speed * delta
	)
	navAgent.velocity = desired_velocity

func UpdateCharacterAgent(safe_velocity: Vector2):
	characterAgent.velocity = safe_velocity
	characterAgent.move_and_slide()
