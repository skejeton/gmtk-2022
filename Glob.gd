extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var v = 0
var h = 0.0
var origin = ""
var ls_scroll = 0
var fix0 = false
var mus = ""
var finished = false
var t = 0
var best = 1e9
var timerstart = false

func starttime():
	t = 0
	timerstart = true
	
func stoptime():
	if t < best:
		best = t
	timerstart = false
	
func getstrbesttime():
	return "%d:%02d" % [int(floor(best/60)), int(floor(best))%60]

func getstrtime():
	return "%d:%02d" % [int(floor(t/60)), int(floor(t))%60]

func set_music2(path, p, v):
	if path != mus:
		mus = path
		if path[0] == "!":
			path = path.substr(1)
		BackgroundMusic.get_node("AudioStreamPlayer").stream = load(path)
		BackgroundMusic.get_node("AudioStreamPlayer").pitch_scale = p
		BackgroundMusic.get_node("AudioStreamPlayer").volume_db = v
		BackgroundMusic.get_node("AudioStreamPlayer").play()

func set_music(path):
	set_music2(path, 0.9, -15)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timerstart:
		t += delta
	pass
