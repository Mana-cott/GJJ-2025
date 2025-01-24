extends CharacterBody2D

const SPEED = 500

func _physics_process(delta):
	velocity = Vector2.ZERO

	# Handle movement
	if Input.is_action_pressed("look_up"):
		velocity.y -= 1 * SPEED
	if Input.is_action_pressed("look_down"):
		velocity.y += 1 * SPEED
	if Input.is_action_pressed("look_left"):
		velocity.x -= 1 * SPEED
	if Input.is_action_pressed("look_right"):
		velocity.x += 1 * SPEED
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED

	move_and_slide()
