extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var p = -3.2
var t = 2
var began = false
var rev = false
var sig = 1

func chg(scene):
	get_tree().change_scene_to(scene)

func stop():
	self.hide()
	$ViewportContainer/Viewport/Spatial/cube.transform.origin.x = -3
	$ViewportContainer/Viewport/Spatial/cube.rotation.y = 0
	$ColorRect.rect_size = Vector2(0, 0)
	began = false


func reverse():
	self.show()
	p = 3.19
	t = 2
	sig = -1
	began = true
	get_tree().create_timer(1.0).connect("timeout", self, "stop", [])

func begin(scene):
	self.show()
	p = -3.2
	t = 2
	sig = 1
	began = true
	get_tree().create_timer(1.9).connect("timeout", self, "chg", [scene])

# Called when the node enters the scene tree for the first time.
func _ready():
	# fix frame-1 flicker
	$ColorRect.rect_size = get_viewport_rect().size
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if began && p < 3.2:
		t += delta
		p += sig * delta * t * t * 1.3
	$ColorRect.rect_size.x = (p/3.0+0.2) * get_viewport_rect().size.x
	$ColorRect.rect_size.y = get_viewport_rect().size.y
		
	$ViewportContainer/Viewport/Spatial/cube.transform.origin.x = p
	$ViewportContainer/Viewport/Spatial/cube.rotate_y(sig * delta * t * t * 1.3)
	$ViewportContainer/Viewport.size = get_viewport_rect().size
	$ViewportContainer.rect_size = get_viewport_rect().size
	pass
