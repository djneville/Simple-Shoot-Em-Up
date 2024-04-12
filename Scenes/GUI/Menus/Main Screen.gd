extends Control

var fadecomplete = false

func _ready():
	$AnimationPlayer.play("fade_from_black")
	Gamestats.lives = 3
	Gamestats.score = 0

func _process(_delta):
	if fadecomplete:
		get_tree().change_scene_to_file("res://Scenes/Game/Test Level/Test Level.tscn")

func _on_start_game_button_pressed():
	$AnimationPlayer.play("fadetoblack")

func _on_level_select_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/GUI/Menus/level_select_screen.tscn")

func _on_quit_game_pressed():
	get_tree().quit()

func fade_to_black():
	fadecomplete = true
