extends Node2D
class_name EnemySpawner

@onready var enemy_base_scene: PackedScene = preload("res://Scenes/Enemies/EnemyEntity.tscn")


func _ready() -> void:
    for marker: Marker2D in get_children():
        var notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
        notifier.screen_entered.connect(spawn_enemy.bind(marker))
        marker.add_child(notifier)


func spawn_enemy(marker: Marker2D) -> void:
    var enemy: EnemyEntity = enemy_base_scene.instantiate()
    var path: Path2D = marker.path
    var path_follow: PathFollow2D = path.find_child("PathFollow2D")
    #TODO: this is really ugly because AFTER THIS the enemy.enemy_level NEEDS to
    # update its upgrade_components.current_upgrade_index property...
    match marker.enemy_type:
        Enemy.TYPE.STANDARD:
            enemy.enemy_level = 2
        Enemy.TYPE.MISSILEER:
            enemy.enemy_level = 3
        Enemy.TYPE.BOMBER:
            enemy.enemy_level = 4

    path_follow.add_child(enemy)
    marker.add_child(path)
    #TODO: cant access path_speed until its added to the scene tree
    path_follow.path_speed = enemy.path_speed
