extends Label

@onready var playerlives = Gamestats.lives

func _process(_delta):
	if playerlives:
		playerlives = Gamestats.lives
		text = str(playerlives)

