extends Node2D
class_name ShopManager

@export var shopTilesContainer : Control
var shopTilesArray : Array

@export var shopTrinketsContainer : Control
var shopTrinketsArray : Array = []

@export var realTilesNode : Node2D
var realTilesArray : Array

@export var shopTileScene : PackedScene
@export var shopTrinketScene : PackedScene
@export var visualTileSlotScene : PackedScene
@export var trinketSlotScene : PackedScene

@export var maxTilesButton : Button
var maxTilesPrice : int = 8

@export var handSizeButton : Button
var handSizePrice : int = 6

@export var roundsPerStageButton : Button
var roundsPerStagePrice : int = 10

@export var tileRemovalManager : TileRemovalManager
var removalPrice : int = 5

@export var removalButton : Button
@export var rerollButton : Button
var rerollPrice : int = 1
var shopLocked = false
var trinketsShown = false
@export var tempSlab : Sprite2D
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
	realTilesArray.append(realTile)
	
	visualTile.showPrice = true
	visualTile.reparent(shopTile)
	
	shopTile.shopManager = self
	
	AddShopTileToNewSlot(shopTile)
	
func AddShopTileToNewSlot(shopTile : ShopTile):
	var newSlot = visualTileSlotScene.instantiate()
	shopTilesContainer.add_child(newSlot)
	newSlot.add_child(shopTile)
	shopTile.position = newSlot.size / 2
	
func CreateShopTrinket(trinketName : String):
	var trinket = Globals.trinketManager.CreateTrinket(trinketName)
	var shopTrinket = shopTrinketScene.instantiate()
	
	shopTrinket.trinket = trinket
	
	shopTrinket.shopManager = self
	
	trinket.showPrice = true
	
	trinket.reparent(shopTrinket)
	
	shopTrinketsArray.append(shopTrinket)
	
	AddShopTrinketToNewSlot(shopTrinket)
	
func AddShopTrinketToNewSlot(shopTrinket : Node2D):
	var newSlot = trinketSlotScene.instantiate()
	shopTrinketsContainer.add_child(newSlot)
	newSlot.add_child(shopTrinket)
	shopTrinket.position = Vector2(64, 64)
	
func ResetRun():
	maxTilesPrice = 8
	handSizePrice = 6
	roundsPerStagePrice = 10
	
func ResetShop():
	if(trinketsShown):
		ToggleTrinkets()
	
	rerollPrice = 1
	
	for shopTile in shopTilesContainer.get_children():
		shopTilesArray.erase(shopTile)
		shopTile.queue_free()
		
	for shopTrinket in shopTrinketsContainer.get_children():
		shopTrinketsArray.erase(shopTrinket)
		shopTrinket.queue_free()
		
func StartShop():
	for i in 3:
		CreateShopTile(Reference.GetCommonTileName())
		
	for i in 3:
		CreateShopTrinket(Reference.CommonTrinkets.pick_random())
	
func AttemptToBuy(shopTile):
	print("purchase attempted")
	if (Globals.main.tokens >= shopTile.realTile.price && !shopLocked && !trinketsShown):
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

func AttemptToBuyTrinket(shopTrinket):
	if (Globals.main.tokens >= shopTrinket.trinket.price && !shopLocked && Globals.trinketManager.trinketArray.size() < 5):
		# deduct the money
		Globals.main.tokens -= shopTrinket.trinket.price
		#remove it from the array (so that the real tile doesnt get deleted i think)
		shopTrinketsArray.erase(shopTrinket)
		
		# get rid of shop slot
		shopTrinket.get_parent().queue_free()
		
		Globals.trinketManager.PutTrinketInPlay(shopTrinket.trinket)
	else:
		print("FAILED!")
		
func AttemptToBuyMaxTiles():
	if (Globals.main.tokens >= maxTilesPrice && !shopLocked):
		Globals.main.tokens -= maxTilesPrice
		Globals.main.maxTilesPerRound += 1
		IncreaseUpgradePrices()
		maxTilesPrice *= 1.2
		
func AttemptToBuyHandSize():
	if (Globals.main.tokens >= handSizePrice && !shopLocked):
		Globals.main.tokens -= handSizePrice
		Globals.main.handSize += 1
		IncreaseUpgradePrices()
		handSizePrice *= 1.2
		
func AttemptToBuyRoundsPerStage():
	if (Globals.main.tokens >= roundsPerStagePrice && !shopLocked):
		Globals.main.tokens -= roundsPerStagePrice
		Globals.main.maxRounds += 1
		IncreaseUpgradePrices()
		roundsPerStagePrice *= 1.2
		
func UpdateButtonText():
	maxTilesButton.text = "+ Tiles Per Round ($" + str(maxTilesPrice) + ")"
	handSizeButton.text = "+ Hand Size ($" + str(handSizePrice) + ")"
	roundsPerStageButton.text = "+ Rounds Per Stage ($" + str(roundsPerStagePrice) + ")"
	removalButton.text = "Remove Tile ($" + str(removalPrice) + ")"
	rerollButton.text = "Reroll Shop ($" + str(rerollPrice) + ")"
	
func IncreaseUpgradePrices():
	maxTilesPrice *= 1.2
	handSizePrice *= 1.2
	roundsPerStagePrice *= 1.2
	
	
	
func _on_leave_button_pressed() -> void:
	if (!shopLocked):
		Globals.main.MoveToBoard()

func AttemptPurchaseRemoval(removalTile):
	if (Globals.main.tokens >= removalPrice):
		Globals.main.tokens -= removalPrice
		tileRemovalManager.AttemptRemoval(removalTile)
		CloseRemovalMenu()
		removalPrice *= 1.2

func OpenRemovalMenu():
	tileRemovalManager.visible = true
	shopLocked = true
	tileRemovalManager.UpdateVisualDeck()
	

func CloseRemovalMenu():
	shopLocked = false
	tileRemovalManager.visible = false

func AttemptReroll():
	if (Globals.main.tokens >= rerollPrice):
		Globals.main.tokens -= rerollPrice
		for shopTile in shopTilesContainer.get_children():
			shopTilesArray.erase(shopTile)
			shopTile.queue_free()
			
		for shopTrinket in shopTrinketsContainer.get_children():
			shopTrinketsArray.erase(shopTrinket)
			shopTrinket.queue_free()
			
		for i in 3:
			CreateShopTile(Reference.GetCommonTileName())
		
		for i in 3:
			CreateShopTrinket(Reference.CommonTrinkets.pick_random())
		rerollPrice += 1

func ToggleTrinkets():
	if (trinketsShown):
		Globals.trinketManager.reparent(Globals.main.gameplayScreen)
		shopTrinketsContainer.visible = true
		tempSlab.visible = true
	else:
		Globals.trinketManager.reparent(self)
		shopTrinketsContainer.visible = false
		tempSlab.visible = false
		
		
	trinketsShown = !trinketsShown
