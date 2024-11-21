extends Marker2D

#TODO: THJIS IS ONLY FOR THE ENEMYSPAWNER IMPLEMENTATION IF WE WANT TO TRY THAT LATER
@export var enemy_type: EnemyType.TYPE = EnemyType.TYPE.BOSS
@export var path_resource: PackedScene = preload("res://Scenes/BossFights/Paths/TestBossPath.tscn")
var path: Path2D


func _ready() -> void:
	path = path_resource.instantiate()
