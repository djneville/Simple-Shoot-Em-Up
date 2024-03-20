extends CharacterBody2D

var bullet = preload("res://Scenes/Player/player_bullet.tscn")

@export var speed = 300

var canshoot = true

@onready var RightGun = $RightGun
@onready var LeftGun = $LeftGun
@onready var muzzle_flash = $MuzzleFlash

var health = 5

func shoot():
	
	muzzle_flash.play("MuzzleAnim")
	var rightbullet = bullet.instantiate()
	rightbullet.position = RightGun.global_position
	get_tree().current_scene.add_child(rightbullet)
	
	$ShootSpeed.start()
	canshoot = false
	
	var leftbullet = bullet.instantiate()
	leftbullet.position = LeftGun.global_position
	get_tree().current_scene.add_child(leftbullet)
	
	$ShootSpeed.start()
	canshoot = false

pass

func _process(delta):
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
	move_and_slide()
	
	print()
	
	global_position.x = clamp(global_position.x,$PlaneSprite.texture.get_width()/2,get_viewport_rect().size.x - $PlaneSprite.texture.get_width()/2)
	global_position.y = clamp(global_position.y,$PlaneSprite.texture.get_height()/2,get_viewport_rect().size.y - $PlaneSprite.texture.get_height()/2)
	
	if Input.is_action_pressed("shoot") and canshoot:
		shoot()
	
	pass


func _on_shoot_speed_timeout():
	canshoot = true
	pass

func player_hit(damage):
	health = health - damage
	if health < 1:
		#blow up
		queue_free()
	pass
