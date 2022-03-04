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
		if Input.is_action_pressed("enter_command_mode"):
			STATE = state.COMMAND
		if Input.is_action_pressed("enter_build_mode"):
			STATE = state.BUILD
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
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed:
				#deselects all units
				for unit in selected:
					unit.collider.deselect()
				#emptys array
				selected = []
				dragging = true
				drag_start = event.position
			elif dragging:
				dragging = false
				#draw selection
				select_draw.update_status(drag_start, event.position, dragging)
				var drag_end = event.position
				select_rectangle.extents = (drag_end - drag_start)/2
				var space = get_world_2d().direct_space_state
				var query = Physics2DShapeQueryParameters.new()
				query.set_shape(select_rectangle)
				query.transform = Transform2D(0, (drag_end + drag_start)/2  + refrence_position)
				#add colliders to selected array
				selected = space.intersect_shape(query, 1000)
				#filter out non units
				var actual_units = []
				for unit in selected:
					if unit.collider.is_in_group("Unit"):
						actual_units.append(unit)
				selected = actual_units
				#selects units
				for unit in selected:
					unit.collider.select()
		if dragging:
			if event is InputEventMouseMotion:
				#draws selection box
				select_draw.update_status(drag_start, event.position, dragging)
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			#tells unit where to move
			if event.pressed:
				for unit in selected:
					unit.collider.move_to(event.position + refrence_position)
	if STATE == state.BUILD:
		print("Build")
