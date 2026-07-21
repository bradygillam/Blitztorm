extends Resource
class_name FriendlyData

@export var Name: String
@export var Cost: int
@export var Health: int

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
