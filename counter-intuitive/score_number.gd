extends Node2D

@export var label : Label

var riseRate = -30
var disappateRate = 0.6
var disappation = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += riseRate * delta
	disappation -= disappateRate * delta
	
	modulate = Color(1, 1, 1, disappation)
	
	if (disappation <= 0):
		queue_free()
