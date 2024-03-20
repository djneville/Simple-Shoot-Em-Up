extends ParallaxLayer

@export var worldspeed = 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.motion_offset.y += worldspeed * delta
	pass
