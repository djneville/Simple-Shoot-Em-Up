extends CharacterBody2D
class_name EnemyEntity

enum ProjectileType { BULLET, BOMB, MISSILE } #TODO: WHAT???? this cant be good

@onready var health = $HealthComponent
@onready var weapon = $WeaponComponent
@onready var upgrade_component = $UpgradeComponent
# THIS enemy_level GETS SET IN THE SPAWNER!!!!!!!!!!! AHHHHHHHHHHHHHHHH
@export var enemy_level: int = 0

signal give_points(points) #TODO: figure out how to maybe make this have effect on the Upgrade logic of the PlayerEntity

var points = 100

@export var path_speed: float = 0.0  # Speed along the path

func _ready():
    upgrade_component.current_upgrade_index = enemy_level # THIS GETS SET IN THE SPAWNER!!!!!!!!!!! AHHHHHHHHHHHHHHHH
    #TODO: this requirement of .update() to be called proves that @onready calls the _ready() of 
    # the upgrade_component before this classes _ready() func is called!!!!!!!!
    #TODO: update() relies on the`upgrade_component.current_upgrade_index` being set first and thats STUPID AND MISLEADING
    upgrade_component.update()
    
    match enemy_level:
        0: weapon.active_projectile_type = ProjectileType.BULLET
        2: weapon.active_projectile_type = ProjectileType.BULLET
        3: weapon.active_projectile_type = ProjectileType.MISSILE
        4: weapon.active_projectile_type = ProjectileType.BOMB
        
    self.path_speed = upgrade_component.active_speed #TODO: this seems sloppy, not sure where to best control speed yet
    
    upgrade_component.active_explosion_animation.animation_finished.connect(_on_animation_finished)
    var collision_shape = upgrade_component.active_collision_shape
    self.add_child(collision_shape)
    health.entity_died.connect(_death)

func _process(_delta):
    #TODO: figure out how to rotate the Enemy????? (maybe just the weapon? as the rotation changes on the path
    weapon.release_projectile(self, global_position, Vector2.DOWN)

func _death():
    health.entity_died.disconnect(_death) # TODO: is this the only way to prevent the signal from occuring more than once??? seems wack
    upgrade_component.active_explosion_sprite.visible = true
    upgrade_component.active_explosion_animation.play("Explosion")

func take_damage(damage):
    health.take_damage(damage)

func _on_animation_finished(anim_name):
    if anim_name == "Explosion":
        Gamestats.score += points
        give_points.emit(points)
        self.queue_free()
