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
var triggerOrderArray : Array

var currentOnBoardTileTriggerIndex : int
var handSlots : Array
var lastOpenIndex : int

var heldTile : Tile

func _ready() -> void:
	Globals.tileManager = self
	main = Globals.main

	
	# CONNECTING SIGNALS
	SignalBus.PlayButtonPressed.connect(_on_play_button_pressed)
	SignalBus.PullNextTileOnBoardTrigger.connect(TriggerNextTileOnBoard)

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
	if (handArray.size() != handSlots.size()):
		if (deckArray.size() == 0):
			ShuffleDiscardIntoDeck()
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


# connected to PullNextTileOnBoardTrigger signal
func TriggerNextTileOnBoard():
	if (currentOnBoardTileTriggerIndex == triggerOrderArray.size()):
		Globals.board.DiscardAllTilesFromBoard()
		print("All done triggering boss")
	else:
		triggerOrderArray[currentOnBoardTileTriggerIndex].OnBoardTrigger()
		currentOnBoardTileTriggerIndex += 1

# connected to Set Button signal
func _on_play_button_pressed():
	print("set button pressed")
	currentOnBoardTileTriggerIndex = 0
	TriggerNextTileOnBoard()
	
	
func CreateTile(tileScene : PackedScene):
	var newTile = tileScene.instantiate()
	add_child(newTile)

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
	while (lastOpenIndex < handSlots.size()):
		DrawTopTileFromDeck()

func CreateHand():
	print("create hand")
	for i in main.handSize:
		CreateNewHandSlot()
	lastOpenIndex = 0;
	

func ResetRound():
	for tile in allTiles:
		tile.ResetRound()
	DrawHand()
	
func ResetStage():
	ShuffleAllIntoDeck()

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
	triggerOrderArray.clear()
	

	
