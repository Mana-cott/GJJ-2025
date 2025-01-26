extends CharacterBody2D

const SPEED = 1000

var current_pos = Vector2.ZERO

func _physics_process(delta):
	
	if Global.look_mode == "arrowkeys":
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
		
	else:
		var screen_mouse_position = get_viewport().get_mouse_position()
		current_pos = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * screen_mouse_position
		global_position = current_pos

#func _input(event):
	# Mouse in viewport coordinates.
	#if event is InputEventMouseMotion:
