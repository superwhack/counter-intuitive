extends Node2D

@export var scoreNumberScene : PackedScene

func _init() -> void:
	Globals.scoreNumberManager = self
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OnScore(source, value):
	var scoreNumber = scoreNumberScene.instantiate()
	source.add_child(scoreNumber)
	scoreNumber.position = Vector2.ZERO
	scoreNumber.reparent(Globals.main, true)
	scoreNumber.label.text = "+" + str(value)
	
	
