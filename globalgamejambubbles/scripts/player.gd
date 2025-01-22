extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -600.0

var double_jumps_left = 1
var face_right = true
var should_be_facing_right = true
var legs_face_right = true
var mouse_position = Vector2.ZERO
var speed = SPEED

@onready var upper_body = $UpperBody
@onready var upper_body_sprite = $UpperBody/UpperBodySprite
@onready var lower_body_sprite = $LowerBodySprite
@onready var lower_body_collision_shape = $LowerBodyCollisionShape
@export var Bullet: PackedScene

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
			
	if Input.is_action_just_pressed("shoot_bullet"):
		shoot_bullet()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		lower_body_sprite.play("freefall")
	else:
		double_jumps_left = 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or double_jumps_left >=0):
		double_jumps_left = double_jumps_left - 1
		velocity.y = JUMP_VELOCITY
		print(double_jumps_left)

	# Reset horizontal velocity
	velocity.x = 0
	# Handle movement
	if Input.is_action_pressed("sprint") and is_on_floor():
		speed = 800.0
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
		
	if velocity.x == 0 and is_on_floor():
		lower_body_sprite.play("idle")
	elif velocity.x != 0 and is_on_floor():
		lower_body_sprite.play("run")

	move_and_slide()

func shoot_bullet():
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.transform = $UpperBody/Muzzle.global_transform
