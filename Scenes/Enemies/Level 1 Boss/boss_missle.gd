extends Area2D

var speed = 320
var current_velocity = Vector2.ZERO
var desired_velocity
var drag_factor = .03
var direction

var damage = 1

var splash = false

@onready var MissleAnims = $MissleAnims
@onready var target = get_tree().get_nodes_in_group("player")[0]

func _ready():
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
		MissleAnims.play("explode")
	pass


func _on_despawntimer_timeout():
	splash = true
	MissleAnims.play("explode")
	pass # Replace with function body.
