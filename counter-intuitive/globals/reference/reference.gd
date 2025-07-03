extends Node2D
@export var WhiteTile : PackedScene
@export var BlackTile : PackedScene

enum COLLISION_LAYERS {
	Tiles,
	BoardSpaces
}

enum TILE_LOCATIONS {
	pickup, 
	hand,
	deck,
	discard,
	board,
	none,
	shop
}

enum STARTING_DECKS {
	WhiteDeck,
	TestDeck
}

var TileScenes : Dictionary = {
	"WhiteTile" : WhiteTile,
	"BlackTile" : BlackTile
}


var handSlotSize : Vector2
var boardSlotSize : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boardSlotSize = Vector2(64, 64)
	handSlotSize = Vector2(64, 64)
	
	# Fill Dictionary
	TileScenes["WhiteTile"] = WhiteTile
	TileScenes["BlackTile"] = BlackTile
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
