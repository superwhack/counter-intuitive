extends Node2D

@export var clink : AudioStream
@export var pickup : AudioStream

func _init() -> void:
	Globals.globalAudioManager = self
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func PlaySound(chosenStream):
	var audioPlayer = AudioStreamPlayer2D.new()
	add_child(audioPlayer)
	match chosenStream:
		Reference.SOUND_NAMES.clink:
			audioPlayer.stream = clink
		Reference.SOUND_NAMES.pickup:
			audioPlayer.stream = pickup
	audioPlayer.pitch_scale += randf_range(-1, 1) * 0.2
	audioPlayer.play()
	await audioPlayer.finished
	audioPlayer.queue_free()
