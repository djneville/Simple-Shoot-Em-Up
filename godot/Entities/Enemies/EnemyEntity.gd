extends CharacterBody2D
class_name EnemyEntity

# Components
@onready var health: HealthComponent = $HealthComponent
@onready var visibility: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
var upgrade_component: UpgradeComponent = null

var intra: PackedScene = preload("res://godot/Entities/UpgradeComponent.tscn")

# Export variables
# THIS enemy_level GETS SET IN THE SPAWNER!!!!!!!!!!! AHHHHHHHHHHHHHHHH
@export var enemy_level: int
@export var path_speed: float = 0.0  # Speed along the path

# Constants
const BASE_POINTS: int = 100
const PROJECTILE_DIRECTION: Vector2 = Vector2.DOWN

# Signals
signal give_points(points: int)  #TODO: figure out how to maybe make this have effect on the Upgrade logic of the PlayerEntity

# Properties
var points: int = BASE_POINTS


func _ready() -> void:
    self.upgrade_component = intra.instantiate()
    self.upgrade_component.current_upgrade_index = self.enemy_level
    self.add_child(upgrade_component)
    self._initialize()
    self._setup_signals()


func _setup_signals() -> void:
    self.upgrade_component.active_explosion_animation.animation_finished.connect(
        _on_animation_finished
    )
    self.health.entity_died.connect(_death)

func _initialize() -> void:
    self.health.set_current_health(1)
    # Configure upgrade component
    #self.upgrade_component.current_upgrade_index = self.enemy_level  # THIS GETS SET IN THE SPAWNER!!!!!!!!!!! AHHHHHHHHHHHHHHHH
    #TODO: this requirement of .update() to be called proves that @onready calls the _ready() of
    # the upgrade_component before this classes _ready() func is called!!!!!!!!
    #TODO: update() relies on the`upgrade_component.current_upgrade_index` being set first and thats STUPID AND MISLEADING
    #self.upgrade_component._update_upgrade()

    # Set up collision
    var collision_shape: CollisionShape2D = self.upgrade_component.active_collision_shape
    self.add_child(collision_shape)

    # Configure speed
    self.path_speed = self.upgrade_component.active_speed  #TODO: this seems sloppy, not sure where to best control speed yet


func _process(_delta: float) -> void:
    for weapon: Weapon in self.upgrade_component.active_weapons:
        weapon.fire(self, self.global_position, PROJECTILE_DIRECTION)


func _death() -> void:
    self.health.entity_died.disconnect(_death)  # TODO: is this the only way to prevent the signal from occuring more than once??? seems wack
    SignalBus.play_sfx.emit(preload(AudioConsts.SFX_534_OCARINA)) #TODO: cant post yet
    self.upgrade_component.active_explosion_sprite.visible = true
    self.upgrade_component.active_explosion_animation.play("Explosion")


func take_damage(damage: int) -> void:
    self.health.take_damage(damage)


#TODO: OVERWRITABLE??
func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "Explosion":
        #TODO: figure out a better way to handle all this score signalling and autoload vars
        GameStatsManager.score += self.points
        SignalBus.score_updated.emit()
        self.give_points.emit(self.points) #TODO: this does nothing still
        self.queue_free()


# Getters/Setters
func get_points() -> int:
    return self.points


func set_points(value: int) -> void:
    self.points = value
