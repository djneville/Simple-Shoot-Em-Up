extends Control
class_name MainMenu

#TODO: make a custom control class that all menus inheret from such that we
# only need to assign the THEME to one Control Scene


func _ready() -> void:
    GameStatsManager.lives = 3
    GameStatsManager.score = 0
    $MarginContainer/CenterContainer/VBoxContainer/StartGame.pressed.connect(
        _on_start_game_button_pressed
    )
    $MarginContainer/CenterContainer/VBoxContainer/LevelSelect.pressed.connect(
        _on_level_select_button_pressed
    )
    $MarginContainer/CenterContainer/VBoxContainer/QuitGame.pressed.connect(_on_quit_game_pressed)


func _on_start_game_button_pressed() -> void:
    SceneManager.change_scene(SceneManager.MAIN_GAME_LOOP)


func _on_level_select_button_pressed() -> void:
    SceneManager.change_scene(SceneManager.LEVEL_SELECT)


func _on_quit_game_pressed() -> void:
    get_tree().quit()
