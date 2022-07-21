extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func load_clipboard():
	if !Glob.putleveldat(OS.get_clipboard()):
		push_error("Fail to load!\n")
	else:
		OS.set_clipboard("")
		Glob.origin = "prescreen"
		get_tree().change_scene("res://scn/editor_play/Play.tscn")

func load_editor():
	get_tree().change_scene("res://scn/editor/Editor.tscn")
	
func back_handle():
	get_tree().change_scene("res://scn/menu/Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Glob.set_music("res://res/dile.ogg")
	$LoadBtn.connect("pressed", self, "load_clipboard")
	$EditBtn.connect("pressed", self, "load_editor")
	$BackBtn.connect("pressed", self, "back_handle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if OS.get_clipboard().begins_with("DL0"):
		load_clipboard()
	pass
