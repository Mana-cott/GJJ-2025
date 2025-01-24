extends CharacterBody2D

const RICOCHET = 3;

var pos:Vector2
var rot:float
var dir:float
var speed = 1000
var ricochet


func _ready():
	global_position = pos
	global_rotation = rot #- ((2*PI)/4)
	velocity = Vector2(speed,0).rotated(dir)
	ricochet = RICOCHET


func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if ricochet > 0:
			velocity = velocity.bounce(collision.get_normal())
			ricochet -= 1
		else:
			disappear()
	else:
		velocity.x -= ((velocity.x/100 +5)/2.3)


#maybe a little animation before deleted the bublle
func disappear():
	print("pop")
	queue_free()


func _on_timer_timeout() -> void:
	#print("disappear")
	disappear()
