# res://Scripts/BulletComponent.gd
extends Area2D
class_name BulletComponent

# Export Variables
@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.DOWN  # TODO: UGH FIX THIS SO THAT ENEMIES ALWAYS SHOOT DOWN AND PLAYER UP
@export var velocity: Vector2 = Vector2.ZERO  # TODO THIS IS JUST HERE FOR REDUNDANCY!!!
@export var lifetime: float = 10.0
@export var damage: int = 1

@export var ownerr: Node  # TODO: fix this with actual owner reference and ancestry?????

# Timers
@onready var lifetime_timer: Timer = Timer.new()

# Nodes
@onready var bullet_sprite: Sprite2D = $BulletSprite
@onready var bullet_explosion_sprite: Sprite2D = $BulletExplosionSprite

func _init() -> void:
    # Initialize non-node dependent properties
    self.set_process(false)

func _ready() -> void:
    self._initialize_velocity()
    self._initialize_timers()
    self._connect_signals()
    self.set_process(true)

# Initialize Velocity Based on Direction and Speed
func _initialize_velocity() -> void:
    self.velocity = self.direction.normalized() * self.speed

# Initialize and Configure Timers
func _initialize_timers() -> void:
    self.lifetime_timer.wait_time = self.lifetime
    self.lifetime_timer.one_shot = true
    self.lifetime_timer.timeout.connect(self.queue_free)
    self.add_child(self.lifetime_timer)
    self.lifetime_timer.start()

# Connect Signals to Their Handlers
func _connect_signals() -> void:
    self.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    self.position += self.velocity * delta

func _on_body_entered(body: Node) -> void:
    if body == self.ownerr: #TODO: FIX THESE OWNERR BULLSHIT
        return
    self.speed = 0
    self.bullet_explosion_sprite.visible = true
    self.bullet_sprite.visible = false
    body.take_damage(self.damage)
    self.queue_free()

# Getters/Setters
func get_ownerr() -> Node:
    return self.ownerr

func set_ownerr(new_owner: Node) -> void:
    self.ownerr = new_owner
