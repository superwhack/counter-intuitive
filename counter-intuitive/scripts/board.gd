extends Node2D
class_name Board

var boardSlotSize : Vector2
@export var spacing : Vector2
@export var boardSlot : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Globals.board = self
	boardSlotSize = Globals.boardSlotSize
	
	var currentPos : Vector2 = (-2 * boardSlotSize) + (-2 * spacing)
	print (currentPos)
	for r in 5:
		for c in 5:
			var newSlot = boardSlot.instantiate()
			add_child(newSlot)
			newSlot.name = (str(r) + " : " + str(c))
			newSlot.position = currentPos
			
			currentPos.x += spacing.x + boardSlotSize.x
		currentPos.x -= 5 * (spacing.x + boardSlotSize.x)
		currentPos.y += spacing.y + boardSlotSize.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
