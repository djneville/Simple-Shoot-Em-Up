extends Label


func _process(_delta: float) -> void:
	self.set_text(str(GameStatsManager.lives))
	pass
