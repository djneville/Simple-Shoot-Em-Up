extends Label

func _process(delta):
    self.set_text(str(GameStatsManager.score))
    pass
