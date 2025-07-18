extends Node2D
class_name ShopTile
var visualTile : VisualTile
var realTile : Tile
var shopManager : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (visualTile.hover && Input.is_action_just_pressed("click")):
		shopManager.AttemptToBuy(self)
