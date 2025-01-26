extends Control

@onready var menu_sfx = $AudioStreamPlayer2D
signal cancel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cancel_button_up() -> void:
	menu_sfx.play()
	cancel.emit() # Replace with function body.
