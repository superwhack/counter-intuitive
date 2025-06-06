extends Node2D
class_name Main

@export var uiManager : UIManager

var score : int:
	set(value): 
		score = value
		uiManager.UpdateScore()
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.main = self
	
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
