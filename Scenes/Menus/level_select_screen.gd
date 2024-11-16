extends Control


func _on_test_level_pressed():
    get_tree().change_scene_to_file("res://Scenes/Main/Main.tscn")
    pass # Replace with function body.


func _on_level_1_pressed():
    pass # Replace with function body.


func _on_back_pressed():
    get_tree().change_scene_to_file("res://Scenes/Menus/main_screen.tscn")
    pass # Replace with function body.
