extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func press():
	get_tree().change_scene("res://scn/menu/Menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Glob.set_music("res://res/dile.ogg")
	$TextureButton.connect("pressed", self, "press")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
