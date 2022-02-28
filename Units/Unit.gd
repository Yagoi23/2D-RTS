extends KinematicBody2D


var selected
onready var SelectedIcon = $SelectedIcon
#onready var sprite = $ColorRect

func _ready():
	selected = false
	SelectedIcon.visible = false
	#sprite.color = Color(0,0,0)

func select():
	selected = true
	SelectedIcon.visible = true
	#sprite.color = Color(30,150,60)

func deselect():
	selected = false
	SelectedIcon.visible = false
	#sprite.color = Color(0,0,0)
