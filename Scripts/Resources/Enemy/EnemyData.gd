extends Resource
class_name EnemyData

@export var Name: String
@export var Cost: int
@export var Health: int

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
@export var Cover_Effectiveness_Explosive: float
@export var Attackee_MaxDistanceForEffectiveness_Explosive: float

@export_group("Attack")
@export var Number_Low_Attack: int
@export var Number_High_Attack: int
@export var Accuracy_Attack: float
@export var Damage_Low_Attack: float
@export var Damage_High_Attack: float
@export var Time_Between_Attacks: float

@export_group("Time")
@export var Idle_Time: float
@export var Target_Time: float
@export var Attack_Time: float

@export_group("Movement")
@export var Rotation_Speed: float
@export var Movement_Speed: float
@export var Movement_ForwardStep: float
@export var Movement_ForwardVarience: float
@export var Movement_VerticalVarience: float

@export_group("Knockback")
@export var DecayRate_Knockback: float
