extends Node2D

@onready var pause_menu = $"Pause Menu"

@onready var player = $CharacterBody2D


func _ready():
    print("ready")
    $ScreenAnims.play("fade_from_black")
    player.restart_level.connect(restart)

func restart():
    $ScreenAnims.play("fade_to_black")
    get_tree().change_scene_to_file("res://Scenes/Menus/GameOverCompleteScreen/game_over_complete_screen.tscn")

func pause():
    get_tree().paused = true
    pause_menu.show()
    
func unpause():
    get_tree().paused = false
    pause_menu.hide()

func _input(_event):
    if Input.is_action_just_pressed("pause"):
        get_viewport().set_input_as_handled()
        pause()
