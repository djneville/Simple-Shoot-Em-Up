extends Marker2D

var to_spawn = "Enemy1Path1"

func _process(_delta):
    position += Vector2.DOWN * 100 * _delta
