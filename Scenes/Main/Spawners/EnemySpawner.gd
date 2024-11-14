# EnemySpawner.gd
extends Node2D
class_name EnemySpawner

# Preload enemy and path scenes
@onready var enemy_path1 = preload("res://Scenes/Enemies/Enemy/EnemyPath1.tscn")
@onready var enemy1path2 = preload("res://Scenes/Enemies/Enemy/EnemyPath2.tscn")
@onready var enemy1path3 = preload("res://Scenes/Enemies/Enemy/EnemyPath3.tscn")
@onready var enemy1path4 = preload("res://Scenes/Enemies/Enemy/EnemyPath4.tscn")
@onready var enemy1path5 = preload("res://Scenes/Enemies/Enemy/EnemyPath5.tscn")
@onready var enemy2path1 = preload("res://Scenes/Enemies/Enemy2/enemy2path1.tscn")
@onready var enemy3path1 = preload("res://Scenes/Enemies/Enemy3/enemy3path1.tscn")

# Mapping from spawn types to their corresponding enemy and path scenes
var spawn_mappings = {
    "Enemy1Path1": { "enemy_scene": "enemy1", "path_scene": "EnemyPath1" },
    "Enemy1Path2": { "enemy_scene": "enemy1", "path_scene": "enemy1path2" },
    "Enemy1Path3": { "enemy_scene": "enemy1", "path_scene": "enemy1path3" },
    "Enemy1Path4": { "enemy_scene": "enemy1", "path_scene": "enemy1path4" },
    "Enemy1Path5": { "enemy_scene": "enemy1", "path_scene": "enemy1path5" },
    "Enemy2Path1": { "enemy_scene": "enemy2", "path_scene": "enemy2path1" },
    "Enemy3Path1": { "enemy_scene": "enemy3", "path_scene": "enemy3path1" },
}

# Mapping identifiers to preloaded scenes
var enemy_scene_mapping = {
    "enemy1": preload("res://Scenes/Enemies/Enemy/EnemyEntity.tscn"),
    #"enemy2": preload("res://Scenes/Enemies/Enemy2/Enemy2Entity.tscn"),
    #"enemy3": preload("res://Scenes/Enemies/Enemy3/Enemy3Entity.tscn"),
}

var path_scene_mapping = {
    "EnemyPath1": preload("res://Scenes/Enemies/Enemy/EnemyPath1.tscn"),
    "enemy1path2": preload("res://Scenes/Enemies/Enemy/EnemyPath2.tscn"),
    "enemy1path3": preload("res://Scenes/Enemies/Enemy/EnemyPath3.tscn"),
    "enemy1path4": preload("res://Scenes/Enemies/Enemy/EnemyPath4.tscn"),
    "enemy1path5": preload("res://Scenes/Enemies/Enemy/EnemyPath5.tscn"),
    "enemy2path1": preload("res://Scenes/Enemies/Enemy2/enemy2path1.tscn"),
    "enemy3path1": preload("res://Scenes/Enemies/Enemy3/enemy3path1.tscn"),
}

func _ready() -> void:
    # Iterate through all child markers
    for marker in get_children():
        # Create and add VisibleOnScreenNotifier2D
        var notifier = VisibleOnScreenNotifier2D.new()
        marker.add_child(notifier)
        print("Added VisibleOnScreenNotifier2D to marker '%s'." % marker.name)
        notifier.screen_entered.connect(spawn_enemy.bind(marker))

func spawn_enemy(marker):
    print("Marker '%s' entered the screen. Spawning enemy..." % marker.name)
    var spawn_type = marker.to_spawn

    var enemy_id = spawn_mappings[spawn_type]["enemy_scene"]
    var path_id = spawn_mappings[spawn_type]["path_scene"]
    
    var enemy_scene = enemy_scene_mapping[enemy_id]
    var enemy = enemy_scene.instantiate()
    
    var path_scene = path_scene_mapping[path_id]
    var path = path_scene.instantiate()
    
    var path_follow = path.find_child("PathFollow2D")
    path_follow.add_child(enemy)
    
    marker.add_child(path)
    print("Enemy '%s' spawned at position %s with path '%s'." % [enemy.name, enemy.position, path_id])
