extends Node2D
class_name Pathfinding

var astar = AStar2D.new()
var tilemap: TileMap
var half_cell_size: Vector2
var used_rect: Rect2

func create_navigation_map(tilemap: TileMap):
	self.tilemap = tilemap
	half_cell_size = tilemap.cell_size / 2
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	add_traversible_tiles(tiles)
	connect_traversible_tiles(tiles)


func add_traversible_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)
		#print("tile added")

func  connect_traversible_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		
		for x in range(3):
			for y in range(3):
				var target_tile = tile + Vector2(x - 1, y - 1)
				var target_id = get_id_for_point(target_tile)
				if tile == target_tile or not astar.has_point(target_id):
					continue
				astar.connect_points(id, target_id, true)
				#print("tile connected")

func get_id_for_point(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x
