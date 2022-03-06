extends StateMachine

func _ready():
	add_state("idle")
	add_state("moving")
	add_state("engaging")
	add_state("attacking")
	add_state("dying")
	call_deferred("set_state", states.idle)

#func _input(event):
#	var refrence_player_state = null
#	var refrence_player_current_state = null
#	refrence_player_state = get_parent().get_node("Player").STATE
#	refrence_player_current_state = get_parent().get_node("Player").state
#	if parent.selected and state != states.dying and refrence_player_state != refrence_player_current_state.state.COMMAND:
#		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
#			parent.movement_target = event.position
#			set_state(states.moving)

func _state_logic(delta):
	match state:
		states.idle:
			pass
		states.moving:
			parent.move_to_target(delta, parent.movement_target)
		states.engaging:
			pass
		states.attacking:
			pass
		states.dying:
			pass



func _on_MoveTimer_timeout():
	if parent.get_slide_count():
		if parent.last_position.distance_to(parent.movement_target) < parent.position.distance_to(parent.movement_target) + parent.move_threshold:
			parent.movement_target = parent.position
			set_state(states.idle)
