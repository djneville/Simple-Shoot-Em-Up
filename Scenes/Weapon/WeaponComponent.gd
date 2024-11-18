extends Node2D
class_name WeaponComponent

enum ProjectileType { BULLET, BOMB, MISSILE }

@export var active_projectile_type: ProjectileType

@export var bullet_fire_rate: float = 0.25 # Seconds between shots
@export var missile_launch_rate: float = 6.0 # Seconds between shots
@export var bomb_drop_rate: float = 1.5 # Seconds between shots

@export var bomb_inventory: int = 5

@onready var bullet_timer: Timer 
@onready var bomb_timer: Timer
@onready var missile_timer:Timer 

@onready var bullet_scene: PackedScene = preload("res://Scenes/Projectiles/BulletComponent.tscn")
@onready var bomb_scene: PackedScene = preload("res://Scenes/Projectiles/BombComponent.tscn")
@onready var missile_scene: PackedScene = preload("res://Scenes/Projectiles/MissileComponent.tscn")

signal bomb_inventory_change(new_bomb_inventory)

func _ready():
    bullet_timer = Timer.new()
    bullet_timer.wait_time = bullet_fire_rate
    bullet_timer.one_shot = true
    add_child(bullet_timer)
    
    bomb_timer = Timer.new()
    bomb_timer.wait_time = bomb_drop_rate
    bomb_timer.one_shot = true
    add_child(bomb_timer)
    
    missile_timer = Timer.new()
    missile_timer.wait_time = missile_launch_rate
    missile_timer.one_shot = true
    add_child(missile_timer)

func release_projectile(shooter: Node, start_position: Vector2, direction: Vector2):
    match self.active_projectile_type:
        ProjectileType.BULLET: fire_bullet(shooter, start_position, direction)
        ProjectileType.BOMB: drop_bomb(shooter, start_position, direction)
        ProjectileType.MISSILE: launch_missile(shooter, start_position, direction)

func fire_bullet(shooter: Node, start_position: Vector2, direction: Vector2):
    if bullet_timer.time_left == 0: #TODO: I really don tlike this timer
        $MuzzleFlash.play("MuzzleFlashAnimation")
        var new_bullet = bullet_scene.instantiate()
        new_bullet.ownerr = shooter
        new_bullet.direction = direction
        # THIS NEXT LINE NEEDS TO HAPPEN I GUESS BECAUSE THE CURRENT SCENE DOESNT KNOW WHERE TO PUT IT!!!!!
        new_bullet.position = start_position 
        get_tree().current_scene.add_child(new_bullet)# Add to main scene to prevent inheriting transforms of parent
        bullet_timer.start() 

func drop_bomb(shooter: Node, start_position: Vector2, direction: Vector2):
    if bomb_inventory == 0:
        return
    if bomb_timer.time_left == 0:
        var bomb = bomb_scene.instantiate()
        bomb.ownerr = shooter
        bomb.direction = direction
        bomb.position = start_position
        get_tree().current_scene.add_child(bomb)
        bomb_inventory -= 1
        bomb_inventory_change.emit(bomb_inventory)
        bomb_timer.start()

func launch_missile(shooter: Node, start_position: Vector2, direction: Vector2):
    if missile_timer.time_left == 0:
        var missile = missile_scene.instantiate()
        missile.ownerr = shooter
        missile.direction = direction
        missile.position = start_position
        get_tree().current_scene.add_child(missile)
        missile_timer.start()
