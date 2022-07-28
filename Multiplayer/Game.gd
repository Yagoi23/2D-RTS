extends Node2D

onready var pathfinding = $Pathfinding
onready var ground = $TileMap

func _ready():
	pathfinding.create_navigation_map(ground)
