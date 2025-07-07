extends Node2D
class_name BoardSlot
var sprite
var snapArea

var tile : Tile
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $Sprite2D
	snapArea = $Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func isEmpty() -> bool:
	return (tile == null)
