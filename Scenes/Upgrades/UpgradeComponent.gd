extends Node2D
class_name UpgradeComponent
# somehow make these imporntant?...
enum UpgradeState {
    UPGRADE0,
    UPGRADE1,
}

class Upgrade:
    var upgrade_node_path: NodePath
    var speed: float
    var plane_sprite_path: NodePath
    var collision_shape_path: NodePath
    var explosion_animation: String # Optional

    func _init(_upgrade_node: NodePath, _speed: float, _plane_sprite: NodePath, _collision_shape: NodePath, _explosion_animation: String):
        upgrade_node_path = _upgrade_node
        speed = _speed
        plane_sprite_path = _plane_sprite
        collision_shape_path = _collision_shape
        explosion_animation = _explosion_animation
        
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
]

#TODO: optional Signals to notify Player or other components of upgrade changes
#signal upgraded(new_state)
#signal downgraded(new_state)

var upgrade_index: int = 0

# TODO: OH DEAR THIS LOOKS GROSS (again how much should be programmatic or not??)
var upgrade_node: Node2D 

# References to current active nodes
@export var active_plane_sprite: Sprite2D = null
@export var active_collision_shape: CollisionShape2D = null
@export var active_explosion_animation: AnimationPlayer = null

@export var speed: float = 0

#TODO: figure out a better way to be able to call apply_upgrade and the node freeing thing
func _ready():
    #apply_upgrade(UPGRADES[0]) 
    var base_upgrade = UPGRADES[0]
    
    upgrade_node = get_node(base_upgrade.upgrade_node_path) as Node2D
    
    speed = base_upgrade.speed
    
    active_plane_sprite = get_node(base_upgrade.plane_sprite_path) as Sprite2D

    active_collision_shape = get_node(base_upgrade.collision_shape_path) as CollisionShape2D
    
    # TODO: this doesnt actually work, you need to figure out a better way to do the Upgrade Logic either Singleton system or more Modular
    active_explosion_animation = $ShipExplode
    active_explosion_animation.current_animation = base_upgrade.explosion_animation

func upgrade():
    print("[UpgradeComponent] upgrade() called")
    upgrade_index += 1
    if upgrade_index >= UPGRADES.size():
        upgrade_index = UPGRADES.size() - 1
        print("[UpgradeComponent] Already at maximum upgrade level")
    else:
        print("[UpgradeComponent] Upgrading to index:", upgrade_index)
        apply_upgrade(UPGRADES[upgrade_index])

func downgrade():
    print("[UpgradeComponent] downgrade() called")
    if upgrade_index == 0:
        print("[UpgradeComponent] Already at minimum upgrade level")
        return
    else:
        upgrade_index -= 1
        print("[UpgradeComponent] Downgrading to index:", upgrade_index)
        apply_upgrade(UPGRADES[upgrade_index])
    print("DOWNGRADED!!!")

# Function to apply the upgrade based on the current index
func apply_upgrade(upgrade: Upgrade):
    print("[UpgradeComponent] apply_upgrade() called with upgrade index:", upgrade_index)
    print("Freeing old Nodes")
    #active_plane_sprite.queue_free()
    #TODO: oh my god next two lines are awful, im so sorry lol
    #active_collision_shape.queue_free()
    self.get_parent().find_child("CollisionShape2D").queue_free()
    
    speed = upgrade.speed
    print("[UpgradeComponent] Speed updated to:", speed)
    
    active_plane_sprite = get_node(upgrade.plane_sprite_path) as Sprite2D
    print("[UpgradeComponent] New active_plane_sprite added to upgrade_node")

    active_collision_shape = get_node(upgrade.collision_shape_path) as CollisionShape2D
    var collision_shape = CollisionShape2D.new()
    collision_shape.shape = active_collision_shape.shape
    self.get_parent().add_child(collision_shape) #TODO: I really dont like this shit
    
    # TODO: this doesnt actually work, you need to figure out a better way to do the Upgrade Logic either Singleton system or more Modular
    active_explosion_animation = $ShipExplode
    active_explosion_animation.current_animation = upgrade.explosion_animation
    print("[UpgradeComponent] Explosion animation updated to:", upgrade.explosion_animation)

func get_upgrade_level():
    print("[UpgradeComponent] get_upgrade_level() called")
    return upgrade_index
