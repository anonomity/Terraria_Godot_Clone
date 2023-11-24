extends Node2D


@export var noise_image : NoiseTexture2D
@onready var tile_map = $TileMap


var width : int = 1000
var height: int = 100

var dirt_grass_atlas = Vector2(0,0)
var dirt_atlas = Vector2(1,0)
var left_ramp = Vector2(2,0)
var right_ramp = Vector2(3,0)
var tile_arr = []
func _ready():
	var noise : FastNoiseLite = noise_image.noise

	for x in (width):
		
		
		var noise_height = int(noise.get_noise_1d(x) * 10)
		
		# filling in the first
		for y in height:
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
