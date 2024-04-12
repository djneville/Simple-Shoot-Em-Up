extends Area2D

var speed = 300
var direction = Vector2.ZERO

var damage = 1

var splash = false

func set_direction(inputangle):
	direction = Vector2.from_angle(inputangle)	
	pass

func _process(delta):
	if !splash:
		position += direction * speed * delta
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.player_hit(damage)
		splash = true
		$bulletexplode.play("bullexplode")
	pass


func _on_despawntimer_timeout():
	queue_free()
	pass # Replace with function body.
