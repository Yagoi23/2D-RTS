extends Node

var files = []
var building_sprites = []


var BuildingData = {
	LivingCapacity = null,
	GenerateResource = null,
	ResourceAmmount = null
}

var LoadPath = "res://Buildings/Buildings/"

func _ready():
	_load_buildings()
	#pass # Replace with function body.

func _load_buildings():
	list_files_in_directory(LoadPath)
	_sort_files(files)
	_compare_extension()
	

func list_files_in_directory(path):
	files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	print(files)

	#return files

func _sort_files(files):
	print("sorting1")
	if files.size() > 0:
		print("....")
		files.sort_custom(self, "_compare_extension")
		return files[0]
	else:
		return null

func _compare_extension():
	print("sorting2")
	if files[0].get_extension() == "png":
		building_sprites.append(files[0])
		return true
	else:
		return false
