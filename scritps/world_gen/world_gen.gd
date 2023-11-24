extends Node2D


@export var noise_image : NoiseTexture2D
@onready var tile_map = $TileMap


var width : int = 10000
var height: int = 100

var dirt_grass_atlas = Vector2(0,0)
var dirt_atlas = Vector2(1,0)
var left_ramp = Vector2(2,0)
var right_ramp = Vector2(3,0)

func _ready():
	var noise : FastNoiseLite = noise_image.noise
	var past_height = null
	for x in width:
		
		
		var noise_height = int(noise.get_noise_1d(x) * 10)
		
		#
		#if (past_height != noise_height) and past_height != null:
			#if past_height > noise_height:
				#tile_map.set_cell(0, Vector2(x-1, noise_height), 0,right_ramp)
			#elif past_height < noise_height:
				#tile_map.set_cell(0, Vector2(x+1, noise_height), 0,left_ramp)
		past_height = noise_height
		# filling in the first
		for y in height:
			tile_map.set_cell(0, Vector2(x, noise_height+y), 0,dirt_atlas)
			
		tile_map.set_cell(0, Vector2(x, noise_height), 0,dirt_grass_atlas)
	

