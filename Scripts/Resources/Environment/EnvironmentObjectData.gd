extends Resource
class_name EnvironmentalObjectData

@export var Name: String

var Size: float
@export var Size_min: float
@export var Size_max: float

@export_group("Cover Effectiveness")
@export var Cover_Effectiveness: float
@export var Attackee_MaxDistanceForMaxEffectiveness: float
@export var Attackee_MaxDistanceForAnyEffectiveness: float
@export var Attacker_MaxDistanceToZeroEffectiveness: float
@export var Attacker_MaxDistanceToMaxEffectiveness: float
func GetModifiedCoverEffectiveness(distanceFromAttacker: float, distanceFromAttackee: float) -> float:
	var modifiedChance = Cover_Effectiveness
	
	modifiedChance *= GetChanceToHitModFromAttackee(distanceFromAttackee)
	modifiedChance *= GetChanceToHitModFromAttacker(distanceFromAttacker)
	
	return modifiedChance
func GetChanceToHitModFromAttackee(distanceFromAttackee: float) -> float:
	if distanceFromAttackee <= Attackee_MaxDistanceForMaxEffectiveness:
		return 1
	elif distanceFromAttackee >= Attackee_MaxDistanceForAnyEffectiveness:
		return 0
	
	return 1 - ((distanceFromAttackee - Attackee_MaxDistanceForMaxEffectiveness) / (Attackee_MaxDistanceForAnyEffectiveness - Attackee_MaxDistanceForMaxEffectiveness))
func GetChanceToHitModFromAttacker(distanceFromAttacker: float) -> float:
	if distanceFromAttacker <= Attacker_MaxDistanceToZeroEffectiveness:
		return 0
	elif distanceFromAttacker >= Attacker_MaxDistanceToMaxEffectiveness:
		return 1
	
	return (Attacker_MaxDistanceToMaxEffectiveness - distanceFromAttacker) / (Attacker_MaxDistanceToMaxEffectiveness - Attacker_MaxDistanceToZeroEffectiveness)


func SetInitialData() -> void:
	Size = randf_range(Size_min, Size_max)
