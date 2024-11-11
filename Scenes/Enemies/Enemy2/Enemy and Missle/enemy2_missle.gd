extends Area2D

var speed = 300
var current_velocity = Vector2.ZERO
var desired_velocity
var drag_factor = .04
var direction

var damage = 1

var splash = false
var target

func _ready():
    $missletailflicker.play("tailflicker")
    target = get_tree().get_nodes_in_group("player")[0]
    current_velocity = speed * Vector2.DOWN 
    pass


func _process(delta):
    if !splash:	
        if !target:
            direction = Vector2.DOWN.normalized()
            rotation = PI/2
        if target:
            direction = global_position.direction_to(target.global_position)
        
        desired_velocity = direction * speed
        var change = (desired_velocity - current_velocity) * drag_factor
        current_velocity += change
        position += current_velocity * delta
        look_at(global_position + current_velocity)
    pass


func _on_body_entered(body):
    if body.is_in_group("player"):
        splash = true
        body.player_hit(damage)
        $missleexplode.play("missleexplode")
    pass


func _on_despawntimer_timeout():
    splash = true
    $missleexplode.play("missleexplode")
    pass # Replace with function body.
