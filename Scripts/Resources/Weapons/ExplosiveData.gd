extends Resource
class_name ExplosiveData

@export var Name: String
@export var Explosion_Prefab: PackedScene

@export_group("Movement")
@export var Speed_Movement: float
@export var Height_Max: float

@export_group("Attack")
@export var Damage_Low_Attack: float
@export var Damage_High_Attack: float
@export var Knockback_Low: float
@export var Knockback_High: float

@export_group("Time")
@export var Explosion_Time: float

@export_group("Size")
@export var Explosion_Size: float
