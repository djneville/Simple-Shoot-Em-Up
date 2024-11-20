extends PathFollow2D

var speed = 90

var activated = false

func _ready():
    progress_ratio = .25

func _process(delta):
    if activated:
        progress += speed * delta
    pass
