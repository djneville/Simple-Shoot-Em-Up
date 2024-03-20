extends Control

func _on_start_game_button_pressed():
	pass # Replace with function body.

func _on_level_select_button_pressed():
	print("pressed")
	get_tree().change_scene_to_file("res://Scenes/Menus/level_select_screen.tscn")
	pass # Replace with function body.

func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
