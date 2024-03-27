extends CharacterBody2D

var enemybullet = preload("res://Scenes/Enemies/Enemy2/Enemy and Missle/enemy2_missle.tscn")

@onready var gun_position = $GunPosition
@onready var muzzleflash = $MuzzleFlash

@export var canshoot = false

@onready var path_follow_2d = $".."
var PathRotation
var noPathRotation

var shotdown = false

var health = 5

func _ready():
	$FirstShot.start()
	pass

func _process(_delta):
	PathRotation = path_follow_2d.rotation
	noPathRotation = rotation + PI/2
	
	if canshoot and !shotdown:		
		muzzleflash.play("MuzzleAnim")
		var bullet = enemybullet.instantiate()
		bullet.position = gun_position.global_position
		get_tree().current_scene.add_child(bullet)
		$ShootSpeed.start()
		canshoot = false
	pass


func _on_shoot_speed_timeout():
	canshoot = true
	pass # Replace with function body.
	


func enemy_hit(damage):
	health = health - damage
	if health < 1:
		canshoot = false
		shotdown = true
		$ShipExplode.play("explode")
	pass



func _on_first_shot_timeout():
	canshoot = true
	pass # Replace with function body.
