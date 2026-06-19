extends BaseUnit
class_name FriendlyBaseUnit

var spawnXTargetValue: float = 1412


func _ready() -> void:
	destinationSpawn = Vector2(spawnXTargetValue, global_position.y)
	destination = destinationSpawn
	state = UnitHandler.States.SPAWN
	UnitHandler.playerUnits.append(self)
	base = find_child("Body", true)
	base.color = baseColour
