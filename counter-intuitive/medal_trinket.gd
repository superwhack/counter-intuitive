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
	
	SignalBus.Score.emit(self, highestTileScore)
			
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	get_tree().create_timer(0.5).timeout.connect(func():tempresetcolor())


func tempresetcolor():
	modulate = Color(1, 1, 1)
	
func ResetRound():
	pass

func ResetStage():
	pass
	
func UpdateTooltipLabel():
	description = "First Place\nAt the end of each Round, gain score equal to the highest score from a Tile this Round."
	tooltipLabel.text = description
