extends Control

onready var BottomMenu = $BottomMenu
onready var arrowButton = $BottomMenu/ArrowButton
var arrowButton_position = null
var Bottom_Menu_up = true
onready var buttonArrowIcon = $BottomMenu/ArrowButton/ColorRect2/ColorRect3/ArrowIcon
onready var building_menu = $BottomMenu/BuildingSelectionMenu

func _ready():
	Bottom_Menu_up = true

func _process(delta):
	if GlobalInformation.building_preview_hidden == true:
		building_menu.visible = false
	else:
		building_menu.visible = true
	if Bottom_Menu_up == true:
		BottomMenu.position.y = 0
	else:
		BottomMenu.position.y = 86
	#if GlobalInformation.player_state == "build":
	#	building_menu_visible = true
	#else:
	#	building_menu_visible = false

func _on_ArrowButton_pressed():
	#print("pressed")
	if Bottom_Menu_up == true:
		Bottom_Menu_up = false
		buttonArrowIcon.flip_v = true
	else:
		Bottom_Menu_up = true
		buttonArrowIcon.flip_v = false
		
