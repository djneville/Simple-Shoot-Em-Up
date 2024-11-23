extends CharacterBody2D
class_name PlayerEntity

# Components
@onready var health: HealthComponent = $HealthComponent
@onready var invulnerability: InvulnerabilityComponent = $InvulnerabilityComponent
@onready var upgrade_component: UpgradeComponent = $UpgradeComponent

# Constants
const INITIAL_POSITION: Vector2 = Vector2(200, 400)
const COLLISION_DAMAGE: int = 10
const PLAYER_DAMAGE: int = 2
const SCORE_HEALTH_BONUS: int = 300
const SCORE_BOMB_BONUS: int = 250
const SCORE_UPGRADE_BONUS: int = 280


func _init() -> void:
    # Initialize any non-node properties here
    # Note: Can't access nodes in _init as they're not ready yet
    self.set_physics_process(false)
    self.set_process(false)


func _ready() -> void:
    self._initialize()
    self._setup_signals()
    self.set_physics_process(true)
    self.set_process(true)


func _setup_signals() -> void:
    # Connect all signals
    self.health.entity_died.connect(_death)
    self.upgrade_component.active_explosion_animation.animation_finished.connect(
        _on_animation_finished
    )


func _initialize() -> void:
    var collision_shape: CollisionShape2D = self.upgrade_component.active_collision_shape
    self.add_child(collision_shape)


func _process(_delta: float) -> void:
    self._handle_movement()
    self._handle_actions()


func _handle_movement() -> void:
    var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
    var speed: float = self.upgrade_component.active_speed
    self.velocity = input_vector * speed

    self.move_and_slide()  #velocity is handled in here

    var collision_count: int = self.get_slide_collision_count()
    for i: int in range(collision_count):
        var collision: KinematicCollision2D = self.get_slide_collision(i)
        var collider: EnemyEntity = collision.get_collider()
        self._handle_collide(collider)


func _handle_actions() -> void:
    if upgrade_component.get_node("Gun") and Input.is_action_pressed("shoot"):
        var gun: Gun = upgrade_component.get_node("Gun")
        gun.fire(self, position, Vector2.UP)
    if upgrade_component.get_node("Canon") and Input.is_action_pressed("bomb"):
        var canon: Canon = upgrade_component.get_node("Canon")
        canon.fire(self, position, Vector2.DOWN)
    if Input.is_action_just_pressed("upgrade"):
        self.upgrade_component.upgrade()
    if Input.is_action_just_pressed("downgrade"):
        self.upgrade_component.downgrade()


func _death() -> void:
    self.health.entity_died.disconnect(_death)  # TODO: is this the only way to prevent the signal from occuring more than once??? seems wack
    self.upgrade_component.active_explosion_sprite.visible = true
    self.upgrade_component.active_explosion_animation.play("Explosion")


func take_damage(damage: int) -> void:
    if not self.invulnerability.is_invulnerable:
        self.invulnerability.start_invulnerability()
        self.health.take_damage(damage)
        self.upgrade_component.downgrade()


func heal(amount: int = 1) -> void:
    if self.health.get_current_health() == self.health.get_max_health():
        SignalBus.score_bonus.emit(SCORE_HEALTH_BONUS)
    else:
        self.health.heal(amount)


func _handle_collide(body: EnemyEntity) -> void:
    if body.is_in_group("enemy"):  #TODO: GROUPS IS NOT A GOOD IDEA, TOO HACKY (boss and enemy are different sometimes
        body.take_damage(COLLISION_DAMAGE)
        self.take_damage(PLAYER_DAMAGE)


func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "Explosion":
        SignalBus.life_lost.emit()  #TODO handle this with gameover elsewhere


#TODO: figure out where to put this collision logic, probably just in the ItemEntity, NOT HERE!
func add_bomb_to_inventory() -> void:
    if upgrade_component.active_weapon_types.has(WeaponType.TYPE.CANON):
        var canon: Canon = upgrade_component.get_node("Canon")
        if canon.get_bomb_inventory() < canon.get_max_bomb_inventory():
            canon.set_bomb_inventory(canon.get_bomb_inventory() + 1)
            return
    SignalBus.score_bonus.emit(SCORE_BOMB_BONUS)


func upgrade() -> void:
    if upgrade_component.get_current_upgrade_index() != 0:
        SignalBus.score_bonus.emit(SCORE_UPGRADE_BONUS)
    else:
        upgrade_component.upgrade()
