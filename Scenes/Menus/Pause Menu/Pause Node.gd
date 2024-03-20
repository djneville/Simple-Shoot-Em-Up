extends Node


@onready var game = $".."


func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_viewport().set_input_as_handled()
		if get_tree().paused:
			game.unpause()
