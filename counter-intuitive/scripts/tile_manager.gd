extends Control
class_name TileManager

@export var handNode : Node
var handArray : Array

@export var deckNode : Node2D
var deckArray : Array

@export var discardNode : Node2D
var discardArray : Array

@export var tileBasic : PackedScene
@export var handSlot : PackedScene

var triggerOrderArray : Array

var currentOnBoardTileTriggerIndex : int
var handSlots : Array
var lastOpenIndex : int

var heldTile : Tile

func _ready() -> void:
	Globals.tileManager = self
	
	for i in 10:
		CreateNewHandSlot()
	lastOpenIndex = 0;
	
	
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
		print(triggerOrderArray.size())
		while(triggerOrderArray.size() > 0):
			AddTileToLocation(triggerOrderArray[0], Reference.TILE_LOCATIONS.discard)
		print("All done triggering boss")
	else:
		triggerOrderArray[currentOnBoardTileTriggerIndex].OnBoardTrigger()
		currentOnBoardTileTriggerIndex += 1

# connected to Set Button signal
func _on_play_button_pressed():
	print("set button pressed")
	currentOnBoardTileTriggerIndex = 0
	TriggerNextTileOnBoard()
	
