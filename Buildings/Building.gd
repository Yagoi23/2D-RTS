extends Node2D
class_name Building

var prod_resource : int = 0
var prod_resource_ammount : int

var upkeep_resource : int = 0
var upkeep_resource_amount : int

func _ready():
	pass

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


