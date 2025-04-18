extends Control
class_name CounterManager

@export var handNode : Node
var handArray : Array

@export var deckNode : Node
var deckArray : Array

@export var discardNode : Node
var discardArray : Array

@export var counterBasic : PackedScene
#@export var handSlot : PackedScene

func _ready() -> void:
	Globals.counterManager = self
	pass 



func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_add_counter")):
		var newCounter = counterBasic.instantiate()
		handNode.add_child(newCounter)
		
		
		


func ReparentToNewHandSlot(counter : Node2D):
	pass
