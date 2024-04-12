extends PathFollow2D

var speed = 140

signal progress_ratio_1

func _process(delta):
	progress += speed * delta
	if progress_ratio == 1:
		emit_signal("progress_ratio_1", progress_ratio)
