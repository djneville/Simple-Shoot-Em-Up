extends ParallaxBackground

@export var worldspeed = 100

func _process(delta):
    scroll_base_offset.y += worldspeed * delta
