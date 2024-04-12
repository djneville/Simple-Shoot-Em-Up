extends Area2D

var speed = 90


func _process(delta):
	position += Vector2.DOWN * speed * delta
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.heal()
		queue_free()
	pass # Replace with function body.
