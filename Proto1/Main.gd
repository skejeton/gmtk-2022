extends Node2D

func reroll():
	$Die1.frame = rand_range(0, 6);
	$Die2.frame = rand_range(0, 6);

func _ready():
	$Button.connect("button_down", self, "reroll")
	pass
