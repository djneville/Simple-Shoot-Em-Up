extends Control
class_name LevelCompleteScreen

func _ready():
    #$CenterContainer/VBoxContainer/NextLevelButton.pressed.connect(_on_next_level_pressed)
    $CenterContainer/VBoxContainer/ReturnToTitleButton.pressed.connect(_on_return_to_title_pressed)

func _on_return_to_title_pressed():
    SceneManager.change_scene(SceneManager.MAIN_MENU)
