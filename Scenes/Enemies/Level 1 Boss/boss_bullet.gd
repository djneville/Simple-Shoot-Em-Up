extends Area2D

var speed = 200

var direction = Vector2.ZERO

var splash = false

@onready var BulletAnims = $BulletAnims

func _process(delta):
	position += direction * delta * speed

func _on_body_entered(body):
	if body.is_in_group("player"):
		splash = true
		BulletAnims.play("explode")
		body.player_hit(1)


func _on_despawn_timer_timeout():
	BulletAnims.play("explode")
	pass

func set_direction(inputangle):
	direction = Vector2.from_angle(inputangle)
	rotation = inputangle
