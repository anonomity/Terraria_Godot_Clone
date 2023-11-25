extends CharacterBody2D


@export var player : CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var ow = $ow
@onready var death_sound = $death


var speed = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var health = 100

func _physics_process(delta):
	var direction
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player.global_position.x > global_position.x:
		direction = 1
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
		direction = -1
		
	velocity.x = direction * speed
	
	move_and_slide()






func _on_area_2d_area_entered(area):
	
	health -= 20
	if health <= 0:
		death()
	else:
		ow.play()

func death():
	death_sound.play()
	await get_tree().create_timer(0.4)
	queue_free()



