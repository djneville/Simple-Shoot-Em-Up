extends CharacterBody2D

var state = 0

var bossbullet = preload("res://Scenes/BossFights/TestLevelBoss/boss_bullet.tscn")
var bossmissle = preload("res://Scenes/BossFights/TestLevelBoss/boss_missle.tscn")

var canshoot1 = false
var canshoot2 = false
var canmissle = false

var invulnerable = false
var revulnerable = false

var firstmissletime = false

@onready var gun_1 = $Gun1
@onready var gun_2 = $Gun2
@onready var gun_3 = $Gun3
@onready var gun_4 = $Gun4
@onready var missle_launcher = $MissleLauncher

@onready var collisionshape = $CollisionPolygon2D

signal damagesignal

var pathrotation

@onready var BossAnims = $BossAnims

var bombed = false


func _process(_delta):
	#enters the scene on the Entrypath
	if state == 0:
		rotation = PI / 2
		return

	#transferred onto the first pattern, this pattern just moves left and right and fires
	elif state == 1:
		if canshoot1:
			firebullet()
			$State1ShootSpeed.start()
			canshoot1 = false

	#transferred onto the second pattern, this pattern fires a little faster and fires a missle
	elif state == 2:
		look_at(Vector2(270, 960))

		if canshoot2:
			firebullet()
			$State2ShootSpeed.start()
			canshoot2 = false

		if firstmissletime:
			$MissleTimer.start()
			firstmissletime = false
		if canmissle:
			BossAnims.play("MissleFire")
			var missle = bossmissle.instantiate()
			missle.position = missle_launcher.global_position
			get_tree().current_scene.add_child(missle)
			$MissleTimer.start()
			canmissle = false
	elif state == 3:
		return


func _on_state_1_shoot_speed_timeout():
	if !invulnerable:
		canshoot1 = true
	pass  # Replace with function body.


func enemy_hit(damage):
	damagesignal.emit(damage)


func _on_state_2_shoot_speed_timeout():
	canshoot2 = true
	pass  # Replace with function body.


func _on_missle_timer_timeout():
	#stop shooting, wait for prime for missle to timeout
	canshoot2 = false
	$PrimeForMissle.start()
	$State2ShootSpeed.stop()
	pass  # Replace with function body.


func _on_prime_for_missle_timeout():
	canmissle = true
	canshoot2 = true
	pass  # Replace with function body.


func boss_invulnerable():
	if !invulnerable:
		BossAnims.stop()
		BossAnims.play("BossInvulnerable")
		collisionshape.set_deferred("disabled", true)
		invulnerable = true
		canshoot2 = false
		canshoot1 = false


func boss_revulnerable():
	if !revulnerable:
		BossAnims.stop()
		collisionshape.set_deferred("disabled", false)
		invulnerable = false
		revulnerable = true
		canshoot2 = true
		firstmissletime = true


func firebullet():
	BossAnims.play("BulletFire")
	var bullet1 = bossbullet.instantiate()
	var bullet2 = bossbullet.instantiate()
	var bullet3 = bossbullet.instantiate()
	var bullet4 = bossbullet.instantiate()

	bullet1.set_direction(rotation)
	bullet2.set_direction(rotation)
	bullet3.set_direction(rotation)
	bullet4.set_direction(rotation)

	bullet1.position = gun_1.global_position
	bullet2.position = gun_2.global_position
	bullet3.position = gun_3.global_position
	bullet4.position = gun_4.global_position

	get_tree().current_scene.add_child(bullet1)
	get_tree().current_scene.add_child(bullet2)
	get_tree().current_scene.add_child(bullet3)
	get_tree().current_scene.add_child(bullet4)
