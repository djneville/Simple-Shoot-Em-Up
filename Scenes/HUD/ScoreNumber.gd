extends Label

@onready var playerscore = GameStatsManager.score

func _process(_delta):
    playerscore = GameStatsManager.score
    text = str(playerscore)
