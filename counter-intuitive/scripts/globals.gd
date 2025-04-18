extends Node2D

var main : Main
var board : Board
var counterManager : CounterManager

var boardSlotSize : Vector2 
var handSlotSize : Vector2
var directSpaceState : PhysicsDirectSpaceState2D
var mouseWorldPosition : Vector2
var camera : Camera2D
var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boardSlotSize = Vector2(64, 64)
	handSlotSize = boardSlotSize
	rng = RandomNumberGenerator.new()
	
	directSpaceState = get_world_2d().direct_space_state
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GetMouseWorldPosition()



func GetMouseWorldPosition():
	mouseWorldPosition = get_global_mouse_position()
