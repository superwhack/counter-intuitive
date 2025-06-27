extends CanvasLayer
class_name UIManager

@export var scoreNumberLabel : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.uiManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func UpdateScore():
	scoreNumberLabel.text = str(Globals.main.score)

func UpdatePlays():
	pass
