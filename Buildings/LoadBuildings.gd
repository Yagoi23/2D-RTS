extends Node

var files = []
var building_sprites = []
var txt_files = []

var list_of_building = []


var BuildingData = {
	Name = null,
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
	print(building_sprites)
	print(txt_files)
	_add_building_to_list()
	

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
	print(files.size())
	#var x = files.size()
	while files.size() > 0:
		#x -= 1
		#print(x)
		if files[0].get_extension() == "png":
			building_sprites.append(files[0])
			files.erase(files[0])
		elif files[0].get_extension() == "txt":
			#print("found txt")
			txt_files.append(files[0])
			files.erase(files[0])
		else:
			files.erase(files[0])

func _add_building_to_list():
	#load_file(txt_files[0])
	var i = txt_files.size()
	#i -= 1
	while i > 0:
		load_file(txt_files[i-1])
		i -= 1

func load_file(file):
	var f = File.new()
	f.open(LoadPath+file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		line += " "
		#print(line + str(index))
		print(line)
		index += 1
	f.close()
	return
