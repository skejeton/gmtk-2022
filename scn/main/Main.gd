extends Node2D

const DieScn = preload("res://obj/die2d/Die2d.tscn")
export var next: PackedScene
export var lv_name: String = ""
var latency = 0

class ActionMove:
	var byX: int
	var byY: int
	var die
	
	func _init(_die, x: int, y: int):
		self.die = _die
		byX = x
		byY = y

class ActionRotate:
	var by: int
	var die
	
	func _init(_die, _by: int):
		self.die = _die
		by = _by
	
var backlog = []
var actions = []
var input_lock = false

enum CellValues {
	CELL_END = 0
	CELL_PLAT = 1
	CELL_DIE = 2
	CELL_RCW = 12
}

func get_die_value_from_cell(x: int) -> int:
	if x < 3:
		return -1
	if x > 11:
		return -1
	var list = [0, 1, 1+6, 2, 2+6, 3, 4, 5, 5+6]
	
	return list[x-3]

func init_from_tilemap():
	for p in $InputData.get_used_cells():
		print(p)
		var cellv = $InputData.get_cellv(p)
		if cellv == CellValues.CELL_DIE: # Die placement tile
			var die = DieScn.instance()
			die.set_pos(p)
			$VisualData/Dice.add_child(die)
		if cellv > 1: # Account for non existence of dice placement cell
			cellv -= 1
		$VisualData/Tilemap.set_cellv(p, cellv)



func _ready():
	$VisualData/CanvasLayer2/TextureButton.connect("pressed", self, "undobtn")
	Glob.set_music("res://res/dice_roller_mastered.mp3")
	$VisualData/CanvasLayer2/Trans.reverse()
	init_from_tilemap()
	$VisualData.show()
	$InputData.hide()

func do_actions(actions):
	for action in actions:
		if action is ActionMove:
			action.die.move_x(action.byX)
			action.die.move_y(action.byY)
		if action is ActionRotate:
			action.die.rotate(action.by)

func undo_actions(actions):
	for i in range(len(actions)):
		var action = actions[len(actions)-i-1]
		
		if action is ActionMove:
			action.die.move_x(-action.byX)
			action.die.move_y(-action.byY)
		if action is ActionRotate:
			action.die.rotate(-action.by)

func cb_wrongblock_timeout(action):
	$SfxWrong.play()
	input_lock = false
	undo_actions([action])

func merge_actions():
	if len(actions) == 0:
		return
	do_actions(actions)
	backlog.append(actions)
	actions = []
	
func pop_actions():
	if len(backlog) == 0:
		return
	
	undo_actions(backlog.pop_back())



func push_move(die, x: int, y: int):
	if input_lock:
		return
		
	var cell = $InputData.get_cellv(die.grid_pos + Vector2(x, y))
	
	var motion
	var value = get_die_value_from_cell(cell)
	
	if cell != -1:
		$SfxRoll.play()
		die.move_x(x)
		die.move_y(y)

		var top = die.get_top()
		
		
		if value != -1 && top != value:
			input_lock = true
			get_tree().create_timer(0.3).connect("timeout", self, "cb_wrongblock_timeout", [ActionMove.new(die, x, y)])
			return
		
		die.move_x(-x)
		die.move_y(-y)
		
		actions.push_back(ActionMove.new(die, x, y))
		
		if cell == CellValues.CELL_END:
			$SfxWin.play()
			input_lock = true
			merge_actions()
			yield(get_tree().create_timer(1), "timeout")
			
			if Glob.origin == "level_select":
				Glob.origin = ""
				Glob.fix0 = true
				$VisualData/CanvasLayer2/Trans.begin(load("res://scn/level_select/LevelSelect.tscn"))
			else:
				$VisualData/CanvasLayer2/Trans.begin(next)
			
		if cell == CellValues.CELL_RCW:
			$SfxRotate.play()
			actions.push_back(ActionRotate.new(die, -1))
	else:
		$SfxCant.play()

func _input(ev):
	if !input_lock:
		if ev is InputEventKey:
			if ev.pressed && (ev.scancode == KEY_ESCAPE || ev.scancode == KEY_BACKSPACE):
				pop_actions()

func undobtn():
	if !input_lock:
		pop_actions()

func _process(delta):
	if len(backlog) > 0 && !input_lock:
		$VisualData/CanvasLayer2/TextureButton.show()
	else:
		$VisualData/CanvasLayer2/TextureButton.hide()
		
	Glob.h += delta/40.0
	
	$VisualData/CanvasLayer/Node2D.modulate = Color.from_hsv(Glob.h, 0.2, 0.2)
	if !input_lock:
		for die in $VisualData/Dice.get_children():
			if Input.is_action_just_pressed("ui_up"):
				push_move(die, 0, -1)
			if Input.is_action_just_pressed("ui_down"):
				push_move(die, 0, 1)
			if Input.is_action_just_pressed("ui_left"):
				push_move(die, -1, 0)
			if Input.is_action_just_pressed("ui_right"):
				push_move(die, 1, 0)
		merge_actions()

	pass
