extends Node2D

@export var spaceSize : Vector2
@export var spacing : Vector2
@export var boardSpace : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var currentPos : Vector2 = (-2 * spaceSize) + (-2 * spacing)
	print (currentPos)
	for r in 5:
		for c in 5:
			var newSpace = boardSpace.instantiate()
			add_child(newSpace)
			newSpace.name = (str(r) + " : " + str(c))
			newSpace.position = currentPos
			
			currentPos.x += spacing.x + spaceSize.x
		currentPos.x -= 5 * (spacing.x + spaceSize.x)
		currentPos.y += spacing.y + spaceSize.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
