extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var moves = 0
var wait = 1.0


func _ready():
	$Main.input_lock = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Glob.finished = true
	Glob.fix0 = true

	Glob.set_music2("!res://res/dice_roller_mastered.mp3", 1.0, 0.7)
	wait -= delta
	if moves == 4:
		$Skejeton.show()

	if moves == 9:
		$Tami.show()

	if moves == 14:
		$Rusheel.show()

	if moves == 23:
		$Player.show()

	if moves == 30:
		moves += 1
		$Main.backlog = []
		$Main.input_lock = false

	if $Main/VisualData/Dice.get_child(0).grid_pos == Vector2(32, -8):
		$Player2.show()




	if wait < 0 && moves < 30:
		moves += 1
		$Main.input_lock = false
		$Main.push_move($Main/VisualData/Dice.get_child(0), 0, -1)
		wait = 1.0
		$Main.input_lock = true
	$Main.merge_actions()


	pass
