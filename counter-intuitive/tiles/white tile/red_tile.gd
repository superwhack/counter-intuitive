extends Tile

func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 3
	super()
	tileName = "RedTile"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func Trigger():
	SignalBus.Score.emit(self, tileManager.GetNeighboringTiles(self).size() * 2)
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
	description = "RedTile\nScore 2 points for each adjacent tile."
	tooltipLabel.text = description
