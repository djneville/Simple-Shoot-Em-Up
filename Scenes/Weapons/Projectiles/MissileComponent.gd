# res://Scripts/MissileComponent.gd
extends Area2D
class_name MissileComponent

# Export Variables
@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.DOWN  # TODO: UGH FIX THIS SO THAT ENEMIES ALWAYS SHOOT DOWN AND PLAYER UP
@export var velocity: Vector2 = Vector2.ZERO  # TODO THIS IS JUST HERE FOR REDUNDANCY!!!
@export var drag_factor: float = 0.03
@export var lifetime: float = 6.0
@export var damage: int = 1

@export var ownerr: Node  # TODO: fix this with actual owner reference and ancestry?????
@export var target: CharacterBody2D

# Timers
@onready var lifetime_timer: Timer = Timer.new()

# Nodes
@onready var missile_sprite: Sprite2D = $MissileSprite
@onready var missile_explosion_sprites: AnimatedSprite2D = $MissileExplosionSprites
@onready var missile_explosion_animation: AnimationPlayer = $MissileExplosionAnimation


func _init() -> void:
    # Initialize non-node dependent properties
    self.set_process(false)


func _ready() -> void:
    self._initialize_target()
    self._initialize_velocity()
    self._initialize_timers()
    self._connect_signals()
    self.set_process(true)


# Initialize Target by Finding the First Player in the "player" Group
func _initialize_target() -> void:
    # TODO: this implies that only the enemy can use this, fix it maybe later
    var players: Array = get_tree().get_nodes_in_group("player")
    if players.size() > 0:
        self.target = players[0]


# Initialize Velocity Based on Direction and Speed
func _initialize_velocity() -> void:
    self.velocity = self.direction.normalized() * self.speed


# Initialize and Configure Timers
func _initialize_timers() -> void:
    self.lifetime_timer.wait_time = self.lifetime
    self.lifetime_timer.one_shot = true
    self.lifetime_timer.timeout.connect(self.missile_explode)
    self.add_child(self.lifetime_timer)
    self.lifetime_timer.start()


# Connect Signals to Their Handlers
func _connect_signals() -> void:
    self.body_entered.connect(_on_body_entered)
    self.missile_explosion_animation.animation_finished.connect(_on_animation_timeout)


func _physics_process(delta: float) -> void:
    # TODO: figure out how to rotate the $MissileSprite as its direction changes
    var direction_towards_target: Vector2 = self.global_position.direction_to(
        self.target.global_position
    )
    var desired_velocity: Vector2 = direction_towards_target.normalized() * self.speed
    var dragged_velocity: Vector2 = (desired_velocity - self.velocity) * self.drag_factor
    self.velocity += dragged_velocity
    self.position += self.velocity * delta


func _on_body_entered(body: Node) -> void:
    if body == self.ownerr:
        return
    self.missile_explode()
    body.take_damage(self.damage)


func missile_explode() -> void:
    self.speed = 0
    self.missile_sprite.visible = false
    self.missile_explosion_sprites.visible = true
    self.missile_explosion_animation.play("MissileExplosion")


func _on_animation_timeout(anim_name: String) -> void:
    if anim_name == "MissileExplosion":
        self.queue_free()


# Getters/Setters
func get_ownerr() -> Node:
    return self.ownerr


func set_ownerr(new_owner: Node) -> void:
    self.ownerr = new_owner


func get_target() -> Node:
    return self.target


func set_target(new_target: Node) -> void:
    self.target = new_target
