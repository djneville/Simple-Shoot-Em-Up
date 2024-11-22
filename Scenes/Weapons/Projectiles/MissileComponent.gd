extends Projectile
class_name MissileComponent

@export var drag_factor: float = 0.03


@export var target: CharacterBody2D

@onready var missile_sprite: Sprite2D = $MissileSprite
@onready var missile_explosion_sprites: AnimatedSprite2D = $MissileExplosionSprites
@onready var missile_explosion_animation: AnimationPlayer = $MissileExplosionAnimation


func _ready() -> void:
    self._initialize_target()
    super._ready()

func _initialize_target() -> void:
    # TODO: this implies that only the enemy can use this, fix it maybe later
    var players: Array = get_tree().get_nodes_in_group("player")
    if players.size() > 0:
        self.target = players[0]


func _physics_process(delta: float) -> void:
    add_drag_to_missile()
    super._physics_process(delta)


func add_drag_to_missile():
    # TODO: figure out how to rotate the $MissileSprite as its direction changes
    var direction_towards_target: Vector2 = self.global_position.direction_to(
        self.target.global_position
    )
    var desired_velocity: Vector2 = direction_towards_target.normalized() * self.speed
    var dragged_velocity: Vector2 = (desired_velocity - self.velocity) * self.drag_factor
    self.velocity += dragged_velocity

func _on_impact() -> void:
    self.missile_explode()


func missile_explode() -> void:
    self.missile_sprite.visible = false
    self.missile_explosion_sprites.visible = true
    self.missile_explosion_animation.play("MissileExplosion")
    self.missile_explosion_animation.animation_finished.connect(_on_animation_timeout)


func _on_animation_timeout(anim_name: String) -> void:
    if anim_name == "MissileExplosion":
        self.queue_free()


func get_target() -> Node:
    return self.target


func set_target(new_target: Node) -> void:
    self.target = new_target
