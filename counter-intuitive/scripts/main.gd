extends Node2D
class_name Main

var uiManager : UIManager
var plays : int:
	set(value):
		plays = value
		uiManager.UpdatePlays()

var score : int:
	set(value): 
		score = value
		uiManager.UpdateScore()
		
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	Globals.main = self
	
func _ready() -> void:
	uiManager = Globals.uiManager
	
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func StartRound():
	pass
	
func Reset():
	pass
	
