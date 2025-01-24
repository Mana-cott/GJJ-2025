extends Control

@onready var toggle_look_mode_button = $MarginContainer/HBoxContainer/VBoxContainer/ToggleLookMode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggle_look_mode_pressed():
	if Global.look_mode == "mouse":
		Global.look_mode = "arrowkeys"
		toggle_look_mode_button.text = "Arrow Keys"
	else:
		Global.look_mode = "mouse"
		toggle_look_mode_button.text = "Mouse"
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_option_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.
