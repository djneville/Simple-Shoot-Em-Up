extends Marker2D

@onready var boss_path = preload("res://Scenes/Enemies/Level 1 Boss/boss_1_path.tscn")
@onready var boss_health = preload("res://Scenes/HUD/BossHealth.tscn")
@onready var visibility= $VisibleOnScreenEnabler2D

func ready():
    visibility.screen_entered.connect(_spawn_boss)

func _spawn_boss():
    var boss_fight = boss_path.instantiate()
    boss_fight.position = Vector2(270,0)
    add_child(boss_fight)
    boss_fight.uihealth.connect(boss_health.update_health)
    boss_health.instantiate()
    #TODO: figure out how to add the boss health to the hud here
