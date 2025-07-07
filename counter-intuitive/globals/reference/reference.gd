extends Node2D
@export var WhiteTile : PackedScene
@export var BlackTile : PackedScene
@export var GreenTile : PackedScene
@export var GrayTile : PackedScene
@export var OrangeTile : PackedScene

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

enum MOVE_DIRECTIONS {
	north,
	south,
	east,
	west,
	northeast,
	southeast,
	northwest,
	southwest
}

var Cardinals = [MOVE_DIRECTIONS.north, MOVE_DIRECTIONS.south, MOVE_DIRECTIONS.east, MOVE_DIRECTIONS.west]
var Ordinals = [MOVE_DIRECTIONS.northeast, MOVE_DIRECTIONS.southeast, MOVE_DIRECTIONS.northwest, MOVE_DIRECTIONS.southwest]
var TileScenes : Dictionary = {
	"WhiteTile" : WhiteTile,
	"BlackTile" : BlackTile,
	"GreenTile" : GreenTile,
	"GrayTile" : GrayTile,
	"OrangeTile" : OrangeTile
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
	TileScenes["GreenTile"] = GreenTile
	TileScenes["GrayTile"] = GrayTile
	TileScenes["OrangeTile"] = OrangeTile
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
