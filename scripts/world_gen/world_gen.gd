extends Node2D


@export var noise_image : NoiseTexture2D
@export var cave_text : NoiseTexture2D
@export var ore_text : NoiseTexture2D

@onready var tile_map = $TileMap

var width : int = 1000
var height: int = 100

var dirt_grass_atlas = Vector2(0,0)
var dirt_atlas = Vector2(1,0)
var left_ramp = Vector2(2,0)
var right_ramp = Vector2(3,0)
var tile_arr = []

var ore_arr = []
var black_tile = Vector2(4,0)
var white_tile = Vector2(5,0)
var front_layer = 1
var back_layer = 0

func build_cells(width: int, height: int) -> Dictionary:
	var noise : FastNoiseLite = noise_image.noise
	var noise_height 
	var cave_noise : FastNoiseLite = cave_text.noise
	var ore_noise : FastNoiseLite = ore_text.noise

	var x = 0
	var y = 0
	var map_tiles = width * height

	for tile in (map_tiles):
		noise_height = int(noise.get_noise_1d(x) * 10)

		#setting background dirt tiles
		if y > 5:
			tile_map.set_cell(back_layer,Vector2(x, noise_height+y), 0,Vector2(6, 0))

		if cave_noise.get_noise_2d(x,y) < 0.4:
			if (ore_noise.get_noise_2d(x,y) > 0.6) and y > 20:
				ore_arr.append(Vector2(x,y))
			else:
				tile_arr.append(Vector2(x, noise_height+y))

		y += 1
		
		#Done column, move row
		if y > height:
			#top layer of the terrain
			if tile_arr.find(Vector2(x, noise_height+1)) != -1:
				tile_arr.append(Vector2(x, noise_height))
				var rand_num = randi_range(0,20)
				if rand_num == 1:
					tile_map.set_cell(front_layer, Vector2(x, noise_height-1),1, Vector2(0,0))
			y = 0
			x += 1
		
		#All rows completed, thus done
		if x > width:
			break;

	return {"tile_arr" = tile_arr, "ore_arr" = ore_arr}

func _ready():
	var cells = build_cells(width, height)
	fill_in_map(cells.tile_arr, cells.ore_arr)

func fill_in_map(tile_arr: Array, ore_arr: Array) -> void:
	BetterTerrain.set_cells(tile_map, front_layer,tile_arr, 0)
	BetterTerrain.set_cells(tile_map, front_layer,ore_arr, 1)
	BetterTerrain.update_terrain_cells(tile_map, front_layer, (tile_arr + ore_arr), false)


