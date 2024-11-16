extends Node2D

var movespeed = 100

#TODO: this should trigger the level being completed when the Boss died, but still need a Boss entity
signal level_complete()

@onready var bossmarker = get_child(0)

@onready var boss = preload("res://Scenes/Enemies/Level 1 Boss/boss_1_path.tscn")
@onready var boss_health = $"../BossHealth"

var bossfight

var bossspawned = false

func _process(delta):
    bossmarker.position.y += movespeed * delta
    if bossmarker.position.y > 0 and !bossspawned:
        bossfight = boss.instantiate()
        bossfight.position = Vector2(270,0)
        add_child(bossfight)
        bossspawned = true
        bossfight.uihealth.connect(boss_health.update_health)
        boss_health.visible = true
    pass
