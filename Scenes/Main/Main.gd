extends Node2D

@onready var pause_menu = $"Pause Menu"

@onready var Player = $CharacterBody2D

var fadecomplete = false

func _ready():
    print("ready")
    fade_from_black()

func _process(_delta):
    if Player.reset_level or Gamestats.gamestatus == "levelcomplete":
        $ScreenAnims.play("fade_to_black")
        if fadecomplete == true:
            print("fadecomplete")
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

func fade_from_black():
    $ScreenAnims.play("fade_from_black")

func fade_complete():
    fadecomplete = true
