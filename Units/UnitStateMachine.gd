extends StateMachine

enum Commands {
	NONE,
	MOVE,
	ATTACK_MOVE,
	HOLD
}
var command = Commands.NONE

enum CommandMods {
	NONE,
	ATTACK_MOVE
}
var command_mod = CommandMods.NONE

func _ready():
	add_state("idle")
	add_state("moving")
	add_state("engaging")
	add_state("attacking")
	add_state("dying")
	call_deferred("set_state", states.idle)

func _input(event):
	if parent.selected and state != states.dying and GlobalInformation.player_state == "command":
		command_mod = CommandMods.ATTACK_MOVE
		#if Input.is_action_just_pressed("attack_move"):
			#command_mod = CommandMods.ATTACK_MOVE
		if Input.is_action_just_pressed("hold"):
			command = Commands.HOLD
			set_state(states.idle)
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
			parent.set_target(event.position  + GlobalInformation.player_refrence_position)
			set_state(states.moving)
			match command_mod:
				CommandMods.NONE:
					command = Commands.MOVE
				CommandMods.ATTACK_MOVE:
					command = Commands.ATTACK_MOVE

func _state_logic(delta):
	match state:
		states.idle:
			pass
		states.moving:
			parent.move_along_path(delta)
		states.engaging:
			if parent.attack_target.get_ref():
				parent.move_to_target(delta, parent.attack_target.get_ref().position)
			else:
				set_state(states.idle)
		states.attacking:
			pass
		states.dying:
			parent.queue_free()

#func _get_transition(delta):
#	match state:
#		states.idle:
#			match command:
#				Commands.HOLD:
#					if parent.closest_enemy_within_range() != null:
#						parent.attack_target = weakref(parent.closest_enemy_within_range())
#						set_state(states.attacking)
#				Commands.ATTACK_MOVE:
#					set_state(states.moving)
#				Commands.NONE:
#					if parent.closest_enemy() != null:
#						parent.attack_target = weakref(parent.closest_enemy())
#						set_state(states.engaging)
#		states.moving:
#			if (command == Commands.ATTACK_MOVE):
#				if parent.closest_enemy() != null:
#					parent.attack_target = weakref(parent.closest_enemy())
#					set_state(states.engaging)
#			if parent.position.distance_to(parent.movement_target) < parent.target_max:
#				parent.movement_target = parent.position
#				set_state(states.idle)
#				command = Commands.NONE
#		states.engaging:
#			if parent.closest_enemy_within_range() != null:
#				parent.attack_target = weakref(parent.closest_enemy())
#				set_state(states.attacking)
#				parent.AttackTimer.start()
#		states.attacking:
#			if !parent.attack_target.get_ref():
#				set_state(states.idle)
#				parent.attack_target = null
#		states.dying:
#			parent.queue_free()

func _get_transition(delta):
	match state:
		states.idle:
			match command:
				Commands.HOLD:
					if parent.closest_enemy_within_range() != null:
						parent.attack_target = weakref(parent.closest_enemy_within_range())
						set_state(states.attacking)
				Commands.ATTACK_MOVE:
					#parent.recalculate_path()
					set_state(states.moving)
				Commands.NONE:
					if parent.closest_enemy() != null:
						parent.attack_target = weakref(parent.closest_enemy())
						set_state(states.engaging)
		states.moving:
			if (command == Commands.ATTACK_MOVE):
				if parent.closest_enemy() != null:
					parent.attack_target = weakref(parent.closest_enemy())
					set_state(states.engaging)
			if parent.position.distance_to(parent.movement_target) < parent.target_max:
				parent.movement_target = parent.position
				set_state(states.idle)
				command = Commands.NONE
				#print("reached target")
		states.engaging:
			if parent.closest_enemy_within_range() != null:
				parent.attack_target = weakref(parent.closest_enemy())
				set_state(states.attacking)
				parent.AttackTimer.start()
			#if parent.attack_target.get_ref().is_dying():
			#	set_state(states.idle)
			#	parent.attack_target = null
		states.attacking:
			pass
			#if parent.attack_target.get_ref().is_dying():
			#	set_state(states.idle)
			#	parent.attack_target = null
		states.dying:
			queue_free()

func _enter_state(new_state, old_state):
	#print(new_state)
	match state:
		states.idle:
			pass
		states.moving:
			pass
		states.engaging:
			pass
		states.attacking:
			pass
			#parent.AttackTimer.start()
		states.dying:
			parent.queue_free()

func _exit_state(old_state, new_state):
	match old_state:
		states.attacking:
			if new_state == states.idle:
				parent.attack_target = null
		states.moving:
			if new_state != states.moving and command != Commands.ATTACK_MOVE:
				parent.movement_target = parent.position

func died():
	set_state(states.dying)

func _on_MoveTimer_timeout():
	if state != states.dying:
		set_state(states.idle)
		parent.movement_target = parent.position
		#print("group reached target")


func _on_AttackTimer_timeout():
	#parent.sprite.color = Color(255,255,255)
	match state:
		states.attacking:
			if parent.attack_target.get_ref():
				if parent.attack_target.get_ref().take_damage(parent.damage):
					if parent.target_within_range():
						pass
					else:
						set_state(states.engaging)
				else:
					set_state(states.idle)
			else:
				set_state(states.idle)
		states.dying:
			parent.queue_free()
