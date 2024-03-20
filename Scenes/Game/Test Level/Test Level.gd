extends Node2D

@onready var pause_menu = $"Pause Menu"

func pause():
	get_tree().paused = true
	pause_menu.show()
	pass
	
func unpause():
	get_tree().paused = false
	pause_menu.hide()
	pass

func _input(event):
	if Input.is_action_just_pressed("pause"):
		print("test pause")
		get_viewport().set_input_as_handled()
		pause()
	pass
