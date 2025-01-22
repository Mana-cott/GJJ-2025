extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -600.0
const SLIDE_SPEED = 1200.0
const SLIDE_DURATION = 0.5
const SLIDE_GRAVITY = 1500.0

var double_jumps_left = 1
var face_right = true
var should_be_facing_right = true
var legs_face_right = true
var mouse_position = Vector2.ZERO
var speed = SPEED
var sliding = false
var slide_timer = 0.0

@onready var upper_body = $UpperBody
@onready var upper_body_sprite = $UpperBody/UpperBodySprite
@onready var lower_body_sprite = $LowerBodySprite
@onready var lower_body_collision_shape = $LowerBodyCollisionShape

@onready var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(delta):
	if Global.look_mode == "mouse":
		mouse_position = get_global_mouse_position()
		# Look at mouse (if mouse mode toggled)
		upper_body.look_at(mouse_position)
		# mouse facing left
		if mouse_position.x > -1:
			should_be_facing_right = false
		# mouse facing right
		elif mouse_position.x < 1:
			should_be_facing_right = true
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
			
	if Input.is_action_pressed("shoot_bullet"):
		shoot_bullet()

	# Handle Slide.
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			sliding = false
			lower_body_collision_shape.disabled = false
		else:
			velocity.y += SLIDE_GRAVITY * delta
			velocity.x = SLIDE_SPEED * (1 if legs_face_right else -1)
			move_and_slide()
			return

	# Handle gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		lower_body_sprite.play("freefall")
	else:
		double_jumps_left = 1

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif double_jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			double_jumps_left -= 1

	# Handle movement
	velocity.x = 0
	if Input.is_action_pressed("sprint") and is_on_floor():
		speed = 1000.0
		lower_body_sprite.play("sprint")
	else:
		speed = SPEED 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * speed
		lower_body_sprite.flip_h = false
		legs_face_right = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * speed
		lower_body_sprite.flip_h = true
		legs_face_right = false
		
	# Trigger slide.
	if Input.is_action_just_pressed("crouch") and velocity.x != 0 and is_on_floor():
		sliding = true
		slide_timer = SLIDE_DURATION
		lower_body_collision_shape.disabled = true
		lower_body_sprite.play("slide")
		velocity.x = SLIDE_SPEED * (1 if face_right else -1)
		move_and_slide()
		return

	# Handle animations.
	if velocity.x == 0 and is_on_floor():
		lower_body_sprite.play("idle")
	elif velocity.x != 0 and is_on_floor():
		lower_body_sprite.play("run")

	move_and_slide()

# Create and shoot a bullet
func shoot_bullet():
	var bullet = bullet.instantiate()
	bullet.dir = upper_body.rotation
	bullet.pos = $UpperBody/Muzzle.global_position
	bullet.rot = $UpperBody/Muzzle.global_rotation
	get_tree().current_scene.add_child(bullet)
