extends Node
class_name Weapon

# Exported Variables
@export var fire_rate: float = 0.25:
    set = set_fire_rate, get = get_fire_rate
@export var projectile_type: ProjectileType.TYPE:
    set = set_projectile_type, get = get_projectile_type

var _timer: Timer


func _ready() -> void:
    _initialize_timer()

func _initialize_timer() -> void:
    _timer = Timer.new()
    _timer.wait_time = fire_rate
    _timer.one_shot = true
    add_child(_timer)

func can_fire() -> bool:
    return _timer.time_left == 0

func fire(shooter: Node, position: Vector2, direction: Vector2):
    if can_fire():
        var projectile: Projectile = ProjectileFactory.create_projectile(
            projectile_type, shooter, position, direction
        )
        _add_projectile_to_scene(projectile)
        _timer.start()

func _add_projectile_to_scene(projectile: Projectile) -> void:
    self.get_tree().current_scene.add_child(projectile)

func get_fire_rate() -> int:
    return fire_rate

func set_fire_rate(value) -> void:
    fire_rate = value

func get_projectile_type() -> ProjectileType.TYPE:
    return projectile_type

func set_projectile_type(value: ProjectileType.TYPE) -> void:
    projectile_type = value
