extends Control

onready var message = $LineEdit#.text
onready var history = $Label#.text

func _process(delta):
	#if(Input.is_action_just_pressed("return_key")):
		#Check it's not an empty space, if it isn't, then sendmessage
	pass

remote func send_chat(txt):
	history.bbcode_text += txt
	history.bbcode_text += ""

func create_message() -> String:
	return message.text 


func _on_SendChatButton_pressed():
	if(message.text != "\n"):
		#Create the message and tell everyone else to add it to their history
		rpc_unreliable("send_chat",create_message())
		history.bbcode_text += create_message()
		message.text = ""
	else:
		message.text = ""
