extends Node2D
var visualTile : VisualTile
var tileRemovalManager : TileRemovalManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (visualTile.hover && Input.is_action_just_pressed("click")):
		print("attempt")
		Globals.shopManager.AttemptPurchaseRemoval(self)
