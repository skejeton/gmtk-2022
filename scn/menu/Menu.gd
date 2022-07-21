extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dinit

func act(i: int):
	match i:
		1:
			Glob.starttime()
			Glob.origin = ""
			$Trans.begin(load("res://lvl/001/001.tscn"))
		2:
			get_tree().change_scene("res://scn/level_select/LevelSelect.tscn")
		3:
			get_tree().change_scene("res://scn/credits/Credits.tscn")
		5:
			get_tree().change_scene("res://scn/editor_prescreen/Prescreen.tscn")
			
		


# Called when the node enters the scene tree for the first time.
func _ready():
	if Glob.finished:
		$PlayBtn/Label.text += " BEST "+Glob.getstrbesttime()
		
	Glob.set_music("res://res/dile.ogg")
	
	dinit = $Dice.position
	$PlayBtn.connect("pressed", self, "act", [1])
	$SelBtn.connect("pressed", self, "act", [2])
	$CreBtn.connect("pressed", self, "act", [5])
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
