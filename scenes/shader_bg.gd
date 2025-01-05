@tool
extends Control

@onready var shader_rect: ColorRect = $ShaderRect
@onready var control_points: Node = $ControlPoints
@onready var manual: Node = $Manual
@onready var top: Label = $top
@onready var bottom: Label = $bottom
@onready var total: Label = $Total
@onready var avg: Label = $Avg
@onready var mouse_ball: LavaBall = $MouseBall


var bottom_charge :float = 0
var top_charge :float = 0
var free_balls :Array[LavaBall] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in control_points.get_children():
		c.queue_free()
	for i in 15:
		var new_ball = LavaBall.new()
		new_ball.position.x = randf_range(0, size.x)
		new_ball.position.y = randf_range(0, size.y)
		new_ball.charge = 2 + randf()*5
		control_points.add_child(new_ball)

func move(ball :LavaBall, delta :float):
	var screen_speed = size.y/10.0
	ball.position.y += ball.speed*screen_speed*delta*ball.current_dir
	
	if ball.position.y < -100:
		#ball.speed = 0
		var lost_charge = delta*1.0
		if ball.charge >= lost_charge:
			ball.charge -= lost_charge
			top_charge += lost_charge
		else:
			free_balls.append(ball)
	elif ball.position.y > size.y + 100:
		#ball.speed = 0
		var lost_charge = delta*1.0
		if ball.charge >= lost_charge:
			ball.charge -= lost_charge
			bottom_charge += lost_charge
		else:
			free_balls.append(ball)

func spawn_top(ball :LavaBall):
	var bsize = 2 + randf()*5
	bsize = minf(bsize, top_charge)
	ball.charge = bsize
	top_charge -= bsize
	ball.position.y = - 100
	ball.position.x = randf_range(0, size.x)
	ball.current_dir = 1
	ball.speed = randf_range(0.15, 1.5)
	#print("spawn top")

func spawn_bottom(ball :LavaBall):
	var bsize = 2 + randf()*5
	bsize = minf(bsize, bottom_charge)
	ball.charge = bsize
	bottom_charge -= bsize
	ball.position.y = size.y + 100
	ball.position.x = randf_range(0, size.x)
	ball.current_dir = -1
	ball.speed = randf_range(0.15, 1.5)
	#print("spawn_bottom")

func move_mouse(delta :float):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#mouse_ball.position.x = move_toward(mouse_ball.position.x, get_local_mouse_position().x, delta*600)
		#mouse_ball.position.y = move_toward(mouse_ball.position.y, get_local_mouse_position().y, delta*600)
		mouse_ball.position.x = get_local_mouse_position().x
		mouse_ball.position.y = get_local_mouse_position().y
		mouse_ball.charge += delta*4*(4 - mouse_ball.charge)
	else:
		mouse_ball.charge -= delta*10
		if mouse_ball.charge < 0:
			mouse_ball.charge = 0
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
			mouse_ball.reparent(manual)
			mouse_ball = LavaBall.new()
			add_child(mouse_ball)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	top.text = "%.3f" % top_charge
	bottom.text = "%.3f" % bottom_charge
	
	if !free_balls.is_empty():
		if top_charge > bottom_charge:
			spawn_top(free_balls.pop_back())
		else:
			spawn_bottom(free_balls.pop_back())
	
	var total_charge :float = top_charge + bottom_charge
	move_mouse(delta)
	for point in control_points.get_children():
		total_charge += point.charge
		move(point, delta)
	
	total.text = "total: %.3f" % total_charge
	avg.text = "avg: %.3f" % (total_charge/control_points.get_children().size())
	var points :Array[Vector3] = []
	for point in control_points.get_children():
		var vec :Vector3 = Vector3(point.position.x/size.x*(size.x/size.y), point.position.y/size.y, point.scale.x)
		points.append(vec)
	for point in manual.get_children():
		point.charge -= delta*(5-point.charge)
		if point.charge < 0:
			point.queue_free()
			pass
		var vec :Vector3 = Vector3(point.position.x/size.x*(size.x/size.y), point.position.y/size.y, point.scale.x)
		points.append(vec)

	points.append(Vector3(mouse_ball.position.x/size.x*(size.x/size.y), mouse_ball.position.y/size.y, mouse_ball.scale.x))
	shader_rect.material.set_shader_parameter("input_points", points)
	shader_rect.material.set_shader_parameter("array_size", points.size())
	shader_rect.material.set_shader_parameter("canvas_size", Vector2(size.x, size.y))

func _draw() -> void:
	return
	for point in control_points.get_children():
		draw_circle(point.position, 6, Color.BLUE)
		if point.position.y > size.y - 16:
			draw_string(get_theme_default_font(), point.position + Vector2.UP*10, "%.3f" % point.charge)
			draw_string(get_theme_default_font(), point.position + Vector2(-60, -10), "%.3f" % point.scale.x, 0, -1, 16, Color.WEB_GRAY)
		else:
			draw_string(get_theme_default_font(), point.position + Vector2.DOWN*20, "%.3f" % point.charge)
			draw_string(get_theme_default_font(), point.position + Vector2(-60, 20), "%.3f" % point.scale.x, 0, -1, 16, Color.WEB_GRAY)
		
