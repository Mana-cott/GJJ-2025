extends Control

@onready var toggle_look_mode_button = $MarginContainer/HBoxContainer/VBoxContainer/ToggleLookMode
@onready var optionMenu = $Option_Menu 
@onready var controlMenu = $Control_Menu
@onready var marginContainer = $MarginContainer
@onready var view_controls_button = $MarginContainer/HBoxContainer/VBoxContainer/Controls
@onready var weapon_label = $MarginContainer/HBoxContainer/VBoxContainerWeaponSelector/Weapon_Label
@onready var weapon_label2 = $MarginContainer/HBoxContainer/VBoxContainerWeaponSelector2/Weapon_Label2
@onready var character_label = $MarginContainer/HBoxContainer/VBoxContainerWeaponSelector/Character_Label
@onready var character_label2 = $MarginContainer/HBoxContainer/VBoxContainerWeaponSelector2/Character_Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_toggle_look_mode_pressed():
	if Global.look_mode == "mouse":
		Global.look_mode = "arrowkeys"
		toggle_look_mode_button.text = "P1 Aim: Arrow Keys"
	else:
		Global.look_mode = "mouse"
		toggle_look_mode_button.text = "P1 Aim: Mouse"
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_controls_pressed() -> void:
	controlMenu.set_visible(true)
	marginContainer.set_visible(false)

func _on_option_pressed() -> void:
	optionMenu.set_visible(true)
	marginContainer.set_visible(false)


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_option_menu_cancel() -> void:
	optionMenu.set_visible(false)
	marginContainer.set_visible(true) # Replace with function body.

# Character select p1
func _on_scubahood_pressed():
	Global.character_p1 = "scubahood"
	character_label.text = "Player 1 Character: SCUBAHOOD"
func _on_dagon_pressed():
	Global.character_p1 = "dagon"
	character_label.text = "Player 1 Character: DAGON"
func _on_collosus_of_rhodes_pressed():
	Global.character_p1 = "collosus"
	character_label.text = "Player 1 Character: COLOSSUS OF RHODES"

# Character select p2
func _on_scubahood_2_pressed():
	Global.character_p2 = "scubahood"
	character_label2.text = "Player 2 Character: SCUBAHOOD"
func _on_dagon_2_pressed():
	Global.character_p2 = "dagon"
	character_label2.text = "Player 2 Character: DAGON"
func _on_collosus_of_rhodes_2_pressed():
	Global.character_p2 = "collosus"
	character_label2.text = "Player 2 Character: COLOSSUS OF RHODES"

func _on_control_menu_cancel() -> void:
	controlMenu.set_visible(false)
	marginContainer.set_visible(true)
