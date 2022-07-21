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
	if !Glob.timerstart:
		$VisualData/CanvasLayer2/TimeMarker.hide()
	 
	$VisualData/CanvasLayer2/TextureButton.connect("pressed", self, "undobtn")
	Glob.set_music("res://res/dice_roller_mastered.mp3")
	$VisualData/CanvasLayer2/Trans.reverse()
	init_from_tilemap()
	$VisualData.show()
	$InputData.hide()

func find_colliding_die(die_t) -> DieClass:
	for die in $VisualData/Dice.get_children():
		if die != die_t && die.grid_pos == die_t.grid_pos:
			return die
	return null
		

func cb_wrongblock_timeout(die, x, y):
	input_lock = false
	print(x, y)
	die.fake_move(x, y)
	
func do_actions(actions):
	var rem = []
	var i = 0
	for action in actions:
		print(action.die.index)
	for action in actions:
		if action is ActionMove:
			action.die.move_x(action.byX)
			action.die.move_y(action.byY)
		i += 1
	
	for x in range(50):
		i = 0
		for action in actions:
			if action is ActionMove:
				var coll = find_colliding_die(action.die)
				if coll:
					action.die.fake_move(-action.die.grid_vis_ofs.x, -action.die.grid_vis_ofs.y)
					if coll.grid_vis_ofs != action.die.grid_vis_ofs:
						var vx = coll.grid_vis_ofs.x-action.die.grid_vis_ofs.x
						var vy = coll.grid_vis_ofs.y-action.die.grid_vis_ofs.y
						action.die.fake_move(vx, vy)
						get_tree().create_timer(0.3).connect("timeout", self, "cb_wrongblock_timeout", [action.die, -vx, -vy])
						
					action.die.move_x(-action.byX)
					action.die.move_y(-action.byY)
					if rem.find(i) == -1:
						rem.append(i)
			i += 1

	# Remove all dependent actions
	i = 0
	for action in actions:
		var yes = false
		for x in rem:
			if action != actions[x] && actions[x].die == action.die:
				rem.append(i)
		i += 1
	
	rem.sort()
	var m = 0
	for id in rem:
		actions.remove(id-m)
		m += 1
		
	for action in actions:
		if action is ActionRotate:
			action.die.rotate(action.by)
			$SfxRotate.play()
	print(rem, actions)
		
	

func undo_actions(actions):
	for i in range(len(actions)):
		var action = actions[len(actions)-i-1]
		
		if action is ActionMove:
			action.die.move_x(-action.byX)
			action.die.move_y(-action.byY)
		if action is ActionRotate:
			action.die.rotate(-action.by)

func merge_actions():
	if len(actions) == 0:
		return
	do_actions(actions)
	# Len may have changed because of invalid moves
	if len(actions) == 0:
		return
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
			
		var coll = find_colliding_die(die)
		
		die.move_x(-x)
		die.move_y(-y)
		
		if value != -1 && top != value:
			if coll == null:
				input_lock = true
				$SfxWrong.play()
				die.fake_move(x, y)
				get_tree().create_timer(0.3).connect("timeout", self, "cb_wrongblock_timeout", [die, -x, -y])
			return
		
		
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
			if Glob.origin == "prescreen":
				Glob.origin = ""
				$VisualData/CanvasLayer2/Trans.begin(load("res://scn/editor_prescreen/Prescreen.tscn"))
			else:
				$VisualData/CanvasLayer2/Trans.begin(next)
			
		if cell == CellValues.CELL_RCW:
			actions.push_back(ActionRotate.new(die, -1))
	else:
		$SfxCant.play()

func _input(ev):
	if ev is InputEventKey:
		if ev.pressed && ev.scancode == KEY_F1:
			input_lock = true
			if Glob.origin == "prescreen":
				$VisualData/CanvasLayer2/Trans.begin(load("res://scn/editor_prescreen/Prescreen.tscn"))
			else:
				$VisualData/CanvasLayer2/Trans.begin(load("res://scn/level_select/LevelSelect.tscn"))
				
			Glob.origin = ""
			Glob.fix0 = true
			$VisualData/CanvasLayer2/TimeMarker.hide()
			Glob.t = 1e9
	
	if !input_lock:
		if ev is InputEventKey:
			if ev.pressed && (ev.scancode == KEY_ESCAPE || ev.scancode == KEY_BACKSPACE):
				pop_actions()

func undobtn():
	if !input_lock:
		pop_actions()

func sort_dice(a, b):
	return Vector2(-1000, -1000).distance_to(a.grid_pos) < Vector2(-1000, -1000).distance_to(b.grid_pos)

func _process(delta):
	$VisualData/Dice.get_children().sort_custom(self, "sort_dice")
	$VisualData/CanvasLayer2/TimeMarker.text = Glob.getstrtime()
	if len(backlog) > 0 && !input_lock:
		$VisualData/CanvasLayer2/TextureButton.show()
	else:
		$VisualData/CanvasLayer2/TextureButton.hide()
		
	Glob.h += delta/40.0
	
	$VisualData/CanvasLayer/Node2D.modulate = Color.from_hsv(Glob.h, 0.2, 0.2)
	if !input_lock:
		var i = 0
		var temp_lock = false
		for die in $VisualData/Dice.get_children():
			input_lock = false
			die.index = i
			i += 1
			if Input.is_action_just_pressed("ui_up"):
				push_move(die, 0, -1)
			if Input.is_action_just_pressed("ui_down"):
				push_move(die, 0, 1)
			if Input.is_action_just_pressed("ui_left"):
				push_move(die, -1, 0)
			if Input.is_action_just_pressed("ui_right"):
				push_move(die, 1, 0)
			if input_lock:
				temp_lock = true
		input_lock = temp_lock
		merge_actions()

	pass
