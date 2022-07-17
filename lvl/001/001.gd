extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tv = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.self_modulate.a = 0
	yield(get_tree().create_timer(2.0), "timeout")
	tv = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.self_modulate.a += (tv-$Sprite.self_modulate.a)*delta
	pass
