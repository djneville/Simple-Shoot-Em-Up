extends Node2D
# Speed at which spawn markers move vertically
@export var move_speed = 100

#y coordinate line where the enemies are set to spawn when the markers cross it
var spawnthreshold = 0


#these scenes consist of 3 nodes:
#The root node is a Path2D node
#A child of that node is the PathFollow2D node
#And a child of that node is the Enemy scene that contains the logic for the enemy, sprite, animations, and bullet shooting logic
@onready var enemy1path1 = preload("res://Scenes/Enemies/Enemy1/enemy1path1.tscn")
@onready var enemy1path2 = preload("res://Scenes/Enemies/Enemy1/enemy1path2.tscn")
@onready var enemy1path3 = preload("res://Scenes/Enemies/Enemy1/enemy1path3.tscn")
@onready var enemy2path1 = preload("res://Scenes/Enemies/Enemy2/enemy2path1.tscn")
#this array is created at ready (so, only once), and creates an array of all of the markers in the scene
var spawn_marker_array = []

#this array keeps track of all of the markers that have crossed the threshold and triggered the spawn_enemy() function
#if it didn't exist, then the for loop would infinitely spawn the enemies as long as the marker had crossed the spawnthreshold
var spawned_markers = []

#this will hold the enemy scene that gets instantiated upon entering the spawn_enemy() function
var enemy

#this array will keep track of spawned enemies, to check for deletion when their progress_ratio reaches 1
var spawned_enemies = []

func _ready():
	#creates the array of markers that are the children of this node
	for marker in self.get_children():
		spawn_marker_array.append(marker)
	pass


func _process(delta):
	
	#for loop that spawns an enemy when the spawn_markers cross the spawnthreshold
	#for each marker in the spawn_marker_array, move the markers down vertically at a speed of move_speed * delta
	#if the marker crosses the spawn threshold, and isn't in the spawned_markers array (i.e. it hasn't been spawned yet),
	#then spawn the enemy at marker.position with the spawn_enemy() function, and add it to the spawned_markers array
	
	for marker in spawn_marker_array:
		marker.position.y += move_speed * delta
		if marker.position.y > spawnthreshold && !spawned_markers.has(marker):
			spawn_enemy(marker, marker.position)
			spawned_markers.append(marker)
			

#I honestly don't know how it works, but it seems like the enemy still follows the path_follow2d node 
# and the progress_ratio still increases even after I've shot down the enemy. I'll take it
	for each_enemy in spawned_enemies:
		if is_instance_valid(each_enemy):
			var path_follow = each_enemy.get_node("PathFollow2D")
			if path_follow.progress_ratio == 1:
				each_enemy.queue_free()

func spawn_enemy(marker, pos):
	#this function will check which enemy and path to spawn based on the to_spawn variable stored in each marker
	if marker.to_spawn == "Enemy1Path1":
		enemy = enemy1path1.instantiate()
	if marker.to_spawn == "Enemy1Path2":
		enemy = enemy1path2.instantiate()
	if marker.to_spawn == "Enemy1Path3":
		enemy = enemy1path3.instantiate()
	if marker.to_spawn == "Enemy2Path1":
		enemy = enemy2path1.instantiate()
	#it sets the position at the position of the marker, and then adds it to the scene
	enemy.position = pos
	add_child(enemy)
	spawned_enemies.append(enemy)
	pass
