extends Node2D
class_name Trinket

var hover
@export var tooltip : Node
@export var tooltipLabel : Node
@export var sprite : Sprite2D
var description : String
var price : int = 5
@export var priceLabel : Label
var showPrice = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HideTooltip()


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
		
	
func ResetRound():
	pass

func ResetStage():
	pass
	
	
func ShowTooltip():
	UpdateTooltipLabel()
	tooltip.visible = true
	
func HideTooltip():
	tooltip.visible = false
	
func UpdateTooltipLabel():
	description = "DEFAULT"
	tooltipLabel.text = description
	#tooltipLabel.text = description

func _on_mouse_entered() -> void:
	hover = true;
	sprite.scale = Vector2(1.05, 1.05)


func _on_mouse_exited() -> void:
	hover = false;
	sprite.scale = Vector2(1, 1)
	
func ShowPrice():
	priceLabel.text = "$" + str(price)
	priceLabel.visible = true
	
func HidePrice():
	priceLabel.visible = false
	
