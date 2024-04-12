extends TextureProgressBar

@onready var playerbombs = get_tree().get_nodes_in_group("player")[0].bombs

func _process(_delta):
	if playerbombs:
		playerbombs = get_tree().get_nodes_in_group("player")[0].bombs
		value = playerbombs
