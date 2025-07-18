extends Trinket

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
	
	var countDictionary : Dictionary
	for tile in Globals.tileManager.allTiles:
		if (countDictionary.has(tile.tileName)):
			countDictionary[tile.tileName] += 1
		else:
			countDictionary[tile.tileName] = 1
	
	var highestCount = 0
	for key in countDictionary.keys():
		if (countDictionary[key] > highestCount):
			highestCount = countDictionary[key]
			
	SignalBus.Score.emit(self, highestCount)
			
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	get_tree().create_timer(0.5).timeout.connect(func():tempresetcolor())


func tempresetcolor():
	modulate = Color(1, 1, 1)
	
func ResetRound():
	pass

func ResetStage():
	pass
	
func UpdateTooltipLabel():
	description = "Friendship Bracelet\nAt the end of each Round, gain 1 point for each of the most common Tile you own."
	tooltipLabel.text = description
