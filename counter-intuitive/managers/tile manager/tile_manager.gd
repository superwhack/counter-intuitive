extends Control
class_name TileManager

var main : Main

@export var handNode : Node
var handArray : Array

@export var deckNode : Node2D
var deckArray : Array

@export var discardNode : Node2D
var discardArray : Array

@export var tileBasic : PackedScene
@export var handSlot : PackedScene

@export var visualTileScene : PackedScene

var visualTiles : Array

var allTiles : Array

var handSlots : Array
var lastOpenIndex : int

var heldTile : Tile

func _ready() -> void:
	Globals.tileManager = self
	main = Globals.main

#region Hand Management
func CreateNewHandSlot() -> Node:
	var newSlot = handSlot.instantiate()
	handNode.add_child(newSlot)
	handSlots.append(newSlot)
	return newSlot

func ReparentToHandSlot(tile : Node2D, slot : Control):
	tile.reparent(slot, true)
	tile.desiredPosition = Reference.handSlotSize / 2
	
func ReparentToLastOpenSlot(tile : Node2D):
	print("wenttolastopen")
	ReparentToHandSlot(tile, handSlots[lastOpenIndex])
	lastOpenIndex += 1
	
func ShiftTilesLeftInHand(index : int):
	lastOpenIndex -= 1
	for i in range(index + 1, handSlots.size()):
		var slotChildren = handSlots[i].get_children()
		if (slotChildren.size() != 0):
			ReparentToHandSlot(slotChildren[0], handSlots[i-1])
		
func ShiftTilesLeftInHandFromTile(tile : Node2D):
	ShiftTilesLeftInHand(handSlots.find(tile.get_parent()))
#endregion	

#region Deck Management
func DrawTopTileFromDeck():
	# Draw if the hand isn't full
	if (handArray.size() < main.handSize):
		# If the deck is empty try to shuffle new tiles in
		if (deckArray.size() == 0):
			ShuffleDiscardIntoDeck()
		# Then try to draw, as long as there's tiles
		if (deckArray.size() > 0):
			AddTileToLocation(deckArray.pop_front(), Reference.TILE_LOCATIONS.hand)
		
func DiscardTile(tile : Tile):
	AddTileToLocation(tile, Reference.TILE_LOCATIONS.discard)
	
func Reshuffle():
	deckArray.shuffle()
	
func AddTileToDeck(tile : Tile):
	AddTileToLocation(tile, Reference.TILE_LOCATIONS)
	
func AddTileToLocation(tile : Tile, location : Reference.TILE_LOCATIONS):
	RemoveTileFromManagerArrays(tile)
	tile.location = location
	AddTileToArrayFromLocation(tile)
	ReparentTileFromLocation(tile)
	
func AddTileToArrayFromLocation(tile):
	match(tile.location):
		Reference.TILE_LOCATIONS.hand:
			handArray.append(tile)
		Reference.TILE_LOCATIONS.deck:
			deckArray.append(tile)
		Reference.TILE_LOCATIONS.discard:
			discardArray.append(tile)

func ReparentTileFromLocation(tile):
	match(tile.location):
		Reference.TILE_LOCATIONS.hand:
			ReparentToLastOpenSlot(tile)
			print(lastOpenIndex)
		Reference.TILE_LOCATIONS.deck:
			tile.reparent(deckNode)
		Reference.TILE_LOCATIONS.discard:
			tile.reparent(discardNode)

			
func RemoveTileFromManagerArrays(tile : Tile):
	match(tile.location):
		Reference.TILE_LOCATIONS.hand:
			ShiftTilesLeftInHandFromTile(tile)
			handArray.erase(tile)
		Reference.TILE_LOCATIONS.deck:
			deckArray.erase(tile)
		Reference.TILE_LOCATIONS.discard:
			discardArray.erase(tile)
		Reference.TILE_LOCATIONS.board:
			Globals.board.RemoveTileFromBoard(tile)
#endregion

	
func CreateTile(tileScene : PackedScene) -> Tile:
	var newTile = tileScene.instantiate()
	add_child(newTile)
	
	newTile.tileManager = self
	newTile.main = Globals.main
	newTile.desiredPosition = newTile.position
	
	return newTile
	
func CreatePlayTile(tileScene : PackedScene) -> Tile:
	var newTile = CreateTile(tileScene)
	
	allTiles.append(newTile)

	return newTile

