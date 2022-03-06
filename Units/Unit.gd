extends KinematicBody2D

export var unit_owner := 0

var selected
var movement_target = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 60
var target_max = 1

onready var SelectedIcon = $SelectedIcon

#var slide_count
const move_threshold = 1.5
var last_position = Vector2.ZERO
#var major_target = Vector2.ZERO
#var last_distance_to_target = Vector2.ZERO
#var current_distance_to_target = Vector2.ZERO

onready var MoveTimer = $MoveTimer

func _ready():
	selected = false
	SelectedIcon.visible = false
	movement_target = position
	if unit_owner == 1:
		$ColorRect.color = Color(255,255,255)

#func _physics_process(delta):
#	if unit_owner == 1:
#		$ColorRect.color = Color(255,255,255)
#	velocity = Vector2.ZERO
#	if position.distance_to(target) > target_max:
#		velocity = position.direction_to(target) * speed
#	velocity = move_and_slide(velocity)
#	if get_slide_count() and MoveTimer.is_stopped():
#		last_position = position

func move_to_target(delta, tar):
	velocity = Vector2.ZERO
	velocity = position.direction_to(tar) * speed
	velocity = move_and_slide(velocity)
	if get_slide_count() and MoveTimer.is_stopped():
		last_position = position

func move_to(tar):
	movement_target = tar

func select():
	selected = true
	SelectedIcon.visible = true

func deselect():
	selected = false
	SelectedIcon.visible = false


#func _on_MoveTimer_timeout():
#	if get_slide_count():
#		if last_position.distance_to(target) < position.distance_to(target) + move_threshold:
#			target = position
