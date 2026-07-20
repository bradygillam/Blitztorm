extends Node

var playerStartingCash: float = 10000
var playerCash: float = playerStartingCash

var waveStartingNumber: int = 0
var waveNumber: int = waveStartingNumber

var enemyStartingCash: float = 100
var enemyCash: float = enemyStartingCash

var waveLabel: Label
var playerCashLabel: Label

func _ready() -> void:
	waveLabel = get_tree().root.find_child("WaveNumber", true, false)
	playerCashLabel = get_tree().root.find_child("CashAmount", true, false)
	waveLabel.text = "Wave: " + str(GlobalData.waveNumber)
	playerCashLabel.text = "Cash: " + str(GlobalData.playerCash)

func IncreaseEnemyCash(increaseAmount: float) -> void:
	enemyCash += increaseAmount

func DecreaseEnemyCash(decreaseAmount: float) -> void:
	enemyCash -= decreaseAmount

func IncreaseWaveNumber(increaseAmount: int) -> void:
	waveNumber += increaseAmount
	waveLabel.text = "Wave: " + str(GlobalData.waveNumber)

func IncreasePlayerCash(increaseAmount: float) -> void:
	playerCash += increaseAmount
	playerCashLabel.text = "Cash: " + str(GlobalData.playerCash)

func DecreasePlayerCash(decreaseAmount: float) -> void:
	playerCash -= decreaseAmount
	playerCashLabel.text = "Cash: " + str(GlobalData.playerCash)
