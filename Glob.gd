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
class Tile:
	var x
	var y
	var v
	func _init(x, y, v):
		self.x = x
		self.y = y
		self.v = v

var leveldat = []

func putleveldat(d: String) -> bool:
	var r = RegEx.new()
	r.compile("\\<[^\\>]*\\>")
	d = r.sub(d, "", true)
	print(d)
	var dat = d.split(",")
	leveldat = []
	if len(dat) < 2:
		return false
	
	if (len(dat)-2)%3 != 0:
		return false
	
	
	if dat[0].strip_edges() != "DL0":
		return false
	
	var checksum = int(dat[1])
	var real_checksum = 0
	
	for i in range(2, len(dat)-2):
		if (i - 2) % 3 != 0:
			continue
		var x = int(dat[i+0])
		var y = int(dat[i+1])
		var v = int(dat[i+2])
		real_checksum += x + y + v
		leveldat.append(Tile.new(x, y, v))
		
#	if checksum != real_checksum:
#		return false
	
	return true
	

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
