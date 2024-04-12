extends TextureProgressBar

@onready var playerhealth = get_tree().get_nodes_in_group("player")[0].health

func _process(_delta):
	if playerhealth:
		playerhealth = get_tree().get_nodes_in_group("player")[0].health
		value = playerhealth
	
