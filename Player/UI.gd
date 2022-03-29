extends Control

onready var BottomMenu = $BottomMenu
onready var arrowButton = $BottomMenu/ArrowButton
var arrowButton_position = null
var Bottom_Menu_up = true

func _ready():
	Bottom_Menu_up = true

func _process(delta):
	if Bottom_Menu_up == true:
		BottomMenu.rect_position.y = 0
	else:
		BottomMenu.rect_position.y = 32
	

func _on_ArrowButton_pressed():
	print("pressed")
	if Bottom_Menu_up == true:
		Bottom_Menu_up = false
	else:
		Bottom_Menu_up = true
