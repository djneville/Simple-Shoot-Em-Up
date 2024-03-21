extends Node2D
# Speed at which spawn markers move vertically
@export var move_speed = 100
var spawnthreshold = 0

@onready var enemy1path1 = preload("res://Scenes/Enemies/Enemy1/enemy1path1.tscn")
@onready var enemy1path2 = preload("res://Scenes/Enemies/Enemy1/enemy1path2.tscn")

var spawn_marker_array = []

var spawned_markers = []

var enemy

var spawned_enemy

func _ready():
	for marker in self.get_children():
		spawn_marker_array.append(marker)
	pass


func _process(delta):
	
	for marker in spawn_marker_array:
		marker.position.y += move_speed * delta
		if marker.position.y > spawnthreshold && !spawned_markers.has(marker):
			spawned_enemy = spawn_enemy(marker, marker.position)
			spawned_markers.append(marker)
			print("spawned markers: ", spawned_markers)
	
	despawn_completed(spawned_enemy)

func spawn_enemy(marker, position):
	if marker.to_spawn == "Enemy1Path1":
		enemy = enemy1path1.instantiate()
	if marker.to_spawn == "Enemy1Path2":
		enemy = enemy1path2.instantiate()
	enemy.position = position
	add_child(enemy)
	return enemy
	pass

func despawn_completed(to_despawn):
	if to_despawn:
		if to_despawn.progress_ratio == 1: #so I think this is going to need some kind of for loop array situation again
			print("despawn")
	pass
