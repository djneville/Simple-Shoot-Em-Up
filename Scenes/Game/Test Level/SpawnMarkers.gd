extends Node2D
# Speed at which spawn markers move vertically
@export var move_speed = 100
var spawnthreshold = 0

@onready var enemy_scene = preload("res://Scenes/Enemies/Enemy1/enemy_1.tscn")

var spawn_marker_array = []

var spawned_markers = []

func _ready():
	for marker in self.get_children():
		spawn_marker_array.append(marker)
	pass


func _process(delta):
	
	
	for marker in spawn_marker_array:
		marker.position.y += move_speed * delta
		if marker.position.y > spawnthreshold && !spawned_markers.has(marker):
			spawn_enemy(marker.position)
			spawned_markers.append(marker)
			print("spawned markers: ", spawned_markers)

func spawn_enemy(position):
	var enemy = enemy_scene.instantiate()
	enemy.position = position
	add_child(enemy)
	pass
