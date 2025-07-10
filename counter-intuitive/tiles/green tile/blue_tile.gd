extends Tile

func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 3
	super()
	tileName = "BlueTile"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func Trigger():
	SignalBus.Score.emit(self, tileManager.deckArray.size())
	modulate = Color(0.6, 0.6, 0.6)
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	get_tree().create_timer(0.5).timeout.connect(func():tempresetcolor())


func tempresetcolor():
	modulate = Color(1, 1, 1)
	
func ResetRound():
	#modulate = Color(1, 1, 1)
	pass
	
func ResetStage():
	pass

func CreateCallable() -> Callable:
	var unbound = Callable(self, "Trigger")
	#var bound = unbound.bind()
	return unbound
	
func UpdateTooltipLabel():
	description = "Blue Tile\nScore points equal to the number of Tiles currently in your deck."
	tooltipLabel.text = description
