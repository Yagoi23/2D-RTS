extends Node

func _process(delta):
	if player_state == "build":
		building_preview_hidden = false
	else:
		building_preview_hidden = true

var player_state = null
var player_refrence_position = null
var movement_group = [1,2,3]
var building_preview_hidden = false
var can_build = null
