extends Node2D
class_name Building

export var unit_owner := 0
var health = 1
onready var collision_shape = $CollisionShape2D

var aligned_to_grid_x = null
var aligned_to_grid_y = null

func _ready():
	aligned_to_grid_x = false
	aligned_to_grid_y = false

func _process(delta):
	# snaps building to grid
	if aligned_to_grid_x != true:
		print("not x")
		if int(position.x) % 16 == 0:
			aligned_to_grid_x = true
		elif int(position.x) == 0:
			aligned_to_grid_x = true
		else:
			var x = int(position.x) % 16
			position.x -= x
	if aligned_to_grid_y != true:
		print("not y")
		if int(position.y) % 16 == 0:
			aligned_to_grid_y = true
		elif int(position.y) == 0:
			aligned_to_grid_y = true
			#print(position)
		else:
			var y = int(position.y) % 16
			position.y -= y
	#if aligned_to_grid_x == true and aligned_to_grid_y == true:
		#print("aligned")

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
		
