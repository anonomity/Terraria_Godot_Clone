extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
@onready var weapon_sprite = $Node2D2/Node2D/Sprite2D
@export var tile_map  : TileMap
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const sword = preload("res://assets/Item_3490.png")

const pickaxe = preload("res://assets/Item_3491.png")

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var animation_player_2 = $AnimationPlayer2

@onready var node_2d_2 = $Node2D2
var dirt_atlas = Vector2(1,0)
var front_layer = 1
var back_layer = 0

enum TOOL_TYPE {SWORD, PICKAXE, DIRT, NONE}
var current_tool = TOOL_TYPE.SWORD
var trigger_mouse_button = [];

func _ready():
	EventBus.have_sword.connect(on_sword_connect)
	EventBus.have_pickaxe.connect(on_pickaxe_connect)
	EventBus.have_dirt.connect(on_dirt_connect)
	current_tool = TOOL_TYPE.SWORD
	

func _physics_process(delta):
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction >= 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		animation_player.play("run")
	else:
		animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("click"):
		animation_player_2.play("chop")
		var mouse = get_global_mouse_position()
		if mouse.x > global_position.x:
			node_2d_2.scale.x = 1
		else:
			node_2d_2.scale.x = -1
	if Input.is_action_just_released("click"):
		animation_player_2.play("idle")

	# Add the gravity.
	if not is_on_floor():
		animation_player.play("jump")
		velocity.y += gravity * delta
	move_and_slide()

func on_sword_connect():
	weapon_sprite.texture = sword
	current_tool = TOOL_TYPE.SWORD
	
func on_pickaxe_connect():
	weapon_sprite.texture = pickaxe
	current_tool = TOOL_TYPE.PICKAXE

func on_dirt_connect():
	weapon_sprite.texture = null
	current_tool = TOOL_TYPE.DIRT

func _input(event):
	var mouse_pos = get_global_mouse_position()
	var tile_pos = tile_map.local_to_map(mouse_pos)
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			trigger_mouse_button.append(event.button_index)
		else:
			trigger_mouse_button.erase(event.button_index)

	if trigger_mouse_button.has(MOUSE_BUTTON_LEFT) and current_tool == TOOL_TYPE.PICKAXE:
		
		if distance_action_allowed(mouse_pos, tile_pos):
			if BetterTerrain.get_cell(tile_map, front_layer, tile_pos) != BetterTerrain.TileCategory.ERROR:
				tile_map.erase_cell(front_layer, tile_pos)
				#tile_arr.erase(tile_pos)
				BetterTerrain.update_terrain_cell(tile_map, front_layer,tile_pos,true)

	if trigger_mouse_button.has(MOUSE_BUTTON_RIGHT) and current_tool == TOOL_TYPE.DIRT:
		if distance_action_allowed(mouse_pos, tile_pos):
			tile_map.set_cell(front_layer, tile_pos, 0,dirt_atlas)

func distance_action_allowed(mouse_pos, tile_pos, max_distance = 100) -> bool:
	var mouse_distance = mouse_pos.distance_to(Vector2(global_position.x, global_position.y))
	
	if mouse_distance <= max_distance:
		return true;
	
	return false;
