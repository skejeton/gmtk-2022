extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cubes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	seed(1)
	for i in range(10):
		var c = $ViewportContainer/Viewport/Spatial/cube.duplicate()
		c.transform.origin = Vector3(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized()/2.2
		c.rotation_degrees = Vector3(rand_range(0, 360), rand_range(0, 360), rand_range(0, 360))
		cubes.append(c)
		$ViewportContainer/Viewport/Spatial.add_child(c)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ViewportContainer/Viewport.size = get_viewport_rect().size
	$ViewportContainer.rect_size = get_viewport_rect().size
	
	Glob.v += 0.05 * delta
	$ViewportContainer/Viewport/Spatial/Camera.rotation = Vector3(Glob.v, Glob.v, Glob.v)
	pass
