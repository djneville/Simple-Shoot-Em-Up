extends CharacterBody2D

var bullet = preload("res://Scenes/Player/player_bullet.tscn")

var bomb = preload("res://Scenes/Player/player_bomb.tscn")

var speed = 150
var upgradelvl = 0
var bombs = 2

var canshoot = true
var canbomb = true
var alive = true

@onready var bombslot = $bombslot

#Upgrade 0
@onready var plane_sprite_0 = $Upgrade0/PlaneSprite0
@onready var upgrade_0 = $Upgrade0
@onready var gun = $Upgrade0/Gun
@onready var areacollision0 = $Upgrade0/U0CollisionDetection/CollisionShape2D
@onready var upgrade_0_col_shape = $Upgrade0ColShape
@onready var u_0_collision_detection = $Upgrade0/U0CollisionDetection

#Upgrade 1
@onready var RightGun = $Upgrade1/RightGun
@onready var LeftGun = $Upgrade1/LeftGun
@onready var plane_sprite_1 = $Upgrade1/PlaneSprite1
@onready var upgrade_1 = $Upgrade1
@onready var u_1_collision_detection = $Upgrade1/U1CollisionDetection
@onready var areacollision1 = $Upgrade1/U1CollisionDetection/CollisionShape2D
@onready var upgrade_1_col_shape = $Upgrade1ColShape

#anims and timer
@onready var ship_explode = $ShipExplode
@onready var muzzle_flash = $MuzzleFlash
@onready var InvulnFlash = $InvulnerableFlash

var reset_level

@onready var health = $Health
@onready var invulnerability = $Invulnerability

func _ready():
    #TODO: see the HealthBar.gd for where the health_changed signal gets handled
    health.entity_died.connect(_player_death)
    
    invulnerability.invulnerability_started.connect(_on_invulnerability_started)
    invulnerability.invulnerability_ended.connect(_on_invulnerability_ended)
    
    downgrade()

func _player_death():
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
    canshoot = false
    canbomb = false

func _on_invulnerability_ended():
    canshoot = true # no no no
    canbomb = true
    InvulnFlash.stop()
    self.visible = true

func heal(amount: int = 1):
    if health.current_health == health.max_health:
        Gamestats.score += 300
    else:
        health.heal(amount) #TODO: technically now this cant be entered at max health so check the logic there

func player_hit(damage):
    if not invulnerability.is_invulnerable:
        if upgradelvl == 1:
            downgrade()
        invulnerability.start_invulnerability()
        health.take_damage(damage)

#TODO: some CRAZY shit is going on with the enemy bullets not causing this to be entered somehow
# But thats the least of the actual composition problems
func _on_collision_detection_body_entered(body):
    if body.is_in_group("enemy") and not invulnerability.is_invulnerable:
        body.enemy_hit(10)
        player_hit(2)

func _process(_delta):
    if Input.is_action_pressed("upgrade"):
        upgrade()
    if Input.is_action_pressed("downgrade"):
        downgrade()
    
    var movement = Vector2.ZERO
    
    if Input.is_action_pressed("up"):
        movement.y = -1
    if Input.is_action_pressed("down"):
        movement.y = 1
    if Input.is_action_pressed("left"):
        movement.x = -1
    if Input.is_action_pressed("right"):
        movement.x = 1
    
    movement = movement.normalized()
    
    self.velocity = movement * speed
    
    move_and_slide()
    
    if upgradelvl == 0:
        global_position.x = clamp(global_position.x,plane_sprite_0.texture.get_width()/2,get_viewport_rect().size.x - plane_sprite_0.texture.get_width()/2)
        global_position.y = clamp(global_position.y,plane_sprite_0.texture.get_height()/2,get_viewport_rect().size.y - plane_sprite_0.texture.get_height()/2)
    if upgradelvl == 1:
        global_position.x = clamp(global_position.x,plane_sprite_1.texture.get_width()/2,get_viewport_rect().size.x - plane_sprite_1.texture.get_width()/2)
        global_position.y = clamp(global_position.y,plane_sprite_1.texture.get_height()/2,get_viewport_rect().size.y - plane_sprite_1.texture.get_height()/2)
    
    if Input.is_action_pressed("shoot") and canshoot:
        if upgradelvl == 0:
            shoot0()
        if upgradelvl == 1:
            shoot1()
    
    if Input.is_action_pressed("bomb") and canbomb:
        dropbomb()

func shoot0():
    muzzle_flash.play("Upgrade0Anim")
    var centerbullet = bullet.instantiate()
    centerbullet.position = gun.global_position
    get_tree().current_scene.add_child(centerbullet)

    $ShootSpeed.start()
    canshoot = false

func shoot1():
    muzzle_flash.play("Upgrade1Anim")
    var rightbullet = bullet.instantiate()
    rightbullet.position = RightGun.global_position
    get_tree().current_scene.add_child(rightbullet)
        
    var leftbullet = bullet.instantiate()
    leftbullet.position = LeftGun.global_position
    get_tree().current_scene.add_child(leftbullet)
    
    $ShootSpeed.start()
    canshoot = false

func dropbomb():
    if bombs > 0:
        var centerbomb = bomb.instantiate()
        centerbomb.position = bombslot.global_position
        get_tree().current_scene.add_child(centerbomb)
        canbomb = false
        bombs -= 1
        $BombReload.start()

func _on_shoot_speed_timeout():
    canshoot = true

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
    canbomb = true

func add_bomb():
    if bombs < 7:
        bombs += 1
    else:
        Gamestats.score += 250
        
func give_upgrade():
    if upgradelvl == 0:
        upgrade()
    else:
        Gamestats.score += 280
