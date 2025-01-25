extends CanvasLayer

@onready var ammo_left = $MarginContainer/HBoxContainer/VBoxContainer/ammo_Left
@onready var nb_bullet_left = $MarginContainer/HBoxContainer/VBoxContainer/bullet_Left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(nb_bullet_left.get_text() == "1"):
		ammo_left.set("theme_override_colors/font_color",Color(1.0,1.0,0.0,1.0))
		nb_bullet_left.set("theme_override_colors/font_color",Color(1.0,1.0,0.0,1.0))
	elif(nb_bullet_left.get_text() == "0"):
		ammo_left.set("theme_override_colors/font_color",Color(1.0,0.0,0.0,1.0))
		nb_bullet_left.set("theme_override_colors/font_color",Color(1.0,0.0,0.0,1.0))
	else:
		ammo_left.set("theme_override_colors/font_color",Color(1.0,1.0,1.0,1.0))
		nb_bullet_left.set("theme_override_colors/font_color",Color(1.0,1.0,1.0,1.0))
