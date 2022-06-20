extends Control

onready var message = $LineEdit#.text
onready var history = $Label#.text
var Name = null

func _process(delta):
	#if(Input.is_action_just_pressed("return_key")):
		#Check it's not an empty space, if it isn't, then sendmessage
	Name = str(Network.PlayerID)

remote func send_chat(txt):
	history.text = ""
	#history.bbcode_text += "[color=ffdd33]"#"[color=#ffffff]"#+str(Network.PlayerID)+" "
	history.bbcode_text = txt 
	#history.bbcode_text += "\n"
	pass

func create_message() -> String:
	#var newMessage = Label
	history.text = ""
	history.bbcode_text += str(Network.PlayerID)+" "#"[color=#ff8400]"+str(Network.PlayerID)+" "
	history.bbcode_text += message.text 
	history.bbcode_text += "\n"
	return history.text

func create_message_to_send() -> String:
	#history.bbcode_text += "[color=#ff8400]"+str(Network.PlayerID)+" "
	#history.bbcode_text += message.text 
	#history.bbcode_text += "\n"
	#return history.text
	return ""
	

func _on_SendChatButton_pressed():
	if(message.text != "\n"):
		#Create the message and tell everyone else to add it to their history
		rpc_unreliable("send_chat",create_message())
		#create_message()
		#history.push_color(Color.blue)
		#history.bbcode_text += create_message()
		
		message.text = ""
	else:
		message.text = ""
