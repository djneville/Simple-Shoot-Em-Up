extends Label


func _process(delta: float) -> void:
	self.set_text(str(GameStatsManager.score))
	pass
