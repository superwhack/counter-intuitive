extends Tile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func OnBoardTrigger():
	main.score += 5
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTileOnBoardTrigger.emit())
