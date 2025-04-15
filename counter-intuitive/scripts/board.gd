extends Node2D

@export var counterSize : Vector2
@export var margin : Vector2
@export var spacing : Vector2
@export var boardSpace : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get the size of counter
	var test = boardSpace.instantiate()
	add_child(test)
	counterSize = test.sprite.get_rect().size
	test.queue_free()
	
	var currentY
	for n in 25:
		pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
