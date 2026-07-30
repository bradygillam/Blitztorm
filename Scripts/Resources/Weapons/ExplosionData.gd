extends Resource
class_name ExplosionData

@export var Name: String

@export_group("Attack")
@export var Damage_Low_Attack: float
@export var Damage_High_Attack: float
@export var Knockback_Low: float
@export var Knockback_High: float

@export_group("Time")
@export var Explosion_Time: float

@export_group("Size")
@export var Size: float
