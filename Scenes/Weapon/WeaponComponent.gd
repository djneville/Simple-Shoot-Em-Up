extends Node2D
class_name WeaponComponent

#TODO: Dwight: WE CAN ABSTRACT THIS WHOLE THING EVEN FURTHER TO JUST ONE METHOD OF "release projectile",
# and then not have to have separate methods for the bullet and bomb projectiles. and instead all the logic for
# different Projectile behavior can be done in versions of a Projectile Node
#TODO: 
enum ProjectileType { BULLET, BOMB }
#TODO: what in the fuck how can you load the scene not as the BulletComponent Class (the root node?!)
@export var bullet_scene: PackedScene = preload("res://Scenes/Projectiles/BulletComponent.tscn")
@export var bomb_scene: PackedScene = preload("res://Scenes/Projectiles/BombComponent.tscn")

#TODO: at somepoint just use the default bullet properties
#TODO: make these customizable also
@export var bullet_speed: float = 400.0
@export var bullet_damage: int = 1
@export var fire_rate: float = 0.25 # Seconds between shots

@export var bomb_inventory: int = 5
signal bomb_inventory_change(new_bomb_inventory)

#TODO: WHEN SHOULD WE PROGRAMMATICALLY ADD NODES OR NOT!!!??????
# When trying to initialize these in the _ready as just Timer.new() things go wrong for some reason
@onready var shoot_timer = $BulletTimer 
@onready var bomb_timer = $BombTimer


func _ready():
    print("[WeaponComponent] _ready() called")
    shoot_timer.wait_time = fire_rate
    shoot_timer.one_shot = true
    shoot_timer.timeout.connect(_on_timeout)
    
    bomb_timer.wait_time = fire_rate
    bomb_timer.one_shot = true # this is misleading, it means that the timer goes forever, not once?
    #TODO: for now there is no reason to have a timeout for the bomb other than just its default queue_free(no animations?)

func fire_bullet(start_position: Vector2, direction: Vector2, shooter: Node):
    if shoot_timer.time_left == 0:
        var new_bullet = bullet_scene.instantiate()
        new_bullet.initialize(direction, bullet_speed, bullet_damage, shooter)  # Initialize bullet properties
        get_tree().current_scene.add_child(new_bullet)  # Add to main scene to prevent inheriting transforms
        new_bullet.global_position = start_position
        shoot_timer.start()
        $MuzzleFlash.play("MuzzleFlashAnimation") 
        print("[WeaponComponent] Bullet fired at", start_position, "direction", direction, "shooter:", shooter.name)
        # TODO: this is ugly but works only because the animation is
        # long enough to not happen more than once between the fire_rate occuring
        #print("WeaponComponent: Bullet fired at", start_position, "direction", direction, "shooter:", shooter.name)

func drop_bomb(start_position: Vector2, shooter: Node):
    print("[WeaponComponent] drop_bomb() called")
    #TODO: this is bad place, figure out somehwere else
    if bomb_inventory == 0:
        print("[WeaponComponent] No bombs left to drop")
        return
    #TODO: I dont like this, there should be a better way to use the timer.
    if bomb_timer.time_left == 0:
        var bomb = bomb_scene.instantiate()
        get_tree().current_scene.add_child(bomb)  # Add to main scene to prevent inheriting transforms
        bomb.global_position = start_position
        #TODO: look at init functions!! fix the defaults and stuff 
        bomb.initialize(shooter)  # Initialize bullet properties
        bomb_timer.start()
        bomb_inventory -= 1
        bomb_inventory_change.emit(bomb_inventory)
        print("[WeaponComponent] Bomb dropped at", start_position, "shooter:", shooter.name)
        # TODO: this is ugly but works only because the animation is
        # long enough to not happen more than once between the fire_rate occuring


#TODO: confused on why this is needed here but can change this when projectile's abstraction is created
func _on_timeout():
    #print("[WeaponComponent] _on_timeout() called")
    $MuzzleFlash.stop()
