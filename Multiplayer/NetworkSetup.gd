extends Control

onready var MultiplayerConfigUi = $MultiplayerConfig
onready var ServerIPAdressBar = $MultiplayerConfig/LineEdit

onready var DeviceIPAdress = $CanvasLayer/DeviceIPAdress

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	DeviceIPAdress.text = Network.ip_adress

func _player_connected(id) -> void:
	print("Player "+str(id)+" has connected")

func _player_disconnected(id) -> void:
	print("Player "+str(id)+" has disconnected")

func _on_Create_Server_pressed():
	MultiplayerConfigUi.hide()
	Network.create_server()

func _on_Join_Server_pressed():
	if ServerIPAdressBar.text != "":
		MultiplayerConfigUi.hide()
		Network.ip_adress = ServerIPAdressBar.text
		Network.join_server()
