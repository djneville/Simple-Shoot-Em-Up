extends Label

@onready var playerscore = Gamestats.score

func _process(_delta):
    playerscore = Gamestats.score
    text = str(playerscore)
