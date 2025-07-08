extends Tile
var copies = []

func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func Trigger():
	# THIS IS BUSTED ! NEED TO MAKE A CUSTOM DUPLICATE FUNCTION :) THEORY WORKS THO IN MY HEAD
	var trigger = main.GetLastTileTrigger()
	if (trigger != null):
		var tileToCopy = trigger.get_object()
		var copy = tileToCopy.duplicate(true)
		copy.location = Reference.TILE_LOCATIONS.none
		tileManager.allTiles.append(copy)
		tileManager.AddTileToLocation(copy, Reference.TILE_LOCATIONS.hand)
		
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
	for copy in copies:
		tileManager.allTiles.erase(copy)
		tileManager.RemoveTileFromManagerArrays(copy)
		copy.queue_free()

func CreateCallable() -> Callable:
	var unbound = Callable(self, "Trigger")
	#var bound = unbound.bind()
	return unbound
	
func UpdateTooltipLabel():
	description = "Purple Tile\nRetrigger the last tile that Triggered."
	tooltipLabel.text = description
