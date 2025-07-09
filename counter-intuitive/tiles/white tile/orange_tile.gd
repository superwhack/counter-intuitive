extends Tile
class_name OrangeTileClass
func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	tileName = "OrangeTile"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func Trigger():
	var trigger = main.GetLastTileTrigger()
	if (trigger != null && trigger.get_object() is not OrangeTileClass):
		trigger.call()
	else:
		print("I failed :(")
		get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())

	modulate = Color(0.6, 0.6, 0.6)
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
	description = "Orange Tile\nRetrigger the last tile that Triggered."
	tooltipLabel.text = description
