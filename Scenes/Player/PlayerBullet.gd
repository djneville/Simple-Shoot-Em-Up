extends Area2D

var speed = -800

var splash = false

var damage = 1

func _process(delta):
	if !splash:
		position.y += delta * speed

#when this area2D collides (i.e. when the body_entered signal is emitted), then send the damage to that node

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		splash = true
		body.enemy_hit(damage)
		$bulletexplode.play("bullexplode")

func _on_despawn_timer_timeout():
	queue_free()
