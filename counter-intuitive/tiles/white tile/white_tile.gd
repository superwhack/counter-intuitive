extends Tile

var score

func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	description = "White Tile\nScore 5 points."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func Trigger():
	main.score += 5
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
	
func ResetRun():
	pass
	
func CreateCallable() -> Callable:
	var unbound = Callable(self, "Trigger")
	#var bound = unbound.bind()
	return unbound
