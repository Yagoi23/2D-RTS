extends Node
#class Name NetworkVirtual

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 6

var server = null
var client = null

var user_list : Dictionary

var PlayerID = null
var user_name : String = "Unammed Player"

var ip_adress = ""
func _ready() -> void:
	ip_adress = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168"):
			print(ip_adress)
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	#if OS.get_name() == "Windows":
	#	ip_adress = IP.get_local_addresses()[3]

func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
	#PlayerID = ip_adress

func join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_adress, DEFAULT_PORT)
	get_tree().set_network_peer(client)
	#PlayerID = ip_adress

func _connected_to_server() -> void:
	print("succesfully connected")
	#rpc_unreliable("send_name",create_name())

func create_name() -> String:
	return str(PlayerID)

func _server_disconnected() -> void:
	print("server disconnected")

remote func update_user(user):
	user_list[str(user[0])] = user[1]
	emit_signal("update_user_list")
	rpc_unreliable("client_update",user_list)
	pass
	
remote func client_update(update_user_list):
	user_list = update_user_list
	emit_signal("update_user_list")
