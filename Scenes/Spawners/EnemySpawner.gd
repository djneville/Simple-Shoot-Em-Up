extends Node2D
class_name EnemySpawner

@onready var enemy_base_scene: PackedScene = preload("res://Scenes/Enemies/EnemyEntity.tscn")
@onready var boss_base_scene: PackedScene = preload("res://Scenes/BossFights/BossEntity.tscn")


func _ready() -> void:
    for marker: Marker2D in get_children():
        var notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
        notifier.screen_entered.connect(spawn_enemy.bind(marker))
        marker.add_child(notifier)


func spawn_enemy(marker: Marker2D) -> void:
    var enemy: EnemyEntity
    var path: Path2D = marker.path
    var path_follow: EnemyPath = path.find_child("EnemyPath")
    #TODO: this is really ugly because AFTER THIS the enemy.enemy_level NEEDS to
    # update its upgrade_components.current_upgrade_index property...
    enemy = enemy_base_scene.instantiate()
    enemy.enemy_level = marker.enemy_type # marker.enemy_type is an Enum Number
    #match marker.enemy_type:
        #EnemyType.TYPE.STANDARD:
            #enemy = enemy_base_scene.instantiate()
            #enemy.enemy_level = 2
        #EnemyType.TYPE.MISSILEER:
            #enemy = enemy_base_scene.instantiate()
            #enemy.enemy_level = 3
        #EnemyType.TYPE.BOMBER:
            #enemy = enemy_base_scene.instantiate()
            #enemy.enemy_level = 4
        ##TODO: SHOULD WE BE ABLE TO SPAWN ENEMIES IN A BOSS SCENE????!!! PROBABLY!!!!
        #EnemyType.TYPE.BOSS:
            #enemy = boss_base_scene.instantiate()
            #enemy.enemy_level = 5
    path_follow.add_child(enemy)
    marker.add_child(path)
    #TODO: cant access path_speed until its added to the scene tree
    path_follow.path_speed = enemy.path_speed
