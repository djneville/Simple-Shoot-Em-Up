extends Node2D
class_name WeaponComponent

#TODO: what in the fuck how can you load the scene not as the BulletComponent Class (the root node?!)
@export var bullet_scene: PackedScene = preload("res://Scenes/Projectiles/BulletComponent.tscn")

#TODO: at somepoint just use the default bullet properties
#TODO: make these customizable also
@export var bullet_speed: float = 400.0
@export var bullet_damage: int = 1
@export var fire_rate: float = 0.25 # Seconds between shots

@onready var shoot_timer = $FireTimer
#TODO: WHEN SHOULD WE PROGRAMMATICALLY ADD NODES OR NOT!!!??????

func _ready():
    shoot_timer.wait_time = fire_rate
    shoot_timer.one_shot = true  # One-shot timer for cooldown
    shoot_timer.timeout.connect(_on_timeout)

func fire_bullet(start_position: Vector2, direction: Vector2, shooter: Node):
    if shoot_timer.time_left == 0:
        var new_bullet = bullet_scene.instantiate()
        get_tree().current_scene.add_child(new_bullet)  # Add to main scene to prevent inheriting transforms
        new_bullet.global_position = start_position
        new_bullet.initialize(direction, bullet_speed, bullet_damage, shooter)  # Initialize bullet properties
        shoot_timer.start()
        $MuzzleFlash.play("MuzzleFlashAnimation") 
        # TODO: this is ugly but works only because the animation is
        # long enough to not happen more than once between the fire_rate occuring
        print("WeaponComponent: Bullet fired at", start_position, "direction", direction, "shooter:", shooter.name)


func _on_timeout():
    $MuzzleFlash.stop()
