extends Control

onready var MultiplayerConfigUi = $MultiplayerConfig
onready var ServerIPAdressBar = $MultiplayerConfig/LineEdit
#onready var ChatEnterBar = $InServerControl/LineEdit
#onready var ChatText = $InServerControl/Label

onready var StartGame = $Start_Game

onready var UserList = $User_List

onready var DeviceIPAdress = $CanvasLayer/DeviceIPAdress
onready var ChatVisual = $Chat
#var playerID = null
onready var Name = $Name/LineEdit

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	DeviceIPAdress.text = Network.ip_adress

func _process(delta):
	Network.PlayerID = "["+Name.text+"]"
	UserList.text = str(Network.user_list)

func _player_connected(id) -> void:
	print("Player "+str(id)+" has connected")
	#playerID = id
	
func _player_disconnected(id) -> void:
	print("Player "+str(id)+" has disconnected")

func _on_Create_Server_pressed():
	Network.user_name = Name.text
	MultiplayerConfigUi.hide()
	Name.hide()
	Network.create_server()
	ChatVisual.show()
	if get_tree().has_network_peer():
		if is_network_master():
			StartGame.show()

func _on_Join_Server_pressed():
	if ServerIPAdressBar.text != "":
		MultiplayerConfigUi.hide()
		Name.hide()
		Network.ip_adress = ServerIPAdressBar.text
		Network.join_server()
		ChatVisual.show()

remote func _start_game() -> void:
	get_tree().change_scene("res://Multiplayer/Game.tscn")

func _startgame() -> void:
	get_tree().change_scene("res://Multiplayer/Game.tscn")


func _on_Start_Game_pressed():
	rpc_unreliable("_start_game")
	_startgame()
	#pass # Replace with function body.
