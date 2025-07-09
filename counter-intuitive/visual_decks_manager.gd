extends Control
class_name VisualDecksManager
@export var visualDeck : Control

@export var visualTileSlotScene : PackedScene
# Called when the node enters the scene tree for the first time.

func _init() -> void:
	pass
func _ready() -> void:
	Globals.visualDecksManager = self
	print(Globals.visualDecksManager)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func AddVisualTileToLocation(visualTile : VisualTile, location : Control):
	var visualTileSlot = visualTileSlotScene.instantiate()
	location.add_child(visualTileSlot)
	
	visualTile.reparent(visualTileSlot)
	visualTileSlot.visualTile = visualTile
	
	visualTile.position = visualTileSlot.size / 2
	
	
func UpdateVisualDeck():
	
	for child in visualDeck.get_children():
		Globals.tileManager.visualTiles.erase(child.visualTile)
		
		child.queue_free()
	
	for tile in Globals.tileManager.deckArray:
		var visualTile = Globals.tileManager.CreateVisualTile(tile)
		AddVisualTileToLocation(visualTile, visualDeck)
	

func StartRound():
	UpdateVisualDeck()
