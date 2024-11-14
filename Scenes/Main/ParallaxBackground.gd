extends ParallaxBackground

#TODO: AHHHHHHHHH!!!!!!!!!!!!!1 JESUS !
@export var worldspeed = 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    scroll_base_offset.y += worldspeed * delta
    pass
