extends Control

@onready var toggle_look_mode_button = $MarginContainer/HBoxContainer/VBoxContainer/ToggleLookMode
@onready var optionMenu = $Option_Menu 
@onready var controlMenu = $Control_Menu
@onready var marginContainer = $MarginContainer
@onready var view_controls_button = $MarginContainer/HBoxContainer/VBoxContainer/Controls
@onready var weapon_label = $MarginContainer/HBoxContainer/VBoxContainerWeaponSelector/Weapon_Label
@onready var weapon_label2 = $MarginContainer/HBoxContainer/VBoxContainerWeaponSelector2/Weapon_Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_toggle_look_mode_pressed():
	if Global.look_mode == "mouse":
		Global.look_mode = "arrowkeys"
		toggle_look_mode_button.text = "Aim: Arrow Keys"
	else:
		Global.look_mode = "mouse"
		toggle_look_mode_button.text = "Aim: Mouse"
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_controls_pressed() -> void:
	controlMenu.set_visible(true)
	marginContainer.set_visible(false)

func _on_option_pressed() -> void:
	optionMenu.set_visible(true)
	marginContainer.set_visible(false)

func _on_soda_pressed() -> void:
	Global.weapon_type_p1 = "soda"
	weapon_label.text = "P1 Currently Selected Bubble: Soda"
func _on_soap_pressed() -> void:
	Global.weapon_type_p1 = "soap"
	weapon_label.text = "P1 Currently Selected Bubble: Soap"
func _on_gum_pressed() -> void:
	Global.weapon_type_p1 = "gum"
	weapon_label.text = "P1 Currently Selected Bubble: Gum"
	
func _on_soda2_pressed() -> void:
	Global.weapon_type_p2 = "soda"
	weapon_label2.text = "P2 Currently Selected Bubble: Soda"
func _on_soap2_pressed() -> void:
	Global.weapon_type_p2 = "soap"
	weapon_label2.text = "P2 Currently Selected Bubble: Soap"
func _on_gum2_pressed() -> void:
	Global.weapon_type_p2 = "gum"
	weapon_label2.text = "P2 Currently Selected Bubble: Gum"


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_option_menu_cancel() -> void:
	optionMenu.set_visible(false)
	marginContainer.set_visible(true) # Replace with function body.


func _on_control_menu_cancel() -> void:
	controlMenu.set_visible(false)
	marginContainer.set_visible(true)
