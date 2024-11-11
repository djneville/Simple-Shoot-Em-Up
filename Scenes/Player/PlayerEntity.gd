extends CharacterBody2D

var speed = 150
var upgradelvl = 0

#Upgrade 0
@onready var plane_sprite_0 = $Upgrade0/PlaneSprite0
@onready var upgrade_0 = $Upgrade0
@onready var areacollision0 = $Upgrade0/U0CollisionDetection/CollisionShape2D
@onready var upgrade_0_col_shape = $Upgrade0ColShape
@onready var u_0_collision_detection = $Upgrade0/U0CollisionDetection

#Upgrade 1

@onready var plane_sprite_1 = $Upgrade1/PlaneSprite1
@onready var upgrade_1 = $Upgrade1
@onready var u_1_collision_detection = $Upgrade1/U1CollisionDetection
@onready var areacollision1 = $Upgrade1/U1CollisionDetection/CollisionShape2D
@onready var upgrade_1_col_shape = $Upgrade1ColShape

#anims and timer
@onready var ship_explode = $ShipExplode

@export var reset_level := false

@onready var health = $HealthComponent
@onready var invulnerability = $InvulnerabilityComponent
#TODO: the flash animation should be contained in the invulnerability node
@onready var InvulnFlash = $InvulnerableFlash

@onready var weapon = $WeaponComponent

func _ready():
    position = Vector2(200, 400)
    #TODO: see the HealthBar.gd for where the health_changed signal gets handled
    health.entity_died.connect(_death)
    weapon.shoot_timer.one_shot = true # To avoid just shooting once???
    invulnerability.invulnerability_started.connect(_on_invulnerability_started)
    invulnerability.invulnerability_ended.connect(_on_invulnerability_ended)

    downgrade()

func _death():
    if upgradelvl == 0:
        ship_explode.play("explode0")
    if upgradelvl == 1:
        ship_explode.play("explode1")
    Gamestats.lives -= 1
    Gamestats.score = 0
    if Gamestats.lives <= 0:
        Gamestats.gamestatus = "gameover"
    else:
        Gamestats.gamestatus = "continue"
    reset_level = true

func _on_invulnerability_started():
    if upgradelvl == 0:
        InvulnFlash.play("Flash0")
    elif upgradelvl == 1:
        InvulnFlash.play("Flash1")

func _on_invulnerability_ended():
    InvulnFlash.stop()
    self.visible = true

func heal(amount: int = 1):
    if health.current_health == health.max_health:
        Gamestats.score += 300
    else:
        health.heal(amount) #TODO: technically now this cant be entered at max health so check the logic here and fix

func take_damage(damage):
    if not invulnerability.is_invulnerable:
        if upgradelvl == 1:
            downgrade()
        invulnerability.start_invulnerability()
        health.take_damage(damage)


func _on_collision_detection_body_entered(body):
    if body.is_in_group("enemy"): #TODO: make this more clear that its not related to BULLETS (IDK IF GROUPS IS THE BEST WAY
        body.take_damage(10)
        take_damage(2)

func _process(_delta):
    if Input.is_action_pressed("upgrade"):
        upgrade()
    if Input.is_action_pressed("downgrade"):
        downgrade()
    var input_dir = Input.get_vector("left", "right", "up", "down")
    # TODO: delta here is often too low as the time for frame draw 
    self.velocity = input_dir * speed # * delta
    # print("fps: ", 1 / delta)
    move_and_slide()
    
    clamp_viewport()
    
    if Input.is_action_pressed("shoot"):
        weapon.fire_bullet(self.global_position, Vector2.UP, self)

func downgrade():
    #disable 1
    upgrade_1.visible = false
    u_1_collision_detection.set_deferred("monitorable", false)
    u_1_collision_detection.monitoring = false
    areacollision1.set_deferred("disabled", true)
    #enable 0
    upgradelvl = 0
    speed = 150
    upgrade_0.visible = true
    u_0_collision_detection.set_deferred("monitorable",true)
    u_0_collision_detection.monitoring = true
    areacollision0.set_deferred("disabled", false)

func upgrade():
    #disable 0
    upgrade_0.visible = false
    u_0_collision_detection.set_deferred("monitorable",false)
    u_0_collision_detection.monitoring = false
    areacollision0.set_deferred("disabled", true)

    #enable 1
    upgradelvl = 1
    speed = 200
    upgrade_1.visible = true
    u_1_collision_detection.set_deferred("monitorable", true)
    u_1_collision_detection.monitoring = true
    areacollision1.set_deferred("disabled", false)

func _on_bomb_reload_timeout():
    pass #TODO this will be covered in the bomb/weapon component just like the bullet
    
func add_bomb():
    pass #TODO: same as the bullet stuff
    #if bombs < 7:
        #bombs += 1
    #else:
        #Gamestats.score += 250
        
func give_upgrade():
    if upgradelvl == 0:
        upgrade()
    else:
        Gamestats.score += 280

#TODO: this should not be in the player entity, but somewhere closer to the Main Scene (once the main scene gets created
func clamp_viewport():
    if upgradelvl == 0:
        global_position.x = clamp(global_position.x,plane_sprite_0.texture.get_width()/2,get_viewport_rect().size.x - plane_sprite_0.texture.get_width()/2)
        global_position.y = clamp(global_position.y,plane_sprite_0.texture.get_height()/2,get_viewport_rect().size.y - plane_sprite_0.texture.get_height()/2)
    if upgradelvl == 1:
        global_position.x = clamp(global_position.x,plane_sprite_1.texture.get_width()/2,get_viewport_rect().size.x - plane_sprite_1.texture.get_width()/2)
        global_position.y = clamp(global_position.y,plane_sprite_1.texture.get_height()/2,get_viewport_rect().size.y - plane_sprite_1.texture.get_height()/2)
    
