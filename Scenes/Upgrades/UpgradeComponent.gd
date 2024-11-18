extends Node2D
class_name UpgradeComponent

# Constants
const MIN_UPGRADE_INDEX: int = 0
const MAX_UPGRADE_INDEX: int = 4  # Assuming 5 upgrades in the UPGRADES array

# Inner Class: Upgrade
class Upgrade:
    var upgrade_node_path: NodePath
    var speed: float
    var plane_sprite_path: NodePath
    var collision_shape_path: NodePath
    var explosion_animation: String

    func _init(
        _upgrade_node: NodePath,
        _speed: float,
        _plane_sprite: NodePath,
        _collision_shape: NodePath,
        _explosion_animation: String,
    ) -> void:
        upgrade_node_path = _upgrade_node
        speed = _speed
        plane_sprite_path = _plane_sprite
        collision_shape_path = _collision_shape
        explosion_animation = _explosion_animation

# TODO: non-static array might be dangerous, not sure how to do statics in GDScript
# also the Enum is worthless until maybe some sort of map + matching is needed
var UPGRADES: Array[Upgrade] = [
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
        "Explosion"
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

# Export Variables
@export var current_upgrade_index: int = 0

@export var active_upgrade_node: Node2D = null
@export var active_plane_sprite: Sprite2D = null
@export var active_collision_shape: CollisionShape2D = null
@export var active_explosion_animation: AnimationPlayer = null
@export var active_explosion_sprite: AnimatedSprite2D = null
@export var active_speed: float = 0.0

# Signals
var points: int = 0 #TODO: does nothing
signal give_points(points: int) #TODO: figure out how to maybe make this have effect on the Upgrade logic of the PlayerEntity

# Onready Node References
@onready var ship_explode_animation: AnimationPlayer = $ShipExplode
@onready var explosion_sprite: AnimatedSprite2D = $Explosion

func _init() -> void:
    # Initialize non-node dependent properties
    self.set_process(false)

func _ready() -> void:
    self._initialize()
    self._setup_signals()
    self.set_process(true)

# Initialization Function
func _initialize() -> void:
    #TODO: fix this, its only needed to allow for the first initialization of the active_upgrade_node
    var upgrade: Upgrade = UPGRADES[self.current_upgrade_index]
    self.active_upgrade_node = get_node(upgrade.upgrade_node_path) as Node2D
    self.active_upgrade_node.visible = false
    self._update_upgrade()

# Signal Connection Function
func _setup_signals() -> void:
    self.ship_explode_animation.animation_finished.connect(_on_animation_finished)

# Update Upgrade Function
func _update_upgrade() -> void:
    #TODO: figure out better way to avoid this stupid solution for upgrade array navigation
    if self.active_upgrade_node:
        self.active_upgrade_node.visible = false

    var upgrade: Upgrade = UPGRADES[self.current_upgrade_index]
    self.active_upgrade_node = get_node(upgrade.upgrade_node_path) as Node2D
    self.active_upgrade_node.visible = true

    self.active_speed = upgrade.speed
    self.active_plane_sprite = get_node(upgrade.plane_sprite_path) as Sprite2D
    self.active_explosion_animation = self.ship_explode_animation
    self.active_explosion_sprite = self.explosion_sprite

    var collision_shape_node: CollisionShape2D = get_node(upgrade.collision_shape_path) as CollisionShape2D
    self.active_collision_shape = CollisionShape2D.new()
    #TODO: this is to make a CollisionShape without the parent "Area2D"...
    self.active_collision_shape.shape = collision_shape_node.shape

# Upgrade Function
func upgrade() -> void:
    if self.current_upgrade_index >= UPGRADES.size() - 1: # EWWWWWWW I HATE computers
        return
    else:
        self.current_upgrade_index += 1
        self._update_upgrade()

# Downgrade Function
func downgrade() -> void:
    if self.current_upgrade_index <= MIN_UPGRADE_INDEX:
        return
    else:
        self.current_upgrade_index -= 1
        self._update_upgrade()

# Animation Finished Handler
func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "Explosion":
        # Emit give_points signal with the current points
        self.give_points.emit(self.points)
        self.queue_free()

# Getters/Setters
func get_current_upgrade_index() -> int:
    return self.current_upgrade_index

func set_current_upgrade_index(new_index: int) -> void:
    self.current_upgrade_index = new_index
    self._update_upgrade()
