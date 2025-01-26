extends Control

signal cancel
 
var master_bus = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(master_bus)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cancel_button_up() -> void:
	cancel.emit()


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus,value)
	if value == -30:
		AudioServer.set_bus_mute(master_bus,true)
	else:
		AudioServer.set_bus_mute(master_bus,false)
