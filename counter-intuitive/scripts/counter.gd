extends Area2D

@export var lerpSpeedFactor = 5.0

var pickedUp: bool = false
var hover : bool = false

var initialPosition : Vector2
var initialMousePosition : Vector2
var deltaPosition : Vector2
var desiredPosition : Vector2



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (Input.is_action_just_pressed("click")):
		if (hover == true):
			pickedUp = true;
	if (pickedUp) :
		if (Input.is_action_pressed("click") == false):
			pickedUp = false
		
		deltaPosition = get_viewport().get_mouse_position() - initialMousePosition;
		desiredPosition = initialPosition + deltaPosition;
	
	position = position.lerp(desiredPosition, delta * lerpSpeedFactor)
	

#
# I dont really understand this. 
#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	#if (event is InputEventMouseButton) :
		#print("hi")
	##


func _on_mouse_entered() -> void:
	hover = true;



func _on_mouse_exited() -> void:
	hover = false;
