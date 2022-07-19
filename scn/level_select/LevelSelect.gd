extends Node2D

var scroll = 0
const Btn = preload("res://obj/menubtn/MenuBtn.tscn") 

onready var levels = [
	load("res://lvl/001/001.tscn"),
	load("res://lvl/002/002.tscn"),
	load("res://lvl/003/003.tscn"),
	load("res://lvl/004/004.tscn"),
	load("res://lvl/005/005.tscn"),
	load("res://lvl/006/006.tscn"),
	load("res://lvl/007/007.tscn"),
	load("res://lvl/lvl_end/LvlEnd.tscn"),
]

func chg_level(lv):
	Glob.origin = "level_select"
	Glob.ls_scroll = scroll
	$Trans.begin(lv)

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_WHEEL_UP:
			scroll += 20
		if ev.button_index == BUTTON_WHEEL_DOWN:
			scroll -= 20
	
	if scroll > 0:
		scroll = 0

func back():
	Glob.origin = "level_select"
	get_tree().change_scene_to(load("res://scn/menu/Menu.tscn"))

func _ready():
	Glob.stoptime()
	
	if Glob.finished:
		levels.append(load("res://lvl/test/test.tscn"))
	Glob.set_music("res://res/dile.ogg")
	if Glob.fix0:
		$Trans.reverse()
		Glob.fix0 = false
	$TextureButton.connect("pressed", self, "back")
	scroll = Glob.ls_scroll
	var i = 0
	for lv in levels:
		var b = Btn.instance()
		b.connect("pressed", self, "chg_level", [lv])
		b.rect_position.y = 100 + i * 80
		b.rect_position.x = 30
		b.get_node("Label").text = str(lv.instance().get_node("Main").lv_name)
		$Scroller.add_child(b)
		i += 1
		

func _process(delta):
	$Scroller.rect_position += (Vector2(0, scroll)-$Scroller.rect_position)/10.0
