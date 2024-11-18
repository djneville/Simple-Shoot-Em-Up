extends Control

@onready var lives_box = $CenterContainer/LivesBox
@onready var game_over_box = $CenterContainer/GameOverBox
@onready var level_complete_box = $CenterContainer/LevelCompleteBox

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("fade_from_black")
    #TODO: These will not get connected to until this screen is set up??
    Gamestats.game_over.connect(_game_over)
    Gamestats.level_complete.connect(_level_complete)
    Gamestats.continue_game.connect(_continue)
 
func _continue():
    lives_box.visible = true
    game_over_box.visible = false
    level_complete_box.visible = false

func _level_complete():
    lives_box.visible = false
    game_over_box.visible = false
    level_complete_box.visible = true

func _game_over():
    $GameOverTimer.start()
    lives_box.visible = false
    game_over_box.visible = true
    level_complete_box.visible = false

func _on_try_again_pressed():
    $AnimationPlayer.play("fade_to_black")
    get_tree().change_scene_to_file("res://Scenes/Main/Main.tscn")

func _on_quit_pressed():
    _return_to_main_screen()

func _on_game_over_timer_timeout():
    _return_to_main_screen()

func _on_return_to_title_pressed():
    _return_to_main_screen()
   
func _return_to_main_screen():
    $AnimationPlayer.play("fade_to_black")
    get_tree().change_scene_to_file("res://Scenes/Menus/MainScreen.tscn")
