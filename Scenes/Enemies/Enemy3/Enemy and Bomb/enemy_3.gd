extends CharacterBody2D

var enemybomb = preload("res://Scenes/Enemies/Enemy3/Enemy and Bomb/enemy3_bomb.tscn")

@onready var gun_position = $GunPosition
@onready var muzzleflash = $MuzzleFlash

@export var canshoot = true
var canaim = false
var canfire = false

var bombed = false

var firetimerstarted = false
var aimbacktimerstarted = false

@onready var path_follow_2d = $".."
var PathRotation

var aimingdirection = Vector2.ZERO

var health = 5

func _process(_delta):
    PathRotation = path_follow_2d.rotation
    
    if canaim:
        aim_at_player()
        if canfire:		
            muzzleflash.play("MuzzleAnim")
            var bomb = enemybomb.instantiate()
            bomb.position = gun_position.global_position
            bomb.set_direction(aimingdirection)
            get_tree().current_scene.add_child(bomb)
            canfire = false
            if !aimbacktimerstarted:
                $AimbackTimer.start()
                aimbacktimerstarted = true
    else:
        global_rotation = lerp_angle(global_rotation, PathRotation, .1)

func enemy_hit(damage):
    health = health - damage
    if health < 1:
        canshoot = false
        $ShipExplode.play("explode")
    pass

func _on_time_to_aim_timeout():
    canaim = true
    pass # Replace with function body.
    
func aim_at_player():
    var player_position = get_tree().get_nodes_in_group("player")[0].global_position
    var vect = (player_position - global_position)
    var angle = vect.angle()
    aimingdirection = lerp_angle(global_rotation, angle, .1)
    global_rotation = aimingdirection
    if !firetimerstarted:
        $TimeToFire.start()
        firetimerstarted = true
    pass

func _on_time_to_fire_timeout():
    canfire = true
    pass # Replace with function body.

func _on_aimback_timer_timeout():
    canaim = false
    pass # Replace with function body.

func enemy3_score():
    Gamestats.score += 250
