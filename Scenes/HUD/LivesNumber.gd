extends Label

@onready var playerlives = GameStatsManager.lives

func _process(_delta):
    if playerlives:
        playerlives = GameStatsManager.lives
        text = str(playerlives)
