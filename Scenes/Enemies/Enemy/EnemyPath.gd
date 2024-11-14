extends PathFollow2D

var speed = 140

signal path_finished

func _process(delta):
    progress += speed * delta
    if self.progress_ratio == 1:
        path_finished.emit()
        queue_free()
