extends Node2D
class_name Main

var uiManager : UIManager
var board : Board
var tileManager : TileManager
var visualDecksManager : VisualDecksManager
@export var gameplayScreen : Node2D
@export var mainMenuScreen : Node2D
@export var pauseScreen : Node2D
@export var shopScreen : Node2D

var screenArray : Array

@export var background : Node

@export var startRunButton : Node

var selectedStartingDeck

var currentScreen

var tilesRemaining : int:
	set(value): 
		tilesRemaining = value
		uiManager.UpdateTiles()
		
var maxTilesPerRound : int

var roundsRemaining : int:
	set(value): 
		roundsRemaining = value
		uiManager.UpdateRounds()
		

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

var goal : int:
	set(value): 
		goal = value
		uiManager.UpdateGoal()

var tokens : int:
	set(value): 
		tokens = value
		uiManager.UpdateTokens()
		
var handSize : int

var triggerArray : Array
var triggerIndex : int

var tilesLocked : bool

var tilesMovedRound : int
var tilesMovedStage : int
var tilesMovedRun

@export var gameOverNodeTemp : Node2D

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	Globals.main = self

	
func _ready() -> void:
	UpdateFromGlobals()
	ResetRun()
	
	tilesLocked = false
	
	screenArray = [gameplayScreen, pauseScreen, mainMenuScreen]
	
	HideAllScreens()
	ShowScreen(mainMenuScreen)
	
	# TEMPORARY!
	selectedStartingDeck = Reference.STARTING_DECKS.TestDeck
	
	# CONNECTING SIGNALS
	SignalBus.PlayButtonPressed.connect(StartTriggerSequence)
	SignalBus.PullNextTrigger.connect(PullNextTrigger)
	SignalBus.Score.connect(OnScoreSignal)
	SignalBus.TileMoved.connect(OnTileMovedSignal)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_cancel")):
		if (currentScreen == gameplayScreen):
			ShowScreen(mainMenuScreen)
		elif (currentScreen == mainMenuScreen):
			get_tree().quit()
			
	if (Input.is_action_just_pressed("toggle_fullscreen")):
		if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:	
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	currentScreen.modulate = lerp(currentScreen.modulate, Color(1, 1, 1, 1,), delta * 3)

# Connected to Start Button
func StartRun():
	UpdateFromGlobals()
	ResetRun()
	CreateStartingDeck()
	ShowScreen(gameplayScreen)
	
	StartRound()
	
		
func ResetRound():
	board.ResetRound()
	tileManager.ResetRound()
	triggerArray.clear()
	triggerIndex = 0
	
	tilesMovedRound = 0
	
	tilesRemaining = maxTilesPerRound
	
	
	tilesLocked = false

	# check for loss
	if (roundsRemaining == 0):
		if (score > goal):
			# Gain Money
			tokens += (int)(10 * (score - goal) / goal)
			ResetStage()
			StartStage()
		else:
			gameOverNodeTemp.visible = true
			get_tree().create_timer(2).timeout.connect(func():gameOverNodeTemp.visible = false)
			get_tree().create_timer(2).timeout.connect(func():ShowScreen(mainMenuScreen))
			
func StartRound():
	tileManager.StartRound()
	visualDecksManager.StartRound()

func StartStage():
	goal *= 1.4
	goal = (int)(goal)
	currentStage += 1
	
	ResetStage()

	
	
	
func ResetStage():
	UpdateFromGlobals()
	
	score = 0
	tilesMovedStage = 0
	roundsRemaining = maxRounds
	
	board.ResetStage()
	tileManager.ResetStage()

	

	
	
func ResetRun():
	score = 0
	
	maxRounds = 3
	roundsRemaining = maxRounds
	
	maxTilesPerRound = 8
	tilesRemaining = maxTilesPerRound
	
	tokens = 0
	
	handSize = 8
	
	goal = 30
	
	tilesMovedRun = 0
	
	tileManager.ResetRun()
	board.ResetRun()
	
	# TEMP!
	gameOverNodeTemp.visible = false
	
	
func UpdateFromGlobals():
	uiManager = Globals.uiManager
	board = Globals.board
	tileManager = Globals.tileManager
	visualDecksManager = Globals.visualDecksManager

	
func PullNextTrigger():
	if (triggerIndex == triggerArray.size()):
		ResetRound()
		StartRound()
	else:
		triggerArray[triggerIndex].call()
		triggerIndex += 1
	
func StartTriggerSequence():
	roundsRemaining -= 1
		
	board.locked = true
	tilesLocked = true
	triggerIndex = 0
	
	for tile in board.flatBoardTilesArray:
		triggerArray.append(tile.CreateCallable())
	
	PullNextTrigger()
	
func RemoveCallableTriggerFromTile(tile : Tile):
	RemoveCallableTriggerFromObject(tile)
	
func RemoveCallableTriggerFromObject(object : Node):
	for callable in triggerArray:
		if(callable.get_object() == object):
			triggerArray.erase(callable)
			
func ShowScreen(screen):
	HideAllScreens()
	screen.visible = true
	currentScreen = screen
	match screen:
		gameplayScreen:
			background.ZoomTo(1)
		mainMenuScreen: 
			background.ZoomTo(3)
		pauseScreen:
			background.ZoomTo(5)
			
func HideAllScreens():
	for screen in screenArray:
		screen.visible = false
		
func CreateStartingDeck():
	match selectedStartingDeck:
		Reference.STARTING_DECKS.WhiteDeck:
			for i in 20:
				tileManager.CreatePlayTileToDeck(Reference.TileScenes["WhiteTile"])
		Reference.STARTING_DECKS.TestDeck:
			for i in 10:
				tokens += 10
				tileManager.CreatePlayTileToDeck(Reference.TileScenes["WhiteTile"])
				

func GameOver():
	ShowScreen(mainMenuScreen)

func GetLastTileTrigger():
	var tempIndex : int = triggerIndex
	tempIndex -= 1
	var found = false
	var callable = null
	while (!found):
		if (tempIndex == -1):
			return null
		callable = triggerArray[tempIndex]
		found = (callable.get_object() is Tile)
		tempIndex -= 1

	return callable
	
func OnScoreSignal(source, value): 
	score += value
	
func OnTileMovedSignal(tile, source, direction):
	tilesMovedRound += 1
	tilesMovedStage += 1
	tilesMovedRun += 1
	
