extends Marker2D

@export var enemy_type: Enemy.TYPE = Enemy.TYPE.BOMBER
@export var path: Path2D = null
@onready var path_resource: PackedScene = preload("res://Scenes/Enemies/Paths/Ushape.tscn")


func _ready() -> void:
	self.path = path_resource.instantiate()
