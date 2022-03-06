extends Node
class_name StateMachine

var state = null
var prev_state = null
var states = {}

onready var parent = get_parent()

func add_state(state_name):
	states[state_name] = states.size()

func set_state(new_state):
	prev_state = state
	state = new_state
	if prev_state != null:
		exit_state(prev_state, new_state)
	if new_state != null:
		enter_state(new_state, prev_state)

func exit_state(prev_state, new_state):
	pass

func enter_state(new_state, prev_state):
	pass

func _physics_process(delta):
	if state != null:
		_state_logic(delta) 
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

func _state_logic(delta):
	pass

func _get_transition(delta):
	pass
