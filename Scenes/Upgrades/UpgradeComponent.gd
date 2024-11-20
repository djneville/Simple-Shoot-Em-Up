extends Node2D
class_name UpgradeComponent

# Constants
const MIN_UPGRADE_INDEX: int = 0

# Export Variables
@export var current_upgrade_index: int = 0

@export var active_plane_sprite: Sprite2D = null
@export var active_collision_shape: CollisionShape2D = null
@export var active_explosion_animation: AnimationPlayer = null
@export var active_explosion_sprite: AnimatedSprite2D = null
@export var active_speed: float = 0.0
@export var active_projectile_type: Projectile.TYPE = Projectile.TYPE.BULLET

# Signals
var points: int = 0  #TODO: does nothing
signal give_points(points: int)  #TODO: figure out how to maybe make this have effect on the Upgrade logic of the PlayerEntity

@onready var ship_explode_animation: AnimationPlayer = $ShipExplode
@onready var explosion_sprite: AnimatedSprite2D = $Explosion


func _ready() -> void:
	self._initialize()
	self._setup_signals()


func _initialize() -> void:
	self._update_upgrade()


func _setup_signals() -> void:
	self.ship_explode_animation.animation_finished.connect(_on_animation_finished)


func _update_upgrade() -> void:
	if self.active_plane_sprite:
		self.active_plane_sprite.queue_free()  #Free the current sprite
	var upgrade_data: UpgradeData = UpgradeManager.upgrades[self.current_upgrade_index]
	self.active_plane_sprite = Sprite2D.new()
	self.active_plane_sprite.set_texture(upgrade_data.plane_sprite_texture)
	self.active_collision_shape = CollisionShape2D.new()
	self.active_collision_shape.set_shape(upgrade_data.collision_shape)
	self.active_speed = upgrade_data.speed
	self.active_projectile_type = upgrade_data.projectile_type
	self.active_explosion_sprite = self.explosion_sprite
	self.active_explosion_animation = self.ship_explode_animation
	add_child(self.active_plane_sprite)  #add the newest active sprite


func upgrade() -> void:
	if self.current_upgrade_index >= UpgradeManager.upgrades.size() - 1:  # EWWWWWWW I HATE computers
		return
	else:
		self.current_upgrade_index += 1
		self._update_upgrade()


func downgrade() -> void:
	if self.current_upgrade_index <= MIN_UPGRADE_INDEX:
		return
	else:
		self.current_upgrade_index -= 1
		self._update_upgrade()


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Explosion":
		self.give_points.emit(self.points)
		self.queue_free()


func get_current_upgrade_index() -> int:
	return self.current_upgrade_index


func set_current_upgrade_index(new_index: int) -> void:
	self.current_upgrade_index = new_index
	self._update_upgrade()
