extends Node2D

@onready var HUD = $HUD
@onready var victory_screen = $HUD/victory_screen

func game_end(id:int):
	get_tree().paused = true
	victory_screen.set_visible(true)
	victory_screen.write_victory_message("Player" + str(id) + " won the game")
	print("Player" , id, " won the game")

# Called when you hit play.
func _ready() -> void:
	# Randomly select and instantiate stage
	# INSERT CODE HERE
	
	# Create 2 children Player instances, assign them player nb 1 and player nb 2
	var player_scene = preload("res://scenes/player.tscn")
	
	# Instantiate player 1
	var p1 = player_scene.instantiate()
	p1.player_nb = 1
	p1.weapon_type = Global.weapon_type_p1
	p1.init_pos = Vector2(-200, 0)
	p1.player_scale = Vector2(3, 3)
	get_tree().current_scene.add_child(p1)
	HUD.display_HUD_player(p1)
	p1.defeat.connect(game_end)
	
	# Instantiate player 2
	var p2 = player_scene.instantiate()
	p2.player_nb = 2
	p2.weapon_type = Global.weapon_type_p2
	p2.init_pos = Vector2(200, 0)
	p2.player_scale = Vector2(3, 3)	
	get_tree().current_scene.add_child(p2)
	HUD.display_HUD_player(p2)
	p2.defeat.connect(game_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_victory_screen_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_victory_screen_retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
