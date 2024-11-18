extends CharacterBody2D
class_name PlayerEntity

@onready var health = $HealthComponent
@onready var invulnerability = $InvulnerabilityComponent
@onready var weapon = $WeaponComponent
@onready var upgrade_component = $UpgradeComponent

signal restart_level()

func _ready():
    print("[PlayerEntity] _ready() called")
    position = Vector2(200, 400)
    health.entity_died.connect(_death)
    upgrade_component.active_explosion_animation.animation_finished.connect(_on_animation_finished)
    var collision_shape = upgrade_component.active_collision_shape
    self.add_child(collision_shape)

func _process(_delta):
    var input_vector = Input.get_vector("left", "right", "up", "down")
    self.velocity = input_vector * upgrade_component.active_speed
    
    move_and_slide() #velocity is handled in here
    
    for i in self.get_slide_collision_count():
        var collision = self.get_slide_collision(i)
        _handle_collide(collision.get_collider())
    
    if Input.is_action_pressed("shoot"):
        weapon.fire_bullet(self, self.global_position, Vector2.UP)
    if Input.is_action_pressed("bomb"):
        weapon.drop_bomb( self, self.global_position, Vector2.DOWN)
    if Input.is_action_just_pressed("upgrade"):
        upgrade_component.upgrade()
    if Input.is_action_just_pressed("downgrade"):
        upgrade_component.downgrade()
    
    clamp_viewport() #TODO: do this somehwere else like in the main scene when thats made

func _death():
    health.entity_died.disconnect(_death) # TODO: is this the only way to prevent the signal from occuring more than once??? seems wack
    upgrade_component.active_explosion_sprite.visible = true
    upgrade_component.active_explosion_animation.play("Explosion")

func take_damage(damage):
    if not invulnerability.is_invulnerable:
        invulnerability.start_invulnerability()
        health.take_damage(damage)
        print("[PlayerEntity] Took damage. Current health:", health.health)
        upgrade_component.downgrade()

func heal(amount: int = 1):
    if health.health == health.max_health:
        Gamestats.score += 300
    else:
        health.heal(amount) #TODO: technically now this cant be entered at max health so check the logic here and fix

func _handle_collide(body):
    if body.is_in_group("enemy"): #TODO: make this more clear that its not related to BULLETS (IDK IF GROUPS IS THE BEST WAY
        body.take_damage(10)
        take_damage(2)

func _on_animation_finished(anim_name):
    if anim_name == "Explosion":
        Gamestats.lives -= 1
        Gamestats.score = 0
        if Gamestats.lives <= 0:
            Gamestats.game_over.emit()
            print("[PlayerEntity] Game over")
        restart_level.emit()

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
