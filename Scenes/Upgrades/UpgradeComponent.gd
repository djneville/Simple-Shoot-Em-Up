extends Node2D
class_name UpgradeComponent

class Upgrade:
    var upgrade_node_path: NodePath
    var speed: float
    var plane_sprite_path: NodePath
    var collision_shape_path: NodePath
    var explosion_animation: String
    var weapon_component: WeaponComponent

    func _init(
        _upgrade_node: NodePath,
        _speed: float,
        _plane_sprite: NodePath,
        _collision_shape: NodePath,
        _explosion_animation: String,
        _weapon_component: WeaponComponent = null):

        upgrade_node_path = _upgrade_node
        speed = _speed
        plane_sprite_path = _plane_sprite
        collision_shape_path = _collision_shape
        explosion_animation = _explosion_animation
        weapon_component = _weapon_component
        
        
        
# TODO: non-static array might be dangerous, not sure how to do statics in GDScript
# also the Enum is worthless until maybe some sort of map + matching is needed
var UPGRADES: Array = [
    Upgrade.new(
        "Upgrade0",
        150.0,
        "Upgrade0/PlaneSprite",
        "Upgrade0/Area2D/CollisionShape2D",
        "Explosion"
    ),
    Upgrade.new(
        "Upgrade1",
        200.0,
        "Upgrade1/PlaneSprite",
        "Upgrade1/Area2D/CollisionShape2D",
        "Explosion"
    ),
    Upgrade.new(
        "EnemyUpgrade0",
        100.0,
        "EnemyUpgrade0/PlaneSprite",
        "EnemyUpgrade0/Area2D/CollisionShape2D",
        "Explosion",
    ),
    Upgrade.new(
        "EnemyUpgrade1",
        80.0,
        "EnemyUpgrade1/PlaneSprite",
        "EnemyUpgrade1/Area2D/CollisionShape2D",
        "Explosion"
    ),
    Upgrade.new(
        "EnemyUpgrade2",
        80.0,
        "EnemyUpgrade2/PlaneSprite",
        "EnemyUpgrade2/Area2D/CollisionShape2D",
        "Explosion"
    ),
]

@export var current_upgrade_index: int = 0

@export var active_upgrade_node: Node2D = null
@export var active_plane_sprite: Sprite2D = null
@export var active_collision_shape: CollisionShape2D = null
@export var active_explosion_animation: AnimationPlayer = null
@export var active_explosion_sprite: AnimatedSprite2D = null
@export var active_speed: float = 0

func _ready():
    #TODO: fix this, its only needed to allow for the first initialization of the active_upgrade_node
    var upgrade = UPGRADES[self.current_upgrade_index]
    self.active_upgrade_node = get_node(upgrade.upgrade_node_path) as Node2D
    update()

func update():
    #TODO: tfigure out better way to avoid this stupid solution for upgrade array navigation
    self.active_upgrade_node.visible = false
    
    var upgrade = UPGRADES[self.current_upgrade_index]
    self.active_upgrade_node = get_node(upgrade.upgrade_node_path) as Node2D
    self.active_upgrade_node.visible = true
    
    self.active_speed = upgrade.speed
    self.active_plane_sprite = get_node(upgrade.plane_sprite_path) as Sprite2D
    self.active_explosion_animation = $ShipExplode
    self.active_explosion_sprite = $Explosion
    
    var collision_shape = get_node(upgrade.collision_shape_path) as CollisionShape2D
    self.active_collision_shape = CollisionShape2D.new()
     #TODO: this is to make a CollisionShhpe without the parent "Area2D"...
    active_collision_shape.shape = collision_shape.shape

func upgrade():
    if self.current_upgrade_index == UPGRADES.size() - 1: # EWWWWWWW I HATE computers
        return
    else:
        self.current_upgrade_index += 1
        update()

func downgrade():
    if self.current_upgrade_index == 0:
        return
    else:
        self.current_upgrade_index -= 1
        update()
