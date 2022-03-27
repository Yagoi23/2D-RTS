extends Node2D

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()
var weakref_selected = []

onready var building = get_node("res://Buildings/Building.gd")
onready var parent = get_parent()

onready var select_draw = $SelectDraw

onready var camera = $Camera2D 
var camera_speed = 1

enum state {COMMAND,BUILD}
var STATE = state.COMMAND

onready var BuildIcon = $UI/BuildingIcon
onready var CommandIcon = $UI/CommandIcon

onready var BuildingPredraw = $Building/BuildingPredraw

var buildingpreview_position = null

func _process(delta):
	#if STATE == state.BUILD:
	#	GlobalInformation.building_preview_hidden = false
	#else:
	#	GlobalInformation.building_preview_hidden = true
	#_update_building_predraw()
	GlobalInformation.movement_group = weakref_selected
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
		GlobalInformation.player_state = "command"
		var refrence_position = Vector2.ZERO
		refrence_position = get_parent().get_node("Player").position
		GlobalInformation.player_refrence_position = refrence_position
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.pressed:
				#deselects all units
				for unit in weakref_selected:
					if unit.get_ref():
						unit.get_ref().deselect()
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
				#for unit in selected:
				#	unit.collider.select()
				for unit in selected:
					if unit.collider.unit_owner == 0:
						unit.collider.select()
						weakref_selected.append(weakref(unit.collider))
		if dragging:
			if event is InputEventMouseMotion:
				#draws selection box
				select_draw.update_status(drag_start, event.position, dragging)
		#if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			#tells unit where to move
			#if event.pressed:
				#for unit in selected:
					#unit.collider.move_to(event.position + refrence_position)
	if STATE == state.BUILD:
		#GlobalInformation.building_preview_hidden = true
		#BuildingPredraw.visible = true
		GlobalInformation.player_state = "build"
		#print("Build")
		_update_building_predraw()
		_deselect_units()
		
		if GlobalInformation.can_build == true:
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
				#print("pressed mouse")
				if event.pressed:
					var node = load("res://Buildings/Building.tscn").instance()
					get_parent().add_child(node)
					node.position = buildingpreview_position#.position#event.position + buildingpreview_position #- GlobalInformation.player_refrence_position
					node.set_owner(get_tree().get_edited_scene_root())
		
			

func _update_building_predraw():
	BuildingPredraw.position = get_local_mouse_position() # - get_global_mouse_position()# - (GlobalInformation.player_refrence_position*2)
	if int(BuildingPredraw.position.x) % 16 == 0:
		pass
	elif int(BuildingPredraw.position.x) == 0:
		pass
		#pass
	else:
		var x = int(BuildingPredraw.position.x) % 16
		BuildingPredraw.position.x -= x 
	if int(BuildingPredraw.position.y) % 16 == 0:
		pass
	#elif int(BuildingPredraw.position.y) == 0:
		#pass
	else:
		var y = int(BuildingPredraw.position.y) % 16
		BuildingPredraw.position.y -= y
	#print(BuildingPredraw.position)
	buildingpreview_position = BuildingPredraw.global_position
	var true_building_preview = get_parent().get_node("TrueBuildingPreview")
	true_building_preview.position = buildingpreview_position

func _deselect_units():
	for unit in weakref_selected:
		if unit.get_ref():
			unit.get_ref().deselect()
			#emptys array
			selected = []
