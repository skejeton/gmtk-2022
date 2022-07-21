extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Glob.leveldat:
		$Main/InputData.set_cellv(Vector2(i.x, i.y), i.v)
	$Main.init_from_tilemap()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
