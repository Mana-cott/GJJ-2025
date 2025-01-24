#extends CharacterBody2D

extends Area2D

const RICOCHET = 3;
const DURATION = 1.0

var pos:Vector2
var rot:float
var dir:float
var speed = 1000

@onready var timer = $Timer


func _ready():
	global_position = pos
	global_rotation = rot - ((2*PI)/4)
	timer.set_wait_time(DURATION)
	print(position)


	
func _physics_process(delta):
	position += transform.x * speed * delta
	#velocity = Vector2(speed,0).rotated(dir)
	speed -= (speed/100 +5)
	print(rot)
	#move_and_slide()

#maybe a little animation before deleted the bublle
func disappear():
	queue_free()


func _on_timer_timeout() -> void:
	#print("disappear")
	disappear() # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	disappear() # Replace with function body.
