extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if (Input.is_action_just_pressed("debug_print_arrays")):
		#_debug_print_arrays()
	#if (Input.is_action_just_pressed("debug_add_tile")):
		#debug_create_tile()
	#if (Input.is_action_just_pressed("debug_draw_tile")):
		#debug_draw_tile()
		#
	#if (Input.is_action_just_pressed("debug_reset_round")):
		#debug_reset_round()
	#if (Input.is_action_just_pressed("debug_reset_stage")):
		#debug_reset_stage()
	#if (Input.is_action_just_pressed("debug_reset_run")):
		#debug_reset_run()
	#if (Input.is_action_just_pressed("debug_generic")):
		#debug_generic()
	pass
#region Debug
func _debug_print_arrays():
	print("Deck: " + str(Globals.tileManager.deckArray))
	print("Discard: " + str(Globals.tileManager.discardArray))
	print("Hand: " + str(Globals.tileManager.handArray))
	print("Board: " + str(Globals.board.boardTilesArray))
	print("Flat Board: " + str(Globals.board.flatBoardTilesArray))
	print("Trigger Array: " + str(Globals.main.triggerArray))
	print("AllTiles: " + str(Globals.tileManager.allTiles))
	
	print("Hand Size: " + str(Globals.main.handSize))
	print("Hand Slot Array Size: " + str(Globals.tileManager.handSlots.size()))
	print("Last Index: " + str(Globals.tileManager.lastOpenIndex))
	


func debug_create_tile():
	Globals.tileManager.CreatePlayTileToDeck(Globals.tileManager.tileBasic)
	
func debug_draw_tile():
	Globals.tileManager.DrawTopTileFromDeck()
	
func debug_shuffle():
	pass
	
func debug_reset_round():
	Globals.main.ResetRound()
	
func debug_reset_stage():
	Globals.main.ResetStage()
	
func debug_reset_run():
	Globals.main.ResetRun()
#endregion

func debug_generic():
	Globals.main.tokens += 10000
	Globals.main.score += 10000
