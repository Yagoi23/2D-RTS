extends Node2D
class_name Building_Preview

onready var green = $Green
onready var red = $Red

var can_build = null

func _ready():
	if GlobalInformation.building_preview_hidden == true:
		visible = false
	else:
		visible = true

func _process(delta):
	# snaps building to grid
	if int(position.x) % 16 == 0:
		pass
	elif int(position.x) == 0:
		pass
	else:
		var x = int(position.x) % 16
		position.x -= x
	if int(position.y) % 16 == 0:
		pass
	elif int(position.y) == 0:
		pass
		print(position)
	else:
		var y = int(position.y) % 16
		position.y -= y
	
	if can_build == true:
		green.visible = true
		red.visible = false
		GlobalInformation.can_build = true
	else:
		green.visible = false
		red.visible = true
		GlobalInformation.can_build = false
	
	if GlobalInformation.building_preview_hidden == true:
		visible = false
	else:
		visible = true




func _on_Area2D_body_entered(body):
	if body.is_in_group("obstacle") or body.is_in_group("Unit"):
		can_build = false


func _on_Area2D_body_exited(body):
	if body.is_in_group("obstacle") or body.is_in_group("Unit"):
		can_build = true
