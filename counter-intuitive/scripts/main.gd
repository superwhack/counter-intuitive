extends Node2D
class_name Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.main = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
