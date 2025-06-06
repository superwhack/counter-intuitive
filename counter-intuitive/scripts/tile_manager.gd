extends Control
class_name TileManager

@export var handNode : Node
var handArray : Array

@export var deckNode : Node
var deckArray : Array

@export var discardNode : Node
var discardArray : Array

@export var tileBasic : PackedScene
@export var handSlot : PackedScene

var boardArray : Array

var currentOnBoardTileTriggerIndex : int
var handSlots : Array
var lastOpenIndex : int

func _ready() -> void:
	Globals.tileManager = self
	
	for i in 10:
		CreateNewHandSlot()
	lastOpenIndex = 0;
	
	
	# CONNECTING SIGNALS
	SignalBus.SetButtonPressed.connect(_on_set_button_pressed)
	SignalBus.PullNextTileOnBoardTrigger.connect(TriggerNextTileOnBoard)
	
	
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_add_tile")):
		debug_create_tile()

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
	
func debug_create_tile():
	var newTile = tileBasic.instantiate()
	newTile.tileManager = self
	newTile.location = Reference.TILE_LOCATIONS.hand
	add_child(newTile)
	ReparentToLastOpenSlot(newTile)


func TriggerNextTileOnBoard():
	currentOnBoardTileTriggerIndex += 1
	if (currentOnBoardTileTriggerIndex == boardArray.size()):
		print("All done triggering boss")
	else:
		boardArray[currentOnBoardTileTriggerIndex].OnBoardTrigger()

func _on_set_button_pressed():
	print("set button pressed")
	currentOnBoardTileTriggerIndex = -1
	TriggerNextTileOnBoard()
