extends Node2D
class_name ShopManager

@export var shopTilesContainer : Control
var shopTilesArray : Array

@export var realTilesNode : Node2D
var realTilesArray : Array

@export var shopTileScene : PackedScene

@export var visualTileSlotScene : PackedScene

@export var maxTilesButton : Button
var maxTilesPrice : int = 8

@export var handSizeButton : Button
var handSizePrice : int = 6

@export var roundsPerStageButton : Button
var roundsPerStagePrice : int = 10

func _init() -> void:
	Globals.shopManager = self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateButtonText()

func CreateShopTile(tileName : String):
	var realTile = Globals.tileManager.CreateTile(Reference.TileScenes[tileName])
	var visualTile = Globals.tileManager.CreateVisualTile(realTile)
	
	var shopTile = shopTileScene.instantiate()
	
	shopTile.realTile = realTile
	shopTile.visualTile = visualTile
	
	realTile.reparent(realTilesNode, false)
	print(realTile.get_parent())
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
		# deduct the money
		Globals.main.tokens -= shopTile.realTile.price
		#remove it from the array (so that the real tile doesnt get deleted i think)
		shopTilesArray.erase(shopTile)
		
		# get rid of shop slot
		shopTile.get_parent().queue_free()
		
		# add the real tile to the deck
		Globals.tileManager.AddTileToLocation(shopTile.realTile, Reference.TILE_LOCATIONS.deck)
		# add it to allTiles
		Globals.tileManager.allTiles.append(shopTile.realTile)
	else:
		print("FAILED!")

func AttemptToBuyMaxTiles():
	if (Globals.main.tokens >= maxTilesPrice):
		Globals.main.tokens -= maxTilesPrice
		Globals.main.maxTilesPerRound += 1
		IncreaseUpgradePrices()
		maxTilesPrice *= 1.2
		
func AttemptToBuyHandSize():
	if (Globals.main.tokens >= handSizePrice):
		Globals.main.tokens -= handSizePrice
		Globals.main.handSize += 1
		IncreaseUpgradePrices()
		handSizePrice *= 1.2
		
func AttemptToBuyRoundsPerStage():
	if (Globals.main.tokens >= roundsPerStagePrice):
		Globals.main.tokens -= roundsPerStagePrice
		Globals.main.maxRounds += 1
		IncreaseUpgradePrices()
		roundsPerStagePrice *= 1.2
		
func UpdateButtonText():
	maxTilesButton.text = "+ Max Tiles ($" + str(maxTilesPrice) + ")"
	handSizeButton.text = "+ Hand Size ($" + str(handSizePrice) + ")"
	roundsPerStageButton.text = "+ Rounds Per Stage ($" + str(roundsPerStagePrice) + ")"
	
func IncreaseUpgradePrices():
	maxTilesPrice *= 1.2
	handSizePrice *= 1.2
	roundsPerStagePrice *= 1.2
	
	
	
func _on_leave_button_pressed() -> void:
	Globals.main.MoveToBoard()
