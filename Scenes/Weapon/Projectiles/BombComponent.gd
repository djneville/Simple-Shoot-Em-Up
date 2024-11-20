# res://Scripts/BombComponent.gd
extends Area2D
class_name BombComponent

# Export Variables
@export var speed: float = 200.0
@export var direction: Vector2 = Vector2.DOWN  # TODO: UGH FIX THIS SO THAT ENEMIES ALWAYS SHOOT DOWN AND PLAYER UP
@export var velocity: Vector2 = Vector2.ZERO
@export var lifetime: float = 3.0
@export var damage: int = 7

@export var ownerr: Node  # TODO: fix this with actual owner reference and ancestry?????

@export var explosion_radius: float = 100.0

# Timers
@onready var lifetime_timer: Timer = Timer.new()

# Nodes
@onready var explosion_area: Area2D = $ExplosionArea
@onready var bomb_sprite: Sprite2D = $BombSprite
@onready var bomb_explosion_animation: AnimationPlayer = $BombExplosionAnimation


func _init() -> void:
	# Initialize non-node dependent properties
	self.set_process(false)


func _ready() -> void:
	self._initialize_velocity()
	self._initialize_timers()
	self._connect_signals()
	self.set_process(true)


func _initialize_velocity() -> void:
	self.velocity = self.direction.normalized() * self.speed


func _initialize_timers() -> void:
	self.lifetime_timer.wait_time = self.lifetime
	self.lifetime_timer.one_shot = true
	self.lifetime_timer.timeout.connect(self.explode)
	self.add_child(self.lifetime_timer)
	self.lifetime_timer.start()


func _connect_signals() -> void:
	self.body_entered.connect(_on_body_entered)
	self.bomb_explosion_animation.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	self.position += self.velocity * delta


func _on_body_entered(body: Node) -> void:
	if body == self.ownerr:
		return
	if body.is_in_group("enemy"):
		self.explode()


func explode() -> void:
	self.speed = 0
	self.bomb_sprite.visible = false
	self.bomb_explosion_animation.play("BombExplosion")
	self.explosion_area.body_entered.connect(_on_explosion_body_entered)


func _on_explosion_body_entered(body: Node) -> void:
	if body == self.ownerr:
		return
	body.take_damage(self.damage)


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "BombExplosion":
		self.queue_free()


# Getters/Setters
func get_ownerr() -> Node:
	return self.ownerr


func set_ownerr(new_owner: Node) -> void:
	self.ownerr = new_owner
