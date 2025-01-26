extends Node

var look_mode = "mouse"
var character_p1 = "scubahood"
var character_p2 = "dagon"

var focused := true


signal on_damage(bullet_ref:Bullet)

func _ready() -> void:
	pass
	#player_ref = get_tree().root.get_node("Player")
	

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true

func input_is_action_pressed(action: StringName) -> bool:
	if focused:
		return Input.is_action_pressed(action)

	return false

func event_is_action_pressed(event: InputEvent, action: StringName) -> bool:
	if focused:
		return event.is_action_pressed(action)

	return false
