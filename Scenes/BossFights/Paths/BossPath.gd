extends EnemyPath
class_name BossPath

#TODO: Child of EnemyPath


func _process(delta: float) -> void:
	self.progress += self.path_speed * delta
	if self.progress_ratio == 1:
		self.path_finished.emit()
