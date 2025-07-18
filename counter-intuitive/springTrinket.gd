extends Trinket

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 5
	SignalBus.TileMoved.connect(OnTileMoved)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func OnTileMoved(tile, source, direction):
	if (tile == source):
		var callable = CreateCallable(tile, source)
		Globals.main.triggerArray.insert(Globals.main.triggerIndex + 1, callable)
	
func CreateCallable(tile, source):
	var unbound = Callable(self, "Trigger")
	var bound = unbound.bind(tile, source)
	return bound	
	
func Trigger(tile, source):
	print("spring trig")
	modulate = Color(0.6, 0.6, 0.6)
	var returnValue = Globals.tileManager.MoveTileInRandomValidDirection(tile)
	if (returnValue[0]):
		SignalBus.TileMoved.emit(tile, self, returnValue[1])
			
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	get_tree().create_timer(0.5).timeout.connect(func():tempresetcolor())


func tempresetcolor():
	modulate = Color(1, 1, 1)
	
func ResetRound():
	pass

func ResetStage():
	pass
	
func UpdateTooltipLabel():
	description = "Spring\nWhenever a Tile moves itself, this moves it again in a random direction."
	tooltipLabel.text = description
