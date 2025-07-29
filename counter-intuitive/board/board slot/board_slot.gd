extends Node2D
class_name BoardSlot
var sprite
var snapArea
var label
var tile : Tile

var effect : int = Reference.BOARD_SLOT_EFFECTS.none

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $Sprite2D
	snapArea = $Area2D
	label = $Label
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match effect:
		Reference.BOARD_SLOT_EFFECTS.double:
			sprite.self_modulate = Color(1, 0.8, 0.8, 1)
			label.visible = true
			label.text = "x2"
		Reference.BOARD_SLOT_EFFECTS.triple:
			sprite.self_modulate = Color(0.8, 1, 0.8, 1)
			label.visible = true
			label.text = "x3"
		_:
			sprite.self_modulate = Color(1, 1, 1, 1)
			label.visible = false
			
			
func isEmpty() -> bool:
	return (tile == null)
