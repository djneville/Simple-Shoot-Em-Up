extends Area2D

var speed = -800

var damage = 1

func _process(delta):
	position.y += delta * speed
	pass

#when this area2D collides (i.e. when the body_entered signal is emitted), then send the damage to that node

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.enemy_hit(damage)
		$bulletexplode.play("bullexplode")
	pass # Replace with function body.


func _on_despawn_timer_timeout():
	queue_free()
	pass # Replace with function body.
