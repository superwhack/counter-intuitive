extends Node2D
class_name Tile

@export var lerpSpeedFactor = 5.0

var pickedUp: bool = false
var hover : bool = false
var location : int

var initialPosition : Vector2
var initialMousePosition : Vector2
var deltaPosition : Vector2
var desiredPosition : Vector2

var tileManager : TileManager

var main : Main
func _ready() -> void:
	tileManager = Globals.tileManager
	desiredPosition = position
	main = Globals.main

func _process(delta: float) -> void:
	
	# if we just clicked and we are hovering this tile, pick it up
	if (Input.is_action_just_pressed("click")):
		if (hover == true):
			OnPickup()
	if (Input.is_action_just_pressed("right_click")):
		if (location == Reference.TILE_LOCATIONS.board):
			location = Reference.TILE_LOCATIONS.hand
			tileManager.ReparentToLastOpenSlot(self)
	# if this tile is picked up, move its desired position and check to see if you drop it
	if (pickedUp) :
		# Update the desired position
		deltaPosition = Globals.mouseWorldPosition - initialMousePosition;
		desiredPosition = initialPosition + deltaPosition;
		
		# Check if the tile is dropped
		if (Input.is_action_pressed("click") == false):
			OnRelease()
			pickedUp = false
		
	# move the position towards the desired position
	position = position.lerp(desiredPosition, delta * lerpSpeedFactor)


# I dont really understand this. Weird input script.
#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	#if (event is InputEventMouseButton) :
		#print("hi")
	##

# what do do when the tile is picked up
func OnPickup():
	match(location):
		Reference.TILE_LOCATIONS.hand:
			tileManager.ShiftTilesLeftInHandFromTile(self)
			
		Reference.TILE_LOCATIONS.board:
			tileManager.boardArray.erase(self)
			
	reparent(Globals.main, true)
	modulate = Color(1, 1, 1, 0.5)
	location = Reference.TILE_LOCATIONS.pickup
	pickedUp = true


# what to do when the tile is released	
func OnRelease():
	# reset the transparency
	modulate = Color(1, 1, 1, 1)
	
	# create a point query that checks against the board slots
	var physPointQuery : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	physPointQuery.collide_with_areas = true
	physPointQuery.position = Globals.mouseWorldPosition
	physPointQuery.collision_mask = 2
	
	# get the results of a physics query at that point
	var results = Globals.directSpaceState.intersect_point(physPointQuery)
	
	# if you drop onto a board slot, reparent to it and change the location.
	if (results.size() > 0):
		var result = results[0]["collider"].get_parent()
		if (result is BoardSlot):
			reparent(result, true)
			desiredPosition = Vector2.ZERO
			location = Reference.TILE_LOCATIONS.board
			
			tileManager.boardArray.append(self)
		#otheriwse, return to hand
		else:
			location = Reference.TILE_LOCATIONS.hand
			tileManager.ReparentToLastOpenSlot(self)
	# if there are no results, return to the hand.
	else:
		location = Reference.TILE_LOCATIONS.hand
		tileManager.ReparentToLastOpenSlot(self)
		
		
		
# update hover when the mouse enters or exits the tile
func _on_mouse_entered() -> void:
	hover = true;
	
func _on_mouse_exited() -> void:
	hover = false;
	
func OnBoardTrigger():
	print("I am a tile named " + name + " and I was triggered!")
	get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTileOnBoardTrigger.emit())
