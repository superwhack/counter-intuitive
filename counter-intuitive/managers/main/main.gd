extends Node2D
class_name Main

var uiManager : UIManager
var board : Board
var tileManager : TileManager


var tilesRemaining : int
var maxTilesPerRound : int

var roundsRemaining : int
var maxRounds : int

var discardsRemaining : int
var maxDiscards : int

var numTrinkets : int
var maxTrinkets : int

var score : int:
	set(value): 
		score = value
		uiManager.UpdateScore()

var currentStage : int
var currentScoreRequirement : int
	
var money : int
	#set(value):
		#score = value
		#uiManager.UpdateMoney()
		

var handSize : int

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	Globals.main = self

	
func _ready() -> void:
	UpdateFromGlobals()
	ResetRun()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()


func StartRun():
	ResetRun()
		
func ResetRound():
	board.ResetRound()

	tileManager.ResetRound()


func StartStage():
	ResetStage()
	
	
func ResetStage():
	UpdateFromGlobals()
	board.ResetStage()
	tileManager.ResetStage()

	score = 0
	tilesRemaining = maxTilesPerRound
	
	roundsRemaining = maxRounds
	
	
func ResetRun():
	score = 0
	
	maxRounds = 3
	roundsRemaining = maxRounds
	
	maxTilesPerRound = 4
	tilesRemaining = maxTilesPerRound
	
	money = 0
	
	handSize = 8
	
	tileManager.ResetRun()
	board.ResetRun()
	
	
func UpdateFromGlobals():
	uiManager = Globals.uiManager
	board = Globals.board
	tileManager = Globals.tileManager
