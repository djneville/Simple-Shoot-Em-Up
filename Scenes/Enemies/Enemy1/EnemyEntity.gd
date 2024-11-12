extends CharacterBody2D

#TODO: I think i understand how this works, but i dont like it...
# what seems to be happening, is that anywhere this EnemyEntity is attached
# to in a Node tree it will be able to look UPwards in the tree in the parents for the PathFollow2D that it needs
# Yes, it allows for unique paths,but i dont like the inheretence wackyness
# There MUST be a better way to declare the existance of multiple enemy path types
# without having to attach the EnemyEntity to the Path, but rather the Path to the EnemyEntity
@onready var path_follow_2d = $".." #TODO NOOOOOOOOOOO
var PathRotation
var noPathRotation

@onready var health = $HealthComponent
@onready var weapon = $WeaponComponent

@export var fire_rate = 0.50 # Interval in seconds for shooting

func _ready():
    health.entity_died.connect(_death)

    weapon.shoot_timer.wait_time = fire_rate #TODO simple overwrite of the wait_time property of the weapon timer
    weapon.bullet_speed = -400
    path_follow_2d.progress_ratio_1.connect(_on_path_looped)

func _death():
    $ShipExplode.play("explode")
    # TODO: when do we free it?
    # queue_free()

#TODO: there might be a better way to directly be able to just call health's 
# take_damage without inheretince
func take_damage(damage):
    health.take_damage(damage)

func _process(_delta):
    PathRotation = path_follow_2d.rotation

    # Attempt to fire bullets as often as possible
    var bullet_direction = Vector2.UP # TODO: WHAT IN THE FUCK WHY IS THE DIRCETION VECTOR REVERSED
    # TODO:the next part doesnt work because i dont know how paths work AT ALL
    #if PathRotation != 0:
    #    bullet_direction = -Vector2(cos(PathRotation - PI / 2), sin(PathRotation - PI / 2))
    weapon.fire_bullet(self.global_position, bullet_direction, self)


func _on_path_looped(progress_ratio):
    print("Path looped! Progress ratio:", progress_ratio)
    queue_free()
