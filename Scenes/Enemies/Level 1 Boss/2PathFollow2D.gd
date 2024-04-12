extends PathFollow2D

var speed = 50

var activated = false

func _process(delta):
	if activated:
		progress += speed * delta
	pass
