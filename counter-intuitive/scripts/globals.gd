extends Node2D

var main : Main
var space : PhysicsDirectSpaceState2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	space = get_world_2d().direct_space_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
