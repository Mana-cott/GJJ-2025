extends CharacterBody2D

# Stats for Soda bubble
const STATS_SODA = {
	"HEALTH": 500,
	"SPEED": 1000, 
	"JUMP_VELOCITY": -600, 
	"SLIDE_SPEED": 1200, 
	"SLIDE_DURATION": 0.375, 
	"SLIDE_GRAVITY": 1500, 
	"SHOOT_COOLDOWN_DURATION": 0.1, 
	"SHOOT_ANIMATION_DURATION": 0.1, 
	"RELOAD_DURATION": 0.5,
	"MAX_AMMO": 20,
	"FULL_AUTO": true,
	"CHARGEABLE": false}

const BULLET_SODA = {
	"DAMAGE": 10,
	"RICOCHET": 1,
	"BULLET_DURATION": 0.5, 
	"BULLET_GRAVITY_MODIFIER": 0, 
	"BULLET_SPEED": 2000, 
	"BULLET_DECCEL_MODIFIER": 3500,
	"BULLET_INERTIA": 1,
	"BULLET_IFRAME_DURATION": 0.2,
	"FRAGILE_BOUNCE": true,
	"CAN_SHOOTER_BOUNCE": false}

# Stats for Soap bubble
const STATS_SOAP = {
	"HEALTH": 750,
	"SPEED": 800, 
	"JUMP_VELOCITY": -600, 
	"SLIDE_SPEED": 1200, 
	"SLIDE_DURATION": 0.375, 
	"SLIDE_GRAVITY": 1500, 
	"SHOOT_COOLDOWN_DURATION": 0.25, 
	"SHOOT_ANIMATION_DURATION": 0.3, 
	"RELOAD_DURATION": 0.5,
	"MAX_AMMO": 10,
	"FULL_AUTO": false,
	"CHARGEABLE": false}

const BULLET_SOAP = {
	"DAMAGE": 10,
	"RICOCHET": 3,
	"BULLET_DURATION": 8, 
	"BULLET_GRAVITY_MODIFIER": 0.5, 
	"BULLET_SPEED": 500, 
	"BULLET_DECCEL_MODIFIER": 200,
	"BULLET_INERTIA": 2,
	"BULLET_IFRAME_DURATION": 0.25,
	"FRAGILE_BOUNCE": false,
	"CAN_SHOOTER_BOUNCE": false}

# Stats for Gum bubble
const STATS_GUM = {
	"HEALTH": 1000,
	"SPEED": 600, 
	"JUMP_VELOCITY": -600, 
	"SLIDE_SPEED": 1200, 
	"SLIDE_DURATION": 0.375, 
	"SLIDE_GRAVITY": 1500, 
	"SHOOT_COOLDOWN_DURATION": 0.5, 
	"SHOOT_ANIMATION_DURATION": 0.2, 
	"RELOAD_DURATION": 0.5,
	"MAX_AMMO": 5,
	"FULL_AUTO": false,
	"CHARGEABLE": true}

const BULLET_GUM = {
	"DAMAGE": 10,
	"RICOCHET": 3,
	"BULLET_DURATION": 5, 
	"BULLET_GRAVITY_MODIFIER": 1.0, 
	"BULLET_SPEED": 250, 
	"BULLET_DECCEL_MODIFIER": 75,
	"BULLET_INERTIA": 4,
	"BULLET_IFRAME_DURATION": 0.25,
	"FRAGILE_BOUNCE": false,
	"CAN_SHOOTER_BOUNCE": true}

const COYOTE_LENIENCY = 0.2

var left_ground_counter = 0
var double_jumps_left = 1
var is_double_jumping = false
var bullets_left = 6
var face_right = true
var should_be_facing_right = true
var legs_face_right = true
var sliding = false
var slide_timer = 0.0
var shooting = false
var shoot_cooldown = 0
var shoot_animation_timer = 0.0
var reloading = false
var reload_timer = 0.0

# Local var for selected weapon type
var weapon_type = "soda"
# Local var for identifying which player character
var player_nb = 1
# Local dictionary var for selected weapon type stats
var player_stats = STATS_SODA
# Initial position of player
var init_pos = Vector2(0, 0)
# Player scaling multiplier
var player_scale = Vector2(0, 0)

@onready var upper_body = $UpperBody
@onready var upper_body_sprite = $UpperBody/UpperBodySprite
@onready var lower_body_sprite = $LowerBodySprite
@onready var lower_body_collision_shape = $LowerBodyCollisionShape
@onready var upper_body_collision_shape = $UpperBodyCollisionShape
@onready var reticle = $Reticle
@onready var muzzle = $UpperBody/Muzzle
@onready var soap_bullet = preload("res://scenes/soapbullet.tscn")
@onready var gum_bullet = preload("res://scenes/gumbullet.tscn")
@onready var soda_bullet = preload("res://scenes/sodabullet.tscn")
@onready var label_state_ammo = $reload_message

func _ready():
	#Sets initial position, size
	global_position = init_pos
	scale = player_scale
	
	
	#Gives stats based on selected weapon
	if weapon_type == "soda":
		player_stats = STATS_SODA
	elif weapon_type == "soap":
		player_stats = STATS_SOAP
	else:
		player_stats = STATS_GUM

