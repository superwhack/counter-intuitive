extends Node2D
class_name TileRemovalManager

@export var visualDeck : Control
@export var scroll : Control
@export var visualTileSlotScene : PackedScene
@export var removalTileScene : PackedScene
func _init() -> void:
	Globals.tileRemovalManager = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func AttemptRemoval(removalTile):
	Globals.tileManager.RemoveTile(removalTile.visualTile.associatedTile)
	removalTile.queue_free()
	UpdateVisualDeck()
	

func AddVisualTileToLocation(visualTile : VisualTile):
	var visualTileSlot = visualTileSlotScene.instantiate()
	visualDeck.add_child(visualTileSlot)
	
	var removalTile = removalTileScene.instantiate()
	removalTile.visualTile = visualTile
	visualTileSlot.add_child(removalTile)
	visualTile.reparent(removalTile)
	visualTileSlot.visualTile = visualTile
	
	visualTile.position = visualTileSlot.size / 2
	
	
	
func UpdateVisualDeck():
	for child in visualDeck.get_children():
		Globals.tileManager.visualTiles.erase(child.visualTile)
		child.visible = false
		child.queue_free()
	
	var deckCopy = Globals.tileManager.allTiles
	deckCopy.shuffle()
	for tile in deckCopy:
		var visualTile = Globals.tileManager.CreateVisualTile(tile)
		AddVisualTileToLocation(visualTile)
	
	
	
