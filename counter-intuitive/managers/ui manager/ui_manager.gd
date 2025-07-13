extends Control
class_name UIManager

@export var scoreNumberLabel : Label
@export var roundsNumberLabel : Label
@export var tokensNumberLabel : Label
@export var goalNumberLabel : Label
@export var tilesNumberLabel : Label
@export var playButton : Button

@export var score : Control
@export var goal : Control
@export var tokens : Control
@export var tiles : Control
@export var rounds : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.uiManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func UpdateScore():
	scoreNumberLabel.text = str(Globals.main.score)

func UpdateRounds():
	roundsNumberLabel.text = str(Globals.main.roundsRemaining)
	
func UpdateTokens():
	tokensNumberLabel.text = str(Globals.main.tokens)
	
func UpdateGoal():
	goalNumberLabel.text = str(Globals.main.goal)
	
func UpdateTiles():
	tilesNumberLabel.text = str(Globals.main.tilesRemaining)

func ShowShop():
	score.visible = false
	goal.visible = false
	tokens.visible = true
	tiles.visible = false
	rounds.visible = false
	playButton.visible = false

func ShowGameplay():
	score.visible = true
	goal.visible = true
	tokens.visible = true
	tiles.visible = true
	rounds.visible = true
	playButton.visible = true
