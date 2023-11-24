extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var animation_player_2 = $AnimationPlayer2


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
	if Input.is_action_just_released("click"):
		animation_player_2.play("idle")

	# Add the gravity.
	if not is_on_floor():
		animation_player.play("jump")
		velocity.y += gravity * delta
	move_and_slide()
