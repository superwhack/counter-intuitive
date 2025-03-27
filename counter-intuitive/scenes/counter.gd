extends Area2D

var pickedUp: bool = false
var initialPosition : Vector2
var initialMousePosition : Vector2
var deltaPosition : Vector2
var desiredPosition : Vector2

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (pickedUp) :
		if (Input.is_action_pressed("click") == false):
			pickedUp = false
		
		deltaPosition = get_viewport().get_mouse_position() - initialMousePosition;
		desiredPosition = initialPosition + deltaPosition;
		
		position = position.lerp(desiredPosition, delta * 8)
	pass
	
	position = position.lerp(desiredPosition, delta * 8)


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton) :
		pickedUp = true
		initialPosition = position;
		initialMousePosition = get_viewport().get_mouse_position()
		
	
