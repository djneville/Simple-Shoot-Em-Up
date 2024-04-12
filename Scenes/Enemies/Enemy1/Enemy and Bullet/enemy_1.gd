extends CharacterBody2D

var enemybullet = preload("res://Scenes/Enemies/Enemy1/Enemy and Bullet/enemy1_bullet.tscn")

@onready var gun_position = $GunPosition
@onready var muzzleflash = $MuzzleFlash

@export var canshoot = true

var bombed = false

@onready var path_follow_2d = $".."
var PathRotation
var noPathRotation

var health = 5

func _process(_delta):
	PathRotation = path_follow_2d.rotation
	noPathRotation = rotation + PI/2
	
	if canshoot:		
		muzzleflash.play("MuzzleAnim")
		var bullet = enemybullet.instantiate()
		bullet.position = gun_position.global_position
		if PathRotation:
			bullet.set_direction(PathRotation)
		else:
			bullet.set_direction(noPathRotation)
		get_tree().current_scene.add_child(bullet)
		$ShootSpeed.start()
		canshoot = false



func _on_shoot_speed_timeout():
	canshoot = true

func enemy_hit(damage):
	health = health - damage
	if health < 1:
		canshoot = false
		$ShipExplode.play("explode")

func enemy1_score():
	Gamestats.score += 120
