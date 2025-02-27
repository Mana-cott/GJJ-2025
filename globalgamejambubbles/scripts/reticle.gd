extends CharacterBody2D

const SPEED = 1000

var current_pos = Vector2.ZERO
var player_nb = 1

func _physics_process(delta):
	
	if player_nb == 1:
		if Global.look_mode == "arrowkeys":
			velocity = Vector2.ZERO
			# Handle movement
			if Input.is_action_pressed("look_up1"):
				velocity.y -= 1 * SPEED
			if Input.is_action_pressed("look_down1"):
				velocity.y += 1 * SPEED
			if Input.is_action_pressed("look_left1"):
				velocity.x -= 1 * SPEED
			if Input.is_action_pressed("look_right1"):
				velocity.x += 1 * SPEED
				
			if velocity.length() > 0:
				velocity = velocity.normalized() * SPEED
							
			move_and_slide()
			
		else:
			var screen_mouse_position = get_viewport().get_mouse_position()
			current_pos = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * screen_mouse_position
			global_position = current_pos
	else:
		velocity = Vector2.ZERO
		# Handle movement
		if Input.is_action_pressed("look_up2"):
			velocity.y -= 1 * SPEED
		if Input.is_action_pressed("look_down2"):
			velocity.y += 1 * SPEED
		if Input.is_action_pressed("look_left2"):
			velocity.x -= 1 * SPEED
		if Input.is_action_pressed("look_right2"):
			velocity.x += 1 * SPEED
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
						
		move_and_slide()

#func _input(event):
	# Mouse in viewport coordinates.
	#if event is InputEventMouseMotion:
