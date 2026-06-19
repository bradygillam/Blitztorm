extends Node

var selectionSquare: ColorRect
var selectionSquareColour: Color = Color.DEEP_SKY_BLUE
var selectionSquareZIndex: int = 99
var selectionSquareAlpha: float = 0.5

var placementLine: Line2D
var placementLineColour: Color = Color.DEEP_SKY_BLUE
var placementLineZIndex: int = 99
var placementLineAlpha: float = 0.9
var placementLineWidth: float = 4

var selectionSquareStartVector: Vector2
var topLeftCorner: Vector2
var bottomRightCorner: Vector2

var placementLineStartVector: Vector2

var selectedUnits: Array[PlayerBaseUnit]

func _ready() -> void:
	selectionSquare = ColorRect.new()
	selectionSquare.color = selectionSquareColour
	selectionSquare.z_index = selectionSquareZIndex
	selectionSquare.color.a = selectionSquareAlpha
	
	placementLine = Line2D.new()
	placementLine.default_color = placementLineColour
	placementLine.z_index = placementLineZIndex
	placementLine.default_color.a = placementLineAlpha
	placementLine.width = placementLineWidth
	
	add_child(selectionSquare)
	add_child(placementLine)
	selectionSquare.visible = false
	placementLine.visible = false


func _process(_delta: float) -> void:
	HandleUnitSelection()
	HandleUnitPlacement()


func HandleUnitSelection() -> void:
	if Input.is_action_just_pressed("Unit_Selection"):
		ResetSelections()
		selectionSquare.visible = true
		selectionSquareStartVector = get_viewport().get_mouse_position()
	if Input.is_action_pressed("Unit_Selection"):
		var pressEndVector: Vector2 = get_viewport().get_mouse_position()
		topLeftCorner = Vector2 (min(selectionSquareStartVector.x, pressEndVector.x), min(selectionSquareStartVector.y, pressEndVector.y))
		bottomRightCorner = Vector2 (max(selectionSquareStartVector.x, pressEndVector.x), max(selectionSquareStartVector.y, pressEndVector.y))
		selectionSquare.position = topLeftCorner
		selectionSquare.size = bottomRightCorner - topLeftCorner
	if Input.is_action_just_released("Unit_Selection"):
		selectedUnits = GetAllPlayerUnitsInSelection(topLeftCorner, bottomRightCorner)
		selectionSquare.visible = false


func ResetSelections() -> void:
	for unit in selectedUnits:
		unit.WasDeselected()
	selectedUnits = []


func HandleUnitPlacement() -> void:
	if Input.is_action_just_pressed("Unit_Placement"):
		placementLine.visible = true
		placementLineStartVector = get_viewport().get_mouse_position()
	if Input.is_action_pressed("Unit_Placement"):
		placementLine.clear_points()
		placementLine.add_point(placementLineStartVector)
		placementLine.add_point(get_viewport().get_mouse_position())
	if Input.is_action_just_released("Unit_Placement"):
		var equidistantPoints: Array[Vector2] = GetEquidistantPointsOnLine(selectedUnits.size(), placementLine.points[0], placementLine.points[1])
		AssignPoints(equidistantPoints)
		selectedUnits = []
		placementLine.visible = false
		placementLine.clear_points()


func GetAllPlayerUnitsInSelection(topLeftCornerIn: Vector2, bottomRightCornerIn: Vector2) -> Array[PlayerBaseUnit]:
	var selectedUnitsOut: Array[PlayerBaseUnit] = []
	var selectionBox: Rect2 = Rect2(topLeftCornerIn, bottomRightCornerIn - topLeftCornerIn).abs()
	
	for unit in UnitHandler.playerUnits:
		if selectionBox.has_point(unit.global_position):
			selectedUnitsOut.append(unit)
			unit.WasSelected()
	
	return selectedUnitsOut

func GetEquidistantPointsOnLine(numPointsNeeded: int, lineStart: Vector2, lineEnd: Vector2) -> Array[Vector2]:
	var destinationVectors: Array[Vector2] = []
	
	if numPointsNeeded == 1:
		return [(lineStart + lineEnd) / 2]
	for i in range(numPointsNeeded):
		var deltaDistance = float(i) / (float(numPointsNeeded) - 1)
		destinationVectors.append(lineStart.lerp(lineEnd, deltaDistance))
	
	return destinationVectors

func AssignPoints(listOfPoints: Array[Vector2]) -> void:
	if selectedUnits.size() != listOfPoints.size():
		printerr("Non-equal number of selected units: " + str(selectedUnits.size()) + " and assignable points: " + str(listOfPoints.size()))
	
	for i in range(selectedUnits.size()):
		selectedUnits[i].AssignDestination(listOfPoints[i])
