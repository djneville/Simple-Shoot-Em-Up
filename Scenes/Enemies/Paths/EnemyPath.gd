extends PathFollow2D

#TODO These `export properties are only accessible once this Node has been added to the Scene.
# so you first add_child this, and then you can set the path_speed
@export var path_speed: float = 0.0

signal path_finished


func _process(delta: float) -> void:
	self.progress += self.path_speed * delta
	if self.progress_ratio == 1:
		path_finished.emit()
		queue_free()
