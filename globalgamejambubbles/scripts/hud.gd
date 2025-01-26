extends CanvasLayer

@onready var ammo_left = $MarginContainer/HBoxContainer/Ammo_P1/ammo_Left
@onready var nb_bullet_left1 = $MarginContainer/HBoxContainer/Ammo_P1/bullet_Left
@onready var ammo_left2 = $MarginContainer/HBoxContainer/Ammo_P2/ammo_Left
@onready var nb_bullet_left2 = $MarginContainer/HBoxContainer/Ammo_P2/bullet_Left
@onready var p1_ammo = $MarginContainer/HBoxContainer/Ammo_P1
@onready var p2_ammo = $MarginContainer/HBoxContainer/Ammo_P2
@onready var p1_Hp = $HP1
@onready var p2_Hp = $HP2
@onready var health_bar1 = $HP1/HP
@onready var health_bar2 = $HP2/HP

const MAX_HEALTH_BAR = 300

var red = Color(1.0,0.0,0.0,1.0)
var yellow = Color(1.0,1.0,0.0,1.0)
var white = Color(1.0,1.0,1.0,1.0)

var soda_health_color = Color(1.0,0.49,0.22,0.20)
var soap_health_color = Color(1.0,0.87,0.88,0.91)
var gum_health_color = Color(1.0,0.41, 0.71, 1)




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_color_ammo()

#must show health bar if player are there
func display_HUD_player(Player : CharacterBody2D):
	if(Player != null):
		if(p1_Hp.get("visible") == false):
			p1_Hp.set("visible", true) 
			p1_ammo.set_visible(true)
			match Player.weapon_type:
				"soda":
					print("soda")
					health_bar2.set_color(soda_health_color)
				"soap":
					health_bar2.set_color(soap_health_color)
				"gum":
					health_bar2.set_color(gum_health_color)
			print("apres soda")
		else:
			p2_Hp.set("visible", true) 
			p2_ammo.set_visible(true)
			match Player.weapon_type:
				"soda":
					print("soda")
					health_bar1.set_color(soda_health_color)
				"soap":
					health_bar1.set_color(soap_health_color)
				"gum":
					health_bar1.set_color(gum_health_color)

func change_ammo_left(ammo_left : int , player:int):
	if player == 1:
		nb_bullet_left1.set_text(str(ammo_left))
	elif player == 2:
		nb_bullet_left2.set_text(str(ammo_left))

#just change the health bar
func change_life_bar(health:float , player:int):
	if player == 1:
		health_bar1.set_size(Vector2(health,health_bar1.get_size().y))
	elif player == 2:
		health_bar2.set_size(Vector2(health,health_bar2.get_size().y))

#like change life bar , but you add the value instead
func increment_life_bar(health:float , player:int):
	if player == 1:
		health_bar1.set_size(Vector2(health_bar1.get_size().x + health,health_bar1.get_size().y))
		if (health_bar1.get_size().x > MAX_HEALTH_BAR):
			health_bar1.set_size(Vector2(MAX_HEALTH_BAR,health_bar1.get_size().y)) 
	elif player == 2:
		health_bar2.set_size(Vector2(health_bar2.get_size().x +health,health_bar2.get_size().y))
		if (health_bar2.get_size().x > MAX_HEALTH_BAR):
			health_bar2.set_size(Vector2(MAX_HEALTH_BAR,health_bar2.get_size().y)) 

#use this function for sparkling the health bar (when its full maybe)
func bursted_spark_effect(player : int , time:int):
	if(player == 1):
		animation_spark_effect(p1_Hp,time)
	else:
		animation_spark_effect(p2_Hp,time)

func animation_spark_effect(hp : Control, time:int):
	for x in time*10:
		hp.set("visible",false)
		await get_tree().create_timer(0.05).timeout
		hp.set("visible",true)
		await get_tree().create_timer(0.05).timeout


#awfully long
func change_color_ammo():
	if(nb_bullet_left1.get_text() == "1"):
		ammo_left.set("theme_override_colors/font_color",yellow)
		nb_bullet_left1.set("theme_override_colors/font_color",yellow)
	elif(nb_bullet_left1.get_text() == "0"):
		ammo_left.set("theme_override_colors/font_color",red)
		nb_bullet_left1.set("theme_override_colors/font_color",red)
	else:
		ammo_left.set("theme_override_colors/font_color",white)
		nb_bullet_left1.set("theme_override_colors/font_color",white)

	if(nb_bullet_left2.get_text() == "1"):
		ammo_left.set("theme_override_colors/font_color",yellow)
		nb_bullet_left2.set("theme_override_colors/font_color",yellow)
	elif(nb_bullet_left2.get_text() == "0"):
		ammo_left.set("theme_override_colors/font_color",red)
		nb_bullet_left2.set("theme_override_colors/font_color",red)
	else:
		ammo_left.set("theme_override_colors/font_color",white)
		nb_bullet_left2.set("theme_override_colors/font_color",white)
