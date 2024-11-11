extends Area2D
class_name BulletComponent

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.UP # TODO can be any direction later
@export var lifetime: float = 20.0
@export var damage: int = 1

var velocity: Vector2 = Vector2.ZERO
var ownerr: Node #TODO: fix this with actual owner reference and ancestory?????

# Initialize function to set bullet properties
func initialize(new_direction: Vector2, new_speed: float, new_damage: int, shooter: Node):
    direction = new_direction.normalized()
    speed = new_speed
    damage = new_damage
    velocity = direction * speed
    ownerr = shooter
    print("Bullet initialized with direction:", direction, "Velocity:", velocity)


func _ready():
    velocity = direction.normalized() * speed
    var lifetime_timer = Timer.new()
    lifetime_timer.wait_time = lifetime
    lifetime_timer.one_shot = true # TODO: wtf
    lifetime_timer.timeout.connect(_on_timeout)
    add_child(lifetime_timer)
    lifetime_timer.start()
    print("Bullet direction:", direction, "Velocity:", velocity)

    #TODO: THIS IS IMPLICITELY ALREADY LINKED!!!!
    # body_entered.connect(_on_body_entered)

func _physics_process(delta):
    position += velocity * delta

# TODO: for all CharacterBody2Ds now we need a collision and area2d thing
func _on_body_entered(body):
    if body == ownerr:
        return  # Ignore collision with the shooter

    if body.has_method("take_damage"):
        body.take_damage(damage)
    
    # Play explosion animation if it exists
    $BulletExplosion.play("BulletExplosion")
    queue_free()

func _on_timeout():
    queue_free()
