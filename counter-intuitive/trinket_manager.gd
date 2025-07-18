extends Node2D
class_name TrinketManager

var trinketArray : Array
@export var trinketsNode : Node
@export var trinketSlotScene : PackedScene
var trinketSlotsArray : Array

func _init() -> void:
	Globals.trinketManager = self
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func ResetRound():
	for trinket in trinketArray:
		trinket.ResetRound()

func ResetStage():
	for trinket in trinketArray:
		trinket.ResetStage()
	
func ResetRun():
	pass

func CreateTrinket(trinketName : String):
	print("create trinket attempted")
	var newTrinket = Reference.TrinketScenes[trinketName].instantiate()
	Globals.main.add_child(newTrinket)
	return newTrinket
	
func PutTrinketInPlay(trinket : Trinket):
	trinketArray.append(trinket)
	
	var slot = trinketSlotScene.instantiate()

	trinketsNode.add_child(slot)
	
	trinket.reparent(slot)
	
	trinket.showPrice = false
	
	trinket.position = Vector2(64, 64)
	
	
func CreatePlayTrinket(trinketName : String):
	var newTrinket = CreateTrinket(trinketName)
	PutTrinketInPlay(newTrinket)
	
	newTrinket.position = Vector2(64, 64)
	
func RemoveTrinket(trinket : Trinket):
	trinket.get_parent().queue_free()
	trinketArray.erase(trinket)
	
