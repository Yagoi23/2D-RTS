extends Node2D

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()

onready var select_draw = $SelectDraw

onready var camera = $Camera2D 
var camera_speed = 1

enum state {COMMAND,BUILD}
var STATE = state.COMMAND

onready var BuildIcon = $UI/BuildingIcon
onready var CommandIcon = $UI/CommandIcon

func _process(delta):
	$UI/Label.text = str(STATE)
	if dragging != true:
		if Input.is_action_pressed("player_move_up"):
			position.y -= camera_speed
		if Input.is_action_pressed("player_move_down"):
			position.y += camera_speed
		if Input.is_action_pressed("player_move_left"):
			position.x -= camera_speed
		if Input.is_action_pressed("player_move_right"):
			position.x += camera_speed
		if Input.is_action_pressed("increase_camera_speed"):
			camera_speed += 1
		if Input.is_action_pressed("decrease_camera_speed"):
			camera_speed -= 1
	if camera_speed > 10:
		camera_speed = 10
	if camera_speed < 1:
		camera_speed = 1
	if STATE == state.COMMAND:
		CommandIcon.visible = true
		BuildIcon.visible = false
	elif STATE == state.BUILD:
		CommandIcon.visible = false
		BuildIcon.visible = true

func _unhandled_input(event):
	if STATE == state.COMMAND:
		var refrence_position = Vector2.ZERO
		refrence_position = get_parent().get_node("Player").position
		#print(refrence_position)
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed:
				for unit in selected:
					unit.collider.deselect()
				selected = []
				dragging = true
				drag_start = event.position
			elif dragging:
				dragging = false
				select_draw.update_status(drag_start, event.position, dragging)
				var drag_end = event.position # - Vector2(position.x, global_position.y)
				#select_rectangle.extents = (drag_end - drag_start)
				select_rectangle.extents = (drag_end - drag_start)/2# + refrence_position# - (drag_end + drag_start)/2
				var space = get_world_2d().direct_space_state
				var query = Physics2DShapeQueryParameters.new()
				query.set_shape(select_rectangle)
				query.transform = Transform2D(0, (drag_end + drag_start)/2  + refrence_position)
				#query.transform = Transform2D(0, (drag_end + drag_start))
				selected = space.intersect_shape(query)
				#print(selected)
				for unit in selected:
					unit.collider.select()
		if dragging:
			if event is InputEventMouseMotion:
				select_draw.update_status(drag_start, event.position, dragging)
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			if event.pressed:
				for unit in selected:
					unit.collider.move_to(event.position)
	if STATE == state.BUILD:
		print("Build")
