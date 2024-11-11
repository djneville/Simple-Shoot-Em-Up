extends Area2D

var speed = -300

var damage = 1

var hit = false

func _process(delta):
    if !hit:
        position.y += delta * speed
        if position.y <= 0:
            hit = true
            $bombexplode.play("bombexplode")
#when this area2D collides (i.e. when the body_entered signal is emitted), then send the damage to that node

func _on_body_entered(body):
    if body.is_in_group("enemy"):
        hit = true
        $bombexplode.play("bombexplode")

func _on_despawn_timer_timeout():
    queue_free()

func _on_explosion_body_entered(body):
    if body.is_in_group("enemy") and !body.bombed:
        body.enemy_hit(50)
        body.bombed = true