func CreatePlayTileToDeck(tileScene : PackedScene):
	var newTile = CreatePlayTile(tileScene)
	AddTileToLocation(newTile, Reference.TILE_LOCATIONS.deck)
	newTile.position = Vector2(0, 0)
	return newTile

func CreateVisualTile(tile : Tile):
	var visualTile = visualTileScene.instantiate()
	add_child(visualTile)
	visualTile.Associate(tile)
	return visualTile
	
	
func ShuffleDiscardIntoDeck():
	while(discardArray.size() > 0):
		AddTileToLocation(discardArray[0], Reference.TILE_LOCATIONS.deck)
	deckArray.shuffle()

func ShuffleAllIntoDeck():
	while(discardArray.size() > 0):
		AddTileToLocation(discardArray[0], Reference.TILE_LOCATIONS.deck)
	while(handArray.size() > 0):
		AddTileToLocation(handArray[0], Reference.TILE_LOCATIONS.deck)
	
	deckArray.shuffle()
	
func DrawHand():
	lastOpenIndex = handArray.size()
	for i in (main.handSize - handArray.size()):
		DrawTopTileFromDeck()

func CreateHand():
	for i in main.handSize:
		CreateNewHandSlot()

	

func StartRound():
	DrawHand()
	
func ResetRound():
	for tile in allTiles:
		tile.ResetRound()
	
func ResetStage():
	for slot in handSlots:
		slot.queue_free()
	handSlots.clear()

	CreateHand()
	ShuffleAllIntoDeck()
	for tile in allTiles:
		tile.ResetStage()

func ResetRun():
	for tile in allTiles:
		tile.queue_free()
	allTiles.clear()
	

	
	handArray.clear()
	deckArray.clear()
	discardArray.clear()

func _process(delta: float) -> void:
	pass

# Returns an array, where the 1st value is the successfulness of the move
# and the second value is the direction moved.
func MoveTile(tile : Tile, direction : Reference.DIRECTIONS):
	var newSlot = Globals.board.GetNeighboringSlotFromTile(tile, direction)
	if (newSlot != null):
		return [Globals.board.ChangeSlot(tile, newSlot), direction]
	else:
		return [false, -1]
		
func MoveTileInRandomDirection(tile : Tile):
	var direction = randi_range(0, 7)
	return MoveTile(tile, direction)
	
func MoveTileInRandomCardinalDirection(tile : Tile):
	return MoveTile(tile, randi_range(0, 3))
	
func MoveTileInRandomOrdinalDirection(tile : Tile):
	return MoveTile(tile, randi_range(4, 7))

func MoveTileInRandomValidDirection(tile : Tile):
	var directions = Reference.Directions.duplicate()
	var returnValue = [false, -1]
	while (directions.size() > 0):
		var newDirection = directions[randi_range(0, directions.size() - 1)]
		returnValue = MoveTile(tile, newDirection)
		if (returnValue[0]):
			return returnValue
		else:
			print("directional failure")
			directions.erase(newDirection)
	return [false, -1]
			
	
func MoveTileInValidRandomCardinalDirection(tile : Tile):
	var directions = Reference.Cardinals.duplicate()
	var returnValue = [false, -1]
	while (directions.size() > 0):
		var newDirection = directions[randi_range(0, directions.size() - 1)]
		returnValue = MoveTile(tile, newDirection)
		if (returnValue[0]):
			return returnValue
		else:
			print("directional failure")
			directions.erase(newDirection)
	return [false, -1]
	
func MoveTileInValidRandomOrdinalDirection(tile : Tile):
	var directions = Reference.Ordinals.duplicate()
	var returnValue = [false, -1]
	while (directions.size() > 0):
		var newDirection = directions[randi_range(0, directions.size() - 1)]
		returnValue = MoveTile(tile, newDirection)
		if (returnValue[0]):
			return returnValue
		else:
			print("directional failure")
			directions.erase(newDirection)
	return [false, -1]

func GetNeighboringTiles(tile : Tile):
	var neighboringSlots = []
	var neighboringTiles = []
	for i in 8:
		neighboringSlots.append(Globals.board.GetNeighboringSlotFromTile(tile, i))
		
	for slot in neighboringSlots:
		if (slot != null && slot.tile != null):
			neighboringTiles.append(slot.tile)
			
	return neighboringTiles

	
