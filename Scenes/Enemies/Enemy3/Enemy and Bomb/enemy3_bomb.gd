extends Area2D

var speed = 300
var direction = Vector2.UP

var hit = false

var damage = 3

@onready var viewportedges = get_viewport().get_visible_rect()

func _ready():
	pass

func set_direction(inputangle):
	direction = Vector2.from_angle(inputangle)
	rotation = inputangle

func _process(delta):
	if !hit:
		position += direction * speed * delta
		if global_position.x > viewportedges.end.x or global_position.y > viewportedges.end.y or global_position.x < viewportedges.position.x or global_position.y < viewportedges.position.y:
			hit = true
			$enemybombexplode.play("enemybombexplode")
			pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		hit = true
		body.player_hit(damage)
		$enemybombexplode.play("enemybombexplode")

func _on_despawntimer_timeout():
	queue_free()


func _on_explosion_body_entered(body):
	if body.is_in_group("player"):
		body.player_hit(2)
