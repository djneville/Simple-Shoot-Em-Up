extends CharacterBody2D
class_name PlayerEntity

# Components
@onready var health: HealthComponent = $HealthComponent
@onready var invulnerability: InvulnerabilityComponent = $InvulnerabilityComponent
@onready var weapon: WeaponComponent = $WeaponComponent
@onready var upgrade_component: UpgradeComponent = $UpgradeComponent

# Constants
const INITIAL_POSITION: Vector2 = Vector2(200, 400)
const COLLISION_DAMAGE: int = 10
const PLAYER_DAMAGE: int = 2
const SCORE_HEALTH_BONUS: int = 300

# Signals
signal restart_level

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
    self.upgrade_component.active_explosion_animation.animation_finished.connect(_on_animation_finished)

func _initialize() -> void:
    # Initialize node-dependent properties
    self.position = INITIAL_POSITION
    
    var collision_shape: CollisionShape2D = self.upgrade_component.active_collision_shape
    self.add_child(collision_shape)

func _process(delta: float) -> void:
    self._handle_movement()
    self._handle_actions()
    self._clamp_viewport() #TODO: do this somehwere else like in the main scene when thats made

func _handle_movement() -> void:
    var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
    var speed: float = self.upgrade_component.active_speed
    self.velocity = input_vector * speed
    
    self.move_and_slide() #velocity is handled in here
    
    var collision_count: int = self.get_slide_collision_count()
    for i in range(collision_count):
        var collision: KinematicCollision2D = self.get_slide_collision(i)
        var collider: Node2D = collision.get_collider()
        self._handle_collide(collider)

func _handle_actions() -> void:
    if Input.is_action_pressed("shoot"):
        var bullet_direction: Vector2 = Vector2.UP
        self.weapon.fire_bullet(self, self.global_position, bullet_direction)
    
    if Input.is_action_pressed("bomb"):
        var bomb_direction: Vector2 = Vector2.DOWN
        self.weapon.drop_bomb(self, self.global_position, bomb_direction)
    
    if Input.is_action_just_pressed("upgrade"):
        self.upgrade_component.upgrade()
    
    if Input.is_action_just_pressed("downgrade"):
        self.upgrade_component.downgrade()

func _death() -> void:
    self.health.entity_died.disconnect(_death) # TODO: is this the only way to prevent the signal from occuring more than once??? seems wack
    self.upgrade_component.active_explosion_sprite.visible = true
    self.upgrade_component.active_explosion_animation.play("Explosion")

func take_damage(damage: int) -> void:
    if not self.invulnerability.is_invulnerable:
        self.invulnerability.start_invulnerability()
        self.health.take_damage(damage)
        self.upgrade_component.downgrade()

func heal(amount: int = 1) -> void:
    var current_health: int = self.health.health
    var max_health: int = self.health.max_health
    
    if current_health == max_health:
        Gamestats.score += SCORE_HEALTH_BONUS
    else:
        self.health.heal(amount) #TODO: technically now this cant be entered at max health so check the logic here and fix

func _handle_collide(body: Node2D) -> void:
    if body.is_in_group("enemy"): #TODO: make this more clear that its not related to BULLETS (IDK IF GROUPS IS THE BEST WAY
        body.take_damage(COLLISION_DAMAGE)
        self.take_damage(PLAYER_DAMAGE)

func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "Explosion":
        Gamestats.lives -= 1
        Gamestats.score = 0
        
        if Gamestats.lives <= 0:
            Gamestats.game_over.emit()        
        self.restart_level.emit()

#TODO: figure out where to put this collision logic, probably just in the ItemEntity, NOT HERE!
func add_bomb() -> void:
    pass 
    #if bombs < 7:
        #bombs += 1
    #else:
        #Gamestats.score += 250

#TODO: same as the add_bomb thing i think its an item, should be in the item entity
func give_upgrade() -> void:
    pass
    #if upgradelvl == 0:
        #upgrade_component.upgrade()
    #else:
        #Gamestats.score += 280

#TODO: this should not be in the player entity, but somewhere closer to the Main Scene (once the main scene gets created
func _clamp_viewport() -> void:
    var plane_sprite: Sprite2D = self.upgrade_component.active_plane_sprite
    var texture_width: float = plane_sprite.texture.get_width()
    var texture_height: float = plane_sprite.texture.get_height()
    var viewport_size: Vector2 = get_viewport_rect().size
    
    self.global_position.x = clamp(
        self.global_position.x,
        texture_width / 2,
        viewport_size.x - texture_width / 2
    )
    
    self.global_position.y = clamp(
        self.global_position.y,
        texture_height / 2,
        viewport_size.y - texture_height / 2
    )
