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
	"DAMAGE": 25,
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
	"DAMAGE": 100,
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
	"DAMAGE": 300,
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
const BUBBLE_STATE_DURATION = 3.0 # 3 seconds
const HIT_DURATION = 0.3

signal defeat(id:int)

var left_ground_counter = 0
var double_jumps_left = 1
var is_double_jumping = false
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
var is_bubbled = false
var bubble_timer = 0.0
var is_hit = false
var hit_timer = 0.0

# Local var for character selected
var character_selected = "scubahood"
# Local var for character selected
var player_nb = 1
# Local dictionary var for selected weapon type stats
var player_stats = STATS_SODA
# Initial position of player
var init_pos = Vector2(0, 0)
# Player scaling multiplier
var player_scale = Vector2(0, 0)
# Player "stance"/HP meter
var current_health = player_stats["HEALTH"]
# Timer after damage for health regen
var regen_timer = 0
#Charged shot charge timer
var charge_timer = 0
# Player current ammo, set to MAX_AMMO
var bullets_left = player_stats["MAX_AMMO"]

# Loading sound effects
var running_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/1-Running.mp3")
var jump_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/2-Jumping.mp3")
var hit_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/Taking damage.mp3")
var death_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/Death sfx.mp3")
var collosus_shoot_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/colloSUS - Shot Firing.mp3")
var collosus_reload_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/colloSUS - Shot Reloading.mp3")
var dagon_shoot_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/Dagon - Shot Firing.mp3")
var dagon_reload_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/Dagon - Shot Reloading.mp3")
var scubahood_shoot_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/Scubahood - Shot Firing.mp3")
var scubahood_reload_sfx = preload("res://assets/audio/2-Sounds GGJ/SFX/Scubahood - Shot Reloading.mp3")

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
@onready var middle_body_part = $Sprite2D
@onready var bubble_state = $BubbleStates
@onready var sound_effects = $SoundEffects

func _ready():
	# Set reticle inputs
	reticle.player_nb = player_nb
	# Character select in effect *mad rhymes
	if player_nb == 1:
		match Global.character_p1:
			"scubahood":
				character_selected = "scubahood"
				middle_body_part.texture = load("res://assets/sprites/body_blocker.png")
			"dagon":
				character_selected = "dagon"
				middle_body_part.texture = load("res://assets/sprites/dagon_body_blocker.png")
			"collosus":
				character_selected = "collosus"
				middle_body_part.texture = load("res://assets/sprites/collosus_body_blocker.png")
	else:
		match Global.character_p2:
			"scubahood":
				character_selected = "scubahood"
				middle_body_part.texture = load("res://assets/sprites/body_blocker.png")
			"dagon":
				character_selected = "dagon"
				middle_body_part.texture = load("res://assets/sprites/dagon_body_blocker.png")
			"collosus":
				character_selected = "collosus"
				middle_body_part.texture = load("res://assets/sprites/collosus_body_blocker.png")

	
	#Sets initial position, size
	global_position = init_pos
	scale = player_scale
	
	Global.connect("on_damage", damage_function)
	
	#Gives stats based on selected weapon
	if character_selected == "scubahood":
		player_stats = STATS_SODA
	elif character_selected == "dagon":
		player_stats = STATS_SOAP
	else:
		player_stats = STATS_GUM
		
	# Hide bubble state
	bubble_state.visible = false
	
	current_health = player_stats["HEALTH"]
	bullets_left = player_stats["MAX_AMMO"]


