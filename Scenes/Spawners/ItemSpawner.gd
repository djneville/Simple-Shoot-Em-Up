extends Node2D
#TODO: compare this to the enemy spawner as an example,
#where THIS "spawner" doesnt actually spawn ANYTHING, it just always has items on the map

@onready var health_item_scene: PackedScene = preload("res://Scenes/Drops/HealthItem.tscn")
@onready var bomb_item_scene: PackedScene = preload("res://Scenes/Drops/BombItem.tscn")
@onready var upgrade_item_scene: PackedScene = preload("res://Scenes/Drops/UpgradeItem.tscn")


func _ready() -> void:
	for marker: Marker2D in get_children():
		var notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
		notifier.screen_entered.connect(spawn_item.bind(marker))
		#notifier.screen_exited.connect(queue_free)
		marker.add_child(notifier)


func spawn_item(marker: Marker2D) -> void:
	match marker.item_type:
		Item.TYPE.HEALTH:
			marker.add_child(health_item_scene.instantiate())
		Item.TYPE.BOMB:
			marker.add_child(bomb_item_scene.instantiate())
		Item.TYPE.UPGRADE:
			marker.add_child(upgrade_item_scene.instantiate())
