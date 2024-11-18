extends Area2D
class_name BombComponent

@export var speed: float = 200.0
@export var direction: Vector2 = Vector2.DOWN #TODO: UGH FIX THIS SO THAT ENEMIES ALWAYS SHOOT DOWN AND PLAYER UP
@export var velocity: Vector2
@export var lifetime: float = 3.0
@export var damage: int = 7

@export var ownerr: Node #TODO: fix this with actual owner reference and ancestory?????

@export var explosion_radius: float = 100.0
@onready var explosion_area = $ExplosionArea


func _ready():
    self.velocity = self.direction * self.speed
    var lifetime_timer = Timer.new()
    lifetime_timer.wait_time = lifetime
    lifetime_timer.one_shot = true
    lifetime_timer.timeout.connect(explode)
    add_child(lifetime_timer)
    lifetime_timer.start()
    body_entered.connect(_on_body_entered)
    #TODO: this is gross, you ahve to iterate through possible the signal handler arguments..
    $BombExplosionAnimation.animation_finished.connect(_on_animation_finished)


func _physics_process(delta):
    position += self.velocity * delta

func _on_body_entered(body):
    if body == ownerr:
        return
    if body.is_in_group("enemy"):
        explode()

func explode():
    self.velocity = Vector2.ZERO
    $BombSprite.visible = false 
    $BombExplosionAnimation.play("BombExplosion")
    explosion_area.body_entered.connect(_on_explosion_body_entered)

func _on_explosion_body_entered(body):
    if body == ownerr:
        return
    body.take_damage(damage)

    
func _on_animation_finished(anim_name):
    if anim_name == "BombExplosion": 
        self.queue_free()
