extends Control

func _ready():
    $AnimationPlayer.play("fade_from_black")
    Gamestats.lives = 3
    Gamestats.score = 0
    $"MarginContainer/CenterContainer/VBoxContainer/Start Game".pressed.connect(_on_start_game_button_pressed)
    $"MarginContainer/CenterContainer/VBoxContainer/Level Select".pressed.connect(_on_level_select_button_pressed)
    $"MarginContainer/CenterContainer/VBoxContainer/Quit Game".pressed.connect(_on_quit_game_pressed)
    $AnimationPlayer.animation_finished.connect(_start_game)

func _on_start_game_button_pressed():
    #TODO: turn this fade stuff into a Tween or something
    $AnimationPlayer.play("fade_to_black")

#TODO: gross because this needs an argument to satisfy the animation_finished signals args
func _start_game(animation_name):
    if(animation_name == "fade_to_black"):
        get_tree().change_scene_to_file("res://Scenes/Main/Main.tscn")

func _on_level_select_button_pressed():
    get_tree().change_scene_to_file("res://Scenes/Menus/level_select_screen.tscn")

func _on_quit_game_pressed():
    get_tree().quit()
