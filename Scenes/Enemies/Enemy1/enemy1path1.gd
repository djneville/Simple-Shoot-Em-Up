extends Path2D

var progress_ratio = 0

@onready var path_follow_2d = $PathFollow2D

func _process(delta):
	progress_ratio = path_follow_2d.progress_ratio
	pass
