extends Label

func _ready():
    if Gamestats.highscore > 0:
        self.set_text(str(Gamestats.highscore))
    pass
