extends Area2D
class_name BombComponent

@export var speed: float = 200.0
@export var damage: int = 50
@export var explosion_radius: float = 100.0
@export var lifetime: float = 3.0

var ownerr: Node

@onready var explosion_area = $ExplosionArea

func initialize(shooter: Node):
    ownerr = shooter
    # TODO:improve how these initialize functions work, with defaults and stuff


func _ready():
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
    var velocity = Vector2.DOWN * speed
    position += velocity * delta

func _on_body_entered(body):
    if body == ownerr:
        return
    if body.is_in_group("enemy"):
        explode()

func explode():
    print("BOMB EXPLODED at:", self.global_position)
    $BombSprite.visible = false 
    self.speed = 0
    $BombExplosionAnimation.play("BombExplosion")
    explosion_area.body_entered.connect(_on_explosion_body_entered)

func _on_explosion_body_entered(body):
    if body == ownerr:
        return
    if body.is_in_group("enemy"):
        body.take_damage(damage)

    
#TODO: this is ridiculous, unexlpained way to have "NO ARGS" to a signal handler...
func _on_animation_finished(anim_name):
    if anim_name == "BombExplosion": # LMAO
        print("ENTERED!!!") # NOOOOOO EWWWWWW IT WORKED....
        self.queue_free()
