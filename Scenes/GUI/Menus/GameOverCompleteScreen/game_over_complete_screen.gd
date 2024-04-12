extends Control

@onready var lives_box = $CenterContainer/LivesBox
@onready var game_over_box = $CenterContainer/GameOverBox
@onready var level_complete_box = $CenterContainer/LevelCompleteBox

var fadeout_complete = false

var retry = false

var quitting = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade_from_black")
	if Gamestats.gamestatus == "continue":
		lives_box.visible = true
		game_over_box.visible = false
		level_complete_box.visible = false
	if Gamestats.gamestatus == "gameover":
		$GameOverTimer.start()
		lives_box.visible = false
		game_over_box.visible = true
		level_complete_box.visible = false
	if Gamestats.gamestatus == "levelcomplete":
		lives_box.visible = false
		game_over_box.visible = false
		level_complete_box.visible = true

func _on_try_again_pressed():
	Gamestats.gamestatus = null
	$AnimationPlayer.play("fade_to_black")
	retry = true


func fadeoutcomplete():
	fadeout_complete = true

func _on_quit_pressed():
	Gamestats.gamestatus = null
	$AnimationPlayer.play("fade_to_black")
	quitting = true



func _on_game_over_timer_timeout():
	Gamestats.gamestatus = null
	$AnimationPlayer.play("fade_to_black")
	quitting = true

func _on_return_to_title_pressed():
	Gamestats.gamestatus = null
	$AnimationPlayer.play("fade_to_black")
	quitting = true
	
func _process(_delta):
	if fadeout_complete: 
		if retry:
			get_tree().change_scene_to_file("res://Scenes/Game/Test Level/Test Level.tscn")
		if quitting:
			get_tree().change_scene_to_file("res://Scenes/GUI/Menus/main_screen.tscn")
