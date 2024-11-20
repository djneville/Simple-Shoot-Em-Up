extends Control
class_name LevelSelectScreen


func _ready() -> void:
    $MarginContainer/CenterContainer/VBoxContainer/TestLevel.pressed.connect(_on_test_level_pressed)
    $MarginContainer/CenterContainer/VBoxContainer/Level1.pressed.connect(_on_level_1_pressed)
    $MarginContainer/CenterContainer/VBoxContainer/Back.pressed.connect(_on_back_pressed)


func _on_test_level_pressed() -> void:
    SceneManager.change_scene(SceneManager.MAIN_GAME_LOOP)


func _on_level_1_pressed() -> void:
    pass
    # Change to Level 1 scene (replace with the actual path to your Level 1 scene)
    #SceneManager.change_scene("res://Scenes/Levels/Level.tscn")


func _on_back_pressed() -> void:
    SceneManager.change_scene(SceneManager.MAIN_MENU)
