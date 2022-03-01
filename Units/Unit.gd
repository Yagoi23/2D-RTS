extends KinematicBody2D


var selected
var target = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 60
var target_max = 1

onready var SelectedIcon = $SelectedIcon

#var slide_count
const move_threshold = 0.025
var last_position = Vector2.ZERO
var major_target = Vector2.ZERO
#var last_distance_to_target = Vector2.ZERO
#var current_distance_to_target = Vector2.ZERO

onready var MoveTimer = $MoveTimer

func _ready():
	selected = false
	SelectedIcon.visible = false
	target = position

func _physics_process(delta):
	velocity = Vector2.ZERO
	if position.distance_to(target) > target_max:
		velocity = position.direction_to(target) * speed
	velocity = move_and_slide(velocity)
	if get_slide_count() and MoveTimer.is_stopped():
		MoveTimer.start()
		last_position = position
		#last_distance_to_target = position.distance_to(target)

func move_to(tar):
	target = tar
	#major_target = tar


#onready var sprite = $ColorRect

func select():
	selected = true
	SelectedIcon.visible = true
	#sprite.color = Color(30,150,60)

func deselect():
	selected = false
	SelectedIcon.visible = false
	#sprite.color = Color(0,0,0)


func _on_MoveTimer_timeout():
	if get_slide_count():
		if last_position.distance_to(target) < position.distance_to(target) + move_threshold:
			target = position
	#else:
		#target = major_target
		#current_distance_to_target = position.distance_to(target)
		#if last_distance_to_target < current_distance_to_target + move_threshold:
			#target = position
