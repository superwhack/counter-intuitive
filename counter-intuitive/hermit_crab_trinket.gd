extends Trinket

var highestTileScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 5
	SignalBus.Score.connect(OnScore)
	Globals.main.TileTriggersAdded.connect(OnTileTriggersAdded)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func OnScore(source, value):
	if (source is Tile):
		var slot = source.get_parent()
		match slot.effect:
			Reference.BOARD_SLOT_EFFECTS.double:
				value *= 2
			Reference.BOARD_SLOT_EFFECTS.triple:
				value *= 3
		if (value > highestTileScore):
			highestTileScore = value
	
func OnTileTriggersAdded():
	highestTileScore = 0
	Globals.main.triggerArray.append(CreateCallable())
	
func CreateCallable():
	var unbound = Callable(self, "Trigger")
	#var bound = unbound.bind()
	return unbound	
	
func Trigger():
	modulate = Color(0.6, 0.6, 0.6)
	
	if (Globals.board.flatBoardTilesArray.size() == 1):
		SignalBus.Score.emit(self, highestTileScore * 2)
			
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	get_tree().create_timer(0.5).timeout.connect(func():tempresetcolor())


func tempresetcolor():
	modulate = Color(1, 1, 1)
	
func ResetRound():
	pass

func ResetStage():
	pass
	
func UpdateTooltipLabel():
	description = "Hermitest Crab\nIf you play exactly 1 tile in a round, gain 2x the highest points scored by a Tile."
	tooltipLabel.text = description
