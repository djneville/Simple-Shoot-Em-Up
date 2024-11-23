extends Control
class_name LevelCompleteScreen


func _ready() -> void:
    #$CenterContainer/VBoxContainer/NextLevelButton.pressed.connect(_on_next_level_pressed)
    $CenterContainer/VBoxContainer/ReturnToTitleButton.pressed.connect(_on_return_to_title_pressed)
    $CenterContainer/VBoxContainer/ScoreBox/Score.set_text(str(GameStatsManager.score))


func _on_return_to_title_pressed() -> void:
    SceneManager.change_scene(SceneManager.MAIN_MENU)
