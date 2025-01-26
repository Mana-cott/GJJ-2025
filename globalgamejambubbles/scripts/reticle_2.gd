extends CharacterBody2D

const SPEED = 1000

var current_pos = Vector2.ZERO

func _physics_process(delta):
	
	velocity = Vector2.ZERO
	# Handle movement
	if Input.is_action_pressed("look_up_p2"):
		velocity.y -= 1 * SPEED
	if Input.is_action_pressed("look_down_p2"):
		velocity.y += 1 * SPEED
	if Input.is_action_pressed("look_left_p2"):
		velocity.x -= 1 * SPEED
	if Input.is_action_pressed("look_right_p2"):
		velocity.x += 1 * SPEED
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
					
	move_and_slide()

#func _input(event):
	# Mouse in viewport coordinates.
	#if event is InputEventMouseMotion:
