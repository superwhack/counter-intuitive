extends Control
class_name VisualDecksManager
@export var visualDeck : Control
@export var visualDeckScroll : Control
@export var visualDiscard: Control
@export var visualDiscardScroll : Control
@export var visualTileSlotScene : PackedScene


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
		child.visible = false
		child.queue_free()
	
	var deckCopy = Globals.tileManager.deckArray
	deckCopy.shuffle()
	for tile in deckCopy:
		var visualTile = Globals.tileManager.CreateVisualTile(tile)
		AddVisualTileToLocation(visualTile, visualDeck)
	
func UpdateVisualDiscard():
	
	for child in visualDiscard.get_children():
		Globals.tileManager.visualTiles.erase(child.visualTile)
		child.queue_free()
	
	var deckCopy = Globals.tileManager.discardArray
	deckCopy.shuffle()
	for tile in deckCopy:
		var visualTile = Globals.tileManager.CreateVisualTile(tile)
		AddVisualTileToLocation(visualTile, visualDiscard)
	


func StartRound():
	UpdateVisualDeck()
	UpdateVisualDiscard()
	

func _on_deck_button_pressed() -> void:
	visualDiscardScroll.visible = false
	visualDeckScroll.visible = !visualDeckScroll.visible


func _on_discard_button_pressed() -> void:
	visualDeckScroll.visible = false
	visualDiscardScroll.visible = !visualDiscardScroll.visible
