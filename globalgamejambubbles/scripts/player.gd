extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var upper_body = $UpperBody

func _physics_process(delta):
	# Look at mouse (if mouse mode toggled)
	upper_body.look_at(get_global_mouse_position())
	print(get_global_mouse_position())
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Reset horizontal velocity
	velocity.x = 0
	# Handle movement
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * SPEED

	move_and_slide()
