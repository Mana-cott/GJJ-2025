extends Node2D

@onready var HUD = $HUD
@onready var victory_screen = $HUD/victory_screen

func game_end(id:int):
	# get_tree().paused = true
	var winner:int
	if id == 1:
		winner = 2
	else:
		winner = 1
	victory_screen.set_visible(true)
	victory_screen.write_victory_message("Player " + str(winner) + " won the game")
	print("Player " , id, " won the game")

# Called when you hit play.
func _ready() -> void:
	# Randomly select and instantiate stage
	# INSERT CODE HERE
	
	# Create 2 children Player instances, assign them player nb 1 and player nb 2
	var player_scene = preload("res://scenes/player.tscn")
	
	# Instantiate player 1
	var p1 = player_scene.instantiate()
	p1.player_nb = 1
	p1.init_pos = Vector2(-200, 0)
	p1.player_scale = Vector2(3, 3)
	get_tree().current_scene.add_child(p1)
	HUD.display_HUD_player(p1)
	p1.defeat.connect(game_end)
	p1.health_update.connect(HUD_update_health)
	p1.ammo_update.connect(HUD_update_ammo)
	p1.max_health.connect(HUD_max_health)
	p1.bubbled_update.connect(HUD_bubbled_effect)

	# Instantiate player 2
	var p2 = player_scene.instantiate()
	p2.player_nb = 2
	p2.init_pos = Vector2(200, 0)
	p2.player_scale = Vector2(3, 3)	
	get_tree().current_scene.add_child(p2)
	HUD.display_HUD_player(p2)
	p2.defeat.connect(game_end)
	p2.health_update.connect(HUD_update_health)
	p2.ammo_update.connect(HUD_update_ammo)
	p2.max_health.connect(HUD_max_health)
	p2.bubbled_update.connect(HUD_bubbled_effect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func HUD_bubbled_effect(player : int , time:int) -> void:
	HUD.bursted_spark_effect(player , time)

func HUD_max_health(player_nb:int, max:int) -> void:
	HUD.set_max_health(player_nb, max)

func HUD_update_health(player_nb:int, current_health:int) -> void:
	HUD.change_life_bar(current_health , player_nb)

func HUD_update_ammo(player_nb:int, current_ammo:int) -> void:
	HUD.change_ammo_left(current_ammo , player_nb)


func _on_victory_screen_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_victory_screen_retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
