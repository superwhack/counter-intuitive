extends Area2D
# I DONT WANNA GO ON A RANT HERE!
# use Associate to copy a bunch of stuff from a tile, including stealing their description and stuff
# you track the associated tile for the shop and for live updating tooltips
# i still dont really know how to track price, maybe another thing in reference ?
# is it worth it to give a "tilename" to tiles so i can check them against the reference enums/dicts?
#
var associatedTile : Tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# tooltip stuff
	# showing prices potentially?
	pass


func Associate(tile : Tile):
	associatedTile = tile;
	Sprite2D	
