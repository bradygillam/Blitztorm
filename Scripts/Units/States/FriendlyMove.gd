extends State
class_name FriendlyMove

@export var friendly: FriendlyBaseUnit

@export var navAgent: NavigationAgent2D
@export var characterAgent: CharacterBody2D

func _ready() -> void:
	navAgent.velocity_computed.connect(UpdateCharacterAgent)

func Enter() -> void:
	friendly.destination = NavigationServer2D.map_get_closest_point(navAgent.get_navigation_map(), friendly.destination)
	navAgent.target_position = friendly.destination
	characterAgent.set_collision_layer_value(2, false)
	characterAgent.set_collision_mask_value(2, false)

func Exit() -> void:
	navAgent.velocity = Vector2.ZERO
	characterAgent.velocity = Vector2.ZERO
	characterAgent.set_collision_layer_value(2, true)
	characterAgent.set_collision_mask_value(2, true)

func PhysicsUpdate(delta: float) -> void:
	if navAgent.is_navigation_finished() or !navAgent.is_target_reachable():
		Transitioned.emit(self, "FriendlyIdle")
		return
	var next_point = navAgent.get_next_path_position()
	var direction = (next_point - characterAgent.global_position).normalized()
	var desired_velocity = direction * friendly.unitData.Movement_Speed
	characterAgent.rotation = lerp_angle(
		characterAgent.rotation,
		desired_velocity.angle(),
		friendly.unitData.Rotation_Speed * delta
	)
	navAgent.velocity = desired_velocity

func UpdateCharacterAgent(safe_velocity: Vector2):
	characterAgent.velocity = safe_velocity
	characterAgent.move_and_slide()
