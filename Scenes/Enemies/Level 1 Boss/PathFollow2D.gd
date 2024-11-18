extends PathFollow2D

var speed = 45

var complete = false

var activated = false

func _process(delta):
    if activated:
        progress += speed * delta
        if progress_ratio >= 1:
            complete = true
    pass
