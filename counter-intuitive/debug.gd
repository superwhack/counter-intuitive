extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_print_arrays")):
		_debug_print_arrays()
	if (Input.is_action_just_pressed("debug_add_tile")):
		debug_create_tile()
	if (Input.is_action_just_pressed("debug_draw_tile")):
		debug_draw_tile()
		
#region Debug
func _debug_print_arrays():
	print("Deck: " + str(Globals.tileManager.deckArray))
	print("Discard: " + str(Globals.tileManager.discardArray))
	print("Hand: " + str(Globals.tileManager.handArray))
	print("Board: " + str(Globals.board.boardTilesArray))
	print("Flat Board: " + str(Globals.board.flatBoardTilesArray))
	print("Trigger Array: " + str(Globals.tileManager.triggerOrderArray))


func debug_create_tile():
	var newTile = Globals.tileManager.tileBasic.instantiate()
	newTile.tileManager = Globals.tileManager
	Globals.tileManager.add_child(newTile)
	Globals.tileManager.AddTileToLocation(newTile, Reference.TILE_LOCATIONS.deck)

func debug_draw_tile():
	Globals.tileManager.DrawTopTileFromDeck()
	
func debug_shuffle():
	pass
	
#endregion
