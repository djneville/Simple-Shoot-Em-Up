extends Control
class_name PauseScreen

signal resume_game
signal quit_to_menu
signal quit_game


func _ready() -> void:
	$MarginContainer/CenterContainer/VBoxContainer/Resume.pressed.connect(_on_resume_pressed)
	$MarginContainer/CenterContainer/VBoxContainer/QuitToMenu.pressed.connect(
		_on_quit_to_menu_pressed
	)
	$MarginContainer/CenterContainer/VBoxContainer/QuitGame.pressed.connect(_on_quit_game_pressed)


func _on_resume_pressed() -> void:
	resume_game.emit()


func _on_quit_to_menu_pressed() -> void:
	quit_to_menu.emit()


func _on_quit_game_pressed() -> void:
	quit_game.emit()
