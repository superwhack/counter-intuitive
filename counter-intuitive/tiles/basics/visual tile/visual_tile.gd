extends Area2D
class_name VisualTile
# I DONT WANNA GO ON A RANT HERE!
# use Associate to copy a bunch of stuff from a tile, including stealing their description and stuff
# you track the associated tile for the shop and for live updating tooltips
# i still dont really know how to track price, maybe another thing in reference ?
# is it worth it to give a "tilename" to tiles so i can check them against the reference enums/dicts?
#
@export var sprite : Sprite2D
@export var tooltip : Node2D
@export var tooltipLabel : Label
@export var priceLabel : Label
var associatedTile : Tile

var hover : bool

var description : String

var showPrice : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	showPrice = false
	HideTooltip()
	HidePrice()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if (hover == true):
			if (Input.is_action_pressed("right_click")):
				ShowTooltip()
			else:
				HideTooltip()
		else:
			HideTooltip()
		if (showPrice == true):
			ShowPrice()
		else:
			HidePrice()
	# tooltip stuff
	# showing prices potentially?


func Associate(tile : Tile):
	associatedTile = tile;
	sprite.texture = associatedTile.sprite.texture
	
	tooltip.queue_free()
	tooltip = associatedTile.tooltip.duplicate()
	add_child(tooltip)
	for child in tooltip.get_children():
		if child is Label:
			tooltipLabel = child
		else:
			tooltipLabel = null
	

#func OnBoardTrigger():
	#print("I am a tile named " + name + " and I was triggered!")
	#get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	
func ShowTooltip():
	UpdateTooltipLabel()
	tooltip.visible = true
	
func HideTooltip():
	tooltip.visible = false
	
func UpdateTooltipLabel():
	associatedTile.UpdateTooltipLabel()
	description = associatedTile.description
	tooltipLabel.text = description

func ShowPrice():
	priceLabel.text = "$" + str(associatedTile.price)
	priceLabel.visible = true
	
func HidePrice():
	priceLabel.visible = false
	


func _on_mouse_entered() -> void:
	hover = true;
	scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	hover = false;
	scale = Vector2(1, 1)