func _physics_process(delta):
	
	# Handles hit timer
	if is_hit:
		hit_timer -= delta
		if hit_timer <= 0:
			hit_timer = 0.0
			is_hit = false
	
	# Handles natural health regen
	regen_timer += 1
	if regen_timer >= 30:
		if current_health < player_stats["HEALTH"]:
			current_health += 1
	
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
	if Input.is_action_just_pressed("jump" + str(player_nb)):
		if is_on_floor() || left_ground_counter <= COYOTE_LENIENCY:
			lower_body_sprite.play(character_selected + "_jump")
			play_sound("jump")
			velocity.y = player_stats["JUMP_VELOCITY"]
		elif double_jumps_left > 0:
			upper_body_sprite.play(character_selected + "_bubble_jump")
			lower_body_sprite.play(character_selected + "_double_jump")
			play_sound("jump")
			velocity.y = player_stats["JUMP_VELOCITY"]
			double_jumps_left -= 1
			is_double_jumping = true

	# Handle movement.
	velocity.x = 0
	if Input.is_action_pressed("move_right"+str(player_nb)):
		velocity.x += 1 * player_stats["SPEED"]
		lower_body_sprite.flip_h = false
		legs_face_right = true
	if Input.is_action_pressed("move_left"+str(player_nb)):
		velocity.x -= 1 * player_stats["SPEED"]
		lower_body_sprite.flip_h = true
		legs_face_right = false
		
	# Handle shoot cooldown
	if(shoot_cooldown > 0):
		shoot_cooldown -= delta

# HANDLES CHARGED FIRE (GUM)
	if player_stats["CHARGEABLE"] == true:
		if Input.is_action_pressed("shoot_bullet"+str(player_nb)):
			if bullets_left > 0 && shoot_cooldown <= 0:
				charge_timer += 1
		else: 
			if charge_timer >= 10:
				bullets_left -= 1
				shoot_cooldown = player_stats["SHOOT_COOLDOWN_DURATION"] + charge_timer
				shoot_animation_timer = player_stats["SHOOT_ANIMATION_DURATION"]
				charge_timer = 0
				#upper_body_sprite.play("shoot")
				shoot_bullet(charge_timer)
				move_and_slide()
				if bullets_left <= 1:
					display_state_ammo("RELOAD" , true)
				return
			else: 
				charge_timer = 0


# HANDLES AUTO FIRE (SODA)
	elif player_stats["FULL_AUTO"] == true:
		if Input.is_action_pressed("shoot_bullet"+str(player_nb)):
			if bullets_left > 0 && shoot_cooldown <= 0:
				bullets_left -= 1
				shoot_cooldown = player_stats["SHOOT_COOLDOWN_DURATION"]
				shoot_animation_timer = player_stats["SHOOT_ANIMATION_DURATION"]
				#upper_body_sprite.play("shoot")
				shoot_bullet(charge_timer)
				move_and_slide()
				if bullets_left <= 1:
					display_state_ammo("RELOAD" , true)
				return


