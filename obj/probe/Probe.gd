extends Node2D

export var size := Vector2(4, 4)
export var pos := Vector2(0, 0)
export var valid := true

func create(size: Vector2) -> void:
	self.size = size

func _init() -> void:
	pass
	
func placement() -> Vector2:
	return pos * 64

func rect():
	return Rect2(position + pos * 64, size * 64)

func tangents() -> Array:
	var tangents := [] 
	
	for x in range(pos.x, size.x+pos.x):
		for y in range(pos.y, size.y+pos.y):
			tangents.append(Vector2(x, y))
	
	return tangents

func _process(delta):
	self.pos = (self.get_local_mouse_position() / 64 - size/2).round();
	update()

func _draw():
	var color := Color.green if valid else Color.red 
	color.a = 0.3
	
	draw_rect(Rect2(self.pos*64, self.size*64), color)
