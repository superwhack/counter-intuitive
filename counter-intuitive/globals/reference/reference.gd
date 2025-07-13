extends Node2D
@export var WhiteTile : PackedScene
@export var BlackTile : PackedScene
@export var GreenTile : PackedScene
@export var GrayTile : PackedScene
@export var OrangeTile : PackedScene
@export var YellowTile : PackedScene
@export var PinkTile : PackedScene
@export var RedTile : PackedScene
@export var PurpleTile : PackedScene
@export var BlueTile : PackedScene


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

enum DIRECTIONS {
	north,
	south,
	east,
	west,
	northeast,
	southeast,
	northwest,
	southwest
}

var Cardinals = [DIRECTIONS.north, DIRECTIONS.south, DIRECTIONS.east, DIRECTIONS.west]
var Ordinals = [DIRECTIONS.northeast, DIRECTIONS.southeast, DIRECTIONS.northwest, DIRECTIONS.southwest]
var Directions = Cardinals + Ordinals

var TileScenes : Dictionary = {
	"WhiteTile" : WhiteTile,
	"BlackTile" : BlackTile,
	"GreenTile" : GreenTile,
	"GrayTile" : GrayTile,
	"OrangeTile" : OrangeTile,
	"YellowTile" : YellowTile,
	"PinkTile" : PinkTile,
	"RedTile" : RedTile,
	"PurpleTile" : PurpleTile,
	"BlueTile" : BlueTile
}

var CommonTiles : Array = [
	"WhiteTile",
	"BlackTile",
	"GreenTile",
	"GrayTile",
	"OrangeTile",
	"YellowTile",
	"PinkTile",
	"RedTile",
	"PurpleTile",
	"BlueTile"]
	
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
	TileScenes["YellowTile"] = YellowTile
	TileScenes["PinkTile"] = PinkTile
	TileScenes["RedTile"] = RedTile
	TileScenes["PurpleTile"] = PurpleTile
	TileScenes["BlueTile"] = BlueTile
	pass # Replace with function body.

func GetCommonTileName():
	return(CommonTiles[randi_range(0, CommonTiles.size() - 1)])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
