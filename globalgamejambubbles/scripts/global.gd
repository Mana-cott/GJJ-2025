extends Node

var look_mode = "mouse"
var weapon_type_p1 = "soap"
var weapon_type_p2 = "soap"

signal on_damage(bullet_ref:Bullet)

func _ready() -> void:
	pass
	#player_ref = get_tree().root.get_node("Player")
	
