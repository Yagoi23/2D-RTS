extends KinematicBody2D


var selected
onready var SelectedIcon = $SelectedIcon

func _ready():
	selected = false
	SelectedIcon.visible = false

func select():
	selected = true
	SelectedIcon.visible = true

func deselect():
	selected = false
	SelectedIcon.visible = false
