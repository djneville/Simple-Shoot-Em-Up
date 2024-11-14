extends CharacterBody2D
class_name EnemyEntity

@onready var health = $HealthComponent
@onready var weapon = $WeaponComponent

signal give_points(points) #TODO: figure out how to maybe make this have effect on the Upgrade logic of the PlayerEntity

var points = 100

@export var fire_rate = 0.50 # Interval in seconds for shooting
@export var path_speed: float = 100.0  # Speed along the path

var path_length: float = 0.0
var progress: float = 0.0  # Current progress along the path

func _ready():
    print("[EnemyEntity] _ready() called")
    health.entity_died.connect(_death)
    $ShipExplode.animation_finished.connect(_on_animation_finished.bind("ShipExplode"))

    weapon.shoot_timer.wait_time = fire_rate #TODO simple overwrite of the wait_time property of the weapon timer
    

func _death():
    health.entity_died.disconnect(_death) # TODO: is this the only way to prevent the signal from occuring more than once??? seems wack
    print("[EnemyEntity] _death() called")
    Gamestats.score += points 
    $Explosion.visible = true #TODO: do we really start explicitely writing all this stuff?
    $ShipExplode.play("ShipExplode")
    give_points.emit(points)
    #TODO: this causes points to accrue every bullet collision?!!!!!!!????

#TODO: there might be a better way to directly be able to just call health's 
# take_damage without inheretince
func take_damage(damage):
    print("[EnemyEntity] take_damage() called with damage:", damage)
    health.take_damage(damage)

func _fire_bullet():
    if weapon.shoot_timer.is_stopped():
        var bullet_direction = Vector2.DOWN.rotated(rotation)
        weapon.fire_bullet(global_position, bullet_direction, self)
        weapon.shoot_timer.start()

func _process(_delta):
    _fire_bullet()

func _on_animation_finished(anim_name):
    if anim_name == "ShipExplode":
        queue_free()
