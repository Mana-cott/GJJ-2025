extends Control

signal retry
signal main_menu

@onready var victory_label = $PanelContainer/VBoxContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func write_victory_message(message: String):
	victory_label.set_text(message)


func _on_play_again_button_up() -> void:
	retry.emit()


func _on_main_menu_button_down() -> void:
	main_menu.emit()


func _on_rage_quit_button_down() -> void:
	get_tree().quit() 
