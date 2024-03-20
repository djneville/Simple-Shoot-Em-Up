extends Control

@onready var game = $"../"

func _on_resume_pressed():
	game.unpause()
	pass # Replace with function body.

func _on_quit_to_menu_pressed():
	game.unpause()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_screen.tscn")
	pass # Replace with function body.

func _on_quit_game_pressed():
	get_tree().quit()
	pass # Replace with function body.
