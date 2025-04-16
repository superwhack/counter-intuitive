extends Area2D

@export var lerpSpeedFactor = 5.0

var pickedUp: bool = false
var hover : bool = false

var initialPosition : Vector2
var initialMousePosition : Vector2
var deltaPosition : Vector2
var desiredPosition : Vector2

var counterManager

func _ready() -> void:
	counterManager = get_parent()
	desiredPosition = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("click")):
		if (hover == true):
			OnPickup()
			pickedUp = true
		
			
	if (pickedUp) :
		# Update the desired position
		deltaPosition = Globals.mouseWorldPosition - initialMousePosition;
		desiredPosition = initialPosition + deltaPosition;
		
		# Check if the counter is dropped
		if (Input.is_action_pressed("click") == false):
			OnRelease()
			pickedUp = false
	
	position = position.lerp(desiredPosition, delta * lerpSpeedFactor)
	print(desiredPosition)

#
# I dont really understand this. 
#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	#if (event is InputEventMouseButton) :
		#print("hi")
	##

func OnPickup():
		reparent(counterManager, true)
		modulate = Color(1, 1, 1, 0.5)
	
	
func OnRelease():
	modulate = Color(1, 1, 1, 1)
	
	var physPointQuery : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	physPointQuery.collide_with_areas = true
	physPointQuery.position = Globals.mouseWorldPosition
	physPointQuery.collision_mask = 2
	
	var results = Globals.directSpaceState.intersect_point(physPointQuery)
	for item in results: 
		var newParentBoardSpace = item["collider"].get_parent()
		
		reparent(newParentBoardSpace, true)
		
		desiredPosition = Vector2.ZERO
		
	
func _on_mouse_entered() -> void:
	hover = true;



func _on_mouse_exited() -> void:
	hover = false;
