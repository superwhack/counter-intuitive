extends Trinket

@export var numberLabel : Label
var chosenNumber = randi_range(1, 10)
var scoreAmount = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price = 5
	SignalBus.Score.connect(OnScore)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	numberLabel.text = str(chosenNumber)

func OnScore(source, value):
	if (source is Tile):
		if (value == chosenNumber):
			SignalBus.Score.emit(self, scoreAmount)
		

func ResetRound():
	pass

func ResetStage():
	chosenNumber = randi_range(1, 10)
	
func UpdateTooltipLabel():
	description = "D10\nWhenever a Tile scores " + str(chosenNumber) + " points, this scores " + str(scoreAmount) + " points. Pick a new number 1-10 each Stage."
	tooltipLabel.text = description
