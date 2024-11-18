extends Area2D
class_name BulletComponent

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.DOWN #TODO: UGH FIX THIS SO THAT ENEMIES ALWAYS SHOOT DOWN AND PLAYER UP
@export var velocity: Vector2 #TODO THIS IS JUST HERE FOR REDUNDANCY!!!
@export var lifetime: float = 10.0
@export var damage: int = 1

@export var ownerr: Node #TODO: fix this with actual owner reference and ancestory?????

func _ready():
    self.velocity = self.direction * self.speed
    var lifetime_timer = Timer.new()
    lifetime_timer.wait_time = lifetime
    lifetime_timer.one_shot = true
    lifetime_timer.timeout.connect(self.queue_free)
    add_child(lifetime_timer)
    lifetime_timer.start()
    self.body_entered.connect(_on_body_entered)

func _physics_process(delta):
    self.position += self.velocity * delta

func _on_body_entered(body):
    if body == ownerr:
        return
    self.velocity = Vector2.ZERO
    $BulletExplosionSprite.visible = true
    $BulletSprite.visible = false
    body.take_damage(damage)
    self.queue_free()
