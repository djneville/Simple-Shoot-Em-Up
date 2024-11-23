extends ParallaxBackground

@export var worldspeed: int = 100


func _process(delta: float) -> void:
    self.scroll_base_offset.y += worldspeed * delta
