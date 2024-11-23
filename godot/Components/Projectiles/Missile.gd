extends Projectile
class_name Missile

@export var drag_factor: float = 0.04

@export var target: CharacterBody2D

const TURN_THRESHOLD = deg_to_rad(60)  # 60 degrees
var previous_rotation = 0.0  # Track rotation from the last check

func _ready() -> void:
    self._initialize_target()
    previous_rotation = self.rotation
    super._ready()


func _initialize_target() -> void:
    # TODO: this implies that only the enemy can use this, fix it maybe later
    var players: Array = get_tree().get_nodes_in_group("player")
    if players.size() > 0:
        self.target = players[0]


func _physics_process(delta: float) -> void:
    $ExhaustFlicker.play("ExhaustFlicker")
    add_drag_to_missile()
    super._physics_process(delta)


func add_drag_to_missile():
    var direction_towards_target: Vector2 = self.global_position.direction_to(
        self.target.global_position
    )
    #TODO: update missile direction to face player or something
    rotation = direction_towards_target.angle() + PI/2
    var desired_velocity: Vector2 = direction_towards_target.normalized() * self.speed
    var dragged_velocity: Vector2 = (desired_velocity - self.velocity) * self.drag_factor
    self.velocity += dragged_velocity

func _on_impact() -> void:
    self.missile_explode()


func missile_explode() -> void:
    $AnimationPlayer.play("Explode")
    $AnimationPlayer.animation_finished.connect(_on_animation_timeout)


func _on_animation_timeout(anim_name: String) -> void:
    if anim_name == "Explode":
        self.queue_free()


func get_target() -> Node:
    return self.target


func set_target(new_target: Node) -> void:
    self.target = new_target