# HANDLE SEMI-AUTO (SOAP)
	else: 
		if Input.is_action_just_pressed("shoot_bullet"+str(player_nb)):
			if bullets_left > 0 && shoot_cooldown <= 0:
				bullets_left -= 1
				#HUD_bullet_left.set_text(str(bullets_left))
				shoot_cooldown = player_stats["SHOOT_COOLDOWN_DURATION"]
				shoot_animation_timer = player_stats["SHOOT_ANIMATION_DURATION"]
				#upper_body_sprite.play("shoot")
				shoot_bullet(0)
				move_and_slide()
				if bullets_left <= 1:
					display_state_ammo("RELOAD" , true)
				return


	# Trigger & Handle shoot.
			
	# Trigger reload.
	if Input.is_action_just_pressed("reload"+str(player_nb)):
		bullets_left = player_stats["MAX_AMMO"]
		reloading = true
		reload_timer = player_stats["RELOAD_DURATION"]
		upper_body_sprite.play(character_selected + "_reload")
		play_sound("reload")
		move_and_slide()
		display_state_ammo("OK!!!" , false)
		return
		
	# Trigger slide.
	if Input.is_action_just_pressed("slide"+str(player_nb)) and velocity.x != 0 and is_on_floor():
		sliding = true
		slide_timer = player_stats["SLIDE_DURATION"]
		lower_body_collision_shape.disabled = true
		lower_body_sprite.play(character_selected + "_slide")
		play_sound("running")
		velocity.x = player_stats["SLIDE_SPEED"] * (1 if face_right else -1)
		move_and_slide()
		return
	
	# Handle bubble state.
	# unfinished!!!
	if is_bubbled:
		bubble_timer -= delta
		if bubble_timer <= 0:
			sliding = false
			lower_body_collision_shape.disabled = false
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			return
			
	# Trigger bubblestate.
	# Use same as slide logic or something

	# Handle HP and bubbling
	if current_health <= 0: 
		defeat.emit(player_nb)
		current_health = player_stats["HEALTH"]
	
	# Handle animations.
	if not is_on_floor() and not is_double_jumping:
		lower_body_sprite.play(character_selected + "_jump")
	elif velocity.x == 0 and is_on_floor():
		if not is_hit:
			if shooting || shoot_animation_timer > 0:
				shoot_animation_timer -= delta
				upper_body_sprite.play(character_selected + "_shoot")
				play_sound("shoot")
			elif reloading:
				upper_body_sprite.play(character_selected + "_reload")
				play_sound("reload")
			else:
				upper_body_sprite.play(character_selected + "_idle")
		lower_body_sprite.play(character_selected + "_idle")
	elif velocity.x != 0 and is_on_floor():
		if not is_hit:
			if shooting || shoot_animation_timer > 0:
				shoot_animation_timer -= delta
				upper_body_sprite.play(character_selected + "_shoot")
				play_sound("shoot")
			elif reloading:
				upper_body_sprite.play(character_selected + "_reload")
				play_sound("reload")
			else:
				upper_body_sprite.play(character_selected + "_default")
		lower_body_sprite.play(character_selected + "_run")
		play_sound("running")

	move_and_slide()

# Handles player taking damage
func damage_function(dmg_source:Bullet):
	if dmg_source.shooter != player_nb:
		upper_body_sprite.play(character_selected + "_hit")
		is_hit = true
		hit_timer = HIT_DURATION
		current_health -= (dmg_source.stats_bullet["DAMAGE"] + dmg_source.charge_boost)
		regen_timer = 0
		print(current_health)
		if current_health <= 0:
			# Bubble state in effect
			bubble_state = true

# Create and shoot a bullet
func shoot_bullet(charge:int):
	var bullet
	
	# DETERMINES STATS OF BULLETS && WHICH TO FIRE
	if character_selected == "dagon":
		bullet = soda_bullet.instantiate()
		bullet.stats_bullet = BULLET_SODA
	elif character_selected == "scubahood":
		bullet = soap_bullet.instantiate()
		bullet.stats_bullet = BULLET_SOAP
	else:
		bullet = gum_bullet.instantiate()
		bullet.stats_bullet = BULLET_GUM
		bullet.charge_boost += charge
	
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
		
# Function to handle SFX
func play_sound(sound_name):
	match sound_name:
		"running":
			$SoundEffects.stream = running_sfx
		"jump":
			$SoundEffects.stream = jump_sfx
		"hit":
			$SoundEffects.stream = hit_sfx
		"death":
			$SoundEffects.stream = death_sfx
		"shoot_sfx":
			if character_selected == "scubahood":
				$SoundEffects.stream = scubahood_shoot_sfx
			elif character_selected == "collosus":
				$SoundEffects.stream = collosus_shoot_sfx
			elif character_selected == "dagon":
				$SoundEffects.stream = dagon_shoot_sfx
		"reload":
			if character_selected == "scubahood":
				$SoundEffects.stream = scubahood_reload_sfx
			elif character_selected == "collosus":
				$SoundEffects.stream = collosus_reload_sfx
			elif character_selected == "dagon":
				$SoundEffects.stream = dagon_reload_sfx
	$SoundEffects.play()
