extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sprite = preload("res://Buildings/BuildingUISprite.tscn")
#var newNode = Sprite.new()
#var scene = 
# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("UI/BuildingSelectionMenu/Control/ScrollContainer/VBoxContainer").
	#sprite.position = Vector2(32,32)
	var i = LoadBuildings.txt_files.size()
	self.rect_size.y = (128 * i)
	if self.rect_size.y < 256:
		self.rect_size.y = 256
	print(self.rect_size)
	print(i)
	while i > 0:
		
		var newNode = sprite.instance()
		add_child(newNode)
		newNode.position = Vector2(32,(64*(i-1))+32)
		i -= 1
	#sprite.set_owner(get_parent())
	#sprite.texture = load("res://Buildings/Buildings/House1")
	#newNode.position.x = 32
	#newNode.position.y = 32
	#print(newNode.position)
	#pass # Replace with function body.
