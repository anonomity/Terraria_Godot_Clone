extends Node2D


@export var noise_image : NoiseTexture2D
@export var cave_text : NoiseTexture2D

@onready var tile_map = $TileMap


var width : int = 1000
var height: int = 100

var dirt_grass_atlas = Vector2(0,0)
var dirt_atlas = Vector2(1,0)
var left_ramp = Vector2(2,0)
var right_ramp = Vector2(3,0)
var tile_arr = []


var black_tile = Vector2(4,0)
var white_tile = Vector2(5,0)

func _ready():
	var noise : FastNoiseLite = noise_image.noise
	var noise_height 
	var cave_noise : FastNoiseLite = cave_text.noise
	for x in (width):
		
		
		noise_height = int(noise.get_noise_1d(x) * 10)
		
		# filling in the first
		for y in height:
			
			
			#if y > 50:
				#print(cave_noise.get_noise_2d(x,y))
			if cave_noise.get_noise_2d(x,y) < 0.4:
				tile_arr.append(Vector2(x, noise_height+y))
			
			
		tile_arr.append(Vector2(x, noise_height))



	BetterTerrain.set_cells(tile_map, 0,tile_arr, 0)
	BetterTerrain.update_terrain_cells(tile_map, 0,tile_arr,true )

func _input(event):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(mouse_pos)
		var index = BetterTerrain.get_cell(tile_map, 0, tile_pos)
		if index != -1:
			tile_map.erase_cell(0, tile_pos)
			#tile_arr.erase(tile_pos)
			BetterTerrain.update_terrain_cell(tile_map, 0,tile_pos,true )
	if Input.is_action_just_pressed("right_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(mouse_pos)
		tile_map.set_cell(0, tile_pos, 0,dirt_atlas)
