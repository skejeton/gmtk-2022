extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dinit

func act(i: int):
	match i:
		1:
			$Trans.begin(preload("res://lvl/001/001.tscn"))
		3:
			get_tree().change_scene("res://scn/credits/Credits.tscn")
			
		


# Called when the node enters the scene tree for the first time.
func _ready():
	dinit = $Dice.position
	$PlayBtn.connect("pressed", self, "act", [1])
	$CreditsBtn.connect("pressed", self, "act", [3])
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		$Dice.move_y(-1)
	if Input.is_action_just_pressed("ui_down"):
		$Dice.move_y(1)
	if Input.is_action_just_pressed("ui_left"):
		$Dice.move_x(-1)
	if Input.is_action_just_pressed("ui_right"):
		$Dice.move_x(1)
	$Dice.pos = dinit
	pass
