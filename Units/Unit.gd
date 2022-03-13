extends KinematicBody2D
class_name Unit

export var unit_owner := 0

var selected
var movement_target = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 60
var target_max = 1

var movement_group = []
onready var player = get_node("/root/player")

onready var SelectedIcon = $SelectedIcon

#var slide_count
const move_threshold = 1.5
var last_position = Vector2.ZERO
#var major_target = Vector2.ZERO
#var last_distance_to_target = Vector2.ZERO
#var current_distance_to_target = Vector2.ZERO

var nav_path : PoolVector2Array
#onready var nav2d = get_node("/root/Level/Navigation2D")
onready var pathfinding = get_node("/root/Level/Pathfinding")
var leg_reset_threshold = 10

var current_leg = Vector2.ZERO

#attacking
var possible_targets = []
var attack_range = 15
var health = 25
var damage = 5
var attack_target = null
onready var state_machine = $UnitStateMachine
onready var collision_shape = $CollisionShape2D

onready var MoveTimer = $MoveTimer
onready var AttackTimer = $AttackTimer
onready var sprite = $ColorRect

onready var rays = $Rays
onready var ray_front = $Rays/RayFront

func _ready():
	selected = false
	SelectedIcon.visible = false
	movement_target = position
	if unit_owner == 1:
		sprite.color = Color(255,255,255)

#func _physics_process(delta):
#	if unit_owner == 1:
#		$ColorRect.color = Color(255,255,255)
#	velocity = Vector2.ZERO
#	if position.distance_to(target) > target_max:
#		velocity = position.direction_to(target) * speed
#	velocity = move_and_slide(velocity)
#	if get_slide_count() and MoveTimer.is_stopped():
#		last_position = position

func set_target(target):
	MoveTimer.stop()
	movement_group = GlobalInformation.movement_group
	print(target)
	nav_path = pathfinding.get_new_path(self.global_position, target)
	#nav_path = nav2d.get_simple_path(self.global_position, target)
	movement_target = target

func recalculate_path():
	pass
	#nav_path = nav2d.get_simple_path(self.global_position, movement_target)

func move_along_path(delta):
	if nav_path.size() > 0:
		var distance_to_next_point = position.distance_to(nav_path[0])
		current_leg = nav_path[0]
		if distance_to_next_point < leg_reset_threshold:
			nav_path.remove(0)
			if nav_path.size() != 0:
				current_leg = nav_path[0]
				velocity = position.direction_to(nav_path[0]) * speed
				#move_and_slide(velocity)
				move_with_avoidance(nav_path[0])
		else:
			velocity = position.direction_to(nav_path[0]) * speed
			#move_and_slide(velocity)
			move_with_avoidance(nav_path[0])
	colliders_reached_target()


func colliders_reached_target():
	if MoveTimer.is_stopped():
		for i in get_slide_count():
			var collider = get_slide_collision(i).collider
			for unit in movement_group:
				if unit.get_ref():
					if unit.get_ref() == collider:
						if collider.reached_target():
							MoveTimer.start()

func reached_target() -> bool:
	return movement_target == position

func move_to_target(delta, tar):
	velocity = Vector2.ZERO
	velocity = position.direction_to(tar) * speed
	velocity = move_and_slide(velocity)
	#if get_slide_count() and MoveTimer.is_stopped():
	#	last_position = position

func move_to(tar):
	movement_target = tar

func select():
	selected = true
	SelectedIcon.visible = true

func deselect():
	selected = false
	SelectedIcon.visible = false

func move_with_avoidance(tar):
	rays.rotation = velocity.angle()
	if _obstacle_ahead():
		var viable_ray = _get_viable_ray()
		if viable_ray:
			velocity = Vector2.RIGHT.rotated(rays.rotation + viable_ray.rotation) * speed
	move_and_slide(velocity)

func _obstacle_ahead() -> bool:
	return ray_front.is_colliding()

func _get_viable_ray() -> RayCast2D:
	for ray in rays.get_children():
		if !ray.is_colliding():
			return ray
	return null
#func _on_MoveTimer_timeout():
#	if get_slide_count():
#		if last_position.distance_to(target) < position.distance_to(target) + move_threshold:
#			target = position


func _on_VisionRange_body_entered(body):
	if body.is_in_group("Unit"):
		if body.unit_owner != unit_owner:
			possible_targets.append(body)

func _on_VisionRange_body_exited(body):
	if possible_targets.has(body):
		possible_targets.erase(body)

func _compare_distance(target_a, target_b):
	if position.distance_to(target_a.position) < position.distance_to(target_b.position):
		return true
	else:
		return false

func closest_enemy() -> Unit:
	if possible_targets.size() > 0:
		possible_targets.sort_custom(self, "_compare_distance")
		return possible_targets[0]
	else:
		return null

func closest_enemy_within_range() -> Unit:
	if closest_enemy():
		if closest_enemy().position.distance_to(position) < attack_range:
			return closest_enemy()
		else:
			return null
	else:
		return null
		
func target_within_range() -> bool:
	if attack_target.get_ref().position.distance_to(position) < attack_range:
		return true
	else:
		return false


func take_damage(amount) -> bool:
	health -= amount
	if health <= 0:
		state_machine.died()
		collision_shape.disabled = true
		return false
	else:
		return true


func get_state():
	return state_machine.state

#func is_dying() -> bool:
#	return state_machine.state == state_machine.states.dying
