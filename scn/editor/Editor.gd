extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func back_handle():
	get_tree().change_scene("res://scn/editor_prescreen/Prescreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.connect("pressed", self, "back_handle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	var o = 48
	
	for x in range(99):
		draw_line(Vector2(0, x*o), Vector2(get_viewport_rect().size.x, x*o), Color.white)
		
	for x in range(99):
		draw_line(Vector2(x*o, 0), Vector2(x*o, get_viewport_rect().size.y), Color.white)
