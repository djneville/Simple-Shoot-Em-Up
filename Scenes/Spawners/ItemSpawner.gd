extends Node2D
# Speed at which spawn markers move vertically
@export var move_speed = 100

#y coordinate line where the items are set to spawn when the markers cross it
var spawnthreshold = 0

@onready var health = preload("res://Scenes/Drops/Health/healthitem.tscn")
@onready var bomb = preload("res://Scenes/Drops/Bomb/bombitem.tscn")
@onready var upgrade = preload("res://Scenes/Drops/Upgrade/upgradeitem.tscn")
#this array is created at ready (so, only once), and creates an array of all of the markers in the scene
var spawn_marker_array = []

#this array keeps track of all of the markers that have crossed the threshold and triggered the spawn_item() function
#if it didn't exist, then the for loop would infinitely spawn the items as long as the marker had crossed the spawnthreshold
var spawned_markers = []

#this will hold the item scene that gets instantiated upon entering the spawn_item() function
var item

#this array will keep track of spawned items, to check for deletion when their progress_ratio reaches 1
var spawned_items = []

func _ready():
    #creates the array of markers that are the children of this node
    for marker in self.get_children():
        spawn_marker_array.append(marker)

func _process(delta):
#for loop that spawns an item when the spawn_markers cross the spawnthreshold
#for each marker in the spawn_marker_array, move the markers down vertically at a speed of move_speed * delta
#if the marker crosses the spawn threshold, and isn't in the spawned_markers array (i.e. it hasn't been spawned yet),
#then spawn the item at marker.position with the spawn_item() function, and add it to the spawned_items array
    for marker in spawn_marker_array:
        marker.position.y += move_speed * delta
        if marker.position.y > spawnthreshold && !spawned_markers.has(marker):
            spawn_item(marker, marker.position)
            spawned_markers.append(marker)
            

#deletes items once they get off screen
    for each_item in spawned_items:
        if is_instance_valid(each_item):
            if each_item.position.y > 980:
                each_item.queue_free()
    
func spawn_item(marker, pos):
    if marker.to_spawn == "health":
        item = health.instantiate()
    if marker.to_spawn == "bomb":
        item = bomb.instantiate()
    if marker.to_spawn == "upgrade":
        item = upgrade.instantiate()	
    
    item.position = pos
    add_child(item)
    spawned_items.append(item)
