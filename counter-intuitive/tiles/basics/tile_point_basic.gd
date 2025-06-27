extends Tile


func _init() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func OnBoardTrigger():
	main.score += 5
	modulate = Color(255, 0, 0)
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTileOnBoardTrigger.emit())
