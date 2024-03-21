extends PathFollow2D

var speed = 150

func _process(delta):
	progress += speed * delta
	
	pass
