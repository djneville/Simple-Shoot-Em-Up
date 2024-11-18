extends Node2D
class_name EnemySpawner

@onready var enemy_base_scene = preload("res://Scenes/Enemies/EnemyEntity.tscn")

func _ready() -> void:
    for marker in get_children():
        var notifier = VisibleOnScreenNotifier2D.new()
        notifier.screen_entered.connect(spawn_enemy.bind(marker))
        marker.add_child(notifier)

func spawn_enemy(marker):
    var enemy = enemy_base_scene.instantiate()
    var path = marker.path
    var path_follow = path.find_child("PathFollow2D")
    #TODO: this is really ugly because AFTER THIS the enemy.enemy_level NEEDS to 
    # update its upgrade_components.current_upgrade_index property...
    enemy.enemy_level = marker.enemy_level
    path_follow.add_child(enemy)
    marker.add_child(path)
    #TODO: cant access path_speed until its added to the scene tree
    path_follow.path_speed = enemy.path_speed
