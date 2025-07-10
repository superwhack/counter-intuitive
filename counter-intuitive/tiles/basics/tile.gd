extends Node2D
class_name Tile

@export var lerpSpeedFactor = 10

@export var sprite : Sprite2D

var pickedUp: bool = false
var hover : bool = false
var location : int

var initialPosition : Vector2
var initialMousePosition : Vector2
var deltaPosition : Vector2
var desiredPosition : Vector2

var tileManager : TileManager

var main : Main

var description : String

var tileName : String

var price : int

@export var tooltip : Node
@export var tooltipLabel : Label

func _init() -> void:
	pass

func _ready() -> void:
	
	UpdateTooltipLabel()
	
	HideTooltip()
	#tileManager = Globals.tileManager
	#main = Globals.main
	#desiredPosition = position
	#
	#tileManager.allTiles.append(self)
	#tileManager.AddTileToLocation(self, Reference.TILE_LOCATIONS.deck)


func _process(delta: float) -> void:
	# if we just clicked and we are hovering this tile, pick it up
	if (Input.is_action_just_pressed("click")):
		if (hover == true):
			if (tileManager.heldTile == null && main.tilesLocked == false):
				match (location):
					Reference.TILE_LOCATIONS.hand:
						OnPickup()
					Reference.TILE_LOCATIONS.board:
						if (Globals.board.locked == false):
							OnPickup()
					_:
						pass
	#if (Input.is_action_just_pressed("right_click")):
		#if (location == Reference.TILE_LOCATIONS.board):
			#location = Reference.TILE_LOCATIONS.hand
			#tileManager.ReparentToLastOpenSlot(self)
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


	if (hover == true && pickedUp == false):
		if (Input.is_action_pressed("right_click")):
			ShowTooltip()
		else:
			HideTooltip()
	else:
		HideTooltip()
			
	

# I dont really understand this. Weird input script.
#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	#if (event is InputEventMouseButton) :
		#print("hi")
	##

# what do do when the tile is picked up
func OnPickup():
	tileManager.heldTile = self
	match(location):
		Reference.TILE_LOCATIONS.hand:
			tileManager.AddTileToLocation(self, Reference.TILE_LOCATIONS.none)
			
		Reference.TILE_LOCATIONS.board:
				Globals.board.RemoveTileFromBoard(self)

		
		
	reparent(Globals.main, true)
	scale = Vector2(1.2, 1.2)
	modulate = Color(1, 1, 1, 0.5)
	pickedUp = true


# what to do when the tile is released	
func OnRelease():
	tileManager.heldTile = null
	# reset the transparency & size
	scale = Vector2(1.0, 1.0)
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
		if (result is BoardSlot) && (result.tile == null) && (Globals.board.locked == false):
			
			Globals.board.AddTileToBoard(self, result)
			
		#otheriwse, return to hand
		else:
			tileManager.AddTileToLocation(self, Reference.TILE_LOCATIONS.hand)
	# if there are no results, return to the hand.
	else:
		tileManager.AddTileToLocation(self, Reference.TILE_LOCATIONS.hand)

		
		
		
# update hover when the mouse enters or exits the tile
func _on_mouse_entered() -> void:
	hover = true;
	scale = Vector2(1.05, 1.05)
	
func _on_mouse_exited() -> void:
	hover = false;
	scale = Vector2(1, 1)
	
#func OnBoardTrigger():
	#print("I am a tile named " + name + " and I was triggered!")
	#get_tree().create_timer(0.5).timeout.connect(func():SignalBus.PullNextTrigger.emit())
	
func ShowTooltip():
	UpdateTooltipLabel()
	tooltip.visible = true
	
func HideTooltip():
	tooltip.visible = false
	
func UpdateTooltipLabel():
	description = "DESCRIPTION MISSING!"
	tooltipLabel.text = description
