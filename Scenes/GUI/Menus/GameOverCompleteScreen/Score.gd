extends Label

func _process(delta):
	self.set_text(str(Gamestats.score))
	pass
