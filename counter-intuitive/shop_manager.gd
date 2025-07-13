extends Node2D
class_name ShopManager

@export var shopTilesContainer : Control
var shopTilesArray : Array

@export var realTilesNode : Node2D
var realTilesArray : Array

@export var shopTileScene : PackedScene

@export var visualTileSlotScene : PackedScene

func _init() -> void:
	Globals.shopManager = self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func CreateShopTile(tileName : String):
	var realTile = Globals.tileManager.CreateTile(Reference.TileScenes[tileName])
	var visualTile = Globals.tileManager.CreateVisualTile(realTile)
	
	var shopTile = shopTileScene.instantiate()
	
	shopTile.realTile = realTile
	shopTile.visualTile = visualTile
	
	realTile.reparent(realTilesNode)
	realTilesArray.append(realTile)
	
	visualTile.showPrice = true
	visualTile.reparent(shopTile)
	
	shopTile.shopTileManager = self
	
	AddShopTileToNewSlot(shopTile)
	
func AddShopTileToNewSlot(shopTile : ShopTile):
	var newSlot = visualTileSlotScene.instantiate()
	shopTilesContainer.add_child(newSlot)
	newSlot.add_child(shopTile)
	
func ResetShop():
	for shopTile in shopTilesContainer.get_children():
		shopTilesArray.erase(shopTile)
		shopTile.queue_free()
	
func StartShop():
	for i in 3:
		CreateShopTile(Reference.GetCommonTileName())
	
func AttemptToBuy(shopTile):
	print("purchase attempted")
	if (Globals.main.tokens >= shopTile.realTile.price):
		Globals.main.tokens -= shopTile.realTile.price
		shopTile.get_parent().queue_free()
		Globals.tileManager.AddTileToLocation(shopTile.realTile, Reference.TILE_LOCATIONS.deck)
		Globals.tileManager.allTiles.append(shopTile.realTile)
	else:
		print("FAILED!")


func _on_leave_button_pressed() -> void:
	Globals.main.MoveToBoard()
