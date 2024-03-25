extends CharacterBody2D

var bullet = preload("res://Scenes/Player/player_bullet.tscn")

@export var speed = 300

var canshoot = true
var alive = true

@onready var RightGun = $RightGun
@onready var LeftGun = $LeftGun
@onready var muzzle_flash = $MuzzleFlash
@onready var InvulnFlash = $InvulnerableFlash
@onready var post_hit_invuln = $PostHitInvuln

var health = 7

var playerinvulnerable = false

func shoot():
	
	muzzle_flash.play("MuzzleAnim")
	var rightbullet = bullet.instantiate()
	rightbullet.position = RightGun.global_position
	get_tree().current_scene.add_child(rightbullet)
	
	var leftbullet = bullet.instantiate()
	leftbullet.position = LeftGun.global_position
	get_tree().current_scene.add_child(leftbullet)
	
	$ShootSpeed.start()
	canshoot = false

pass

func _process(_delta):
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
	
	velocity = movement * speed
	
	if alive:
		move_and_slide()
	
	global_position.x = clamp(global_position.x,$PlaneSprite.texture.get_width()/2,get_viewport_rect().size.x - $PlaneSprite.texture.get_width()/2)
	global_position.y = clamp(global_position.y,$PlaneSprite.texture.get_height()/2,get_viewport_rect().size.y - $PlaneSprite.texture.get_height()/2)
	
	if Input.is_action_pressed("shoot") and canshoot:
		shoot()
	
	if health < 1:
		movement = Vector2.ZERO
		canshoot = false
		alive = false
		$ShipExplode.play("explode")
	pass


func _on_shoot_speed_timeout():
	canshoot = true
	pass

func player_hit(damage):
	if !playerinvulnerable:
		print("health calculation: ", health, " - ", damage)
		health = health - damage
		print("current health: ", health)
		#go invulnerable
		if health > 0:
			Invulnerable()
		pass
	
func Invulnerable():
	post_hit_invuln.start()
	InvulnFlash.play("Flash")
	canshoot = false
	playerinvulnerable = true
	$CollisionShape2D.set_deferred("disabled", true)

func _on_post_hit_invuln_timeout():
	canshoot = true
	InvulnFlash.stop()
	if $PlaneSprite.visible == false:
		$PlaneSprite.visible = true
	playerinvulnerable = false
	$CollisionShape2D.set_deferred("disabled", false)
	pass # Replace with function body.


func _on_collision_detection_body_entered(body):
	if body.is_in_group("enemy") and !playerinvulnerable:
		body.enemy_hit(10)
		player_hit(2)
	pass # Replace with function body.
