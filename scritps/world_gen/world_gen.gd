extends Node2D


@export var noise_image : NoiseTexture2D
@onready var tile_map = $TileMap


var width : int = 1000
var height: int = 100

var dirt_grass_atlas = Vector2(0,0)
var dirt_atlas = Vector2(1,0)
var left_ramp = Vector2(2,0)
var right_ramp = Vector2(3,0)

var height_tile_arr = []
var dirt_fill_arr = []

func _ready():
	var noise : FastNoiseLite = noise_image.noise

	for x in width:
		
		
		var noise_height = int(noise.get_noise_1d(x) * 10)
		

	
		# filling in the first
		for y in height:
			dirt_fill_arr.append(Vector2(x, noise_height+y))
			
			

	
		height_tile_arr.append(Vector2(x, noise_height))
	

	#filling the height
	BetterTerrain.set_cells(tile_map, 0,height_tile_arr, 0)
	BetterTerrain.update_terrain_cells(tile_map, 0,height_tile_arr,true )
	
	# filling in the dirt
	BetterTerrain.set_cells(tile_map, 0,dirt_fill_arr, 0)
	BetterTerrain.update_terrain_cells(tile_map, 0,dirt_fill_arr,true )
