extends Node2D

class_name DieClass

class LogicalDice:
	var bottom = 3
	var rollX = [1+6, 2, 4]
	var rollZ = [5, 2, 0]

	func subvalue(v):
		var mod = v % 6
		
		if mod != 0 && mod != 3 && mod != 4:
			if v >= 6:
				v -= 6
			else:
				v += 6
		return v
		
		
	func shift_next(arr: Array, arr2: Array):
		var mem = arr[0]
		arr.pop_front()
		arr.append(bottom)
		bottom = mem
		arr2[1] = arr[1]
		arr2[0] = subvalue(arr2[0])
		arr2[2] = subvalue(arr2[2])

	func shift_prev(arr: Array, arr2: Array):
		var mem = arr[2]
		arr.pop_back()
		arr.insert(0, bottom)
		bottom = mem
		arr2[1] = arr[1]
		arr2[0] = subvalue(arr2[0])
		arr2[2] = subvalue(arr2[2])

	# Y rotation
	func spin_generic(l):
		bottom = subvalue(bottom)
		rollX[1] = subvalue(rollX[1])
		rollZ[1] = subvalue(rollZ[1])
		
		# swap rotors
		rollX[0] = subvalue(l[0])
		rollZ[0] = subvalue(l[1])
		rollX[2] = subvalue(l[2])
		rollZ[2] = subvalue(l[3])

	func spin_right():
		spin_generic([rollZ[2], rollX[0], rollZ[0], rollX[2]])
		pass
		
	func spin_left():
		spin_generic([rollZ[0], rollX[2], rollZ[2], rollX[0]])
		# swap rotors
		
	func rotate_pitch(v):
		if v < 0:
			for i in range(-v):
				shift_prev(rollX, rollZ)
		else:
			for i in range(v):
				shift_next(rollX, rollZ)
				
	func rotate_roll(v):
		if v < 0:
			for i in range(-v):
				shift_prev(rollZ, rollX)
		else:
			for i in range(v):
				shift_next(rollZ, rollX)
	
	func rotate_yaw(v):
		if v < 0:
			for i in range(-v):
				spin_left()
		else:
			for i in range(v):
				spin_right()
				
	func get_top(): 
		assert(rollX[1] == rollZ[1])
		return rollX[1]

var dice = LogicalDice.new()
var v_tran = Transform.IDENTITY
var x_tran = Transform.IDENTITY
var tran = Transform.IDENTITY
onready var pos = position
var grid_pos = Vector2(0, 0)
var rotated = false
var delay = 0.0

func get_top() -> int:
	return self.dice.get_top()

func set_pos_smooth(grid_pos):
	self.grid_pos = grid_pos
	self.pos = grid_pos * 64
	
func set_pos(grid_pos):
	set_pos_smooth(grid_pos)
	self.position = self.pos
	
func move_y(by):
	if by == 0:
		return
	tran = tran.rotated(Vector3(1, 0, 0), by*PI/2)
	set_pos_smooth(grid_pos+Vector2(0, by))
	dice.rotate_pitch(-by)
	x_tran = tran

func move_x(by):
	if by == 0:
		return
	tran = tran.rotated(Vector3(0, 0, 1), by*-PI/2)
	set_pos_smooth(grid_pos+Vector2(by, 0))
	dice.rotate_roll(-by)
	x_tran = tran
	

func rotate(times):
	dice.rotate_yaw(times)
	tran = tran.rotated(Vector3(0, 1, 0), times*PI/2)
	delay = 0.5
	yield(get_tree().create_timer(0.3), "timeout")
	x_tran = tran

func _process(delta):
	v_tran = v_tran.interpolate_with(x_tran, delta * 10)
	position = position.linear_interpolate(pos, delta * 10)
	
	update()
	
	$ViewportContainer/Viewport/Spatial/cube.transform = v_tran

func _draw():
	pass
#	var l = Label.new()
#	draw_string(l.get_font(""), Vector2(0, -40), "%s:%s" % [dice.rollX, dice.rollZ])
#	draw_string(l.get_font(""), Vector2(0, -20), "Top is %d:%d" % [dice.get_top()%6+1, dice.get_top()/6])
