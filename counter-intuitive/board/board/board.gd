extends Node2D
class_name Board

var boardSlotSize : Vector2
@export var spacing : Vector2
@export var boardSlot : PackedScene

var locked : bool

var boardSlotsArray : Array
var flatBoardSlotsArray : Array
var boardTilesArray : Array
var flatBoardTilesArray : Array

var numRows : int = 4
var numColumns : int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.board = self
	boardSlotSize = Reference.boardSlotSize
	
	locked = false
	


func _process(delta: float) -> void:
	pass

func ClearAllTilesFromBoard():
	while (flatBoardTilesArray.size() > 0):
		RemoveTileFromBoard(flatBoardTilesArray[0])
		
func AddTileToBoard(tile : Tile, boardSlot : BoardSlot):
	if (Globals.main.tilesRemaining > 0):
		tile.reparent(boardSlot, true)
		tile.desiredPosition = Vector2.ZERO
		
		Globals.tileManager.RemoveTileFromManagerArrays(tile)
		
		tile.location = Reference.TILE_LOCATIONS.board
		
		boardSlot.tile = tile
		
		AddTileToBoardArrays(tile)
		
		
		Globals.main.tilesRemaining -= 1
	else:
		Globals.tileManager.AddTileToLocation(tile, Reference.TILE_LOCATIONS.hand)
		
func RemoveTileFromBoard(tile):
	# reset the board slot's tile
	var boardSlot = tile.get_parent()
	boardSlot.tile = null
	
	# remove the tile from the arrays
	RemoveTileFromBoardArrays(tile)
	
	# reparent it to main
	tile.reparent(Globals.main, true)
	
	# set its location
	tile.location = Reference.TILE_LOCATIONS.none
	
	Globals.main.tilesRemaining += 1
	
func DiscardTileFromBoard(tile):
	Globals.tileManager.AddTileToLocation(tile, Reference.TILE_LOCATIONS.discard)
	
func DiscardAllTilesFromBoard():
	while (flatBoardTilesArray.size() > 0):
		DiscardTileFromBoard(flatBoardTilesArray[0])
		
func CreateBoardSlots():
	# start in the top left
	var currentPos : Vector2 = ((numRows - 1) * -0.5 * boardSlotSize) + ((numRows - 1) * -0.5 * spacing)
	for r in numRows:
		boardSlotsArray.append([])
		for c in numColumns:
			var newSlot = boardSlot.instantiate()
			add_child(newSlot)
			newSlot.name = (str(r) + " : " + str(c))
			newSlot.position = currentPos
			boardSlotsArray[r].append(newSlot)
			flatBoardSlotsArray.append(newSlot)
			
			currentPos.x += spacing.x + boardSlotSize.x
		currentPos.x -= numRows * (spacing.x + boardSlotSize.x)
		currentPos.y += spacing.y + boardSlotSize.y
		
func CreateTileArrays():
	flatBoardTilesArray = []
	boardTilesArray = []
	
	for r in numRows:
		boardTilesArray.append([])
		for c in numColumns:
			boardTilesArray[r].append(null)
			
func AddTileToBoardArrays(tile : Tile):
	for r in numRows:
		for c in numColumns:
			if (boardSlotsArray[r][c].get_children().has(tile)):
				boardTilesArray[r][c] = tile
	flatBoardTilesArray.append(tile)
	
func RemoveTileFromBoardArrays(tile : Tile):
	for r in numRows:
		var found = boardTilesArray[r].find(tile)
		if (found != -1):
			boardTilesArray[r][found] = null
	flatBoardTilesArray.erase(tile)
	
func ResetRound():
	locked = false
	DiscardAllTilesFromBoard()
	
func ResetStage():
	DiscardAllTilesFromBoard()
	
func ResetRun():
	DiscardAllTilesFromBoard()
	
	for slot in flatBoardSlotsArray:
		slot.queue_free()
	flatBoardSlotsArray.clear()
	boardSlotsArray.clear()
	
	CreateBoardSlots()
	
	boardTilesArray.clear()
	flatBoardTilesArray.clear()
	
	CreateTileArrays()
	
func GetSlotIndices(boardSlot : BoardSlot):
	for r in numRows:
		for c in numColumns:
			if (boardSlotsArray[r][c] == boardSlot):
				return Vector2(r, c)
	return null
	
func GetNeighboringSlot(boardSlot : BoardSlot, direction : Reference.DIRECTIONS):
	var indices = GetSlotIndices(boardSlot)

	match direction:
		Reference.DIRECTIONS.south:
			if (indices.x < numRows - 1):
				return boardSlotsArray[indices.x + 1][indices.y]
			else:
				return null
		Reference.DIRECTIONS.north:
			if (indices.x > 0):
				return boardSlotsArray[indices.x - 1][indices.y]
			else:
				return null
		Reference.DIRECTIONS.east:
			if (indices.y < numColumns - 1):
				return boardSlotsArray[indices.x][indices.y + 1]
			else:
				return null
		Reference.DIRECTIONS.west:
			if (indices.y > 0):
				return boardSlotsArray[indices.x][indices.y - 1]
			else:
				return null
		Reference.DIRECTIONS.southeast:
			if (indices.x < numRows - 1 && indices.y < numColumns - 1):
				return boardSlotsArray[indices.x + 1][indices.y + 1]
			else:
				return null
		Reference.DIRECTIONS.northeast:
			if (indices.x > 0 && indices.y < numColumns - 1):
				return boardSlotsArray[indices.x - 1][indices.y + 1]
			else:
				return null
		Reference.DIRECTIONS.northwest:
			if (indices.x > 0 && indices.y > 0):
				return boardSlotsArray[indices.x - 1][indices.y - 1]
			else:
				return null
		Reference.DIRECTIONS.southwest:
			if (indices.x < numRows - 1 && indices.y > 0):
				return boardSlotsArray[indices.x + 1][indices.y - 1]
			else:
				return null
	
func GetNeighboringSlotFromTile(tile : Tile, direction : Reference.DIRECTIONS):
	if (tile.get_parent() is BoardSlot):
		return GetNeighboringSlot(tile.get_parent(), direction)
	else:
		return null
		
func ChangeSlot(tile : Tile, boardSlot : BoardSlot):
	var currentSlot = tile.get_parent()
	if (currentSlot is BoardSlot && boardSlot.tile == null):
		# reset the board slot's tile
		currentSlot.tile = null
		
		# remove the tile from the arrays
		RemoveTileFromBoardArrays(tile)
		
		# start of add
		tile.reparent(boardSlot, true)
		tile.desiredPosition = Vector2.ZERO
		
		boardSlot.tile = tile
		
		AddTileToBoardArrays(tile)
		return true
	else:
		return false
		
func CheckFullRows():
	var results = []
	for i in numRows:
		results.append(true)
		for spot in boardTilesArray[i]:
			if (spot == null):
				results[i] = false
				
	return results

		
