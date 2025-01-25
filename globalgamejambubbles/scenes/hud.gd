extends CanvasLayer

@onready var ammo_left = $MarginContainer/HBoxContainer/VBoxContainer/ammo_Left
@onready var nb_bullet_left = $MarginContainer/HBoxContainer/VBoxContainer/bullet_Left
@onready var health_bar = $HP


var health_bar_max

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar_max = health_bar.get_size()
	print(health_bar.get_size().x)



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

#just change the health bar
func change_life_bar(health:float):
	health_bar.set_size(Vector2(health,health_bar.get_size().y))
	