func _physics_process(delta):
	# Handle reticle
	face_right = reticle.global_position.x > global_position.x
	if face_right:
		upper_body.scale.x = abs(upper_body.scale.x)
		var angle_to_reticle = (reticle.global_position - global_position).angle()
		upper_body.rotation = angle_to_reticle - 0.20
	else:
		upper_body.scale.x = -abs(upper_body.scale.x)
		var angle_to_reticle = (reticle.global_position - global_position).angle()
		upper_body.rotation = angle_to_reticle + deg_to_rad(180) + 0.20
		
	# Handle reload.
	if reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			reloading = false

	# Handle Slide.
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			sliding = false
			lower_body_collision_shape.disabled = false
		else:
			velocity.y += player_stats["SLIDE_GRAVITY"] * delta
			velocity.x = player_stats["SLIDE_SPEED"] * (1 if legs_face_right else -1)
			move_and_slide()
			return

	# Handle gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		left_ground_counter += delta
	else:
		left_ground_counter = 0
		double_jumps_left = 1
		is_double_jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || left_ground_counter <= COYOTE_LENIENCY:
			lower_body_sprite.play("jump")
			velocity.y = player_stats["JUMP_VELOCITY"]
		elif double_jumps_left > 0:
			upper_body_sprite.play("bubble_jump")
			lower_body_sprite.play("double_jump")
			velocity.y = player_stats["JUMP_VELOCITY"]
			double_jumps_left -= 1
			is_double_jumping = true

	# Handle movement.
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 * player_stats["SPEED"]
		lower_body_sprite.flip_h = false
		legs_face_right = true
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 * player_stats["SPEED"]
		lower_body_sprite.flip_h = true
		legs_face_right = false
		
	# Handle shoot cooldown
	if(shoot_cooldown > 0):
		shoot_cooldown -= delta

	# Trigger & Handle shoot.
	if Input.is_action_just_pressed("shoot_bullet"):
		# ADD INTERACTIONS FOR HOLDING DOWN SHOOT BUTTON (FULL AUTO/CHARGEABLE)
		
		if bullets_left > 0 && shoot_cooldown <= 0:
			bullets_left -= 1
			#HUD_bullet_left.set_text(str(bullets_left))
			shoot_cooldown = player_stats["SHOOT_COOLDOWN_DURATION"]
			shoot_animation_timer = player_stats["SHOOT_ANIMATION_DURATION"]
			#upper_body_sprite.play("shoot")
			shoot_bullet()
			move_and_slide()			
			if bullets_left <= 1:
				display_state_ammo("RELOAD" , true)
			return
			
	# Trigger reload.
	if Input.is_action_just_pressed("reload"):
		bullets_left = player_stats["MAX_AMMO"]
		reloading = true
		reload_timer = player_stats["RELOAD_DURATION"]
		upper_body_sprite.play("reload")
		move_and_slide()
		display_state_ammo("OK!!!" , false)
		return
		
	# Trigger slide.
	if Input.is_action_just_pressed("crouch") and velocity.x != 0 and is_on_floor():
		sliding = true
		slide_timer = player_stats["SLIDE_DURATION"]
		lower_body_collision_shape.disabled = true
		lower_body_sprite.play("slide")
		velocity.x = player_stats["SLIDE_SPEED"] * (1 if face_right else -1)
		move_and_slide()
		return
		
	# Handle animations.
	if not is_on_floor() and not is_double_jumping:
		lower_body_sprite.play("jump")
	elif velocity.x == 0 and is_on_floor():
		if shooting || shoot_animation_timer > 0:
			shoot_animation_timer -= delta
			upper_body_sprite.play("shoot")
		elif reloading:
			upper_body_sprite.play("reload")
		else:
			upper_body_sprite.play("idle")
		lower_body_sprite.play("idle")
	elif velocity.x != 0 and is_on_floor():
		if shooting || shoot_animation_timer > 0:
			shoot_animation_timer -= delta
			upper_body_sprite.play("shoot")
		elif reloading:
			upper_body_sprite.play("reload")
		else:
			upper_body_sprite.play("default")
		lower_body_sprite.play("run")

	move_and_slide()

# Create and shoot a bullet
func shoot_bullet():
	var bullet
	
	# DETERMINES STATS OF BULLETS && WHICH TO FIRE
	if weapon_type == "soda":
		bullet = soda_bullet.instantiate()
		bullet.stats_bullet = BULLET_SODA
	elif weapon_type == "soap":
		bullet = soap_bullet.instantiate()
		bullet.stats_bullet = BULLET_SOAP
	else:
		bullet = gum_bullet.instantiate()
		bullet.stats_bullet = BULLET_GUM
	
	var bullet_angle_vec = Vector2((reticle.global_position.x - muzzle.global_position.x), (reticle.global_position.y - muzzle.global_position.y))
	var bullet_direction = bullet_angle_vec.angle()
	bullet.dir = bullet_direction
	bullet.pos = muzzle.global_position
	bullet.rot = muzzle.global_rotation
	bullet.shooter = player_nb
	get_tree().current_scene.add_child(bullet)

func display_state_ammo(message:String , display:bool):
	if display == true:
		label_state_ammo.set_text(message)
		label_state_ammo.set_visible(true)
	else:
		label_state_ammo.set_text("OK!!!")
		await get_tree().create_timer(0.5).timeout
		label_state_ammo.set_visible(false)
