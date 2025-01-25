extends CharacterBody2D

var stats_bullet = {
	"DAMAGE": 10,
	"RICOCHET": 3,
	"BULLET_DURATION": 5, 
	"BULLET_GRAVITY_MODIFIER": 1, 
	"BULLET_SPEED": 500, 
	"BULLET_DECCEL_MODIFIER": 1,
	"BULLET_INERTIA": 1,
	"BULLET_IFRAME_DURATION": 0.5,
	"FRAGILE_BOUNCE": false,
	"CAN_SHOOTER_BOUNCE": false}

var pos:Vector2
var rot:float
var dir:float
var oldBub = false
var ricochetCount = 0
var shooter = 0

@onready var timer = $Timer

func _ready():
	global_position = pos
	global_rotation = rot #- ((2*PI)/4)
	velocity = Vector2(stats_bullet["BULLET_SPEED"], 0).rotated(dir)
	ricochetCount = stats_bullet["RICOCHET"]
	timer.start(stats_bullet["BULLET_DURATION"])

func _on_player_hit(playerHit:Node2D, playerShooter:int):
	if playerHit.player_nb == playerShooter:
		# Do nothing
		print("Hit self")
	else:
		# Do damage signal???
		print("Hit target!")

func _physics_process(delta):
	
	# Once i-frame duration elapses, bubbles can be popped by player/bounce off each other
	if (stats_bullet["BULLET_DURATION"] - timer.get_time_left()) < stats_bullet["BULLET_IFRAME_DURATION"]:
		oldBub = false
	else: 
		oldBub = true
	
	var collision = move_and_collide(velocity * delta)

	# Triggers when bullet hits something
	if collision:

		#Triggers when bullet hits the terrain
		if collision.get_collider().is_class("TileMapLayer"):
			# Ricochet with reduced velocity
			if ricochetCount > 0:
				velocity = velocity.bounce(collision.get_normal())
				velocity = velocity*0.75
				ricochetCount -= 1
			#Pops if ricochets all used up
			else:
				disappear()

		#If collider hit is a player
		elif collision.get_collider().get_collision_layer_value(2):
			#Checks whether player is the one who shot the bubble
			_on_player_hit(collision.get_collider(), shooter)
			print(oldBub)
			#Bubble pops either way
			if oldBub == true:
				if stats_bullet["CAN_SHOOTER_BOUNCE"] && collision.get_collider().player_nb == shooter:
					velocity = velocity.bounce(collision.get_normal())
				else:
					disappear()
		
		# Makes bubbles bounce off of other bubbles
		elif collision.get_collider().get_collision_layer_value(3): 
			if oldBub == true && collision.get_collider().oldBub == true:
				if stats_bullet["FRAGILE_BOUNCE"] == true && collision.get_collider().shooter != shooter:
					disappear()
				if stats_bullet["FRAGILE_BOUNCE"] == true && collision.get_collider().shooter == shooter:
					velocity = velocity.bounce(collision.get_normal())
					ricochetCount -= 1
				else:
					# IMPLEMENT BULLET INERTIA HERE!!!
					velocity = velocity.bounce(collision.get_normal())
	
	# If it hits nothing, it slowly deccelerates.
	# FIX THIS
	# position = position.move_toward(Vector2(0,0), delta * speed)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * stats_bullet["BULLET_DECCEL_MODIFIER"])
			#If gravity modifier is positive, add downwards accel
			
	if stats_bullet["BULLET_GRAVITY_MODIFIER"] >= 0:
		position.y += stats_bullet["BULLET_GRAVITY_MODIFIER"]
 

# Maybe a little animation before deleted the bublle
func disappear():
	queue_free()

# When timer is up, bullet pops
func _on_timer_timeout() -> void:
	#print("disappear")
	disappear()
