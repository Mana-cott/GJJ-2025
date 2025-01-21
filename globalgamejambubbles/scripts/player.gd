extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var double_jumps_left = 1
var face_right = true
var look_position = Vector2.ZERO
@onready var upper_body = $UpperBody
@onready var upper_body_sprite = $UpperBody/UpperBodySprite
@onready var lower_body_sprite = $LowerBodySprite
@onready var lower_body_collision_shape = $LowerBodyCollisionShape

func _physics_process(delta):
	if Global.look_mode == "mouse":
		look_position = get_global_mouse_position()
		# Look at mouse (if mouse mode toggled)
		upper_body.look_at(look_position)#clamp(look_position, Vector2(0, 180), Vector2(180, 0)))
		if look_position.x > -1:
			upper_body.position.x *= -1
			upper_body_sprite.flip_h = false
		elif look_position.x < 1:
			upper_body.position.x *= 1
			upper_body_sprite.flip_h = true
	else:
		if face_right:
			upper_body_sprite.flip_h = false
		else:
			upper_body_sprite.flip_h = true
		if Input.is_action_pressed("look_up"):
			if face_right:
				upper_body.rotate(-0.05)
			else:
				upper_body.rotate(0.05)
		elif Input.is_action_pressed("look_down"):
			if face_right:
				upper_body.rotate(0.05)
			else:
				upper_body.rotate(-0.05)
		elif Input.is_action_pressed("look_left"):
			face_right = false
		elif Input.is_action_pressed("look_right"):
			face_right = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		lower_body_sprite.play("freefall")
	else:
		double_jumps_left = 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or double_jumps_left >=0):
		velocity.y = JUMP_VELOCITY
		double_jumps_left = double_jumps_left - 1
		print(double_jumps_left)

	# Reset horizontal velocity
	velocity.x = 0
	# Handle movement
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * SPEED
		lower_body_sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * SPEED
		lower_body_sprite.flip_h = true
		
	if velocity.x == 0 and is_on_floor():
		lower_body_sprite.play("idle")
	elif velocity.x != 0 and is_on_floor():
		lower_body_sprite.play("run")

	move_and_slide()
