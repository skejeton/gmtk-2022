extends TextureButton

var v = 0.0

func _process(delta):
	if is_hovered():
		v *= 1.2
		v += 0.01
	else:
		v /= 2

	v = clamp(v, 0.1, 1.0)
	
	self.self_modulate = Color(1.0, 1.0, 1.0, clamp(v, 0.1, 1.0))
	$Label.rect_position.x = 30+v*20
	self.self_modulate = Color(1.0, 1.0, 1.0, clamp(v, 0.1, 1.0))
	
