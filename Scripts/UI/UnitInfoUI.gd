extends Control
class_name UnitInfoUI

var unitData: FriendlyData
var unitState: State

var UI_name: Label
var UI_state: Label
var UI_cost: Label
var UI_speed: Label
var UI_health: Label
var UI_accuracy: Label
var UI_damage: Label
var UI_shotsPer: Label

func _ready() -> void:
	UI_name = find_child("Name", true, false)
	UI_state = find_child("State", true, false)
	UI_cost = find_child("Cost", true, false)
	UI_speed = find_child("Speed", true, false)
	UI_health = find_child("Health", true, false)
	UI_accuracy = find_child("Accuracy", true, false)
	UI_damage = find_child("Damage", true, false)
	UI_shotsPer = find_child("Shots", true, false)

func _process(_delta: float) -> void:
	DrawUI()

func DrawPawnInfo(unitDataIn: FriendlyData, unitPositionIn: Vector2, currentState: State) -> void:
	unitData = unitDataIn
	position = GetUIPosition(unitPositionIn)
	unitState = currentState
	visible = true

func UnDrawPawnInfoUI() -> void:
	visible = false

func DrawUI() -> void:
	if unitData == null:
		return
	UI_name.text = "Unit: " + unitData.Name
	UI_state.text = "State: " + unitState.name
	UI_cost.text = "Cost: " + str(unitData.Cost)
	UI_speed.text = "Speed: " + str(unitData.Movement_Speed)
	UI_health.text = "Health: " + str(unitData.Health)
	UI_accuracy.text = "Accuracy: %" + str(100 * unitData.Accuracy_Attack)
	UI_damage.text = "Damage: " + str(unitData.Damage_Low_Attack) + " - " + str(unitData.Damage_High_Attack)
	UI_shotsPer.text = "Shots: " +  str(unitData.Number_Low_Attack) + " - " + str(unitData.Number_High_Attack)

func GetUIPosition(unitPosition: Vector2) -> Vector2:
	var viewportSize: Vector2 = get_viewport_rect().size
	var UIPosition: Vector2 = Vector2.ZERO
	var offSet: float = 10
	
	if unitPosition.x + size.x >= viewportSize.x:
		UIPosition.x = unitPosition.x - size.x - offSet
	else:
		UIPosition.x = unitPosition.x
	
	if unitPosition.y + size.y >= viewportSize.y:
		UIPosition.y = unitPosition.y - size.y - offSet
	else:
		UIPosition.y = unitPosition.y
		
	return UIPosition
