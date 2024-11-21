extends PathFollow2D

var speed: int = 45

var complete: bool = false

var activated: bool = false


func _process(delta: float) -> void:
	if activated:
		progress += speed * delta
		if progress_ratio >= 1:
			complete = true
	pass
