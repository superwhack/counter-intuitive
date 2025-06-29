extends Control

@export var stars : TextureRect
@export var circles : TextureRect

var starsMaterial
var circlesMaterial

var circleDefaultScale = 0.5
var starDefaultScale = 1

@export var scaleFactor = 1.0;
@export_range(0, 1000) var desiredScale = 1.0;

var lerpScale = 2;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starsMaterial = stars.material
	circlesMaterial = circles.material
	
	SetScale()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scaleFactor = lerpf(scaleFactor, desiredScale, 2 * delta)
	
	SetScale()
	
#func GetScale():
	#circleScale = circlesMaterial.get_shader_parameter("scale")
	#starScale = starsMaterial.get_shader_parameter("scale")
	
func SetScale():
	circlesMaterial.set_shader_parameter("scale", circleDefaultScale * scaleFactor)
	starsMaterial.set_shader_parameter("scale", starDefaultScale * scaleFactor)

func ZoomTo(desired : float):
	desiredScale = desired
