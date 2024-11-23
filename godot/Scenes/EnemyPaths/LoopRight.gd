extends Marker2D

@export var enemy_type: EnemyType.TYPE = EnemyType.TYPE.STANDARD
@export var path: Path2D = null
@onready var path_resource: PackedScene = preload(PathManager.LOOP_RIGHT)


func _ready() -> void:
    self.path = path_resource.instantiate()
