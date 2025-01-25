extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -600.0
const SLIDE_SPEED = 1200.0
const SLIDE_DURATION = 0.5
const SHOOT_DURATION = 0.3
const RELOAD_DURATION = 0.3
const SLIDE_GRAVITY = 1500.0

var double_jumps_left = 1
var is_double_jumping = false
var bullets_left = 6
var face_right = true
var should_be_facing_right = true
var legs_face_right = true
var speed = SPEED
var sliding = false
var slide_timer = 0.0
var shooting = false
var shoot_timer = 0.0
var reloading = false
var reload_timer = 0.0

@onready var upper_body = $UpperBody
@onready var upper_body_sprite = $UpperBody/UpperBodySprite
@onready var lower_body_sprite = $LowerBodySprite
@onready var lower_body_collision_shape = $LowerBodyCollisionShape
@onready var reticle = $Reticle
@onready var HUD_bullet_left = $HUD/MarginContainer/HBoxContainer/VBoxContainer/bullet_Left
@onready var label_state_ammo = $reload_message
@onready var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(delta):
	# Handle reticle
	face_right = reticle.global_position.x > global_position.x
	if face_right:
		upper_body.scale.x = abs(upper_body.scale.x)
		var angle_to_reticle = (reticle.global_position - global_position).angle()
		upper_body.rotation = angle_to_reticle
	else:
		upper_body.scale.x = -abs(upper_body.scale.x)
		var angle_to_reticle = (reticle.global_position - global_position).angle()
		upper_body.rotation = angle_to_reticle + deg_to_rad(180)
		
	# Handle shoot.
	if shooting:
		shoot_timer -= delta
		if shoot_timer <= 0:
			shooting = false
		else:
			if upper_body_sprite.animation == "shoot" and upper_body_sprite.frame == 0:
				HUD_bullet_left.set_text(str(bullets_left))
				shoot_bullet()
				
	# Handle reload.
	if reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			HUD_bullet_left.set_text(str(bullets_left))
			reloading = false

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
	else:
		double_jumps_left = 1
		is_double_jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			lower_body_sprite.play("jump")
			velocity.y = JUMP_VELOCITY
		elif double_jumps_left > 0:
			upper_body_sprite.play("bubble_jump")
			lower_body_sprite.play("double_jump")
			velocity.y = JUMP_VELOCITY
			double_jumps_left -= 1
			is_double_jumping = true

	# Handle movement.
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * speed
		lower_body_sprite.flip_h = false
		legs_face_right = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * speed
		lower_body_sprite.flip_h = true
		legs_face_right = false
		
	# Trigger shoot.
	if Input.is_action_just_pressed("shoot_bullet"):
		if bullets_left > 0:
			shooting = true
			shoot_timer = SHOOT_DURATION
			upper_body_sprite.play("shoot")
			bullets_left -= 1
			move_and_slide()
			if bullets_left <= 1:
				display_state_ammo("RELOAD" , true)
			return
			
	# Trigger reload.
	if Input.is_action_just_pressed("reload"):
		bullets_left = 6
		reloading = true
		reload_timer = RELOAD_DURATION
		upper_body_sprite.play("reload")
		move_and_slide()
		display_state_ammo("OK!!!" , false)
		return
		
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
	if not is_on_floor() and not is_double_jumping:
		lower_body_sprite.play("jump")
	elif velocity.x == 0 and is_on_floor():
		if shooting:
			upper_body_sprite.play("shoot")
		elif reloading:
			upper_body_sprite.play("reload")
		else:
			upper_body_sprite.play("idle")
		lower_body_sprite.play("idle")
	elif velocity.x != 0 and is_on_floor():
		if shooting:
			upper_body_sprite.play("shoot")
		elif reloading:
			upper_body_sprite.play("reload")
		else:
			upper_body_sprite.play("default")
		lower_body_sprite.play("run")

	move_and_slide()

# Create and shoot a bullet
func shoot_bullet():
	var bullet = bullet.instantiate()
	var bullet_direction = upper_body.rotation
	if not face_right:
		bullet_direction += deg_to_rad(180)
	bullet.dir = bullet_direction
	bullet.pos = $UpperBody/Muzzle.global_position
	bullet.rot = $UpperBody/Muzzle.global_rotation 
	get_tree().current_scene.add_child(bullet)

func display_state_ammo(message:String , display:bool):
	if display == true:
		label_state_ammo.set_text(message)
		label_state_ammo.set_visible(true)
	else:
		label_state_ammo.set_text("OK!!!")
		await get_tree().create_timer(0.5).timeout
		label_state_ammo.set_visible(false)



		
	
