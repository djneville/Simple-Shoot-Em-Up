extends Control
class_name GameOverScreen

func _ready():
    #TODO: OH MY GOD THIS IS AWFUL SORRY:
    if GameStatsManager.lives <= 0:
        $CenterContainer/VBoxContainer/TryAgainButton.hide()
        $CenterContainer/GameOverBox.show()
    else:
        $CenterContainer/VBoxContainer/TryAgainButton.show()
        $CenterContainer/GameOverBox.hide()

    $CenterContainer/VBoxContainer/TryAgainButton.pressed.connect(_on_try_again_pressed)
    $CenterContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_try_again_pressed():
    SceneManager.change_scene(SceneManager.MAIN_GAME_LOOP)

func _on_quit_pressed():
    SceneManager.change_scene(SceneManager.MAIN_MENU)
