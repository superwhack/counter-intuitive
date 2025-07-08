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

func CreateVisualTile(tileScene : PackedScene):
	pass
	
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
	for i in (main.handSize - handArray.size()):
		DrawTopTileFromDeck()

func CreateHand():
	for i in main.handSize:
		CreateNewHandSlot()
	lastOpenIndex = 0;
	

func StartRound():
	DrawHand()
	
func ResetRound():
	for tile in allTiles:
		tile.ResetRound()
	
func ResetStage():
	ShuffleAllIntoDeck()
	for tile in allTiles:
		tile.ResetStage()

func ResetRun():
	for tile in allTiles:
		tile.queue_free()
	allTiles.clear()
	
	for slot in handSlots:
		slot.queue_free()
	handSlots.clear()
	
	CreateHand()
	
	handArray.clear()
	deckArray.clear()
	discardArray.clear()

func _process(delta: float) -> void:
	pass

func MoveTile(tile : Tile, direction : Reference.DIRECTIONS):
	var newSlot = Globals.board.GetNeighboringSlotFromTile(tile, direction)
	if (newSlot != null):
		Globals.board.ChangeSlot(tile, newSlot)
	else:
		print("move failure")
	
