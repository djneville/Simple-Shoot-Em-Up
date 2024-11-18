extends Area2D
class_name MissileComponent


@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.DOWN #TODO: UGH FIX THIS SO THAT ENEMIES ALWAYS SHOOT DOWN AND PLAYER UP
@export var velocity: Vector2 #TODO THIS IS JUST HERE FOR REDUNDANCY!!!
@export var drag_factor = 0.04
@export var lifetime: float = 10.0
@export var damage: int = 1

@export var ownerr: Node #TODO: fix this with actual owner reference and ancestory?????
@export var target: Node

func _ready():
    #TODO: this implies that only the enemy can use this, fix it maybe later
    self.target = get_tree().get_nodes_in_group("player")[0]
    
    self.velocity = self.direction * self.speed
    var lifetime_timer = Timer.new()
    lifetime_timer.wait_time = lifetime
    lifetime_timer.one_shot = true
    lifetime_timer.timeout.connect(missile_explode)
    add_child(lifetime_timer)
    lifetime_timer.start()
    body_entered.connect(_on_body_entered)
    $MissileExplosionAnimation.animation_finished.connect(_on_animation_timeout)

func _physics_process(delta):
    #TODO: figure out how to rotate the $MissileSprite as its direction changes
    var direction_towards_target = global_position.direction_to(self.target.global_position)
    var desired_velocity = direction_towards_target * self.speed
    var dragged_velocity = (desired_velocity - self.velocity) * drag_factor
    self.velocity += dragged_velocity
    position += self.velocity * delta

func _on_body_entered(body):
    if body == ownerr:
        return
    missile_explode()
    body.take_damage(damage)

func missile_explode():
    self.velocity = Vector2.ZERO
    $MissileSprite.visible = false
    $MissileExplosionAnimation.play("BombExplosion")

func _on_animation_timeout(anim_name):
    if anim_name == "MissileExplosion":
        self.queue_free()
