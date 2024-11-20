extends Label

func _process(_delta):
    self.set_text(str(GameStatsManager.lives))
    pass
