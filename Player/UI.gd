extends Control

onready var BottomMenu = $BottomMenu
onready var arrowButton = $BottomMenu/ArrowButton
var arrowButton_position = null
var Bottom_Menu_up = true
onready var buttonArrowIcon = $BottomMenu/ArrowButton/ColorRect2/ColorRect3/ArrowIcon

func _ready():
	Bottom_Menu_up = true

func _process(delta):
	if Bottom_Menu_up == true:
		BottomMenu.position.y = 0
	else:
		BottomMenu.position.y = 86
	

func _on_ArrowButton_pressed():
	#print("pressed")
	if Bottom_Menu_up == true:
		Bottom_Menu_up = false
		buttonArrowIcon.flip_v = true
	else:
		Bottom_Menu_up = true
		buttonArrowIcon.flip_v = false
