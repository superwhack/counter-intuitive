extends Trinket

var score = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 5
	Globals.main.TileTriggersAdded.connect(OnTileTriggersAdded)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func OnTileTriggersAdded():
	Globals.main.triggerArray.append(CreateCallable())
	
func CreateCallable():
	var unbound = Callable(self, "Trigger")
	#var bound = unbound.bind()
	return unbound	
	
func Trigger():
	modulate = Color(0.6, 0.6, 0.6)
	var rowResults = Globals.board.CheckFullRows()
	var colResults = Globals.board.CheckFullColumns()
	for result in rowResults:
		if result:
			SignalBus.Score.emit(self, score)
			
	for result in rowResults:
		if result:
			SignalBus.Score.emit(self, score)
			
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	get_tree().create_timer(0.5).timeout.connect(func():tempresetcolor())


func tempresetcolor():
	modulate = Color(1, 1, 1)
	
func ResetRound():
	pass

func ResetStage():
	pass
	
func UpdateTooltipLabel():
	description = "5-inch Ruler\nAt the end of each Round, gain 10 points for each full row or column."
	tooltipLabel.text = description
