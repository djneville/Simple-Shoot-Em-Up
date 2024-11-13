extends CharacterBody2D

@export var reset_level := false

@onready var health = $HealthComponent
@onready var invulnerability = $InvulnerabilityComponent
@onready var weapon = $WeaponComponent
@onready var upgrade_component = $UpgradeComponent

func _ready():
    print("[PlayerEntity] _ready() called")
    position = Vector2(200, 400)
    #TODO: see the HealthBar.gd for where the health_changed signal gets handled
    health.entity_died.connect(_death)
    weapon.shoot_timer.one_shot = true # To avoid just shooting once???
    var collision_shape = CollisionShape2D.new()
    collision_shape.shape = upgrade_component.active_collision_shape.shape
    self.add_child(collision_shape)
    print("[PlayerEntity] Initialization complete")

func _death():
    print("[PlayerEntity] _death() called")
    upgrade_component.active_explosion_animation.play()
    Gamestats.lives -= 1
    Gamestats.score = 0
    print("[PlayerEntity] Lives left:", Gamestats.lives)
    if Gamestats.lives <= 0:
        Gamestats.gamestatus = "gameover"
        print("[PlayerEntity] Game over")
    else:
        Gamestats.gamestatus = "continue"
        print("[PlayerEntity] Continue game")
    reset_level = true

func heal(amount: int = 1):
    print("[PlayerEntity] heal() called with amount:", amount)
    if health.health == health.max_health:
        Gamestats.score += 300
        print("[PlayerEntity] Health is full. Added bonus score. New score:", Gamestats.score)
    else:
        health.heal(amount) #TODO: technically now this cant be entered at max health so check the logic here and fix
        print("[PlayerEntity] Healed. Current health:", health.health)

func take_damage(damage):
    print("[PlayerEntity] take_damage() called with damage:", damage)
    if not invulnerability.is_invulnerable:
        invulnerability.start_invulnerability()
        health.take_damage(damage)
        print("[PlayerEntity] Took damage. Current health:", health.health)
        upgrade_component.downgrade()
        print("[PlayerEntity] upgrade_component.downgrade() is commented out")
    else:
        print("[PlayerEntity] Invulnerable. Damage not applied")

func _handle_collide(body):
    print("[PlayerEntity] _on_collision_detection_body_entered() called with body:", body)
    if body.is_in_group("enemy"): #TODO: make this more clear that its not related to BULLETS (IDK IF GROUPS IS THE BEST WAY
        print("[PlayerEntity] Collision with enemy")
        body.take_damage(10)
        print("[PlayerEntity] Dealt 10 damage to enemy")
        take_damage(2)
    else:
        print("[PlayerEntity] Collision with non-enemy body")

func _process(_delta):
    var input_dir = Input.get_vector("left", "right", "up", "down")
    # TODO: delta here is often too low as the time for frame draw 
    self.velocity = input_dir * upgrade_component.speed # * delta
    # print("fps: ", 1 / delta)
    move_and_slide()
    for i in self.get_slide_collision_count():
        var collision = self.get_slide_collision(i)
        print("[PlayerEntity] collided with ", collision.get_collider().name)
        _handle_collide(collision.get_collider())
        
    if Input.is_action_pressed("shoot"):
        weapon.fire_bullet(self.global_position, Vector2.UP, self)
    if Input.is_action_pressed("bomb"):
        weapon.drop_bomb(self.global_position, self)
        
    if Input.is_action_just_pressed("upgrade"):
        print("[PlayerEntity] Upgrade key pressed")
        upgrade_component.upgrade()
    if Input.is_action_just_pressed("downgrade"):
        print("[PlayerEntity] Downgrade key pressed")
        upgrade_component.downgrade()
    clamp_viewport() #TODO: do this somehwere else like in the main scene when thats made

#TODO: figure out where to put this collision logic, probably just in the ItemEntity, NOT HERE!
func add_bomb():
    print("[PlayerEntity] add_bomb() called")
    pass 
    #if bombs < 7:
        #bombs += 1
    #else:
        #Gamestats.score += 250

#TODO: same as the add_bomb thing i think its an item, should be in the item entity
func give_upgrade():
    print("[PlayerEntity] give_upgrade() called")
    pass
    #if upgradelvl == 0:
        #upgrade_component.upgrade()
    #else:
        #Gamestats.score += 280

#TODO: this should not be in the player entity, but somewhere closer to the Main Scene (once the main scene gets created
func clamp_viewport():
    var plane_sprite = upgrade_component.active_plane_sprite
    global_position.x = clamp(global_position.x, plane_sprite.texture.get_width() / 2, get_viewport_rect().size.x - plane_sprite.texture.get_width() / 2)
    global_position.y = clamp(global_position.y, plane_sprite.texture.get_height() / 2, get_viewport_rect().size.y - plane_sprite.texture.get_height() / 2)
