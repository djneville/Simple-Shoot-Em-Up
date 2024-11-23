extends Area2D
class_name Projectile

# Exported Variables with Default Values
@export var speed: float:
    set = set_speed,
    get = get_speed
@export var direction: Vector2:
    set = set_direction,
    get = get_direction
@export var lifetime: float:
    set = set_lifetime,
    get = get_lifetime
@export var damage: int:
    set = set_damage,
    get = get_damage
@export var projectile_owner: Node:
    set = set_projectile_owner,
    get = get_projectile_owner

# Internal Variables
var velocity: Vector2
var lifetime_timer: Timer


func _ready() -> void:
    _initialize_velocity()
    _initialize_and_add_lifetime_timer()
    _connect_signals()


func _initialize_velocity() -> void:
    velocity = direction.normalized() * speed


func _initialize_and_add_lifetime_timer() -> void:
    lifetime_timer = Timer.new()
    lifetime_timer.wait_time = lifetime
    lifetime_timer.one_shot = true
    lifetime_timer.timeout.connect(_on_lifetime_timeout)
    add_child(lifetime_timer)
    lifetime_timer.start()


func _connect_signals() -> void:
    body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
    position += velocity * delta


func _on_body_entered(body: Node) -> void:
    if body == projectile_owner:
        return
    self.set_physics_process(false)
    body.take_damage(damage)
    _on_impact()


func _on_lifetime_timeout() -> void:
    queue_free()


func _on_impact() -> void:
    queue_free()


# Getters and Setters


func get_speed() -> float:
    return speed


func set_speed(value: float) -> void:
    speed = value
    _initialize_velocity()  # Recalculate velocity when speed changes


func get_direction() -> Vector2:
    return direction


func set_direction(value: Vector2) -> void:
    direction = value.normalized()
    _initialize_velocity()  # Recalculate velocity when direction changes


func get_lifetime() -> float:
    return lifetime


func set_lifetime(value: float) -> void:
    lifetime = value
    if lifetime_timer:
        lifetime_timer.wait_time = lifetime
        lifetime_timer.start()


func get_damage() -> int:
    return damage


func set_damage(value: int) -> void:
    damage = value


func get_projectile_owner() -> Node:
    return projectile_owner


func set_projectile_owner(value: Node) -> void:
    projectile_owner = value
