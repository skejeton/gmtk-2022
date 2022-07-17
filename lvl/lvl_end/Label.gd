extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var shown = false

func show():
	shown = true
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate.a = 0.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shown:
		self_modulate.a += delta
		self_modulate.a *= 1.1
		if self_modulate.a > 1:
			self_modulate.a = 1
	pass
