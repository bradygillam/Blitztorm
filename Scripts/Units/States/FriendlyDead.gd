extends State
class_name FriendlyDead

@export var friendly: FriendlyBaseUnit

func Enter() -> void:
	UnitHandler.playerUnits.erase(friendly)
