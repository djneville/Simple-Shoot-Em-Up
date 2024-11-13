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
    print("[BulletComponent] initialize() called")
    direction = new_direction.normalized()
    speed = new_speed
    damage = new_damage
    ownerr = shooter
    print("[BulletComponent] Initialized with direction:", direction, "speed:", speed, "damage:", damage, "owner:", ownerr.name)
    #print("Bullet initialized with direction:", direction, "Velocity:", velocity)

func _ready():
    print("[BulletComponent] _ready() called")
    velocity = direction.normalized() * speed
    var lifetime_timer = Timer.new()
    lifetime_timer.wait_time = lifetime
    lifetime_timer.one_shot = true # TODO: wtf
    lifetime_timer.timeout.connect(_on_timeout)
    add_child(lifetime_timer)
    lifetime_timer.start()
    #print("[BulletComponent] Bullet direction:", direction, "Velocity:", velocity)
    #TODO: THIS IS IMPLICITELY ALREADY LINKED!!!!
    # body_entered.connect(_on_body_entered)

func _physics_process(delta):
    #print("[BulletComponent] _physics_process() called with delta:", delta)
    position += velocity * delta

# TODO: for all CharacterBody2Ds now we need a collision and area2d thing
func _on_body_entered(body):
    print("[BulletComponent] _on_body_entered() called with body:", body.name)
    if body == ownerr:
        print("[BulletComponent] Collision with owner, ignoring")
        return  # Ignore collision with the shooter
    $BulletExplosion.play("BulletExplosion")
    print("[BulletComponent] Collision with", body.name, "applying damage:", damage)
    body.take_damage(damage)
    #TODO: No need to FREE here because I guess it just disappears from the animation and then lifetime timeout????? seems bad

#TODO: This is perhaps just a default _on_timeout that can get overwritten in the WeaponComponent?
func _on_timeout():
    print("[BulletComponent] _on_timeout() called")
    queue_free()
