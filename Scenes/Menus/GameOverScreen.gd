extends Control
class_name GameOverScreen


func _ready() -> void:
    #TODO: OH MY GOD THIS IS AWFUL SORRY:
    if GameStatsManager.lives <= 0:
        $CenterContainer/VBoxContainer/TryAgainButton.hide()
        $CenterContainer/GameOverBox.show()
    else:
        $CenterContainer/VBoxContainer/TryAgainButton.show()
        $CenterContainer/GameOverBox.hide()
    $CenterContainer/VBoxContainer/TryAgainButton.pressed.connect(_on_try_again_pressed)
    $CenterContainer/VBoxContainer/QuitButton.pressed.connect(_return_to_menu)
    $CenterContainer/VBoxContainer/Labels/Lives.set_text(str(GameStatsManager.lives))
    $GameOverTimer.timeout.connect(_return_to_menu)


func _on_try_again_pressed() -> void:
    SceneManager.change_scene(SceneManager.MAIN_GAME_LOOP)


func _return_to_menu() -> void:
    SceneManager.change_scene(SceneManager.MAIN_MENU)
